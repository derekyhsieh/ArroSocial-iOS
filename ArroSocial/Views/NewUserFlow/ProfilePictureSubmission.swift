//
//  ProfilePictureSubmission.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct ProfilePictureSubmission: View {
    @Binding var generatedProfileColor: Color
    @Binding var username: String
    @AppStorage("gottenUserPermissions") var gottenUserPermissions: Bool = false
    @Binding var isShowingImagePicker: Bool
    @Binding var showPermissionsModal: Bool
    @Binding var postImage: UIImage
    
    var color: Color
    var body: some View {
        VStack {
            Button(action: {
                
                if(gottenUserPermissions == false) {
                    print(" is showing permission modal")
                    self.showPermissionsModal = true
                } else {
                    print("isshowingiomage picker")
                    self.isShowingImagePicker = true
                }
                
            }) {
                
                if(postImage != UIImage(named: "placeholder")) {
                    Image(uiImage: postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        
                } else {
                    
                    Circle()
                        .fill(generatedProfileColor)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Text(username.count == 0 ? "as" : (username.prefix(2)))
                                .foregroundColor(Color.white)
                            //                            .modifier(Poppins(fontWeight: AppFont.semiBold, .largeTitle))
                                .font(.custom(("Poppins-"+AppFont.semiBold), size: 90))
                        )
                }
                
            }
            
            Text("Tap on the circle to import your own profile picture")
            
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(color)
                .font(.custom(("Poppins-"+AppFont.semiBold), size: 30))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            
            Button(action: {
                generatedProfileColor = Color.random()
            }) {
                
                PrimaryButton(title: "Shuffle")
                    .frame(width: UIScreen.main.bounds.width / 2)
            }
            
            Spacer(minLength: 0)
            
            
            
        }
        .sheet(isPresented: $isShowingImagePicker) {
            PhotoPicker(image: $postImage)
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
