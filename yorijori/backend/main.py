from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn

app = FastAPI()

class AnalyzeRequest(BaseModel):
    url: str

@app.get("/")
def read_root():
    return {"message": "Server is running"}

@app.post("/api/v1/analyze")
async def analyze_recipe(request: AnalyzeRequest):
    print(f"✅ 요청 받음: {request.url}")

    return {
        # 1. api_response.dart (CamelCase)
        "youtubeId": "video_123",
        "title": "초간단 김치찌개",
        "channelName": "백종원 PAIK JONG WON",
        "thumbnailUrl": "https://img.youtube.com/vi/qWbHSOplcvY/maxresdefault.jpg",
        "ingredients": [
            "김치 1포기", 
            "돼지고기 200g",
            "두부 1모"
        ],
        
        # 2. [핵심 수정] step.dart에 정의된 변수명(time, desc)과 100% 일치시킴
        "steps": [
            {
                "time": 10,       # 기존 timestamp -> time 으로 변경
                "desc": "돼지고기를 볶아주세요." # 기존 description -> desc 로 변경
            },
            {
                "time": 60,
                "desc": "김치를 넣고 볶습니다."
            },
            {
                "time": 120,
                "desc": "물을 붓고 끓으면 두부를 넣어주세요."
            }
        ]
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)