#!/bin/bash
# iOS 시뮬레이터 실행 (CocoaPods를 찾을 수 있도록 PATH 설정)
# Cursor/IDE에서 "CocoaPods not installed" 나오면 터미널에서 이 스크립트로 실행하세요.
# 사용법: ./run_ios.sh          → iPhone 15
#         ./run_ios.sh "iPhone 15"  → 해당 기기
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
cd "$(dirname "$0")"
DEVICE="${1:-iPhone 15}"
flutter run -d "$DEVICE" "${@:2}"
