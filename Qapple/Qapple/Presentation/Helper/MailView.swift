//
//  MailView.swift
//  Capple
//
//  Created by 김민준 on 3/19/24.
//

import SwiftUI
import UIKit
import MessageUI

// 출처: https://stackoverflow.com/questions/56784722/swiftui-send-email
struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        
        // 메일 본문 양식
        let bodyString = """
        아래의 양식을 작성하여 문의 혹은 의견을 보내주시면 감사하겠습니다. 캡처 화면을 함께 보내주시면 보다 정확한 답변이 가능합니다!
        
        
        1. 문의 내용:
        
        2. 추가 사항(선택사항):
        
        3. 연락처(선택사항):
        
        빠른 시일 내에 답변 드리겠습니다. 감사합니다! 😀
        """
        
        vc.setToRecipients(["0.team.capple@gmail.com"])
        vc.setSubject("[Qapple 캐플] 문의 사항")
        vc.setMessageBody(bodyString, isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
