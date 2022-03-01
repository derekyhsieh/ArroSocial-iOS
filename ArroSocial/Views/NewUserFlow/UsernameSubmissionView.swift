//
//  UsernameSubmissionView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct UsernameSubmissionView: View {
    @Binding var username: String
    var color: Color
    var body: some View {
        VStack {
            Text("Pick a username")
                .foregroundColor(color)
                .modifier(Poppins(fontWeight: AppFont.semiBold, .title2))
                .multilineTextAlignment(.center)
            
            TextField("username", text: ($username))
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(50.0)
                .shadow(color: Color.black.opacity(0.1), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                .padding(.vertical)
                .onChange(of: username) { usernameValue in
                    if(usernameValue.first != "@") {
//                        self.username = "@" + usernameValue
                    }
                }
//                .padding()
                
        }
    }
}

//struct UsernameSubmissionView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsernameSubmissionView(color: Color(AppColors.lightBlue))
//    }
//}
