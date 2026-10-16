#!/usr/bin/env bash
# Android 프로젝트를 생성하고 위치 권한을 추가한다 (CI와 로컬 공용). 생성물(android/)은 커밋하지 않는다.
set -euo pipefail
cd "$(dirname "$0")"
[ -d android ] || npx cap add android
MANIFEST=android/app/src/main/AndroidManifest.xml
for perm in ACCESS_COARSE_LOCATION ACCESS_FINE_LOCATION; do
  grep -q "android.permission.$perm" "$MANIFEST" || sed -i "s#</manifest>#    <uses-permission android:name=\"android.permission.$perm\" />\n</manifest>#" "$MANIFEST"
done
npx cap sync android
