//
//  CommentView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/23/22.
//

import SwiftUI

struct CommentView: View {
    var username: String
    var commment: String
    var dateCreated: Date
    var commentID: String
    var userID: String
    
    @StateObject var profilePicVM: ProfilePictureViewModel
    
    var body: some View {
        HStack {
            
            if(profilePicVM.hexColor != nil) {
                Circle()
                    .fill(Color(hexString: profilePicVM.hexColor!)!)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(username.prefix(2))
                            .modifier(Poppins(fontWeight: AppFont.medium, .caption))
                            .foregroundColor(Color.white)
                    )
            } else {
                
                Image(uiImage: (profilePicVM.profilePicture ?? UIImage(named: "placeholder")!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .redacted(when: profilePicVM.isLoading, redactionType: .customPlaceholder)
            
            }
           
            
            
                
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(username)
                        .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                    .padding(.bottom, 5)
                    
                    Spacer()
                    
                    Text(getDifferenceBetweenTwoDates(lhs: dateCreated, rhs: Date()))
                        .modifier(Poppins(fontWeight: AppFont.medium, .caption))
                        .foregroundColor(Color.gray)
                    
                }
                
                Text(commment)
                    .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                    .foregroundColor(Color.gray)
            }
        }
            
    }
    
    func getDifferenceBetweenTwoDates(lhs: Date, rhs: Date) -> String {
        let diffComponents = Calendar.current.dateComponents([.minute, .day, .hour], from: lhs, to: rhs)
        let minutes = diffComponents.minute
        let hours = diffComponents.hour
        let days = diffComponents.day
        
        if minutes! < 60  {
            return ("\(String(describing: minutes!))m")
        } else if hours! < 24 {
            return ("\(String(describing: hours!))h")
        } else {
            return ("\(String(describing: days!))d")
        }
        
    }
       
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(username: "derekhsieh", commment: "tes tcomment", dateCreated: Date())
//    }
//}
