//
//  Floats.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/18/22.
//

import Foundation
import SwiftUI

class Floats {
    static let instance = Floats()
    func createSuccessFloat(message: String, color: Color) -> some View {
        
        VStack {
            Text(message)
                .foregroundColor(.white)
                .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Tap to dismiss")
                .foregroundColor(Color.white.opacity(0.8))
                .modifier(Poppins(fontWeight: AppFont.regular, .caption))
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30, height: 100)
        .background(color)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.8), radius: 0.25, x: 0, y: 0)
        
    }
    
}

