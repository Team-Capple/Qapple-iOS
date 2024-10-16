//
//  BulletinPostingView.swift
//  Qapple
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

struct BulletinPostingView: View {

    @EnvironmentObject private var pathModel: Router
    
    @StateObject private var postingUseCase = BulletinPostingUseCase()

    @State private var isBackAlertPresented = false

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                NavigationBar(isBackAlertPresented: $isBackAlertPresented)
                Spacer()
                WritingView(isTextFieldFocused: $isTextFieldFocused)
                Spacer()
                Footer()
            }
            if postingUseCase.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .environmentObject(postingUseCase)
        .popGestureDisabled()
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .disabled(postingUseCase.isLoading)
        .alert("정말 그만두시겠어요?", isPresented: $isBackAlertPresented) {
            HStack {
                Button("취소", role: .cancel) {}
                Button("그만두기", role: .none) {
                    pathModel.pop()
                }
            }
        } message: {
            Text("지금까지 작성한 답변이 사라져요")
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {

    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    @Binding private(set) var isBackAlertPresented: Bool

    var body: some View {
        CustomNavigationBar(
            leadingView: {
                Button("취소") {
                    if postingUseCase._state.content.isEmpty {
                        pathModel.pop()
                    } else {
                        isBackAlertPresented.toggle()
                    }
                }
                .foregroundStyle(GrayScale.icon)
            },
            principalView: {
                Text("게시판")
                    .pretendard(.semiBold, 17)
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
                Button("올리기") {
                    if !postingUseCase._state.content.isEmpty {
                        Task {
                            HapticManager.shared.notification(type: .success)
                            try await postingUseCase.effect(.uploadPost)
                            bulletinBoardUseCase.reset()
                            pathModel.pop()
                            postingUseCase.isLoading = false
                        }
                    }
                }
                .foregroundStyle(postingUseCase._state.content.isEmpty ? .disable : BrandPink.button)
                .disabled(postingUseCase._state.content.isEmpty)
            },
            backgroundColor: .clear
        )
    }
}

// MARK: - WritingView

private struct WritingView: View {

    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    var isTextFieldFocused: FocusState<Bool>.Binding

    var body: some View {
        ZStack {
            if postingUseCase._state.content.isEmpty {
                Placeholder()
            }

            PostTextField(isTextFieldFocused: isTextFieldFocused)
        }
        .multilineTextAlignment(.center)
    }
}

// MARK: - Placeholder

private struct Placeholder: View {

    var body: some View {
        VStack(spacing: 16) {
            Text("자유롭게 생각을\n작성해주세요")
                .font(.pretendard(.semiBold, size: 48))

            Text("* 논란을 만들 질문들은 지양해주세요")
                .font(.pretendard(.medium, size: 16))
                .lineSpacing(6)
        }
        .foregroundStyle(TextLabel.placeholder)
        .padding(.horizontal, 24)
    }
}

// MARK: - PostTextField

private struct PostTextField: View {

    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    @State private var fontSize: CGFloat = 48

    var isTextFieldFocused: FocusState<Bool>.Binding

    var body: some View {
        TextField(
            text: $postingUseCase._state.content,
            axis: .vertical
        ) {
            Color.clear
        }
        .font(.pretendard(.semiBold, size: fontSize))
        .foregroundStyle(.wh)
        .focused(isTextFieldFocused)
        .padding(.horizontal, 24)
        .autocorrectionDisabled()
        .onChange(of: postingUseCase._state.content) { oldText, newText in

            // 글자 수 제한 로직
            if newText.count > postingUseCase.textCountLimit {
                postingUseCase._state.content = oldText
            }

            // 폰트 크기 변경 로직
            switch newText.count {
            case 0..<20: fontSize = 48
            case 20..<32: fontSize = 40
            case 32..<60: fontSize = 32
            case 60...100: fontSize = 24
            case 100...: fontSize = 17
            default: break
            }
        }
    }
}

// MARK: - Footer

private struct Footer: View {

    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    @State private var isAnonymitySheetPresented = false

    var body: some View {
        HStack {
            Button {
                isAnonymitySheetPresented.toggle()
            } label: {
                Text("익명이 보장되나요?")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundStyle(BrandPink.text)
            }
            .sheet(isPresented: $isAnonymitySheetPresented) {
                AnonymityNoticeView(isAnonymitySheetPresented: $isAnonymitySheetPresented)
                    .presentationDetents([.height(560)])
            }
            
            Spacer()

            Text("\(postingUseCase._state.content.count)/\(postingUseCase.textCountLimit)")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub3)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }
}

// MARK: - Preview

#Preview {
    BulletinPostingView()
}
