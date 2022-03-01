//
//  FirstLastNameSubmission.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct FirstLastNameSubmission: View {
    @State private var firstN: String = ""
    @State private var lastN: String = ""
    var color: Color
    var body: some View {
        VStack {
            Text("Enter your first name and last name")
                .foregroundColor(color)
                .font(.custom(("Poppins-"+AppFont.semiBold), size: 40))
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)
            
            TextField("First Name", text: $firstN)
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(50.0)
                .shadow(color: Color.black.opacity(0.1), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                .padding(.vertical)
                .foregroundColor(color)
//                .padding()
            
            TextField("Last Name", text: $lastN)
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(50.0)
                .foregroundColor(color)
                .shadow(color: Color.black.opacity(0.1), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                .padding(.vertical)
                
        }
    }
}

struct FirstLastNameSubmission_Previews: PreviewProvider {
    static var previews: some View {
        FirstLastNameSubmission(color: Color(AppColors.blue))
    }
}
