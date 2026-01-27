📱 기획안: AI 쿠킹 어시스턴트 "요리조리"

## 📊 프로젝트 현황 (2026.01.27)

### ✅ 구현 완료
- **홈 화면**: 레시피 리스트 표시, 추가, 삭제 기능
- **레시피 분석**: YouTube URL 입력 → AI 분석 → 데이터베이스 저장
- **백엔드 API**: FastAPI + Gemini 2.5 Flash를 활용한 레시피 추출
- **로컬 데이터베이스**: Drift를 사용한 SQLite 저장소
- **데이터 모델**: Recipe, Step, API Response 모델 구조화
- **에러 처리**: 네트워크, 파싱, 검증 에러 처리
- **UI/UX**: Material Design 3 기반 테마 적용

### 🚧 구현 중 / 미구현
- **레시피 상세 화면**: YouTube 플레이어 연동 (기본 UI만 구현됨)
- **재료 체크리스트**: 체크박스 토글 기능
- **타임스탬프 연동**: 조리 단계 클릭 시 영상 자동 이동
- **Wakelock**: 화면 자동 꺼짐 방지
- **로딩 애니메이션**: Lottie 애니메이션

---

## 1. 서비스 개요 및 핵심 가치

**슬로건**: "영상은 한 번만, 요리는 편하게."

**서비스 정의**: 유튜브 요리 영상 링크만 넣으면, AI가 '재료 체크리스트'와 '단계별 레시피'로 변환해주고, 나만의 요리 기록으로 저장해주는 서비스.

해결하려는 문제:

요리 도중 젖은 손으로 영상을 계속 멈추거나 뒤로 감기 해야 하는 불편함.

영상 설명란에 재료가 없거나, 영상 중간에만 나오는 꿀팁을 놓치는 문제.

"저번에 그 영상 뭐였지?" 하고 다시 찾아 헤매는 번거로움.

2. 타겟 오디언스 (Target Audience)
선생님 본인의 상황과 시장 수요를 반영하여 두 가지 핵심 페르소나를 설정했습니다.

A. "효율 중시형 예비/신혼부부" (Main Target)

특징: 맞벌이 등으로 바빠서 저녁 준비 시간을 줄이고 싶음. 유튜브(백종원, 류수영 등)를 보고 따라 하지만, 영상 켜놓고 요리하는 게 정신없음.

니즈: 장보기 리스트가 필요하고, 요리할 때는 핵심만 딱 보고 싶음.

B. "체계적인 홈쿡 러버" (Sub Target)

특징: 요리를 취미로 하며 새로운 레시피 도전을 즐김.

니즈: 내가 성공했던 레시피를 날짜별로 기록(아카이빙)하고 싶어 함.

## 3. 핵심 기능 (Core Features)

### ① AI 레시피 추출 (Magic Parser) ✅ **구현 완료**
- **기능**: 유튜브 링크 입력 시 약 10~20초 내에 분석 완료
- **구현 상태**: 
  - ✅ YouTube URL 유효성 검증
  - ✅ 자막 추출 (YouTube Transcript API)
  - ✅ 자막 없을 경우 오디오 분석 (Gemini 2.5 Flash)
  - ✅ LLM을 통한 재료/조리법 구조화
  - ✅ 데이터 정규화 및 검증

- **출력 내용**:
  - 재료(Ingredients): 수치(g, 스푼)까지 정확히 명시된 체크리스트
  - 조리법(Steps): 불필요한 사담은 제거하고, 핵심 행동 단위로 문장 요약
  - 타임스탬프: 각 조리 단계의 시작 시간(초 단위)

### ② 타임스탬프 연동 플레이어 (Sync Player) 🚧 **구현 예정**
- **기능**: 텍스트 레시피의 "Step 3. 양파 볶기"를 터치하면, 상단 영상이 해당 구간(예: 03:45)으로 즉시 점프하여 재생
- **구현 상태**: 
  - ✅ 조리 단계 UI 카드 (타임스탬프 표시)
  - 🚧 YouTube 플레이어 연동
  - 🚧 Tap-to-Seek 기능
  - 🚧 현재 재생 중인 단계 하이라이팅

- **가치**: 텍스트만으로 이해 안 될 때, 딱 그 부분만 영상으로 확인 가능

### ③ 데일리 쿡 로그 (Daily Cook Log) ✅ **구현 완료**
- **기능**: 사용자가 변환한 레시피를 날짜별 히스토리로 자동 저장
- **구현 상태**:
  - ✅ 레시피 자동 저장 (로컬 SQLite)
  - ✅ 최신순 정렬 리스트 표시
  - ✅ 레시피 카드 UI (썸네일, 제목, 채널명, 날짜)
  - ✅ 스와이프 삭제 기능
  - ✅ 빈 상태 UI

- **UI 구성**: 타임라인 리스트 뷰 (캘린더 뷰는 옵션)
- **저장 형식**: "2026.01.26 - 류수영의 제육볶음" 형태로 카드 저장
- **미구현**: 직접 만든 요리 사진을 한 장 찍어서 썸네일로 교체하는 기능(옵션)

4. 디자인 컨셉 (Design Concept)
타겟(2030, 신혼, 개발자)에게 어필할 수 있는 **'깔끔함'과 '따뜻함'**이 공존해야 합니다.

키워드: Clean, Focus, Warm

컬러 팔레트:

Primary (메인): Burnt Orange (#E65100) - 식욕을 돋우고 따뜻한 부엌 느낌.

Background: Cream White (#FDFBF7) - 쨍한 흰색보다 눈이 편안한 미색.

Text: Dark Gray (#333333) - 가독성 최우선.

UI 스타일:

카드형 레이아웃: 각 조리 단계(Step)가 하나의 큼직한 카드로 구분되어야 함.

Big Typos: 요리 중에는 폰을 멀리 두고 보므로, 글씨 크기가 평소 앱보다 1.2~1.5배 커야 함.

인터랙션: 체크리스트 터치 시 기분 좋은 햅틱 반응(진동)과 취소선 애니메이션 적용.

## 5. 화면 구성안 (Wireframe Idea)

### A. 메인 (홈) 화면 - [리스트 페이지] ✅ **구현 완료**
- **상단**: AppBar (앱 이름)
- **중단**: [내가 만든 요리 기록] 리스트
  - ✅ 최근 날짜 순으로 카드 나열
  - ✅ 각 카드에는 유튜브 썸네일, 요리 이름, 채널명, 만든 날짜 표시
  - ✅ 빈 상태 UI (레시피가 없을 때)
- **하단**: Floating Action Button (+) -> 링크 입력 모달 팝업
  - ✅ URL 입력 필드
  - ✅ 클립보드 붙여넣기 버튼
  - ✅ 분석 중 로딩 표시
  - ✅ 중복 레시피 검사

### B. 상세 (레시피) 화면 - [변환 결과] 🚧 **부분 구현**
- **구현 완료**:
  - ✅ 요리 제목, 채널명 표시
  - ✅ 재료 목록 표시 (아이콘 포함)
  - ✅ 조리법 단계별 카드 리스트 (번호, 설명, 타임스탬프)

- **구현 예정**:
  - 🚧 최상단: 유튜브 플레이어 (평소엔 작게, 필요시 전체화면)
  - 🚧 중단 탭: [재료] / [조리법] 탭으로 구분
  - 🚧 [재료] 탭: 체크박스 토글 기능 ("장보기 모드")
  - 🚧 [조리법] 탭: 각 카드 우측에 ▶ 영상 보기 아이콘 배치
  - 🚧 Tap-to-Seek: 카드 클릭 시 해당 타임스탬프로 영상 이동

---

## 6. 기술 스택 및 아키텍처

### 프론트엔드 (Flutter)
- **프레임워크**: Flutter 3.x
- **상태 관리**: StatefulWidget (현재), 추후 Provider/Riverpod 고려
- **로컬 DB**: Drift (SQLite ORM)
- **네트워크**: Dio
- **이미지**: cached_network_image
- **날짜 포맷**: intl

### 백엔드 (Python)
- **프레임워크**: FastAPI
- **AI 모델**: Google Gemini 2.5 Flash
- **YouTube 처리**: 
  - youtube-transcript-api (자막 추출)
  - yt-dlp (오디오 다운로드)
- **오디오 처리**: FFmpeg

### 데이터베이스
- **로컬**: SQLite (Drift ORM)
- **스키마**: recipes 테이블 (id, youtube_id, title, channel_name, thumbnail_url, ingredients, steps, created_at)

---

# 📋 프로젝트: AI 쿠킹 어시스턴트 "요리조리" 요구사항 정의서

## 1. 시스템 개요

* **목적:** 유튜브 요리 영상의 시청 불편함(반복 재생, 정지)을 해소하기 위해, 영상을 분석하여 '재료 체크리스트'와 '타임스탬프 연동 레시피'를 제공하고 이를 아카이빙함.
* **개발 환경:**
* **Client:** Flutter (Android / iOS)
* **Server:** Python FastAPI (LangChain + OpenAI/Gemini API)
* **Database:** Local SQLite (via Drift or Sqflite package)



---

## 2. 기능 요구사항 (Functional Requirements)

### **FR-01. 레시피 생성 (Creation & AI Processing)**

사용자가 유튜브 링크를 입력하고 AI 분석 결과를 받아오는 과정입니다.

* **[REQ-1.1] URL 유효성 검증 (Client)**
* **입력:** 사용자가 텍스트 필드에 URL을 입력하고 '분석하기' 버튼을 누른다.
* **로직:** 정규식(`^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$`)을 사용하여 유효성을 검사한다.
* **예외:** 형식이 올바르지 않을 경우, `Toast` 또는 `SnackBar`로 "올바른 유튜브 링크를 입력해주세요." 메시지를 출력하고 서버 요청을 차단한다.


* **[REQ-1.2] 자막 추출 및 구조화 (Server)**
* **입력:** 클라이언트로부터 `youtube_url`을 전송받는다.
* **프로세스:**
1. `youtube-transcript-api`를 통해 자막 텍스트와 시작 시간(`start`)을 추출한다.
2. LLM에게 자막을 전달하여 아래 JSON 스키마로 변환을 요청한다.
* `title`: 요리 제목 (String)
* `ingredients`: 재료 목록 (List<String>) - *수량 포함 (예: "양파 1/2개")*
* `steps`: 조리 단계 리스트 (List<Object>)
* `time`: 해당 단계 시작 시간 (초 단위, Integer)
* `desc`: 조리 설명 (String)






* **출력:** 구조화된 JSON 데이터를 클라이언트에 반환한다.


* **[REQ-1.3] 예외 처리 (Server/Client)** ✅
  * **자막 없음:** 서버에서 Transcript 추출 실패 시 오디오 분석으로 자동 전환. 실패 시 `500 Internal Server Error` 반환. 클라이언트는 "자막이 없어 AI가 분석할 수 없는 영상입니다."를 출력한다.
  * **비요리 영상:** (현재 미구현, 추후 LLM 필터링 추가 예정)
  * **파싱 에러:** JSON 파싱 실패 시 상세 에러 메시지와 함께 처리
  * **네트워크 에러:** 타임아웃 및 연결 실패 처리



### **FR-02. 레시피 뷰어 (Recipe Viewer / Player)** 🚧 **부분 구현**

변환된 데이터를 사용자가 실제로 보고 활용하는 화면입니다.

* **[REQ-2.1] 고정형 영상 플레이어 (Sticky Player)** 🚧
  * **UI:** `youtube_player_flutter` 또는 `webview_flutter` 위젯을 화면 최상단(SafeArea 아래)에 고정 배치한다.
  * **동작:** 스크롤을 내려도 플레이어는 사라지지 않으며, 화면 비율은 16:9를 유지한다.
  * **구현 상태:** 기본 레시피 상세 화면 구조만 구현됨, 플레이어 연동 필요

* **[REQ-2.2] 재료 체크리스트** 🚧
  * **UI:** 영상 플레이어 하단에 `CheckboxListTile` 형태로 재료 목록을 나열한다.
  * **구현 상태:** ✅ 재료 목록 표시 (아이콘 포함), 🚧 체크박스 토글 기능 미구현
  * **동작:** 항목 터치 시 체크박스가 토글(Toggle)되며 텍스트에 취소선(Line-through) 스타일이 적용된다.
  * **데이터:** 체크 상태는 휘발성 데이터로 처리하여, 앱 재실행 시 초기화되어도 무방하다(MVP).

* **[REQ-2.3] 인터랙티브 조리 단계 (Interactive Steps)** 🚧
  * **UI:** 재료 리스트 하단에 `Card` 위젯 리스트로 조리 단계를 나열한다. 각 카드는 `단계 번호`, `설명`, `타임스탬프`를 포함한다.
  * **구현 상태:** ✅ 조리 단계 카드 UI, 🚧 재생 버튼 아이콘 및 Tap-to-Seek 미구현
  * **동작 (Tap-to-Seek):** 사용자가 특정 카드를 탭하면,
    1. 상단 플레이어 컨트롤러의 `seekTo(Duration(seconds: step.time))`를 호출한다.
    2. 이동 후 즉시 `play()`를 실행한다.
  * **하이라이팅 (Highlight):** 현재 선택된(재생 중인) 단계의 카드는 테두리(`Border`) 색상을 Primary Color로 변경하거나, 배경색을 옅게 깔아 시각적으로 강조한다.



### **FR-03. 데일리 쿡 로그 (History & List)** ✅ **구현 완료**

사용자의 요리 기록을 관리하는 기능입니다.

* **[REQ-3.1] 자동 저장 및 정렬** ✅
  * **시점:** FR-01의 분석 결과가 성공적으로 수신되면, 즉시 로컬 DB에 데이터를 `INSERT` 한다.
  * **구현:** `RecipeService.analyzeAndSaveRecipe()` → `AppDatabase.insertRecipe()`
  * **정렬:** 메인 화면 진입 시 `created_at` 필드를 기준으로 내림차순(최신순) 정렬하여 데이터를 조회(`SELECT`)한다.
  * **구현:** `AppDatabase.getAllRecipes()`에서 `OrderingTerm.desc(t.createdAt)` 적용

* **[REQ-3.2] 리스트 카드 UI** ✅
  * 메인 화면 리스트의 각 항목은 다음 정보를 포함한다:
    * ✅ `썸네일 이미지` (좌측, `CachedNetworkImage` 사용)
    * ✅ `요리 제목` (Title)
    * ✅ `채널명` (Channel Name)
    * ✅ `등록 날짜` (YYYY-MM-DD 형식, `intl` 패키지 사용)
  * **구현:** `RecipeCard` 위젯으로 구현

* **[REQ-3.3] 항목 삭제** ✅
  * **UI:** 리스트 항목(ListTile)에 `Dismissible` 위젯을 적용한다.
  * **동작:** 좌/우로 스와이프 시 삭제 아이콘이 노출되며, 스와이프 완료 시 DB에서 해당 row를 `DELETE` 하고 UI를 갱신한다.
  * **구현:** `HomeScreen`에서 `Dismissible` 위젯 사용, `RecipeService.deleteRecipe()` 호출



---

## 3. 비기능 요구사항 (Non-Functional Requirements)

* **[NFR-1] 화면 유지 (Wakelock):** 🚧 **미구현**
  * 레시피 뷰어 화면 진입 시 `wakelock_plus` 패키지를 사용하여 화면 자동 꺼짐을 방지하고, 화면 이탈 시 해제한다. (요리 중 손을 못 쓰므로 필수)
  * **구현 예정:** `pubspec.yaml`에 패키지 추가 필요

* **[NFR-2] 가독성 (Accessibility):** ✅ **구현 완료**
  * 조리법 텍스트(`desc`)의 폰트 크기는 기본 본문(14~16sp)보다 큰 **18sp 이상**으로 설정한다.
  * **구현:** `AppConstants.recipeTextSize = 18.0` 설정, `RecipeDetailScreen`에서 적용

* **[NFR-3] 응답 대기 UX:** 🚧 **부분 구현**
  * AI 분석 대기 시간(약 10~20초 예상) 동안 사용자 이탈을 막기 위해 `Lottie` 애니메이션이나 "AI가 영상을 맛보는 중입니다..." 같은 위트 있는 로딩 문구를 표시한다.
  * **구현 상태:** ✅ 로딩 메시지 표시 (`AppConstants.loadingAnalyzing`), 🚧 Lottie 애니메이션 미구현



---

## 4. 데이터베이스 스키마 (Local DB - SQLite) ✅ **구현 완료**

**Table Name:** `recipes` (Drift ORM 사용)

| 필드명 | 데이터 타입 | 설명 | 비고 |
| --- | --- | --- | --- |
| `id` | `INTEGER` | Primary Key | Auto Increment ✅ |
| `youtube_id` | `TEXT` | 영상 고유 ID | 예: `3A5xL-1z` ✅ |
| `title` | `TEXT` | 요리 제목 | ✅ |
| `channel_name` | `TEXT` | 채널 이름 | ✅ |
| `thumbnail_url` | `TEXT` | 썸네일 URL | ✅ |
| `ingredients` | `TEXT` | 재료 목록 (JSON String) | List를 JSON 직렬화하여 저장 ✅ |
| `steps` | `TEXT` | 조리 단계 (JSON String) | List를 JSON 직렬화하여 저장 ✅ |
| `created_at` | `TEXT` | 생성 일시 | ISO8601 String ✅ |

**구현 파일:**
- `lib/models/recipe.dart`: Recipes 테이블 정의 (Drift)
- `lib/database/app_database.dart`: 데이터베이스 클래스 및 CRUD 메서드
- `lib/database/app_database.g.dart`: Drift 자동 생성 코드

---

## 5. API 인터페이스 명세 (Server Endpoint)

**POST** `/api/v1/analyze`

**Request Body:**

```json
{
  "url": "https://www.youtube.com/watch?v=..."
}

```

**Response Body (200 OK):**

```json
{
  "youtubeId": "VideoID123",
  "title": "초간단 김치찌개",
  "channelName": "백종원 PAIK JONG WON",
  "thumbnailUrl": "https://img.youtube.com/...",
  "ingredients": [
    "묵은지 1/4포기",
    "돼지고기 200g",
    "대파 1대"
  ],
  "steps": [
    {
      "time": 45,
      "desc": "돼지고기를 냄비에 넣고 기름이 나올 때까지 볶습니다."
    },
    {
      "time": 120,
      "desc": "김치와 물 500ml를 넣고 강불에서 끓입니다."
    }
  ]
}
```

**구현 파일:**
- `backend/main.py`: FastAPI 서버, Gemini 2.5 Flash 연동
- `lib/services/api_service.dart`: Dio를 사용한 HTTP 클라이언트
- `lib/models/api_response.dart`: API 응답 모델 (JSON 직렬화)

**에러 응답:**
- `400 Bad Request`: 잘못된 URL 형식
- `500 Internal Server Error`: 자막/오디오 분석 실패, JSON 파싱 실패

---

## 6. 프로젝트 구조

```
yorijori/
├── lib/
│   ├── database/          # 로컬 데이터베이스 (Drift)
│   │   ├── app_database.dart
│   │   └── app_database.g.dart
│   ├── models/            # 데이터 모델
│   │   ├── recipe.dart
│   │   ├── step.dart
│   │   └── api_response.dart
│   ├── screens/           # 화면
│   │   ├── home_screen.dart
│   │   └── recipe_detail_screen.dart
│   ├── services/          # 비즈니스 로직
│   │   ├── api_service.dart
│   │   └── recipe_service.dart
│   ├── utils/             # 유틸리티
│   │   ├── constants.dart
│   │   └── validators.dart
│   ├── widgets/           # 재사용 가능한 위젯
│   │   └── recipe_card.dart
│   └── main.dart
├── backend/               # FastAPI 서버
│   ├── main.py
│   ├── ffmpeg.exe
│   └── ffprobe.exe
└── README.md
```

---

## 7. 다음 단계 (TODO)

### 우선순위 높음
1. **YouTube 플레이어 연동** 🚧
   - `youtube_player_flutter` 또는 `webview_flutter` 패키지 추가
   - 레시피 상세 화면에 플레이어 통합

2. **Tap-to-Seek 기능** 🚧
   - 조리 단계 카드 클릭 시 해당 타임스탬프로 영상 이동
   - 현재 재생 중인 단계 하이라이팅

3. **재료 체크리스트 토글** 🚧
   - `CheckboxListTile`로 재료 체크박스 구현
   - 체크 시 취소선 스타일 적용

### 우선순위 중간
4. **Wakelock 기능** 🚧
   - 레시피 상세 화면 진입 시 화면 자동 꺼짐 방지

5. **로딩 애니메이션** 🚧
   - Lottie 애니메이션 추가
   - AI 분석 중 사용자 경험 개선

### 우선순위 낮음
6. **요리 사진 촬영 기능** (옵션)
   - 직접 만든 요리 사진을 썸네일로 교체

7. **캘린더 뷰** (옵션)
   - 날짜별 레시피 조회 기능

---

**최종 업데이트**: 2026.01.27