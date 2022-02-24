//
//  FontDynamic.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import Foundation
import SwiftUI


// View modifier that allows dynamic font sizing for custom font

/*
 Example Call
 Text("hello world")
    .modifier(Poppins(fontWeight: AppFont.medium, .largeTitle))
 */

// - Parameter value: Font Weight to target different custom font, and textStyle to indicate which dynamic font used




struct Poppins: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var fontWeight: String
    var textStyle: Font.TextStyle
    
    init(fontWeight: String, _ textStyle: Font.TextStyle = .body) {
        self.textStyle = textStyle
        self.fontWeight = fontWeight
    }
    
    func body(content: Content) -> some View {
        content.font(getFont())
    }
    
    func getFont() -> Font {
        switch(sizeCategory) {
        case .extraSmall:
            return Font.custom("Poppins-\(fontWeight)", size: 16 * getStyleFactor())
        case .small:
            return Font.custom("Poppins-\(fontWeight)", size: 21 * getStyleFactor())
        case .medium:
            return Font.custom("Poppins-\(fontWeight)", size: 24 * getStyleFactor())
        case .large:
            return Font.custom("Poppins-\(fontWeight)", size: 28 * getStyleFactor())
        case .extraLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 32 * getStyleFactor())
        case .extraExtraLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 36 * getStyleFactor())
        case .extraExtraExtraLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 40 * getStyleFactor())
        case .accessibilityMedium:
            return Font.custom("Poppins-\(fontWeight)", size: 48 * getStyleFactor())
        case .accessibilityLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 52 * getStyleFactor())
        case .accessibilityExtraLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 60 * getStyleFactor())
        case .accessibilityExtraExtraLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 66 * getStyleFactor())
        case .accessibilityExtraExtraExtraLarge:
            return Font.custom("Poppins-\(fontWeight)", size: 72 * getStyleFactor())
        @unknown default:
            return Font.custom("Poppins-\(fontWeight)", size: 36 * getStyleFactor())
        }
    }
    
    func getStyleFactor() -> CGFloat {
        switch textStyle {
        case .caption:
            return 0.6
        case .footnote:
            return 0.7
        case .subheadline:
            return 0.8
        case .callout:
            return 0.9
        case .body:
            return 1.0
        case .headline:
            return 1.2
        case .title:
            return 1.5
        case .largeTitle:
            return 2.0
        case .title2:
            return 1.4
        case .title3:
            return 1.3
        case .caption2:
            return 0.5
        @unknown default:
            return 1.0
        }
    }
    
}
