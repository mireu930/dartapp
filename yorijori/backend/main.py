from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn

app = FastAPI()

# 앱에서 보내는 데이터 형식 정의
class AnalyzeRequest(BaseModel):
    url: str

@app.get("/")
def read_root():
    return {"message": "요리조리 서버가 실행 중입니다!"}

# [핵심] 레시피 분석 API
@app.post("/api/v1/analyze")
async def analyze_recipe(request: AnalyzeRequest):
    print(f"분석 요청 들어옴: {request.url}")
    
    # 더미 데이터 반환
    return {
        "youtubeId": "dummy_id",
        "title": "초간단 김치찌개 만들기",
        "channelName": "백종원 PAIK JONG WON",
        "thumbnailUrl": "https://img.youtube.com/vi/qWbHSOplcvY/maxresdefault.jpg",
        "ingredients": [
            "김치 1포기",
            "돼지고기 200g",
            "두부 1모",
            "대파 1개"
        ],
        "steps": [
            {"order": 1, "description": "냄비에 돼지고기를 넣고 볶아주세요.", "timestamp": 10},
            {"order": 2, "description": "김치를 넣고 함께 볶습니다.", "timestamp": 45},
            {"order": 3, "description": "물을 붓고 끓으면 두부를 넣어주세요.", "timestamp": 120}
        ]
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)