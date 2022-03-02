//
//  HomeFeedView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/1/22.
//

import SwiftUI

struct HomeFeedView: View {
    var body: some View {
        ZStack {
            Color(AppColors.bg).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    
                    HStack {
                        Image(systemName: "arrow.uturn.up")
                        
                            .font(.title.bold())
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(Color(AppColors.purple) .clipShape(Circle()))
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0.0, y: 16)
                        
                        
                        
                    }
                    
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    
                    HStack {
                        
                        Circle()
                            .fill(Color(AppColors.blue))
                            .frame(width: 40, height: 40)
                            .overlay(Text("de"))
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                        
                        Text("@derekhsieh")
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
