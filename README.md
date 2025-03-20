# 🍎 Qapple-iOS / 아카데미 러너끼리 익명으로 소통하기!

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
|iOS|[한톨 Hantol](https://github.com/thinkySide), [리버 Liver](https://github.com/kyxxgsoo), [웰디 WellD](https://www.linkedin.com/in/hyeonheeshim/?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app)|
|Back-End|[리버 Liver](https://github.com/kyxxgsoo), [망고 Mango](https://www.linkedin.com/in/재원-이-859981227/), [루시 Lucy](https://github.com/tnals2384), [아리 Ari](https://github.com/youngeun-dev)|
|UXUI|[라무네 Ramune](https://www.linkedin.com/in/ramunesoojin/)|

#### 시즌 2) 유지보수 및 TCA 리팩토링 (24. 04. 01 ~ 진행 중)
|총 인원|10명|
|:--|:--|
|iOS|[한톨 Hantol](https://github.com/thinkySide), [시몬스 Simmons](https://github.com/OhMyungJin), [무니 Mooni](https://github.com/mooninbeom)|
|PM|[프라이데이 Friday](https://www.linkedin.com/in/minwoo-kim-7b94952b7/), [세미 Sammy](https://www.linkedin.com/in/sammy-kwak-8b2286221/)|
|Back-End|[리버 Liver](https://github.com/kyxxgsoo), [망고 Mango](https://www.linkedin.com/in/재원-이-859981227/), [루시 Lucy](https://github.com/tnals2384), [아리 Ari](https://github.com/youngeun-dev)|
|UXUI|[라무네 Ramune](https://www.linkedin.com/in/ramunesoojin/)|

## 스크린샷
![Group 1000012348 1](https://github.com/user-attachments/assets/78452cb1-b017-4e8b-8b90-ccd25f5083c6)

## 폴더 구조
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

## 이벤트 Flow
![image](https://github.com/user-attachments/assets/9b1112e0-7ce5-4a1e-9d2b-258cbcc1824a)

## 네비게이션 Flow
캐플 팀은 TCA를 활용한 스택형 네비게이션을 정의했습니다.

NavigationStack을 담당하는 Reducer가 하위 View에서 발생하는 Action들을 관찰합니다. 그 중 특정한 Action이 실행될 경우 Path가 변경될 수 있게 했습니다.

### 네비게이션 과정
1. 관찰을 원하는 Reducer을 Path 열거형으로 정의합니다.

```swift
// in SighUpFlowFeature.swift
extension SignUpFlowFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case emailForm(EmailFormFeature)
        case authCodeForm(AuthCodeFormFeature)
        case nicknameForm(NicknameFormFeature)
        case termsAgreement(TermsAgreementFeature)
        case signUpComplete(SignUpCompleteFeature)
    }
}
```

2. 트리거거가 될(추적을 할) 액션을 선택한 후 해당 액션의 실행 코드를 재정의합니다.

```swift
// in SighUpFlowFeature.swift
case let .path(stackAction):
    switch stackAction {
    case let .element(id: _, action: .emailForm(.sendCertificationEmailResponse(email))):
        state.path.append(.authCodeForm(.init(emailText: email)))
        return .none
        
    case let .element(id: _, action: .authCodeForm(.authCodeFormComplete(email))):
        state.path.append(.nicknameForm(.init(emailText: email)))
        return .none
        
    case let .element(id: _, action: .nicknameForm(.nicknameFormComplete(email, nickname))):
        state.path.append(.termsAgreement(.init(emailText: email, nicknameText: nickname)))
        return .none
        
    case .element(id: _, action: .termsAgreement(.signUpResponse)):
        state.path.append(.signUpComplete(.init()))
        HapticService.notification(type: .success)
        return .none
        
    case .element(id: _, action: .signUpComplete(.startButtonTapped)):
        state.$isSignIn.withLock { $0 = true }
        state.path.removeAll()
        return .none
        
    default:
        return .none
    }
```

3. Path의 추가되는 열거형의 타입에 따른 추가될 View를 적어줍니다.

```swift
// in SignUpView.swift
var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        SocialLoginView(store: store.scope(state: \.socialLogin, action: \.socialLogin))
    } destination: { store in
        switch store.case {
        case let .emailForm(store): EmailFormView(store: store)
        case let .authCodeForm(store): AuthCodeFormView(store: store)
        case let .nicknameForm(store): NicknameFormView(store: store)
        case let .termsAgreement(store): TermsAgreementView(store: store)
        case let .signUpComplete(store): SignUpCompleteView(store: store)
        }
    }
}
```

### 흐름 예시도(NicknameFormView Push 과정)

![Navigation Flow 정리](https://github.com/user-attachments/assets/afd1140b-b909-40ca-9605-22afcb7509f9)

### 네비게이션 구조
- SignUp(회원가입)
    - SocialLoginView
    - EmailFormView
    - AuthCodeFormView
    - NicknameFormView
    - TermsAgreementView
    - TermsContentView
    - SignUpCompleteView
- MainFlow(앱 메인)
    - QuestionTab
        - TodayQuestionView
            - AnswerListView
            - WriteAnswerView
                - CompleteAnswerView
        - QuestionListView
            - AnswerListView
            - WriteAnswerView
                - CompleteAnswerView
    - BulletinBoardTab
        - BulletinBoardView
            - BulletinBoardSearchView
            - BulletinBoardPostView
            - CommentView
    - ProfileTab
        - ProfileView
            - ProfileEditView
            - MyAnswerListView
            - PeopleWhoMadeQappleView
    - NotifiactionView
    - SeeMoreSheetView
    - ReportView



## 트러블 슈팅
- [무니 Mooni의 CI/CD 구축기 with Github Actions (1)](https://velog.io/@mooninbeom/CICD-구축기-with-Github-Actions-1)
- [한톨의 캐플 리팩토링 첫 번째 이야기 - 방향성 설정하기](https://thinkyside.tistory.com/56)
- [한톨의 캐플 리팩토링 두 번째 이야기 - 프로젝트 세팅하기](https://thinkyside.tistory.com/58)
- [한톨의 캐플 리팩토링 세 번째 이야기 - 트러블 슈팅](https://thinkyside.tistory.com/66) 
- [한톨의 캐플 리팩토링 네 번째 이야기 - Repository 모듈 만들기](https://thinkyside.tistory.com/90)

## 프로젝트 회고
- [시몬스의 회고](https://dding-genie.tistory.com/38)
