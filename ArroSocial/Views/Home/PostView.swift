//
//  PostView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/1/22.
//

import SwiftUI

struct PostView: View {
    @State var post: PostModel
    @State private var showsMenu: Bool = false
    var body: some View {
        ZStack {
            post.image
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            
            
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
                            post.userPicture
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            Text("@" + post.username)
                                .foregroundColor(.white)
                                .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                            
                            Spacer()
                        }
                        
                        
                        // caption can be nil
                        if post.caption != nil {
                            // can safely unwrap with bang since we checked already
                            Text(post.caption!)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.white)
                                .modifier(Poppins(fontWeight: AppFont.medium, .caption))
                                .frame(height: 50)
                                .truncationMode(.tail)
                                .padding(-5)
                        }
                    }
                    .padding()
                    
                    .frame(maxWidth: UIScreen.main.bounds.width - 20)
                    //                .shadow(color: Color.black, radius: 15, x: 0, y: -10)
                    .shadow(color: Color.black, radius: 20, x: 0.0, y: 5)
                }
                
                if showsMenu {
                    VStack {
                        Button {
                            post.likedByUser.toggle()
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
    }
}

let data = PostModel(id: UUID(), postID: "123", userID: "123", userPicture: Image("person"), username: "johndoe", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et", image: Image("d1"), dateCreated: Date(), likeCount: 123, likedByUser: true)


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: data)
    }
}