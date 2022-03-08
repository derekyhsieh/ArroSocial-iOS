//
//  UploadView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/8/22.
//

import SwiftUI

struct UploadView: View {
    @State private var caption = ""
    @AppStorage(CurrentUserDefaults.username) var username: String?
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColor: String = ""
    
    
    var body: some View {
        VStack {
            Text("Upload Photo")
                .font(.custom("Poppins-Medium", size: 30))
            
            
            ZStack(alignment: .trailing) {
                VStack {
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(Color(hexString: self.profilePicColor) ?? Color(AppColors.purple))
                                .frame(width: 50, height: 50)
                            // first 2 letters of username
                                .overlay(
                                    Text((username ?? "  ").prefix(2) )
                                        .font(.custom("Poppins-SemiBold", size: 20))
                                        .foregroundColor(.white)
                                )
                            Text("@" + (self.username ?? ""))
                                .foregroundColor(.white)
                                .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                            
                            Spacer()
                        }
                        
                        if self.caption != "" {
                            Text(self.caption)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.white)
                                .modifier(Poppins(fontWeight: AppFont.medium, .caption))
                                .frame(height: 50)
                                .truncationMode(.tail)
                                .padding(-5)
                        }
               
                    }
                    .padding()
                    
                    .frame(maxWidth: UIScreen.main.bounds.width - 20)
                    //                .shadow(color: Color.black, radius: 15, x: 0, y: -10)
                    .shadow(color: Color.black.opacity(0.4), radius: 30, x: 0.0, y: 5)
                }
                
            }
            .frame(width: UIScreen.main.bounds.width - 20, height: 400)
            .background(Color.secondary.opacity(0.5))
            .overlay(
                
                Button(action: {
                    
                }) {
                    Image(systemName: "arrow.up.doc.fill")
    //                    .resizable()
    //                    .aspectRatio(contentMode: .fill)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
       
            )
            .cornerRadius(30)
            
            
            TextEditor(text: $caption)
            
            
            Spacer(minLength: 0)
            
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
