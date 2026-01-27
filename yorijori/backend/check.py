import google.generativeai as genai

# 본인 API 키 입력
GEMINI_API_KEY = "AIzaSyB_QrJNahM5ghtF5sjxJD_UudxRtI3Z1FE" 
genai.configure(api_key=GEMINI_API_KEY)

print("사용 가능한 모델 목록:")
for m in genai.list_models():
    if 'generateContent' in m.supported_generation_methods:
        print(m.name)