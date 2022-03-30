//
//  TitleRow.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct TitleRow: View {
    @StateObject var profilePicVM: ProfilePictureViewModel
    @Environment(\.presentationMode) var presentationMode
    var username: String
    var body: some View {
        HStack(spacing: 20) {
           
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
//                    .foregroundColor(Color.black)
                    .font(.title2)
            }
            
            Spacer()
            ProfilePicture(dimension: 50, username: username, userID: profilePicVM.userID, profilePicVM: profilePicVM)
               Text("@" + username)
                    .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                
            
            Spacer()
           
        }
        .padding()
//        .background(Color(AppColors.purple).opacity(0.45))
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: 100)
        
       
        
        
            
    }
}

//struct TitleRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleRow(username: "derekhsieh")
//    }
//}
