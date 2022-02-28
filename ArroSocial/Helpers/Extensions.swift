//
//  Extensions.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import Foundation
import UIKit

// let back swipe functionality still work when navigation bar is hidden
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
