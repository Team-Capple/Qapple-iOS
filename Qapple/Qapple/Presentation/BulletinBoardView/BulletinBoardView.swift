//
//  BulletinBoardView.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

struct BulletinBoardView: View {
    var body: some View {
        VStack {
            
        }
        .toolbar {
            ToolbarItem {
                Text("asd")
            }
            
            ToolbarItem {
                Button {
                    // TODO: 게시글 작성 View 이동
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(BrandPink.button)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BulletinBoardView()
    }
}
