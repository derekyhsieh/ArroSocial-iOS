//
//  HomeView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/24/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                
                Text("Arro\nSocial")
                    .font(Font.custom(AppFont.lobster, size: 27))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    print("clicked user")
                }) {
                    Image(systemName: "person.fill")
                    
                        .frame(width: 30, height: 30)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 20).strokeBorder(Color(AppColors.secondary), lineWidth: 2.5)
                                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
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
                                .shadow(color: Color.black.opacity(0.7), radius: 3, x: 0, y: 0)
                        )
                }
                
                
            }
            .padding(.horizontal)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            
         
            
            PostCell()
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(AppColors.background).edgesIgnoringSafeArea(.all))
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
