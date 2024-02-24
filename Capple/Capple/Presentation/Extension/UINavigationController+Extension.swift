//
//  UINavigationController+Extension.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
//        navigationBar.isHidden = true // 모든 네비게이션 뷰에서 bar를 없애는 코드
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
