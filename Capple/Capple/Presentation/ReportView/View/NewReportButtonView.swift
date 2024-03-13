
import SwiftUI

struct NewReportButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var moreList = [
        "신고하기"
    ]
    
    @ObservedObject var sharedData = SharedData()
    
    @State private var reportButtonPosition: CGPoint = .zero // ellipsis 버튼 위치 저장을 위한 State
    var body: some View {
      
        ZStack {
            
                Color(Color.clear)
                    .ignoresSafeArea()
            HStack(alignment: .top){
                GeometryReader { geometry in
                    
                    Text("신고하기")
                        .frame(width: 200, height: 50)
                        .background(Background.first)
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main)
                        .onTapGesture {
                            self.reportButtonPosition = CGPoint(x: geometry.frame(in: .global).minX, y: geometry.frame(in: .global).minY)
                            print(sharedData.showingReportSheet)
                            sharedData.innerShowingReportSheet = true
                        }
                }
                
                // 플로팅 모달 조건부 표시
                if sharedData.innerShowingReportSheet {
                    
                    NewReportView()
                        .offset(x: reportButtonPosition.x - 70 , y: reportButtonPosition.y - 270  ) // 이 값은 NewReportButtonView의 실제 크기와 위치에 따라 조정될 수 있습니다.
                    
                    
                    //   .transition(.move(edge: .bottom)) // 모달 등장 애니메이션
                        .animation(.default, value: sharedData.innerShowingReportSheet)
                    
                    
                }
            }
            }.onTapGesture {
                sharedData.showingReportSheet = false// 이곳에 실제 모달을 보여주는 트리거
                
            }.frame(width: 300, height: 350)
                .cornerRadius(12)
                .shadow(radius: 20)
                .zIndex(1)
               
        }
}
    


#Preview {
    NewReportButtonView()
}
