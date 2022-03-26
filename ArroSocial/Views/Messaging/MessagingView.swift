//
//  MessaingView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct MessagingView: View {
    
    var body: some View {
        TitleRow(username: "derekhsieh")
            .background(Color(AppColors.purple).opacity(0.3))
            .foregroundColor(Color.white)
    }
}

struct MessaingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}
