# 요리조리 백엔드 - Render 배포용 (저장소 루트)
# Render: Root Directory 비워 두고 이 Dockerfile 사용
FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ .

EXPOSE 8000
CMD sh -c 'uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}'
