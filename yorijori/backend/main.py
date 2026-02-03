import os
import json
import re
import glob
import traceback
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import uvicorn
from youtube_transcript_api import YouTubeTranscriptApi
from yt_dlp import YoutubeDL
import google.generativeai as genai

# ==========================================
# [설정] 구글 Gemini API 키 (환경 변수 사용, 클라우드 배포 시 필수)
# 로컬: .env 파일 또는 export GEMINI_API_KEY=xxx
# 클라우드: 서비스 대시보드에서 GEMINI_API_KEY 환경 변수 설정
# ==========================================
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

GEMINI_API_KEY = (os.environ.get("GEMINI_API_KEY") or "").strip()
if not GEMINI_API_KEY:
    raise RuntimeError(
        "GEMINI_API_KEY가 설정되지 않았습니다. "
        "로컬: .env 파일에 GEMINI_API_KEY=xxx 추가 또는 export GEMINI_API_KEY=xxx"
    )
genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-2.5-flash',
                              generation_config={"response_mime_type": "application/json"})

app = FastAPI()

# ngrok / Flutter 앱에서 접속할 수 있도록 CORS 허용
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def _error_body(error_code: str, message: str) -> dict:
    """앱에서 파싱하는 에러 형식: errorCode, message"""
    return {"errorCode": error_code, "message": message}


@app.exception_handler(HTTPException)
def http_exception_handler(request, exc: HTTPException):
    """HTTPException을 앱이 기대하는 JSON 형식으로 반환"""
    if isinstance(exc.detail, dict) and "errorCode" in exc.detail and "message" in exc.detail:
        body = exc.detail
    else:
        body = _error_body("UNKNOWN", str(exc.detail))
    return JSONResponse(status_code=exc.status_code, content=body)


@app.exception_handler(Exception)
def unhandled_exception_handler(request, exc: Exception):
    """처리되지 않은 예외: 터미널에 전체 로그 출력 후 500 반환"""
    print("=" * 60)
    print("❌ [서버 에러] 처리되지 않은 예외")
    print("=" * 60)
    traceback.print_exc()
    print("=" * 60)
    return JSONResponse(
        status_code=500,
        content=_error_body("SERVER_ERROR", "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."),
    )


class AnalyzeRequest(BaseModel):
    url: str

def extract_video_id(url):
    patterns = [r'(?:v=|\/)([0-9A-Za-z_-]{11}).*', r'(?:youtu\.be\/)([0-9A-Za-z_-]{11})']
    for pattern in patterns:
        match = re.search(pattern, url)
        if match: return match.group(1)
    raise ValueError("올바른 유튜브 URL이 아닙니다.")


def get_video_metadata_via_api(video_id: str) -> dict | None:
    """YouTube Data API v3로 메타데이터 조회 (봇 차단 없음). YOUTUBE_API_KEY 필요."""
    api_key = (os.environ.get("YOUTUBE_API_KEY") or "").strip()
    if not api_key:
        return None
    try:
        import urllib.request
        url = f"https://www.googleapis.com/youtube/v3/videos?id={video_id}&part=snippet&key={api_key}"
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode())
        items = data.get("items") or []
        if not items:
            return None
        sn = items[0].get("snippet") or {}
        thumb = (sn.get("thumbnails") or {}).get("default") or {}
        return {
            "title": sn.get("title") or "제목 없음",
            "channel": sn.get("channelTitle") or "알 수 없음",
            "thumbnail": thumb.get("url") or "",
        }
    except Exception as e:
        print(f"   ⚠️ YouTube API 메타데이터 조회 실패: {e}")
        return None


def get_video_metadata(url: str, video_id: str | None = None) -> dict:
    """영상 메타데이터 조회. YouTube API 우선, 없으면 yt-dlp 사용."""
    vid = video_id or extract_video_id(url)
    # 1) YouTube Data API 시도 (봇 차단 없음)
    meta = get_video_metadata_via_api(vid)
    if meta:
        return meta
    # 2) yt-dlp 사용 (봇 차단 시 쿠키 필요할 수 있음)
    ydl_opts = {'quiet': True, 'no_warnings': True}
    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)
        return {
            "title": info.get('title', '제목 없음'),
            "channel": info.get('uploader', '알 수 없음'),
            "thumbnail": info.get('thumbnail', ''),
        }

def _get_yt_dlp_cookiefile():
    """yt-dlp용 쿠키 파일 경로 반환. 없으면 None."""
    path = (os.environ.get("YT_DLP_COOKIES_PATH") or "").strip()
    if path and os.path.isfile(path):
        return path
    # 인라인 쿠키(Netscape 형식): env에 넣고 YT_DLP_COOKIES 로 전달 시 임시 파일로 저장
    raw = (os.environ.get("YT_DLP_COOKIES") or "").strip()
    if not raw:
        return None
    try:
        import tempfile
        fd, tmp = tempfile.mkstemp(suffix=".txt", prefix="yt_dlp_cookies_")
        with os.fdopen(fd, "w") as f:
            f.write(raw)
        return tmp
    except Exception:
        return None


def download_audio(url, video_id):
    """자막이 없을 때 오디오를 다운로드. 포맷 불가 시 best(영상+음성)로 재시도."""
    for file in glob.glob(f"{video_id}.*"):
        try: os.remove(file)
        except: pass

    base_opts = {
        'postprocessors': [{'key': 'FFmpegExtractAudio', 'preferredcodec': 'mp3'}],
        'outtmpl': f'{video_id}',
        'quiet': True,
    }
    cookiefile = _get_yt_dlp_cookiefile()
    if cookiefile:
        base_opts['cookiefile'] = cookiefile

    # 여러 포맷 순서로 시도 (일부 영상은 bestaudio가 없고 best만 있음)
    for fmt in [
        'bestaudio[ext=m4a]/bestaudio[ext=webm]/bestaudio/best',
        'bestaudio/best',
        'best',  # 영상+음성 통합 → FFmpeg이 음성만 추출
    ]:
        for f in glob.glob(f"{video_id}.*"):
            try: os.remove(f)
            except: pass
        ydl_opts = {**base_opts, 'format': fmt}
        try:
            with YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])
            out = f"{video_id}.mp3"
            if os.path.exists(out):
                return out
        except Exception as e:
            err = str(e)
            if "Requested format is not available" in err or "format is not available" in err:
                continue
            raise
    raise RuntimeError("사용 가능한 오디오 포맷이 없습니다.")

@app.post("/api/v1/analyze")
async def analyze_recipe(request: AnalyzeRequest):
    print(f"✅ 분석 요청: {request.url}")
    try:
        video_id = extract_video_id(request.url)
    except ValueError as e:
        print(f"❌ URL 파싱 실패: {e}")
        raise HTTPException(
            status_code=400,
            detail=_error_body("INVALID_URL", "올바른 YouTube URL을 입력해 주세요."),
        )
    try:
        metadata = get_video_metadata(request.url, video_id=video_id)
    except Exception as e:
        print(f"❌ 영상 정보 조회 실패: {e}")
        traceback.print_exc()
        raise HTTPException(
            status_code=502,
            detail=_error_body("VIDEO_ERROR", "영상 정보를 가져올 수 없습니다. 비공개/삭제/지역제한 여부를 확인해 주세요."),
        )
    
    prompt = """
    너는 요리 레시피 분석 전문가야. 제공된 내용을 바탕으로 요리 재료와 조리 과정을 추출해줘.
    
    [필수 규칙]
    1. 반드시 JSON 포맷으로만 응답해. 다른 텍스트는 포함하지 마.
    2. steps 배열의 각 객체는 반드시 "time"과 "desc" 필드를 가져야 해.
    3. steps의 'time'은 조리 단계가 시작되는 초(second) 단위 정수 숫자야. (예: 0, 30, 120)
    4. steps의 'desc'는 조리 행동을 명확하게 요약한 문자열이야. (예: "양파를 다진다", "팬에 기름을 두른다")
    5. ingredients는 문자열 배열이야. 수량 정보가 있다면 포함해. (예: ["양파 1개", "마늘 3쪽"])
    6. steps는 최소 1개 이상 있어야 해. 빈 배열이면 안 돼.

    [정확한 JSON 형식 예시]
    {
        "ingredients": ["양파 1개", "마늘 3쪽", "올리브오일 2큰술"],
        "steps": [
            {"time": 0, "desc": "양파를 다진다"},
            {"time": 30, "desc": "팬에 올리브오일을 두르고 중불로 예열한다"},
            {"time": 60, "desc": "다진 양파를 넣고 볶는다"}
        ]
    }
    
    위 형식을 정확히 따라야 해. time은 반드시 정수, desc는 반드시 문자열이어야 해.
    """

    try:
        # [시도 1] 자막 가져오기
        print("1️⃣ 자막 검색 중...")
        transcript_list = YouTubeTranscriptApi.get_transcript(video_id, languages=['ko', 'en'])
        full_text = " ".join([f"[{int(t['start'])}초] {t['text']}" for t in transcript_list])
        print("   👉 자막 발견! 텍스트로 분석합니다.")
        
        final_prompt = f"{prompt}\n\n[자막 내용]\n{full_text}"
        response = model.generate_content(final_prompt)

    except Exception:
        # [시도 2] 자막 없으면 오디오 분석
        print("   👉 자막 없음. 오디오 분석 모드로 전환합니다... (시간이 좀 걸려요)")
        try:
            audio_path = download_audio(request.url, video_id)
            print("   👉 오디오 다운로드 완료. AI에게 듣게 하는 중...")
            
            audio_file = genai.upload_file(audio_path)
            response = model.generate_content([prompt, audio_file])
            
            # 파일 삭제 (청소)
            if os.path.exists(audio_path):
                os.remove(audio_path)
                
        except Exception as e:
            print(f"❌ 오디오 분석 실패: {e}")
            traceback.print_exc()
            err_str = str(e)
            if "bot" in err_str.lower() or "Sign in" in err_str or "cookies" in err_str.lower():
                msg = (
                    "이 영상에는 자막이 없고, 오디오 다운로드가 YouTube 제한으로 불가합니다. "
                    "자막이 있는 요리 영상으로 시도해 주세요."
                )
            else:
                msg = "자막을 찾을 수 없고 오디오 분석도 실패했습니다."
            raise HTTPException(
                status_code=500,
                detail=_error_body("NO_TRANSCRIPT", msg),
            )

    try:
        ai_result = json.loads(response.text)
        
        # 데이터 검증 및 정규화
        ingredients = ai_result.get('ingredients', [])
        if not isinstance(ingredients, list):
            ingredients = []
        # 문자열로 변환 (혹시 다른 타입이 들어올 경우 대비)
        ingredients = [str(item) for item in ingredients if item]
        
        steps = ai_result.get('steps', [])
        if not isinstance(steps, list):
            steps = []
        
        # steps 정규화: time과 desc 필드 확인
        normalized_steps = []
        for step in steps:
            if isinstance(step, dict):
                normalized_step = {
                    "time": int(step.get('time', 0)) if isinstance(step.get('time'), (int, float)) else 0,
                    "desc": str(step.get('desc', step.get('description', ''))) if step.get('desc') or step.get('description') else ''
                }
                if normalized_step['desc']:  # desc가 비어있지 않을 때만 추가
                    normalized_steps.append(normalized_step)
        
        final_response = {
            "youtubeId": video_id,
            "title": metadata.get('title', '제목 없음'),
            "channelName": metadata.get('channel', '알 수 없음'),
            "thumbnailUrl": metadata.get('thumbnail', ''),
            "ingredients": ingredients,
            "steps": normalized_steps
        }
        
        # 터미널에 예쁘게 출력 (한글 깨짐 방지 포함)
        print("📢 [생성된 JSON 데이터]")
        print(json.dumps(final_response, ensure_ascii=False, indent=2))
        
        # 데이터 검증: 필수 필드 확인
        if not final_response['ingredients']:
            print("⚠️ 경고: 재료 목록이 비어있습니다.")
        if not final_response['steps']:
            print("⚠️ 경고: 조리 단계가 비어있습니다.")

        return final_response

    except json.JSONDecodeError as e:
        print(f"❌ JSON 파싱 실패: {e}")
        print(f"📋 원본 응답: {response.text}")
        raise HTTPException(
            status_code=500,
            detail=_error_body("PARSE_ERROR", "AI 응답 처리 중 오류가 발생했습니다. 다시 시도해 주세요."),
        )
    except Exception as e:
        print(f"❌ 예상치 못한 오류: {e}")
        traceback.print_exc()
        raise HTTPException(
            status_code=500,
            detail=_error_body("AI_ERROR", f"AI 응답 오류: {str(e)}"),
        )

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)