//
//  PostView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/1/22.
//

import SwiftUI
import Photos

struct PostView: View {
    @State var post: PostModel
    @State private var showsMenu: Bool = true
    @State private var finishedFetchingProfileImage: Bool = false
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @State private var showPosterProfileView: Bool = false
    
    // data
    @State private var profileImage: UIImage = UIImage(named: "placeholder")!
    @State private var postImage: UIImage = UIImage(named: "placeholder")!
    @State private var profilePictureColor: String = ""
    @State private var isLoading: Bool = true
    
    @Binding var show: Bool
    @Binding var selectedPost: FullScreenPostModel?
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Image(uiImage: postImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .redacted(when: isLoading, redactionType: .customPlaceholder)
            //                .matchedGeometryEffect(id: selectedPost?.postID, in: namespace)
            
                .onTapGesture {
                    showFullScreen()
                }
            
            
            ZStack(alignment: .trailing) {
                VStack {
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showsMenu.toggle()
                            }
                            
                        }) {
                            Image(systemName: showsMenu ? "xmark" :  "arrow.up.left.and.arrow.down.right")
                                .foregroundColor(Color.white)
                                .font(.title2.bold())
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20)
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            if finishedFetchingProfileImage {
                                // profile picture
                                VStack {
                                    if profileImage.isEqual(UIImage(named: "placeholder")!) {
                                        // no profile picture
                                        Circle()
                                            .fill(Color(hexString: self.profilePictureColor)!)
                                            .frame(width: 50, height: 50)
                                        // first 2 letters of username
                                            .overlay(
                                                Text((post.username ).prefix(2))
                                                    .font(.custom("Poppins-SemiBold", size: 20))
                                                    .foregroundColor(.white)
                                            )
                                        
                                            .redacted(when: isLoading, redactionType: .customPlaceholder)
                                        
                                        
                                    } else {
                                        Image(uiImage: profileImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                        
                                            .redacted(when: isLoading, redactionType: .customPlaceholder)
                                        
                                    }
                                }
                               
                              
                                
                                
                            } else {
                                Image(uiImage: UIImage(named: "placeholder")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .redacted(when: isLoading, redactionType: .customPlaceholder)
                            }
                            
                            Text("@" + post.username)
                                .foregroundColor(.white)
                                .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                            
                            Spacer()
                        }
                        
                        
                        Text(post.caption ?? "" )
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.white)
                            .modifier(Poppins(fontWeight: AppFont.medium, .caption))
                            .frame(height: 50)
                            .truncationMode(.tail)
                            .padding(-5)
                    }
                    .padding()
                    .onTapGesture {
                        showProfileViewOfPoster()
                    }
                    
                    .frame(maxWidth: UIScreen.main.bounds.width - 20)
                    //                .shadow(color: Color.black, radius: 15, x: 0, y: -10)
                    .shadow(color: Color.black, radius: 20, x: 0.0, y: 5)
                }
                
                if showsMenu {
                    VStack {
                        Button {
                            
                            
                            if(post.likedByUser) {
                                // is already liked
                                unlikePost()
                            } else {
                                // is not liked
                                likePost()
                            }
                            
                            
                            
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "heart.fill")
                                    .font(.title.bold())
                                Text("\(post.likeCount)")
                                    .font(.subheadline)
                            }
                            .foregroundColor(post.likedByUser ? Color("heart") : .white)
                            
                            
                        }
                        Button {
                            
                            showFullScreen()
                            
                            
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "message.fill")
                                    .font(.title.bold())
                                Text("\(12)")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            
                            
                        }
                        .padding(.vertical)
                        
                        Button {
                            
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.title.bold())
                            }
                            .foregroundColor(.white)
                            
                            
                        }
                        
                    }
                    .padding()
                    .padding()
                    .padding(.vertical)
                    .background(
                        //                        EmptyView()
                        .ultraThinMaterial
                        //                            .frame(width: (UIScreen.main.bounds.width - 20) / 3.5, height: UIScreen.main.bounds.height / 2)
                        
                    )
                    .cornerRadius(20)
                    //                    .offset(x: 10)
                    .frame(width: (UIScreen.main.bounds.width - 20) / 3.5, height: UIScreen.main.bounds.height / 2)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                }
                
                
                
            }
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 2)
        .clipped()
        .cornerRadius(25)
        .onAppear {
            getImages()
        }
        .matchedGeometryEffect(id: post.postID, in: namespace)
        .sheet(isPresented: $showPosterProfileView) {
            ProfileView(isUsersOwnProfile: false, profilePosts: PostsViewModel(userID: post.userID), profilePictureVM: ProfilePictureViewModel(userID: post.userID), selectedPost: $selectedPost, profileUser: post.username, postUserID: post.userID)
        }
        //                .matchedGeometryEffect(id: "container\(post.postID)", in: namespace)
        
    }
    
    func getImages() {
        // get profile image
        
        ImageService.instance.downloadProfileImage(userID: post.userID) { image, hexColor  in
            // error checking image for nil
            if let hexColor = hexColor {
                self.profilePictureColor = hexColor
                self.finishedFetchingProfileImage = true
            } else if let image = image {
                self.profileImage = image
                withAnimation {
                    self.finishedFetchingProfileImage = true
                }
            }
            
            
            
        }
        
        ImageService.instance.downloadPostImage(postID: post.postID) { image in
            if let image = image {
                self.postImage = image
                withAnimation {
                    self.isLoading = false
                }
            }
            
        }
    }
    
    func showProfileViewOfPoster() {
        self.showPosterProfileView = true
    }
    
    func likePost() {
        
        let generator =  UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        guard let userID = currentUserID  else {
            print("cannot find userid while liking post")
            
            return
        }
        // local
        post.likedByUser = true
        post.likeCount += 1
        
        
        // on database
        DataService.instance.likePost(postID: post.postID, currentUserID: userID)
    }
    
    func unlikePost() {
        
        
        guard let userID = currentUserID  else {
            print("cannot find userid while liking post")
            return
        }
        // local
        post.likedByUser = false
        post.likeCount -= 1
        
        
        // on database
        DataService.instance.unlikePost(postID: post.postID, currentUserID: userID)
    }
    
    func showFullScreen() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
            
            show.toggle()
            self.selectedPost = FullScreenPostModel(postID: post.postID, userID: post.userID, username: post.username, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount, likedByUser: post.likedByUser, postImage: self.postImage, profileImage: self.profileImage, profilePictureColor: self.profilePictureColor)
        }
    }
    
}

//let data = PostModel(id: UUID(), postID: "123", userID: "123", userPicture: Image("person"), username: "johndoe", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et", image: Image("d1"), dateCreated: Date(), likeCount: 123, likedByUser: true)


//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView(post: data)
//    }
//}
