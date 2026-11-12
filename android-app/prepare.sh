#!/usr/bin/env bash
# Android 프로젝트를 생성·설정한다 (CI와 로컬 공용). 생성물(android/)은 커밋하지 않는다.
#   VERSION_CODE  : Play 업로드마다 증가해야 하는 정수 (기본 1)
#   VERSION_NAME  : 사용자에게 보이는 버전 (기본 1.0.0)
#   KEYSTORE_FILE / KEYSTORE_PASSWORD / KEY_ALIAS / KEY_PASSWORD : 설정되면 release 빌드를 업로드 키로 서명
set -euo pipefail
cd "$(dirname "$0")"
[ -d android ] || npx cap add android

MANIFEST=android/app/src/main/AndroidManifest.xml
for perm in ACCESS_COARSE_LOCATION ACCESS_FINE_LOCATION; do
  grep -q "android.permission.$perm" "$MANIFEST" || sed -i "s#</manifest>#    <uses-permission android:name=\"android.permission.$perm\" />\n</manifest>#" "$MANIFEST"
done

GRADLE=android/app/build.gradle
sed -i -E "s/versionCode [0-9]+/versionCode ${VERSION_CODE:-1}/; s/versionName \"[^\"]*\"/versionName \"${VERSION_NAME:-1.0.0}\"/" "$GRADLE"
if ! grep -q "pickit-signing" "$GRADLE"; then
cat >> "$GRADLE" <<'GRADLE_EOF'

// pickit-signing: 환경변수가 있을 때만 release 서명 (비밀값은 저장소에 두지 않는다)
android {
    signingConfigs {
        release {
            if (System.getenv("KEYSTORE_FILE")) {
                storeFile file(System.getenv("KEYSTORE_FILE"))
                storePassword System.getenv("KEYSTORE_PASSWORD")
                keyAlias System.getenv("KEY_ALIAS")
                keyPassword System.getenv("KEY_PASSWORD")
            }
        }
    }
    buildTypes {
        release {
            if (System.getenv("KEYSTORE_FILE")) { signingConfig signingConfigs.release }
        }
    }
}
GRADLE_EOF
fi

# 아이콘: assets/ 에 원본이 있으면 모든 해상도를 생성한다
if [ -f assets/icon-only.png ]; then npx @capacitor/assets generate --android --assetPath assets; fi
npx cap sync android
