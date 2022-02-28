//
//  HomeView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/24/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme // check if is in dark mode or light
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                
                Text("Arro\nSocial")
                    .font(Font.custom(AppFont.lobster, size: 27))
//                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    print("clicked user")
                }) {
                    Image(systemName: "person.fill")
                    
                        .frame(width: 30, height: 30)
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 20).strokeBorder(Color(AppColors.secondary), lineWidth: 2.5)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                        )
                }
                
                
                Button(action: {
                    print("new post")
                }) {
                    
                    Image(systemName: "plus")
                        .font(Font.system(size: 35, weight: .semibold))
                        .frame(width: 30, height: 30)
                        .foregroundStyle(
                            .linearGradient(colors: [Color(AppColors.purple), Color.blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 20).strokeBorder(Color(AppColors.secondary), lineWidth: 2.5)
                                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 0)
                        )
                }
                
                
            }
            .padding(.horizontal)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding(.bottom)
            
         
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
//                    PostCell(userProfilePic: Image("person"), username: "JaneDoe", numberOfLikes: 316, isFollowing: true, caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et", image: Image("d1"))
//                    
//                    PostCell(userProfilePic: Image("person"), username: "JohnDoe", numberOfLikes: 0, isFollowing: false, caption: "Lorem ipsum dolor sitconsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et adsfasdfsda fasdfasdfasdfasdf", image: Image("d2"))
//                    
//                    PostCell(userProfilePic: Image("person"), username: "JohnDoe", numberOfLikes: 22, isFollowing: false, caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et adsfasdfsda fasdfasdfasdfasdf", image: Image("d3"))
                    PostCell(post: data)
                    PostCell(post: data)
                    PostCell(post: data)
                    PostCell(post: data)
                    PostCell(post: data)
                    
                }
              
                Spacer()
            }
            .padding(.horizontal)
     
            
           
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(AppColors.background).edgesIgnoringSafeArea(.all))
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
