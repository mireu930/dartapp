#!/bin/bash
# iPad 시뮬레이터에서 앱 실행 (CocoaPods PATH 설정 포함)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
cd "$(dirname "$0")"

# 기본: iPad Pro 11-inch (M5). 다른 기기는 첫 번째 인자로 전달 가능
# 예: ./run_ipad.sh "iPad Pro 13-inch (M5)"
DEVICE="${1:-iPad Pro 11-inch (M5)}"
echo "📱 실행 대상: $DEVICE"
flutter run -d "$DEVICE" "${@:2}"
