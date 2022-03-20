//
//  HomeFeedView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/1/22.
//

import SwiftUI
import PermissionsSwiftUI
import Photos


struct HomeFeedView: View {
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    @AppStorage(CurrentUserDefaults.userID) var userID: String = ""
    @AppStorage("gottenUserPermissions") var gottenUserPermissions: Bool = false
    @Binding var isFinishedLoadingData: Bool
    @Binding var profileImage: UIImage
    @Binding var isShowingUploadView: Bool
    @Binding var showPermissionsModal: Bool
    
    
    
    var body: some View {
        ZStack {
            Color(AppColors.bg).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 42, height: 42)
                            .foregroundColor(.white)
                            .padding(2)
                            .background(Color(AppColors.purple) .clipShape(Circle()))
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // check if app storage has gotten
                        //                        if !self.gottenPermissions {
                        self.showPermissionsModal = true
                        
                        if(self.gottenUserPermissions) {
                            
                            self.isShowingUploadView = true
                        }
                        
                        
                        
                        
                        //                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .frame(width: 30, height: 30)
                            .padding(10)
                            .padding(.horizontal, 10)
                            .foregroundColor(Color.black.opacity(0.7))
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.15))
                                    .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                            )
                    }
                    
                    Spacer()
                    
                    
                    HStack {
                        
                        if isFinishedLoadingData {
                            if profileImage != UIImage(named: "arro") {
                                                        Image(uiImage: profileImage)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 40, height: 40)
                                                            .clipShape(Circle())
                                                            .font(.custom("Poppins-SemiBold", size: 20))
                                                            .foregroundColor(.white)
                            } else {
                                Circle()
                                    .fill(Color(hexString: self.profilePicColorBackground) ?? Color(AppColors.purple))
                                    .frame(width: 40, height: 40)
                                // first 2 letters of username
                                    .overlay(
                                        Text(username.prefix(2))
                                            .font(.custom("Poppins-SemiBold", size: 20))
                                            .foregroundColor(.white)
                                    )
                            }
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                        }
                        
                        
                        Text("@\(self.username)")
                            .foregroundColor(.black)
                            .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                        
                   
                    }
                    .padding(7)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                    )
                    
                }
                .padding(.horizontal)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        PostView(post: data)
                        PostView(post: PostModel(postID: "123", userID: "123", userPicture: Image("person"), username: "johndoe", caption: "test caption", image: Image("d2"), dateCreated: Date(), likeCount: 201, likedByUser: true))
                        PostView(post: PostModel(postID: "123", userID: "123", userPicture: Image("person"), username: "johndoe", caption: "asdfjasdkfljasdkfjasl kjfasdjfla ksjfklasjdflkasjd lkjasdlfkj asdklfjaskldj", image: Image("d1"), dateCreated: Date(), likeCount: 201, likedByUser: true))
                        
                        PostView(post: data)
                            .opacity(0)
                    }
                    
                }
                .padding(.vertical)
            }
        }
   
        
    }
    

}

//struct HomeFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeFeedView()
//    }
//}
