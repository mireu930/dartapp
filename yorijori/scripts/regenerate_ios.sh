#!/bin/bash
# iOS 폴더를 Flutter 기본 템플릿으로 재생성 (IPA Undefined symbol 해결 시도)
# 사용법: 프로젝트 루트(yorijori)에서 ./scripts/regenerate_ios.sh

set -e
cd "$(dirname "$0")/.."
PROJECT_ROOT=$(pwd)

echo "=== 1. 백업 ==="
BACKUP_NAME="ios_backup_$(date +%Y%m%d_%H%M%S)"
cp -R ios "$BACKUP_NAME"
echo "백업 완료: $BACKUP_NAME"

echo "=== 2. Podfile 보존 (post_install 등) ==="
cp ios/Podfile /tmp/yorijori_Podfile_backup

echo "=== 3. Info.plist, 앱 아이콘 등 보존 ==="
mkdir -p /tmp/yorijori_ios_backup
cp -R ios/Runner/Info.plist /tmp/yorijori_ios_backup/ 2>/dev/null || true
cp -R ios/Runner/Assets.xcassets /tmp/yorijori_ios_backup/ 2>/dev/null || true
cp -R ios/Runner/Base.lproj /tmp/yorijori_ios_backup/ 2>/dev/null || true

echo "=== 4. ios 폴더 삭제 ==="
rm -rf ios

echo "=== 5. Flutter로 ios 플랫폼 재생성 ==="
flutter create . --platforms=ios

echo "=== 6. 보존한 Podfile 복원 ==="
cp /tmp/yorijori_Podfile_backup ios/Podfile

echo "=== 7. Info.plist 등 복원 (필요 시) ==="
cp /tmp/yorijori_ios_backup/Info.plist ios/Runner/Info.plist 2>/dev/null || true
# Assets는 새 템플릿 것 유지해도 되고, 기존 앱 아이콘 쓰려면 아래 주석 해제
# cp -R /tmp/yorijori_ios_backup/Assets.xcassets/* ios/Runner/Assets.xcassets/ 2>/dev/null || true

echo "=== 8. flutter pub get && pod install ==="
flutter pub get
cd ios && pod install && cd ..

echo ""
echo "=== 완료. 아래 명령으로 IPA 빌드해 보세요. ==="
echo "  flutter build ipa"
echo ""
