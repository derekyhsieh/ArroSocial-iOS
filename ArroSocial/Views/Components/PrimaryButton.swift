//
//  PrimaryButton.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var body: some View {
        Text(title)
            .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(AppColors.purple))
            .cornerRadius(50)
    }
}
