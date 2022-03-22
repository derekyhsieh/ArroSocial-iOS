//
//  ProfileView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/21/22.
//

import SwiftUI

struct ProfileView: View {
    
    var isUsersOwnProfile: Bool
    
    @StateObject var profilePosts: PostsViewModel
    @StateObject var profilePictureVM: ProfilePictureViewModel
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    
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
                            .frame(width: 125, height: 125)
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
                }
                Spacer(minLength: 0)
                
                Text("@\(username)")
                    .modifier(Poppins(fontWeight: AppFont.medium, .title3))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
            }
            if !isUsersOwnProfile {
                Button(action: {}) {
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
                    .background(Color(AppColors.purple).cornerRadius(30).shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 0))
                    
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
                    
                    Text("0")
                        .modifier(Poppins(fontWeight: AppFont.medium, .callout))
                    Text("Followers")
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                }
                
            }
            .padding()
            
            Divider()
            
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(self.profilePosts.dataArray) { post in
                        PostImageView(post: post)
                    }
                    
                }
            }
        }
        .padding()
        .padding(.top)
    }
}

struct ProfileView_Previews: PreviewProvider {
    @AppStorage(CurrentUserDefaults.userID) var userID: String = ""
    
    static var previews: some View {
        ProfileView(isUsersOwnProfile: false, profilePosts: PostsViewModel(userID: "62lnkEVO6WZpXnlm1zAOybFOHfW2"), profilePictureVM: ProfilePictureViewModel())
    }
}


struct PostImageView: View {
    @State var post: PostModel
    @State private var postImage: UIImage = UIImage(named: "placeholder")!
    var body: some View {
        
        VStack {
            Image(uiImage: postImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            
        }
        .onAppear {
            ImageService.instance.downloadPostImage(postID: post.postID) { image in
                if let image = image {
                    self.postImage = image
                }
            }
        }
        
    }
}