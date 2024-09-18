//
//  UINavigationController+Extension.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import UIKit

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return PopGestureManager.shared.isAllowPopGesture() && viewControllers.count > 1
    }
}
