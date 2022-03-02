//
//  PostView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/25/22.
//

import SwiftUI

struct PostCell: View {
    @State var post: PostModel
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(AppColors.background))
   
            VStack {
                
                post.image
                    .resizable()
                  
                    .aspectRatio(contentMode: .fill)
                    
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 200)
                    .clipped()
                    .cornerRadius(25)
                    
                
                
                HStack {
                    
                    HStack(alignment: .top) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(AppColors.purple), lineWidth: 1.5)
                                .frame(width: 62, height: 62)
                                
                                
                            
                            Image("person")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .cornerRadius(10)
                            
                            
                            
          
                        }
                        
                        
                            Text("@" + post.username)
                                .modifier(Poppins(fontWeight: AppFont.semiBold, .caption))
                    }
              


                    
                    
                    .padding(.horizontal)
                    
                    Spacer(minLength: 0)
                    
                    VStack {
                        
                        Button(action: {post.likedByUser.toggle()}) {
                            Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                                .foregroundColor(post.likedByUser ? Color("heart") : Color(.gray))
                                .font(.title)
                            .foregroundColor(Color.secondary)
                        }
                   
                        
                        Text("\(post.likeCount)")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                    VStack {
                        Image(systemName: "bubble.left")
                            .font(.title)
                            .foregroundColor(.gray)
                        Text("\(post.likeCount)")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.clear)
                    }
                }
                .padding(.vertical)
                
                
                Text(post.caption ?? "")
                    .frame(maxWidth: .infinity)
                    
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 75)
            .padding()
            .padding(.top)
        }
        .frame(width: UIScreen.main.bounds.width - 50)
        .frame(height: 450)
        .shadow(color: Color("lightShadow"), radius: 8, x: -8, y: -8)
    
        .shadow(color: Color("darkShadow"), radius: 8, x: 8, y: 8)
        .padding()
       
       
        
    
        
       
        
        
    }
}


struct PostCell_Previews: PreviewProvider {

    static var previews: some View {
        PostCell(post: data)
//        PostCell(userProfilePic: Image("person"), username: "JaneDoe", numberOfLikes: 102, isFollowing: true, caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et", image: Image("d3"))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
