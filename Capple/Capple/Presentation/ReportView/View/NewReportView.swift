
import SwiftUI


struct NewReportView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

   
    var moreList = [
        "불법촬영물 등의 유통", "상업적 광고 및 판매",
        "게시판 성격에 부적절함", "욕설/비하", "정당/정치인 비하 및 선거운동",
        "유출/사칭/사기", "낚시/놀림/도배"
    ]
    
    var body: some View {
        
        @ObservedObject var sharedData = SharedData()
        GeometryReader { geometry in
            ZStack {
                Color(Background.first)
                    .ignoresSafeArea()
                
                VStack {
                    List(moreList, id: \.self) { more in
                       
                        Button {
                            // TODO: 신고하기 이동
                            
                        } label: {
                            ReportListRow(title: more)
                            
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                    }
                    .listStyle(.plain)
                    
                }
            }.offset(y: 0)
        }
        .onTapGesture {
            sharedData.innerShowingReportSheet = false // 이곳에 실제 모달을 보여주는 트리거
            }  .frame(width: 300, height: 350) // 필요에 따라 조정
            .cornerRadius(12)
            .shadow(radius: 20)
    }
}

#Preview {
    NewReportView()
}
