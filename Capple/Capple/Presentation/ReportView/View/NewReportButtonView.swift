
import SwiftUI

struct NewReportButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var moreList = [
        "신고하기"
    ]
    
    @ObservedObject var sharedData = SharedData()
    
    var body: some View {
      
            ZStack {
                Color(Color.clear)
                    .ignoresSafeArea()
                
                Text("신고하기")
                    .frame(width: 200, height: 50)
                    .background(Background.first)
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
                    .onTapGesture {
                        print(sharedData.showingReportSheet)
                        sharedData.innerShowingReportSheet = true
                    }
                
                // 플로팅 모달 조건부 표시
                if sharedData.innerShowingReportSheet {
                    GeometryReader { geometry in
                        NewReportView()
                        
                        
                        //   .transition(.move(edge: .bottom)) // 모달 등장 애니메이션
                            .animation(.default, value: sharedData.innerShowingReportSheet)
                        
                        }
                }
            }.onTapGesture {
                sharedData.showingReportSheet = false// 이곳에 실제 모달을 보여주는 트리거
                
            }.frame(width: 300, height: 350)
                .cornerRadius(12)
                .shadow(radius: 20)
               
        }
    }
    


#Preview {
    NewReportButtonView()
}
