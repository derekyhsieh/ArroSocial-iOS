//
//  ChangePasswordView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/18/22.
//

import SwiftUI

struct ChangeEmailView: View {
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var email: String = ""
    @State private var emailIsOk: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                
             
                
                
                Spacer(minLength: 0)
                VStack {
                    HStack(alignment: .center){
                        
                        
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color.black)
                                    .font(.title2)
                            }
                            
                            
                        
                        
                        
                        Spacer(minLength: 0)
                        
                        Text("Change Email")
                            .modifier(Poppins(fontWeight: AppFont.semiBold, .title3))
//                            .padding(.bottom, 30)
                            .lineLimit(1)
                        .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
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
                                    self.emailIsOk = emailValue.isValidEmail()
                                }
                            }
                        if(emailIsOk) {
                            Text(Image(systemName: "checkmark"))
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                            
                            
                        }
                        
                    }
                    
                    Text(errorMessage)
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                        .modifier(Poppins(fontWeight: AppFont.regular, .caption))
                    
                Spacer()
                    
                    Button(action: {
                        
                    }) {
                        PrimaryButton(title: "Edit Email")
                            .padding(.vertical)
                        
                    }
                    
       
                    
                }
                
            }
            .padding()
            
            if isLoading {
                CustomLoadingIndicator(isShowing: $isLoading)
            }
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
    }
}
