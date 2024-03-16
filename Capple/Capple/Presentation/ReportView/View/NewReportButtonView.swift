
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
                if sharedData.innerShowingReportSheet {
                    NewReportView()
                        .offset(x: reportButtonPosition.x - 70 , y: reportButtonPosition.y - 270  )
                        .animation(.default, value: sharedData.innerShowingReportSheet)
                }
            }
            }.onTapGesture {
                
            }.frame(width: 350, height: 350)
                .cornerRadius(12)
                .shadow(radius: 20)
               
        }
}
    


#Preview {
    NewReportButtonView()
}
