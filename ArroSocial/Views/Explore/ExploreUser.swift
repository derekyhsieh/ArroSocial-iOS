//
//  ExploreUser.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/30/22.
//

import SwiftUI

struct ExploreUser: View {
    @State private var username: String = ""
    @State var userID: String
    @Binding var selectedPost: FullScreenPostModel?
    @Binding var showProfile: Bool
    
    var body: some View {
        HStack {
            ProfilePicture(dimension: 80, username: username, userID: userID, profilePicVM: ProfilePictureViewModel(userID: userID))
            Text(username)
            
            Spacer()
            Button(action: {
                showProfile = true
            }) {
               Image(systemName: "chevron.right")
                    .font(.callout)
            }
        }
        .onAppear {
            DataService.instance.getUserDocument(userID: userID) { doc in
                if let doc = doc {
                    self.username = (doc.get(FSUserData.username) as? String)!
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(isUsersOwnProfile: .constant(false), profilePosts: PostsViewModel(userID: userID), profilePictureVM: ProfilePictureViewModel(userID: userID), selectedPost: $selectedPost, profileUser: username, postUserID: userID)
        }
    }
}

//struct ExploreUser_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreUser()
//    }
//}
