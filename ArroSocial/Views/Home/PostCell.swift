//
//  PostView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/25/22.
//

import SwiftUI

struct PostCell: View {
    var image: Image = Image(systemName: "person.fill")
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color(AppColors.secondary), lineWidth: 10)
            .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 3)
            .overlay(
                VStack {
                    HStack {
                        
                        image
                            .font(.system(size: 50))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.white))
                                    .padding(7)
                                    
                                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
                                    
                                    .background(
                                        
                                        RoundedRectangle(cornerRadius: 10).strokeBorder(Color(AppColors.purple), lineWidth: 3)
                                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
                                    )
                            )
                        
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                    .padding()
            )
        
        
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PostCell()
                .padding()
        }
        .background(Color(AppColors.background))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}
