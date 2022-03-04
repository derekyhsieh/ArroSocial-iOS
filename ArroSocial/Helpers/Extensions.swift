//
//  Extensions.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import Foundation
import UIKit
import SwiftUI


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


// random color

extension Color {
    static func random() -> Color {
        Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}


// manuallly hide keyboard for iOS 14 and lower users

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#endif


// extension to check if multiple variables are nil (used in backend firebase auth service)
extension Collection where Element == Optional<Any> {

    func allNotNil() -> Bool {
        return !allNil()
    }

    func atleastOneNotNil() -> Bool {
        return self.flatMap { $0 }.count > 0
    }

    func allNil() -> Bool {
        return self.flatMap { $0 }.count == 0
    }
}



// convert UIColor to hex string

class CustomColorHelper {
    static var instance = CustomColorHelper()
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
}
