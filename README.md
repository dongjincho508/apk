# 픽잇 Android APK

[픽잇](https://pickit-six.vercel.app)(오늘 뭐 먹지?)의 Android 앱 배포 저장소입니다. 앱은 배포된 웹을 그대로 보여주는 Capacitor 래퍼이며, 웹 소스 코드는 이 저장소에 없습니다.

## 다운로드
**[최신 APK 받기](https://github.com/dongjincho508/apk/releases/latest/download/pickit.apk)** · [모든 버전](https://github.com/dongjincho508/apk/releases)

- 디버그 서명 APK(사이드로딩용)입니다. 설치할 때 "출처를 알 수 없는 앱" 허용이 필요합니다.
- 위치 권한은 "내 주변 식당" 기능을 쓸 때 요청합니다.

## 빌드
`main`에 `android-app/`이 바뀌면 GitHub Actions가 APK를 빌드해 Releases에 올립니다. Actions 탭에서 수동 실행도 가능합니다.
