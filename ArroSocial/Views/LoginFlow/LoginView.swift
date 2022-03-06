//
//  LoginView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email: String = "" // by default it's empty
    @State private var password: String = "" // by default it's empty
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.black)
                            .font(.title2)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                
                Spacer(minLength: 0)
                VStack {
                    Text("Log In")
                        .modifier(Poppins(fontWeight: AppFont.semiBold, .title))
                        .padding(.bottom, 30)
                        .foregroundColor(Color.black)
                    
                    TextField("email address", text: $email)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .textInputAutocapitalization(.never)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    
                    SecureField("password", text: $password)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    
                    Text(errorMessage)
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                    
                    
                    
                    Button(action: {checkUserInputFieldsForProblem()}) {
                        PrimaryButton(title: "Log In")
                            .padding(.vertical)
                        
                    }
                    
                    
                    
                }
                Spacer()
                // custom divider
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity, maxHeight: 2)
                Spacer()
                Text("Read our Terms & Conditions")
                    .foregroundColor(Color(AppColors.purple))
                
            }
            .padding()
            
            if isLoading {
                ProgressView()
                    .padding()
                    .padding()
                    .scaleEffect(1.5, anchor: .center)
                    .accentColor(Color(AppColors.purple))
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 60, x: 0, y: 0)
                    )
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func checkUserInputFieldsForProblem() {
        
        
        if email.isEmpty || password.isEmpty {
            withAnimation
            {
                errorMessage = "All fields must be entered"
            }
        }
        else if !isValidEmail(self.email) {
            withAnimation {
                errorMessage = "Please enter a valid email address"
            }
        } else {
            
            // start loading indicator
            
            withAnimation {
                // start progress view loading indicator
                self.isLoading = true
            }
            
            withAnimation {
                errorMessage = ""
                
                withAnimation {
                    AuthenticationService.instance.signInUser(email: self.email, password: self.password) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        } else {
                            // user is successfully signed in
                            self.isLoading = false
                        }
                    }
                }
          
            }
        }
        self.isLoading = false
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
