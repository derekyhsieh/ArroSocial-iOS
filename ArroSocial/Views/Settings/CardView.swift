//
//  CardView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/30/22.
//

import SwiftUI

struct CardView: View {
    var userID: String
    var firstN: String
    var lastN: String
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 4 + 20)
                .cornerRadius(15)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        
                        Text("ArroSocial")
                            .modifier(Poppins(fontWeight: AppFont.medium, .callout))
                       Text(userID)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("CARD HOLDER")
                                    .fontWeight(.semibold)
                                Text(firstN + " " + lastN)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            Spacer(minLength: 0)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("CARD HOLDER")
                                    .fontWeight(.semibold)
                                Text(firstN + " " + lastN)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        }
                        .foregroundColor(Color.white)
                        
                    }
                )
            
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(userID: "ajsdkflajsdlkf2123j", firstN: "Derek", lastN: "Hsieh")
    }
}
