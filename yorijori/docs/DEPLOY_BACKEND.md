# 요리조리 백엔드 클라우드 배포 (앱 스토어 심사 통과용)

앱 스토어 심사 시 **분석하기** 버튼이 동작하려면, 심사관이 테스트할 때 백엔드 서버가 **항상 접근 가능**해야 합니다.  
로컬 PC + ngrok은 PC가 꺼지거나 ngrok이 끊기면 실패하므로, **클라우드에 백엔드를 배포**한 뒤 앱에서 그 URL을 쓰도록 설정해야 합니다.

---

## 1. Render로 배포 (무료 플랜 가능)

### 1) 저장소 준비

- 이 프로젝트를 **GitHub**에 올려 두세요.
- **저장소 루트**에 `Dockerfile`(백엔드 빌드용)이 있어야 합니다. 없으면 Render가 `open Dockerfile: no such file or directory` 로 실패합니다.
- 터미널에서 확인 후 푸시:
  ```bash
  git status   # Dockerfile이 보여야 함
  git add Dockerfile render.yaml backend/
  git commit -m "Add Dockerfile and render.yaml for Render"
  git push
  ```
- **Blueprint 사용 시**: 루트에 `render.yaml`이 있으면 Render 대시보드에서 **New → Blueprint**로 이 저장소를 연결해 한 번에 배포할 수 있습니다.

### 2) Render에서 서비스 생성

1. [render.com](https://render.com) 가입 후 로그인.
2. **Dashboard** → **New** → **Web Service**.
3. GitHub 저장소 연결 후:
   - **Root Directory**: **비워 두기** (지우거나 비워 두면 저장소 루트 사용).
   - **Environment**: **Docker** 선택. (루트의 `Dockerfile`이 백엔드용으로 사용됩니다.)
   - **Instance Type**: Free 선택 (무료는 15분 미사용 시 슬립 → 첫 요청 시 지연 가능).
4. **Environment** 탭에서 환경 변수 추가:
   - `GEMINI_API_KEY` = (Google AI Studio에서 발급한 Gemini API 키).
5. **Create Web Service**로 배포 시작.

### 3) URL 확인

- 배포가 끝나면 **서비스 URL**이 나옵니다. 예: `https://yorijori-api.onrender.com`
- 이 URL을 **앱의 프로덕션 URL**로 사용합니다.

---

## 2. 앱에서 프로덕션 URL 설정

1. **`lib/utils/constants.dart`** 열기.
2. **`prodApiBaseUrl`** 값을 위에서 받은 URL로 변경 (끝에 `/` 없이).

```dart
static const String prodApiBaseUrl = 'https://yorijori-api.onrender.com';
```

3. **릴리스 빌드** 시에는 자동으로 `prodApiBaseUrl`이 사용됩니다 (이미 `kReleaseMode`로 분기되어 있음).
4. **앱 스토어 제출용** 아카이브/빌드는 반드시 **Release** 모드로 하세요.

---

## 3. 로컬 개발 (백엔드)

- **처음 한 번**: `backend/.env.example`을 복사해 `backend/.env`를 만들고, Gemini API 키를 넣습니다.
  ```bash
  cp backend/.env.example backend/.env
  # .env 파일을 열어 GEMINI_API_KEY=실제키값 으로 수정
  ```
- **실행**:
  ```bash
  cd backend
  pip install -r requirements.txt
  python main.py
  ```
- 앱은 디버그 빌드 시 `devApiBaseUrl`(ngrok 등)을 그대로 사용합니다.

---

## 4. 무료 플랜 참고 (Render)

- **Free** 인스턴스는 약 15분 동안 요청이 없으면 **슬립**합니다.
- 심사관이 처음 **분석하기**를 누를 때 깨우는 데 30초~1분 걸릴 수 있어, 앱 타임아웃(60초)에 걸릴 수 있습니다.
- **심사 통과를 우선**하려면:
  - 유료 플랜(예: Render Starter)으로 상시 가동, 또는
  - 재제출 전에 브라우저 등으로 프로덕션 URL 한 번 호출해 서비스를 깨워 둔 뒤 제출하는 방법을 고려할 수 있습니다.

---

## 5. 요약

| 단계 | 할 일 |
|------|--------|
| 1 | Render에서 `backend` 기준 Web Service 생성 (Docker), `GEMINI_API_KEY` 설정 |
| 2 | 배포된 URL을 `constants.dart`의 `prodApiBaseUrl`에 넣기 |
| 3 | 앱은 **Release**로 빌드 후 앱 스토어 제출 |
| 4 | 심사 시 **분석하기**는 클라우드 서버로 요청 → 항상 동작 가능 |

이렇게 하면 심사관 기기에서 **분석하기**를 눌러도 클라우드 서버로 요청이 가므로, “분석하기 버튼 탭 시 에러”로 인한 2.1 거절을 피할 수 있습니다.

---

## 6. "open Dockerfile: no such file or directory" 나올 때

- **원인**: Render가 저장소에서 `Dockerfile`을 찾지 못함 (루트에 없거나, 커밋/푸시가 안 됨).
- **해결**:
  1. 프로젝트 **루트**에 `Dockerfile`이 있는지 확인.
  2. `git add Dockerfile && git commit -m "Add Dockerfile" && git push` 로 푸시.
  3. Render에서 **Root Directory**는 비워 두기.
  4. GitHub에 푸시한 브랜치가 Render가 연결한 브랜치와 같은지 확인.
