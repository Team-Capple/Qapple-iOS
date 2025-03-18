# 🥕 Qapple-iOS

## 프로젝트 개요
|상태|앱스토어 배포 완료 및 업데이트 진행 중(v2.0.3)|
|:--|:--|
|기술 스택|SwiftUI, TCA, Keychain, SPM, Firebase, Google Analytics, Github Actions|
|앱스토어|[캐플 - 아카데미 러너끼리 익명으로 답변하기](https://apps.apple.com/kr/app/qapple-%EC%BA%90%ED%94%8C/id6480340462)|
|Repository 패키지|[Qapple-Repository](https://github.com/Team-Capple/Qapple-Repository)|
|이메일 문의|0.team.capple@gmail.com|

#### 시즌 1) MVP 개발을 통한 빠른 피드백 수집 (24. 01. 22 ~ 24. 04. 01)
|총 인원|7명|
|:--|:--|
|iOS|한톨 Hantol, 리버 Liver, 웰디 WellD|
|Back-End|리버 Liver, 망고 Mango, 루시 Lucy, 아리 Ari|
|UXUI|라무네 Ramune|

#### 시즌 2) 유지보수 및 TCA 리팩토링 (24. 04. 01 ~ 진행 중)
|총 인원|10명|
|:--|:--|
|iOS|한톨 Hantol, 시몬스 Simmons, 무니 Mooni|
|PM|프라이데이 Friday, 세미 Sammy|
|Back-End|리버 Liver, 망고 Mango, 루시 Lucy, 아리 Ari|
|UXUI|라무네 Ramune|

### 스크린샷
![image](https://github.com/user-attachments/assets/94c3601d-dfef-4037-97e5-c98ee5bc86b5)

### 폴더 구조
~~~
🍎
├── 🗂️Qapple
│   ├── 🗂️Qapple
│   │   ├── 📄QappleApp.swift         # 앱의 진입점
│   │   ├── 🗂️QappleBox               # 앱의 설정 및 보안 관련 파일 저장소 (공개 X)
│   │   ├── 🗂️Resource                # 앱에서 사용하는 리소스 (UI 및 설정 관련)
│   │   └── 🗂️SourceCode
│   │       ├── 🗂️App                 # 앱의 핵심 설정 및 진입점 관련 코드
│   │       ├── 🗂️Data
│   │       │   ├── 🗂️Repository      # 데이터 저장소 (데이터 관리 및 캐싱)
│   │       │   └── 🗂️Service         # API 통신 및 데이터 서비스
│   │       ├── 🗂️Entity              # 데이터 모델 정의
│   │       ├── 🗂️Feature
│   │       │   ├── 🗂️0.SignUpFlow    # 회원가입 및 로그인 관련 화면
│   │       │   ├── 🗂️1.MainFlow      # 앱의 메인 화면 및 기본 네비게이션
│   │       │   ├── 🗂️2.QuestionTab   # 질문 관련 UI 및 로직
│   │       │   ├── 🗂️3.BulletinBoard # 게시판 관련 UI 및 로직
│   │       │   ├── 🗂️4.Comment       # 댓글관련 UI 및 로직
│   │       │   ├── 🗂️5.Profile       # 사용자 프로필 관련 UI 및 로직
│   │       │   ├── 🗂️6.Notification  # 알림 기능 (푸시 알림 등)
│   │       │   ├── 🗂️7.SeeMoreSheet  # 더보기 시트 UI
│   │       │   └── 🗂️8.Report        # 신고 기능
│   │       ├── 🗂️UIComponent         # 공통 UI 컴포넌트
│   │       └── 🗂️Utility             # 유틸리티 함수 및 헬퍼 클래스
│   ├── Qapple.xcodeproj              # Xcode 프로젝트 파일
│   └── 🗂️QappleTests                 # 테스트 코드 폴더
└── 📄README.md                       
~~~

### 이벤트 Flow
![image](https://github.com/user-attachments/assets/f8ca3858-7ca3-4191-b604-8d87688643cb)


## 트러블 슈팅
- [무니 Mooni의 CI/CD 구축기 with Github Actions (1)](https://velog.io/@mooninbeom/CICD-구축기-with-Github-Actions-1)
- [한톨의 캐플 리팩토링 첫 번째 이야기 - 방향성 설정하기](https://thinkyside.tistory.com/56)
- [한톨의 캐플 리팩토링 두 번째 이야기 - 프로젝트 세팅하기](https://thinkyside.tistory.com/58)
- [한톨의 캐플 리팩토링 세 번째 이야기 - 트러블 슈팅](https://thinkyside.tistory.com/66) 
- [한톨의 캐플 리팩토링 네 번째 이야기 - Repository 모듈 만들기](https://thinkyside.tistory.com/90)

## 프로젝트 회고
- [시몬스의 회고](https://dding-genie.tistory.com/38)
