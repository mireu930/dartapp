# iOS 시뮬레이터 실행 (CocoaPods 오류 해결)

## "CocoaPods not installed" 나올 때

Cursor/IDE Run 버튼은 **PATH에 `/usr/local/bin`이 없어서** Flutter가 `pod`를 못 찾는 경우가 있습니다. 아래 방법 중 하나로 실행하세요.

### 방법 1: Cursor에서 Task로 실행 (권장)

1. **Terminal** 메뉴 → **Run Task...**
2. **"Run iOS Simulator (CocoaPods PATH fix)"** 선택
3. 시뮬레이터가 뜨고 앱이 실행됩니다.

### 방법 2: 터미널에서 실행

```bash
# 프로젝트 루트에서
./run_ios.sh
```

또는

```bash
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
flutter run -d "iPhone 15"
```

### 다른 기기로 실행

```bash
./run_ios.sh "iPhone 15 Pro"
./run_ios.sh "iPad Pro 11-inch (M5)"
```
