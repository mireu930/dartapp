import os
import json
import re
import glob
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
from youtube_transcript_api import YouTubeTranscriptApi
from yt_dlp import YoutubeDL
import google.generativeai as genai

# ==========================================
# [설정] 구글 Gemini API 키
GEMINI_API_KEY = "" # 👈 여기에 키를 꼭 넣어주세요!
# ==========================================

genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-2.5-flash',
                              generation_config={"response_mime_type": "application/json"})

app = FastAPI()

class AnalyzeRequest(BaseModel):
    url: str

def extract_video_id(url):
    patterns = [r'(?:v=|\/)([0-9A-Za-z_-]{11}).*', r'(?:youtu\.be\/)([0-9A-Za-z_-]{11})']
    for pattern in patterns:
        match = re.search(pattern, url)
        if match: return match.group(1)
    raise ValueError("올바른 유튜브 URL이 아닙니다.")

def get_video_metadata(url):
    ydl_opts = {'quiet': True, 'no_warnings': True}
    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)
        return {
            "title": info.get('title', '제목 없음'),
            "channel": info.get('uploader', '알 수 없음'),
            "thumbnail": info.get('thumbnail', ''),
        }

def download_audio(url, video_id):
    """자막이 없을 때 오디오를 다운로드하는 함수"""
    # 기존 파일 삭제
    for file in glob.glob(f"{video_id}.*"):
        try: os.remove(file)
        except: pass

    ydl_opts = {
        'format': 'bestaudio/best',
        'postprocessors': [{'key': 'FFmpegExtractAudio','preferredcodec': 'mp3',}],
        'outtmpl': f'{video_id}',
        'quiet': True,
    }
    with YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])
    return f"{video_id}.mp3"

@app.post("/api/v1/analyze")
async def analyze_recipe(request: AnalyzeRequest):
    print(f"✅ 분석 요청: {request.url}")
    video_id = extract_video_id(request.url)
    metadata = get_video_metadata(request.url)
    
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
            raise HTTPException(status_code=500, detail="자막도 없고 오디오 분석도 실패했습니다.")

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
        raise HTTPException(status_code=500, detail=f"AI 응답 JSON 파싱 오류: {str(e)}")
    except Exception as e:
        print(f"❌ 예상치 못한 오류: {e}")
        raise HTTPException(status_code=500, detail=f"AI 응답 오류: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)