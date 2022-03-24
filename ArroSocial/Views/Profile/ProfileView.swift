//
//  ProfileView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/21/22.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    
    var isUsersOwnProfile: Bool
    
    @StateObject var profilePosts: PostsViewModel
    @StateObject var profilePictureVM: ProfilePictureViewModel
    @State private var isEditing: Bool = false
    @State var fetchingFollowerData: Bool = true
    @State private var followerCount: Int = 0
    @State private var isFollowing: Bool = false
    
    @Binding var selectedPost: FullScreenPostModel?
    
    // if this isn't nil then it's not the currnet user's profile
    var profileUser: String?
    var postUserID: String?
    
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil),
        //            GridItem(.flexible(), spacing: nil, alignment: nil),
    ]
    
    
    var body: some View {
        VStack {
            HStack {
                if profilePictureVM.isFinishedFetchingProfilePicture {
                    if profilePictureVM.profilePicture != nil {
                        Image(uiImage: profilePictureVM.profilePicture!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                    } else {
                        Circle()
                            .fill(Color(hexString: profilePicColorBackground) ?? Color(AppColors.purple))
                            .frame(width: 125, height: 125)
                            .overlay(Text(username.prefix(2)))
                            .font(.custom("Poppins-SemiBold", size: 40))
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                        
                    }
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 125, height: 125)
                        .redacted(when: profilePictureVM.isLoading, redactionType: .customPlaceholder)
                }
                Spacer(minLength: 0)
                
                Text("@\((profileUser == nil ? username : profileUser)!)")
                    .modifier(Poppins(fontWeight: AppFont.medium, .title3))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
            }
            if !isUsersOwnProfile {
                
                if(isFollowing) {
                    Button(action: {
                        withAnimation {
                            // right now is following
                            isFollowing.toggle()
                            unFollowUser()
                        }
                        
                    }) {
                        HStack {
                            
                            
                            
                            Text("Following")
                                .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                            
                            Image(systemName: "checkmark")
                                .font(Font.title3.weight(.medium))
                            
                            
                        }
                        .foregroundColor(Color(AppColors.purple))
                        .frame(maxWidth: .infinity)
                        
                        .padding()
                        //                    .background(Color(AppColors.purple).cornerRadius(30).shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 0))
                        
                        .background(RoundedRectangle(cornerRadius: 30).stroke(Color(AppColors.purple), lineWidth: 4).shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 0))
                        
                        
                        
                        
                        
                    }
                    
                }
                else {
                    Button(action: {
                        withAnimation {
                            // right now is unfollowed
                            followUser()
                            isFollowing.toggle()
                            
                        }
                    }) {
                        HStack {
                            
                            
                            
                            Text("Follow")
                                .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                                .foregroundColor(.white)
                            Image(systemName: "plus")
                                .font(Font.title3.weight(.medium))
                                .foregroundColor(.white)
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        .padding()
                        
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color(AppColors.purple)).shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 0))
                        .redacted(when: fetchingFollowerData, redactionType: .customPlaceholder)
                        
                    }
                    
                    
                    
                    
                    
                }
                
            }
            
            
            
            HStack {
                VStack {
                    
                    Text("100")
                        .modifier(Poppins(fontWeight: AppFont.medium, .callout))
                    Text("Likes")
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                }
                Spacer()
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 1, height: 15)
                
                Spacer()
                
                VStack {
                    
                    Text("\(self.profilePosts.dataArray.count)")
                        .modifier(Poppins(fontWeight: AppFont.medium, .callout))
                    Text("Posts")
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                }
                
                Spacer()
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 1, height: 15)
                
                Spacer()
                
                VStack {
                    
                    Text("\(followerCount)")
                        .modifier(Poppins(fontWeight: AppFont.medium, .callout))
                        .redacted(when: fetchingFollowerData, redactionType: .customPlaceholder)
                    Text("Followers")
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                }
                
            }
            .padding()
            
            Divider()
            
            if isUsersOwnProfile {
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isEditing.toggle()
                        }
                        
                    }) {
                        Text(isEditing ? "done" : "edit")
                            .foregroundColor(isEditing ? Color.red : Color.blue)
                            .font(.custom("Poppins-regular", size: 15))
                    }
                }
                
            }
            
            
            
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(self.profilePosts.dataArray) { post in
                        PostImageView(postVM: profilePosts, isEditing: $isEditing, selectedPost: $selectedPost, post: post, profilePicVM: profilePictureVM)
                        
                        
                    }
                    
                }
            }
        }
        .padding()
        .padding(.top)
        .onAppear {
            if !isUsersOwnProfile {
                DataService.instance.getIfCurrentUserIsFollowingAndCount(currentUserID: currentUserID, targetUserID: postUserID!) { isFollowing, followerCount in
                    self.isFollowing = isFollowing
                    self.followerCount = followerCount
                    self.fetchingFollowerData = false
                }
                
            } else {
                DataService.instance.getIfCurrentUserIsFollowingAndCount(currentUserID: "", targetUserID: currentUserID) { isFollowing, followerCount in
//                    self.isFollowing = isFollowing
                    self.followerCount = followerCount
                    self.fetchingFollowerData = false
                }
            }
            
            
        }
    }
    
    func checkIfUserFollows() {
        
    }
    
    func followUser() {
        withAnimation(.easeInOut) {
            self.followerCount += 1
        }
        DataService.instance.followUser(followerID: currentUserID, followedID: postUserID!)
        
        
    }
    
    func unFollowUser() {
        withAnimation(.easeInOut) {
            self.followerCount -= 1
        }
        DataService.instance.unfollowUser(followerID: currentUserID, followedID: postUserID!)
        
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    @AppStorage(CurrentUserDefaults.userID) var userID: String = ""
//
//    static var previews: some View {
//        ProfileView(isUsersOwnProfile: true, profilePosts: PostsViewModel(userID: "62lnkEVO6WZpXnlm1zAOybFOHfW2"), profilePictureVM: ProfilePictureViewModel())
//    }
//}


struct PostImageView: View {
    @State var isLoading: Bool = true
    @StateObject var postVM: PostsViewModel
    @Binding var isEditing: Bool
    @Binding var selectedPost: FullScreenPostModel?
    @State var post: PostModel
    @Environment(\.presentationMode) var presentationMode
    @State private var postImage: UIImage = UIImage(named: "placeholder")!
    @StateObject var profilePicVM: ProfilePictureViewModel
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    
    var body: some View {
        
        VStack {
            VStack {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    Image(uiImage: postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        .redacted(when: isLoading, redactionType: .customPlaceholder)
                        .onTapGesture {
                            // show full screen
                            presentationMode.wrappedValue.dismiss()
                            
                            self.showFullScreenPost()
                        }
                    
                    if isEditing {
                        Button {
                            deletePost()
                        } label: {
                            ZStack {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.red)
                                
                                Image(systemName: "minus.circle")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.white)
                            }
                            .redacted(reason: isLoading ? .placeholder : [])
                        }
                        
                        
                        
                    }
                }
                
                
            }
            //        .redacted(when: isLoading, redactionType: .customPlaceholder)
            //        .frame(width: 300, height: 150)
            .onAppear {
                ImageService.instance.downloadPostImage(postID: post.postID) { image in
                    if let image = image {
                        self.postImage = image
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
                
                
            }
            
            
        }
    }
    
    func deletePost() {
        
        postVM.deletePost(postID: post.postID) { finished in
            
        }
        
    }
    
    func showFullScreenPost() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
            
            self.selectedPost = FullScreenPostModel(postID: post.postID, userID: post.userID, username: post.username, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount, likedByUser: post.likedByUser, postImage: self.postImage, profileImage: ((profilePicVM.profilePicture ?? UIImage(named: "placeholder"))!) , profilePictureColor: profilePicColorBackground)
        }
    }
}

