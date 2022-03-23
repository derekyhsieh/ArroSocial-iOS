//
//  FullScreenPostView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/23/22.
//

import SwiftUI

struct FullScreenPostView: View {
    @State var post: PostModel
    @State var postImage: UIImage
    @State private var commentText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: postImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 350)
            
            VStack {
                HStack {
                    Image("person")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                        .offset(y: -30)
                        .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 0)
                    
                    Text("@\(post.username)")
                        .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                    Spacer()
                    
                    Button {
                        post.likedByUser.toggle()
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .foregroundColor(Color.red)
                            .font(.system(.title))
                    }
                    
                    Button {
                        print("send")
                    } label: {
                        Image(systemName: "message")
                            .foregroundColor(Color.gray)
                            .font(.system(.title))
                    }
                }
                
                Text(post.caption ?? "")
                
                Divider()
                    .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    CommentView(username: "derekhsieh", commment: "jadskl fjaskjf alksjdflsa", dateCreated: Date())
                    CommentView(username: "derekhsieh", commment: "jadskl fjaskjf alksjdflsa", dateCreated: Date())
                    CommentView(username: "derekhsieh", commment: "jadskl fjaskjf alksjdflsa", dateCreated: Date())
                    CommentView(username: "derekhsieh", commment: "jadskl fjaskjf alksjdflsa", dateCreated: Date())
                    
                }
                
            }
            .padding(.horizontal)
            
            
            
            Spacer()
            
            
            HStack {
                TextField("Write comment here", text: $commentText).textFieldStyle(RoundedBorderTextFieldStyle())
                
                if commentText.count > 0 {
                    Button(action: {
                        
                    }) {
                        Text("post")
                            .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                    }
                    
                }
                
            }
            .padding()
        }
        .background(Color(AppColors.bg))
        .frame(width: UIScreen.main.bounds.width)
        .edgesIgnoringSafeArea(.top)
    }
}

struct FullScreenPostView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenPostView(post: PostModel(id: UUID(), postID: "", userID: "", username: "derekhsieh", caption: "ajskdlfj askdjflkajsflkjas lkadfjlasdjflasjdflkasjdflkajsdflkjadsfjaskdlf", dateCreated: Date(), likeCount: 0, likedByUser: false), postImage: UIImage(named: "d1")!)
    }
}
