//
//  ProfilePicture.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

struct ProfilePicture: View {
    var dimension: CGFloat
    var username: String
    var userID: String
    @StateObject var profilePicVM: ProfilePictureViewModel
    var body: some View {
        VStack {
            if profilePicVM.isFinishedFetchingProfilePicture {
                if profilePicVM.profilePicture != nil {
                    Image(uiImage: profilePicVM.profilePicture!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: dimension, height: dimension)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(hexString: profilePicVM.hexColor ?? "A9A9AC") ?? Color(.gray))
                        .frame(width: dimension, height: dimension)
                        .overlay(Text(username.prefix(2)))
                        .font(.custom("Poppins-SemiBold", size: dimension/2))
                        .foregroundColor(.white)
                }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: dimension, height: dimension)
                    .redacted(reason: profilePicVM.isLoading ? .placeholder : [])
            }
        }
        .onAppear {
            self.profilePicVM.fetchData(userID: userID)
        }
    }
}

//struct ProfilePicture_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePicture(dimension: 100, username: "derekhsieh", profilePicVM: ProfilePictureViewModel(userID: "RYh4POBI6kYMYuKmxyxtA2nMwhK2"))
//    }
//}
