//
//  ProfilePictureSubmission.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct ProfilePictureSubmission: View {
    @State private var generatedProfileColor: Color = Color.random()
    @Binding var username: String
    var color: Color
    var body: some View {
        VStack {
            Button(action: {}) {
                Circle()
                    .fill(generatedProfileColor)
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text(generateProfilePicText())
                            .foregroundColor(Color.white)
                            .modifier(Poppins(fontWeight: AppFont.semiBold, .largeTitle))
                    )
            }
            
            Text("Tap on the circle to import your own profile picture")
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(color)
                .modifier(Poppins(fontWeight: AppFont.semiBold, .headline))
                .multilineTextAlignment(.center)
            
            Button(action: {
                generatedProfileColor = Color.random()
            }) {
                
                PrimaryButton(title: "Shuffle")
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
   
            Spacer(minLength: 0)
            
            
            
        }
    }
    // generate text for profile pic from username
    private func generateProfilePicText() -> String {
        
        // check if username is greater than 2 (shouldn't happen bc checking in front but just in case)
        if(username.count >= 2) {
        
            var profileText: String = (String(self.username.prefix(1)))
            
            // create array excluding first character in username and append random character to as second
            var arr = username.map { String($0) }
            arr.removeFirst()
            print(arr)
            if arr.count > 2 {
                
                
                profileText.append(arr.randomElement()!)
                return profileText.lowercased()
            }
        }
    
        
        // if everything fails edge case return arro social AS
        return "AS"
        
    }
}
