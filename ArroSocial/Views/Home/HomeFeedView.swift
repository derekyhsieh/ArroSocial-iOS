//
//  HomeFeedView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/1/22.
//

import SwiftUI


struct HomeFeedView: View {
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    
    var body: some View {
        ZStack {
            Color(AppColors.bg).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    
                    HStack {
                        Image(systemName: "arrow.uturn.up")
                        
                            .font(.title.bold())
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(AppColors.purple) .clipShape(Circle()))
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
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
                        
                        Circle()
                            .fill(Color(hexString: self.profilePicColorBackground) ?? Color(AppColors.purple))
                            .frame(width: 40, height: 40)
                        // first 2 letters of username
                            .overlay(
                                Text(username.prefix(2))
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.white)
                            )
                        
                        
                        //                        Image("person")
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fill)
                        //                            .frame(width: 40, height: 40)
                        //                            .clipShape(Circle())
                        //                            .font(.custom("Poppins-SemiBold", size: 20))
                        //                            .foregroundColor(.white)
                        //                            .padding(.trailing, 5)
                        
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

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
