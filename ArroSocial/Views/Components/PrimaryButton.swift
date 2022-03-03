//
//  PrimaryButton.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct PrimaryButton: View {
    var color: Color? = Color(AppColors.purple)
    var title: String
    var body: some View {
        Text(title)
            .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(50)
    }
}
