//
//  ReportClass.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/12/24.
//

import Foundation
class SharedData: ObservableObject {
    @Published var showingReportSheet: Bool = false
    @Published var innerShowingReportSheet: Bool = false
    @Published var offset: CGFloat = 0
    @Published var reportButtonPosition: CGPoint? = nil
   
}
