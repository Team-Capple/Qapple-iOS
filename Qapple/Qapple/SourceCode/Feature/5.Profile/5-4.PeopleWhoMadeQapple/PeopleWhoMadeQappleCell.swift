//
//  ProfileCell.swift
//  Qapple
//
//  Created by kyungsoolee on 12/27/24.
//

import SwiftUI

struct PeopleWhoMadeQappleCell: View {
    let avatar: ImageResource
    let backgroundColor: Color
    let nicknameKor: String
    let nicknameEng: String
    let position: String
    let description: String
    let githubLink: String?
    let linkedinLink: String?
    
    var body: some View {
        HStack(spacing: 0) {
            Image(avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 76, height: 76)
                .clipShape(Circle())
                .background {
                    Circle()
                        .frame(width: 76, height: 76)
                        .foregroundColor(backgroundColor)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(nicknameKor)
                        .foregroundStyle(.text)
                    
                    Rectangle()
                        .frame(width: 1, height: 12)
                        .foregroundStyle(.sub2)
                    
                    Text(nicknameEng)
                        .foregroundStyle(.sub2)
                }
                .font(.pretendard(.bold, size: 16))
                
                Text(description)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(.sub3)
            }
            .padding(.leading, 12)
            
            Spacer()
            
            if let githubLink = githubLink {
                Button {
                    openURL(githubLink)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.12))
                            .stroke(TextLabel.ph, lineWidth: 1)
                            .frame(width: 36, height: 36)
                            
                        Image(.github)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            if let linkedinLink = linkedinLink {
                Button {
                    openURL(linkedinLink)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.12))
                            .stroke(TextLabel.ph, lineWidth: 1)
                            .frame(width: 36, height: 36)
                            
                        Image(.linkedin)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .frame(height: 76)
        .padding(.horizontal, 20)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.first.ignoresSafeArea()
        PeopleWhoMadeQappleCell(
            avatar: .liver,
            backgroundColor: .liver,
            nicknameKor: "리버",
            nicknameEng: "Liver",
            position: "Back-end Developer",
            description: "리버풀 광팬",
            githubLink: "https://github.com/kyxxgsoo",
            linkedinLink: nil
        )
    }
}
