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
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "person")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
            VStack(alignment: .leading) {
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

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(username: "derekhsieh", commment: "tes tcomment", dateCreated: Date())
    }
}
