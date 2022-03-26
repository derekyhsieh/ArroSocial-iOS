//
//  TitleRow.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct TitleRow: View {
    var username: String
    var body: some View {
        HStack(spacing: 20) {
           
            Button(action: {}) {
                Image(systemName: "chevron.backward")
//                    .foregroundColor(Color.black)
                    .font(.title2)
            }
            
            Spacer()
            Image("person")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            VStack(alignment: .leading) {
               Text("@" + username)
                    .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
//                    .foregroundColor(.white)
                
                Text("Following")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
           
        }
        .padding()
//        .background(Color(AppColors.purple).opacity(0.45))
        .frame(maxWidth: .infinity, alignment: .trailing)
        
       
        
        
            
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow(username: "derekhsieh")
    }
}
