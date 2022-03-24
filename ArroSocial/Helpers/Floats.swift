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
        
        VStack(spacing: 1) {
            Text(message)
                .foregroundColor(.white)
                .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                .frame(maxHeight: 100)
                .multilineTextAlignment(.center)
            Text("Tap to dismiss")
                .foregroundColor(Color.white.opacity(0.8))
                .modifier(Poppins(fontWeight: AppFont.regular, .caption))
        }
        .padding(5)
        .padding(.horizontal, 5)
        .frame(width: UIScreen.main.bounds.width - 30)
        
        .frame(maxHeight: 150)
        .background(color)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.8), radius: 0.25, x: 0, y: 0)
        
    }
    
}

