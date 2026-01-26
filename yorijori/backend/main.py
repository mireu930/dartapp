import os
import json
import re
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
from youtube_transcript_api import YouTubeTranscriptApi
from yt_dlp import YoutubeDL
import google.generativeai as genai

# ==========================================
# [설정] 구글 Gemini API 키를 여기에 입력하세요
# https://aistudio.google.com/app/apikey 에서 발급 가능
GEMINI_API_KEY = "AIzaSyB_QrJNahM5ghtF5sjxJD_UudxRtI3Z1FE" # 👈 여기에 발급받은 키를 붙여넣으세요!
# ==========================================

# Gemini 설정
genai.configure(api_key=GEMINI_API_KEY)

# 모델 설정 (gemini-1.5-flash가 빠르고 요리 분석에 충분합니다)
model = genai.GenerativeModel('gemini-1.5-flash',
                              generation_config={"response_mime_type": "application/json"})

app = FastAPI()

class AnalyzeRequest(BaseModel):
    url: str

def extract_video_id(url):
    """유튜브 URL에서 video_id만 추출하는 함수"""
    patterns = [
        r'(?:v=|\/)([0-9A-Za-z_-]{11}).*',
        r'(?:youtu\.be\/)([0-9A-Za-z_-]{11})'
    ]
    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    raise ValueError("올바른 유튜브 URL이 아닙니다.")

def get_video_metadata(url):
    """yt-dlp를 이용해 제목, 채널명, 썸네일 추출"""
    ydl_opts = {'quiet': True, 'no_warnings': True}
    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)
        return {
            "title": info.get('title', '제목 없음'),
            "channel": info.get('uploader', '알 수 없음'),
            "thumbnail": info.get('thumbnail', ''),
        }

@app.post("/api/v1/analyze")
async def analyze_recipe(request: AnalyzeRequest):
    print(f"✅ 분석 요청 받음: {request.url}")
    
    try:
        # 1. Video ID 추출
        video_id = extract_video_id(request.url)
        
        # 2. 영상 메타데이터 가져오기
        print("1️⃣ 메타데이터 추출 중...")
        metadata = get_video_metadata(request.url)
        
        # 3. 자막(Transcript) 가져오기
        print("2️⃣ 자막 다운로드 중...")
        try:
            transcript_list = YouTubeTranscriptApi.get_transcript(video_id, languages=['ko', 'en'])
            # Gemini는 긴 텍스트도 잘 처리하므로 자막 전체를 합칩니다.
            full_text = " ".join([f"[{int(t['start'])}초] {t['text']}" for t in transcript_list])
        except Exception:
            raise HTTPException(status_code=400, detail="이 영상에는 자막이 없어 분석할 수 없습니다.")

        # 4. Gemini에게 분석 요청
        print("3️⃣ Gemini AI 분석 진행 중...")
        
        prompt = f"""
        너는 요리 레시피 분석 전문가야. 아래 제공된 유튜브 자막을 바탕으로 요리 재료와 조리 과정을 추출해줘.

        [자막 내용]
        {full_text}

        [요청 사항]
        1. 반드시 아래 JSON 포맷으로만 응답해. (Markdown 코드 블럭 없이 순수 JSON만)
        2. steps의 'time'은 자막의 [초] 정보를 참고해서 해당 조리 단계가 시작되는 가장 정확한 시간을 숫자로 적어.
        3. steps의 'desc'는 조리 행동을 명확하게 요약해.
        4. ingredients는 수량 정보가 있다면 포함해서 적어.

        [JSON 응답 형식]
        {{
            "ingredients": ["돼지고기 200g", "김치 1포기", ...],
            "steps": [
                {{"time": 10, "desc": "돼지고기를 냄비에 넣고 볶습니다."}},
                {{"time": 60, "desc": "김치를 넣고 함께 볶아줍니다."}}
            ]
        }}
        """

        response = model.generate_content(prompt)

        # 5. 결과 파싱 및 병합
        ai_result = json.loads(response.text)
        
        final_response = {
            "youtubeId": video_id,
            "title": metadata['title'],
            "channelName": metadata['channel'],
            "thumbnailUrl": metadata['thumbnail'],
            "ingredients": ai_result.get('ingredients', []),
            "steps": ai_result.get('steps', [])
        }
        
        print("✅ 분석 완료!")
        return final_response

    except Exception as e:
        print(f"❌ 에러 발생: {e}")
        # 디버깅을 위해 에러 내용을 상세히 출력
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)