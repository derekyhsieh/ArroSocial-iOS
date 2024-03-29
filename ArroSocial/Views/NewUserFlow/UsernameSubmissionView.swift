//
//  UsernameSubmissionView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/28/22.
//

import SwiftUI

struct UsernameSubmissionView: View {
    @Binding var username: String
//    @State private var errorMessage: String = ""
    
    
    // usernameStatus = true means username is taken, false means username isnt taken
    @State private var usernameStatus: Bool = true
    @State private var showingUsernameStatusAlert: Bool = false
    var color: Color
    var body: some View {
        VStack {
            Text("Pick a username")
                .foregroundColor(color)
                .font(.custom(("Poppins-"+AppFont.semiBold), size: 50))
                .minimumScaleFactor(0.7)
            
                .multilineTextAlignment(.center)
            
            
            HStack {
                TextField("username", text: ($username))
                    .font(.title3)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.1), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                    .padding(.vertical)
                    .onChange(of: username) { usernameValue in
                        if(usernameValue.first != "@") {
                            //                        self.username = "@" + usernameValue
                        }
                        if usernameValue.count >= 3 {
                            AuthenticationService.instance.checkIfUsernameExistsInDatabase(username: usernameValue) { error, usernameExists in
                                if let error = error {
                                    print(error)
                                }
                                
                                withAnimation(.easeInOut) {
                                    self.usernameStatus = usernameExists
                                }
                                
                                
                            }
                        } else if usernameValue.count > 0 {
                            withAnimation(.easeInOut) {
                                self.usernameStatus = true
                            }
                        }
                     
                    }
                
                if username.count > 1 {
                    
                    Text(Image(systemName: usernameStatus ? "xmark" : "checkmark"))
                        .fontWeight(.bold)
                        .foregroundColor(usernameStatus ? Color.red : Color.green)
                        .animation(.default)
                }
                    

            }
        }
    }
}

//struct UsernameSubmissionView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsernameSubmissionView(color: Color(AppColors.lightBlue))
//    }
//}
