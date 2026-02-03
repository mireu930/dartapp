# 요리조리 백엔드 - 클라우드 배포용 (Render, Railway 등)
FROM python:3.11-slim

# FFmpeg 설치 (자막 없을 때 오디오 분석용)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 8000
# Render 등 클라우드는 PORT 환경 변수로 포트 지정
CMD sh -c 'uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}'
