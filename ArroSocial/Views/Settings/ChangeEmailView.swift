//
//  ChangePasswordView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/18/22.
//

import SwiftUI
import SSToastMessage

struct ChangeEmailView: View {
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var email: String = ""
    @State private var emailIsOk: Bool = false
    @State var attempts: Int = 0
    @Binding var floatMessage: String
    
    @State private var showingSuccessFloat: Bool = false
    @Binding var isShowingFloat: Bool
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
                            .modifier(Poppins(fontWeight: AppFont.semiBold, .headline))
                        //                            .padding(.bottom, 30)
                            .lineLimit(1)
                            .foregroundColor(.black)
                        
                        Spacer(minLength: 0)
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
                        self.errorMessage = ""
                        
                        if emailIsOk {
                            AuthenticationService.instance.updateUserEmail(newEmail: self.email) { success, errorMessage in
                                if let errorMessage = errorMessage {
                                    self.errorMessage = errorMessage
                                } else {
                                    print("succesfully changed email")
                                    
                                    self.floatMessage = "Succesfully changed email"
                                    self.isShowingFloat = true
                                    
                                    presentationMode.wrappedValue.dismiss()
                                    
                                    
                                    
                                }
                            }
                        } else {
                            withAnimation(.default) {
                                self.errorMessage = "Not valid email"
                                self.attempts += 1
                            }
                        }
                        
                    }) {
                        PrimaryButton(title: "Edit Email")
                            .padding(.vertical)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                            .padding(.bottom, ((UIApplication.shared.windows.first?.safeAreaInsets.bottom)!) * 2)
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
//
//struct ChangeEmailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeEmailView()
//    }
//}
