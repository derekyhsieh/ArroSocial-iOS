//
//  SignUpView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showNewUserWalkthrough: Bool
    @State private var emailIsOk: Bool = false
    @State private var passwordIsOk: Bool = false
    @State private var reenterIsOk: Bool = false
    @State private var email: String = "" // by default it's empty
    @State private var password: String = "" // by default it's empty
    @State private var reenter: String = "" // by default it's empty
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    // only used if user force quits app during walkthrough flow
    @AppStorage(CurrentUserDefaults.email) var emailDefault: String = ""
    @AppStorage(CurrentUserDefaults.password) var passwordDefault: String = ""
    @AppStorage("userIsInTheMiddleOfWalkthrough") var userIsInMiddleOfWalkthrough: Bool = false
    
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
                    
                    HStack {
                        TextField("email address", text: $email)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .textInputAutocapitalization(.never)
                            .padding(.vertical)
                            .keyboardType(.emailAddress)
                            .onChange(of: email) { emailValue in
                                withAnimation {
                                    // animate state var for checkmark when email is valid
                                    self.emailIsOk = isValidEmail(emailValue)
                                }
                            }
                            .disableAutocorrection(true)
                        if(emailIsOk) {
                            Text(Image(systemName: "checkmark"))
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                            
                            
                        }
                        
                    }
                    
                    HStack {
                        SecureField("password", text: $password)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(.vertical)
                            .onChange(of: password) { passwordValue in
                                withAnimation {
                                    // animate state var for checkmark when email is valid
                                    self.passwordIsOk = isValidPassword(passwordValue)
                                }
                            }
                        if(passwordIsOk) {
                            Text(Image(systemName: "checkmark"))
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                            
                            
                        }
                    }
                    
                    
                    HStack {
                        SecureField("re-eenter password", text: $reenter)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(.vertical)
                            .onChange(of: reenter) { reenterValue in
                                withAnimation {
                                    // animate state var for checkmark when valid
                                    if reenterValue == self.password {
                                        reenterIsOk = true
                                    } else {
                                        reenterIsOk = false
                                    }
                                }
                            }
                        
                        if reenterIsOk {
                            Text(Image(systemName: "checkmark"))
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                            
                        }
                    }
                    
                    
                    Button(action: {checkUserInputFieldsForProblem()}) {
                        PrimaryButton(title: "Sign Up")
                            .padding(.vertical)
                        
                    }
                    
                    Text(errorMessage)
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                    
                }
                Spacer()
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray.opacity(0.5))
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
        // email sanitization
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: cleanedEmail)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let numbers = CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
        if password.count <= 7 {
            return false
        } else if password.rangeOfCharacter(from: numbers) == nil {
            return false
        }
        
        return true
    }
    
    
    func checkUserInputFieldsForProblem() {
        
        
        if email.isEmpty || password.isEmpty || reenter.isEmpty {
            errorMessage = "All fields must be entered"
        }
        else if !isValidEmail(self.email) {
            errorMessage = "Please enter a valid email address"
        } else if !isValidPassword(self.password){
            errorMessage = "Password must contain at least 1 number and be 8 characters or longer"
        }
        else if password != reenter {
            errorMessage = "Password and reenter password fields must be the same"
        } else {
            errorMessage = ""
            
            withAnimation {
                // start progress view loading indicator
                self.isLoading = true
            }
            
            AuthenticationService.instance.createNewUser(email: self.email, password: self.password) { errorMessage, email in
                if(errorMessage != nil) {
                    // there were errors with authentication
                    print(errorMessage!)
                    
                    withAnimation {
                        self.isLoading = false
                        self.errorMessage = errorMessage!
                    }
                    
                } else {
                    // no errors with authentication and proceed
                    
                    // stop loading indicator
                    self.isLoading = false
                    
                    withAnimation {
                           emailDefault = email
                        passwordDefault = password
                        
                        self.showNewUserWalkthrough = true
                        self.userIsInMiddleOfWalkthrough = true
                    }
                }
            }
            
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignUpView(showNewUserWalkthrough: .constant(false))
            .preferredColorScheme(.light)
    }
}


