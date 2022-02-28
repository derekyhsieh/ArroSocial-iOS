//
//  SignUpView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email: String = "" // by default it's empty
    @State private var password: String = "" // by default it's empty
    @State private var reenter: String = "" // by default it's empty
    @State private var errorMessage: String = ""
    
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
                    Text("Sign Up")
                        .modifier(Poppins(fontWeight: AppFont.semiBold, .title))
                        .padding(.bottom, 30)
                        .foregroundColor(.black)
                 
                    TextField("email address", text: $email)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
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
                    
                    SecureField("reeenter password", text: $reenter)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    
                    Button(action: {checkUserInputFieldsForProblem()}) {
                        PrimaryButton(title: "Sign Up")
                            .padding(.vertical)
                        
                    }
                
                    Text(errorMessage)
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                    
                }
                Spacer()
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: 2)
                Spacer()
                Text("Read our Terms & Conditions.")
                    .foregroundColor(Color(AppColors.purple))
                
            }
            .padding()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func checkUserInputFieldsForProblem() {
        
        
        if email.isEmpty || password.isEmpty || reenter.isEmpty {
            errorMessage = "All fields must be entered"
        }
        else if !isValidEmail(self.email) {
            errorMessage = "Please enter a valid email address"
        } else if password != reenter {
            errorMessage = "Password and reenter password fields must be the same"
        } else {
            errorMessage = ""
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .preferredColorScheme(.light)
    }
}


