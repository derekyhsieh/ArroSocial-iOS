//
//  CustomLoadingIndicator.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/17/22.
//

import SwiftUI

struct CustomLoadingIndicator: View {
    @Binding var isShowing: Bool
    var body: some View {
        ProgressView()
            .padding()
            .padding()
            .scaleEffect(1.5, anchor: .center)
            .accentColor(Color(AppColors.purple))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0, y: 0)
            )
            .opacity(isShowing ? 1 : 0)
    }
}

struct CustomLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingIndicator(isShowing: .constant(true))
    }
}
