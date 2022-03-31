//
//  FullScreenPostView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/23/22.
//

import SwiftUI

struct FullScreenPostView: View {
    @Binding var post: FullScreenPostModel?
    @Binding var show: Bool
    let namespace: Namespace.ID
    @State private var commentText: String = ""
    @State var currentUserProfileImage: UIImage
    var currentUserProfileBackground: String
    @AppStorage(CurrentUserDefaults.username) var currentUsername = ""
    @AppStorage(CurrentUserDefaults.userID) var currentUserID = ""
    @State var showActionSheet: Bool = false
    @State var showPosterProfileView: Bool = false
    @State var isUsersOwnPost: Bool = false
    @StateObject var commentVM: CommentViewModel
    
    @State var value: CGFloat = 0
    
    
    
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    Image(uiImage: (post?.postImage ?? UIImage(named: "placeholder"))!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 350)
                        .matchedGeometryEffect(id: post?.postID, in: namespace)
                    
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                                
                                show.toggle()
                                self.post = nil
                            }
                        }
                    
                    VStack {
                        HStack {
                            
                            
                            if post != nil {
                                if(post!.profileImage.isEqual(UIImage(named: "placeholder")!)) {
                                    // no profile picture
                                    Circle()
                                        .fill(Color(hexString: post!.profilePictureColor) ?? Color(.gray))
                                        .frame(width: 85, height: 85)
                                    // first 2 letters of username
                                        .overlay(
                                            Text((post?.username ?? "  ").prefix(2))
                                                .font(.custom("Poppins-SemiBold", size: 30))
                                                .foregroundColor(.white)
                                        )
                                        .offset(y: -30)
                                        .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 0)
                                    
                                    
                                } else {
                                    Image(uiImage: (post?.profileImage ?? UIImage(named: "placeholder"))!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 85, height: 85)
                                        .clipShape(Circle())
                                        .offset(y: -30)
                                        .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 0)
                                }
                            }
                            
                            
                            
                            Text("@\(post?.username ?? "")")
                                .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                            Spacer()
                            
                            
                            Button {
                                self.showActionSheet = true
                            } label: {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(Color.gray)
                                    .font(.system(.title))
                            }
                        }
                        .onTapGesture {
                            self.showPosterProfileView = true
                        }
                        
                        Text(post?.caption ?? "")
                        
                        Divider()
                            .padding()
                        
                        ScrollView(.vertical, showsIndicators: true) {
                            ForEach(commentVM.commentArray, id: \.self) { comment in
                                CommentView(username: comment.username, commment: comment.content, dateCreated: comment.dateCreated, commentID: comment.commentID, userID: comment.userID, profilePicVM: ProfilePictureViewModel(userID: comment.userID))
                                  
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                    Spacer()
                    
                    
                    HStack {
                        
                        if(currentUserProfileImage.isEqual(UIImage(named: "placeholder")!) && post?.profilePictureColor != nil) {
                            // user has no profile view
                            
                            Circle()
                                .fill(Color(hexString: self.currentUserProfileBackground )!)
                                .frame(width: 45, height: 45)
                                .overlay(
                                    Text(currentUsername.prefix(2))
                                        .font(.custom("Poppins-SemiBold", size: 15))
                                        .foregroundColor(.white)
                                )
                            
                        } else {
                            Image(uiImage: currentUserProfileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                            
                        }
                        
                        TextField("Write comment here", text: $commentText).textFieldStyle(RoundedBorderTextFieldStyle())
                            .onAppear {
                                withAnimation(.spring()) {
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
                                        DispatchQueue.main.async {
                                            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                            let height = value.height
                                            
                                            self.value = height
                                        }
                                    }
                                    
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { noti in
                                        DispatchQueue.main.async {
                                            print("dismissing")
                                            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                            let height = 0
                                            self.value = 0
                                        }
                                    }
                                }
                            }
                        
                        
                        
                        if commentText.count > 0 {
                            Button(action: {
                                // upload comment
                                
                                
                                    self.value = 0
                                    hideKeyboard()
                                commentVM.uploadComment(userID: currentUserID, postID: post!.postID, username: currentUsername, content: self.commentText) { isFinished in
                                    self.commentText = ""
                                }
                                
                                
                            }) {
                                Text("post")
                                    .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                            }
                            
                        }
                        
                    }
                    //                .frame(height: 100)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color(AppColors.bg)))
                    .offset(y: -self.value)
             
                }
                .background(Color(AppColors.bg))
                .frame(width: UIScreen.main.bounds.width)
                .edgesIgnoringSafeArea(.vertical)
                
                
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                        
                        show.toggle()
                        self.post = nil
                        
                    }
                    
                }) {
                    Circle()
                        .fill(Color.gray)
                        .shadow(color: Color.black.opacity(0.7), radius: 30, x: 0, y: 0)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "xmark")
                                .foregroundColor(Color.white)
                        )
                        .padding(.trailing)
                        .padding(.top, 50)
                }
            }
            CustomLoadingIndicator(isShowing: $commentVM.isUploading)
        }
        .disabled(commentVM.isUploading)
        // for comment text field
        .confirmationDialog(Text("Why are you reporting this post?"), isPresented: $showActionSheet) {
            
            Button("Spam", role: .destructive) { print("Spam")}
            Button("Inappropriate content", role: .destructive) { print("inappropriate content")}
            Button("Hate speech", role: .destructive) { print("hate speech")}
            
            
            
        }
        .sheet(isPresented: $showPosterProfileView) {
            ProfileView(isUsersOwnProfile: $isUsersOwnPost, profilePosts: PostsViewModel(userID: post?.userID ?? ""), profilePictureVM: ProfilePictureViewModel(userID: post?.userID ?? "62lnkEVO6WZpXnlm1zAOybFOHfW2"), selectedPost: $post, profileUser: post?.username ?? "", postUserID: post?.userID ?? "")
        }
        .onAppear {
            if currentUserID == post?.userID {
                self.isUsersOwnPost = true
            } else {
                self.isUsersOwnPost = false
            }
        }
    }
    
    //    func likePost() {
    //
    ////        post?.likeCount += 1
    ////        post?.likedByUser = true
    //
    //        guard let post = post else {return}
    //        DataService.instance.likePost(postID: post.postID, currentUserID: currentUserID)
    //
    //    }
    //
    //    func unlikePost() {
    ////        post?.likeCount -= 1
    ////        post?.likedByUser = false
    //        guard let post = post else {return}
    //        DataService.instance.unlikePost(postID: post.postID, currentUserID: currentUserID)
    //
    //    }
}

//struct FullScreenPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullScreenPostView(post: PostModel(id: UUID(), postID: "", userID: "", username: "derekhsieh", caption: "ajskdlfj askdjflkajsflkjas lkadfjlasdjflasjdflkasjdflkajsdflkjadsfjaskdlf", dateCreated: Date(), likeCount: 0, likedByUser: false), postImage: UIImage(named: "d1")!)
//    }
//}
