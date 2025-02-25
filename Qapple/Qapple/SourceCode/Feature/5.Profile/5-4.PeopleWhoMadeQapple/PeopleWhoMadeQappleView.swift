//
//  PeopleWhoMadeQappleView.swift
//  Qapple
//
//  Created by kyungsoolee on 12/27/24.
//

import SwiftUI

struct PeopleWhoMadeQappleView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            QPNavigationBar(
                title: "캐플을 만든 사람들",
                leadingView: {
                    QPNavigationButton(buttonType: .back) {
                        dismiss()
                    }
                }
            )
            
            ScrollView {
                VStack(spacing: 24) {
                    ProductManager()
                    Designer()
                    iOSDeveloper()
                    BackendDeveloper()
                }
            }
            .padding(.top, 20)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - ProductManager

private struct ProductManager: View {
    var body: some View {
        VStack(spacing: 16) {
            CustomBookMark(position: "Product Manager")
            
            PeopleWhoMadeQappleCell(
                avatar: .friday,
                backgroundColor: .friday,
                nicknameKor: "프라이데이",
                nicknameEng: "friday",
                position: "Product Manager",
                description: "대전 사람입니다. 성심당 잘 안먹습니다.",
                githubLink: nil,
                linkedinLink: "https://www.linkedin.com/in/minwoo-kim-7b94952b7/"
            )
            PeopleWhoMadeQappleCell(
                avatar: .sammy,
                backgroundColor: .sammy,
                nicknameKor: "세미",
                nicknameEng: "sammy",
                position: "Product Manager",
                description: "냉정과 열정 사이",
                githubLink: nil,
                linkedinLink: "https://www.linkedin.com/in/sammy-kwak-8b2286221/"
            )
        }
    }
}

// MARK: - Designer

private struct Designer: View {
    var body: some View {
        VStack(spacing: 16) {
            CustomBookMark(position: "Designer")
            
            PeopleWhoMadeQappleCell(
                avatar: .lamune,
                backgroundColor: .lamune,
                nicknameKor: "라무네",
                nicknameEng: "lamune",
                position: "Designer",
                description: "인풋과 아웃풋의 조화",
                githubLink: nil,
                linkedinLink: "https://www.linkedin.com/in/ramunesoojin/"
            )
        }
    }
}

// MARK: - iOSDeveloper

private struct iOSDeveloper: View {
    var body: some View {
        VStack(spacing: 16) {
            CustomBookMark(position: "iOS Developer")
            
            PeopleWhoMadeQappleCell(
                avatar: .hantol,
                backgroundColor: .hantol,
                nicknameKor: "한톨",
                nicknameEng: "hantol",
                position: "iOS Developer",
                description: "디자이너와 개발자, 그 사이 어딘가",
                githubLink: "https://github.com/thinkySide",
                linkedinLink: nil
            )
            PeopleWhoMadeQappleCell(
                avatar: .mooni,
                backgroundColor: .mooni,
                nicknameKor: "무니",
                nicknameEng: "mooni",
                position: "iOS Developer",
                description: "월드 클래스 디벨로퍼",
                githubLink: "https://github.com/mooninbeom",
                linkedinLink: nil
            )
            PeopleWhoMadeQappleCell(
                avatar: .simmons,
                backgroundColor: .simmons,
                nicknameKor: "시몬스",
                nicknameEng: "simmons",
                position: "iOS Developer",
                description: "흔들리지 않는 편안함",
                githubLink: "https://github.com/OhMyungJin",
                linkedinLink: nil
            )
        }
    }
}

// MARK: - BackendDeveloper

private struct BackendDeveloper: View {
    var body: some View {
        VStack(spacing: 16) {
            CustomBookMark(position: "Back-end Developer")
            
            PeopleWhoMadeQappleCell(
                avatar: .liver,
                backgroundColor: .liver,
                nicknameKor: "리버",
                nicknameEng: "liver",
                position: "Back-end Developer",
                description: "노는게 제일 좋아! 하나!",
                githubLink: "https://github.com/kyxxgsoo",
                linkedinLink: nil
            )
            PeopleWhoMadeQappleCell(
                avatar: .mango,
                backgroundColor: .mango,
                nicknameKor: "망고",
                nicknameEng: "mango",
                position: "Back-end Developer",
                description: "노는게 제일 좋아! 둘!",
                githubLink: nil,
                linkedinLink: "https://www.linkedin.com/in/재원-이-859981227/"
            )
            PeopleWhoMadeQappleCell(
                avatar: .lucy,
                backgroundColor: .lucy,
                nicknameKor: "루시",
                nicknameEng: "lucy",
                position: "Back-end Developer",
                description: "노는게 제일 좋아! 셋!",
                githubLink: "https://github.com/tnals2384",
                linkedinLink: nil
            )
            PeopleWhoMadeQappleCell(
                avatar: .ari,
                backgroundColor: .ari,
                nicknameKor: "아리",
                nicknameEng: "ari",
                position: "Back-end Developer",
                description: "노는게 제일 좋아! 야!",
                githubLink: "https://github.com/youngeun-dev",
                linkedinLink: nil
            )
        }
    }
}

// MARK: - CustomBookMark

private struct CustomBookMark: View {
    let position: String
    var body: some View {
        HStack {
            Text(position)
                .font(Font.pretendard(.semiBold, size: 16))
                .foregroundStyle(.sub2)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview

#Preview {
    PeopleWhoMadeQappleView()
}
