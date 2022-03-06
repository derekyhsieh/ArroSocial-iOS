//
//  SettingsView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/2/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    @AppStorage(CurrentUserDefaults.fName) var firstName: String = ""
    @AppStorage(CurrentUserDefaults.lName) var lastName: String = ""
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .background(Color.white.opacity(0.3))
                    .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                    
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color(hexString: profilePicColorBackground) ?? Color(AppColors.purple))
                            .frame(width: 125, height: 125)
                            .overlay(Text(username.prefix(2)))
                            .font(.custom("Poppins-SemiBold", size: 40))
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                        
                        Button(action: {}) {
                            Image(systemName: "pencil")
                                .frame(width: 30, height: 30)
                                .font(.title3)
                                .foregroundColor(.white)
                            
                                .background(Color(AppColors.purple).clipShape(Circle()))
                                .shadow(color: Color.black, radius: 50, x: 0, y: 0)
                                .offset(x: -10)
                        }
                    }
                    .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: 0)
                    
                    
                    
                    Text(firstName + " " + lastName)
                        .foregroundColor(Color.black)
                        .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                        .padding()
                    
                    Divider()
                    
                    // settings dashboard
                    VStack(alignment: .leading) {
                        
                        NavigationLink {
                            Text("transactions")
                        } label: {
                            
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.white)
                                    .font(.title.bold())
                                    .padding()
    //                                .padding(5)
                                    .background(
                                        Circle()
                                            .fill(Color.green)
                                    )
                                Text("Transactions")
                                    .modifier(Poppins(fontWeight: AppFont.regular, .subheadline))
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline.bold())
                                
                            }
                            .foregroundColor(.black)
                            
                        }
                        .navigationBarHidden(true)
                        
                        
                        NavigationLink {
                            Text("edit email")
                        } label: {
                            HStack {
                                Image(systemName: "envelope.badge.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.title.bold())
    //                                .padding(5)
                                    .background(
                                        Circle()
                                            .fill(Color.yellow)
                                    )
                                Text("Edit Email")
                                    .modifier(Poppins(fontWeight: AppFont.regular, .subheadline))
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline.bold())
                                
                            }
                            .foregroundColor(.black)
                        }
                        .navigationBarHidden(true)
                        
                        
                        
                        
                        
                        NavigationLink {
                            Text("change password")
                        } label: {
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.title.bold())
                                    .background(
                                        Circle()
                                            .fill(Color.gray)
                                    )
                                Text("Change Password")
                                    .modifier(Poppins(fontWeight: AppFont.regular, .subheadline))
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline.bold())
                                
                            }
                            .foregroundColor(.black)
                        }
                        
                        
                        
                        
                        
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.title.bold())
                                    .background(
                                        Circle()
                                            .fill(Color.orange)
                                    )
                                Text("Privacy Policy")
                                    .modifier(Poppins(fontWeight: AppFont.regular, .subheadline))
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline.bold())
                                
                            }
                            
                        }
                        .foregroundColor(.black)
                        
                        Button(action: {
                            self.signOut()
                        }) {
                            
                            PrimaryButton(color: Color.red.opacity(0.87), title: "Sign Out")
                            
                        }
                        
                        Text("")
                            .frame(height: 50)
                    }
                    //            .padding(.vertical)
                    .padding()
                }
         
                
           
                
                Spacer(minLength: 0)
            }
            .padding()
        }
//        .padding(.bottom, UIScreen.main.bounds.height / 8)
    }
    
    private func signOut() {
        // sign out logic
        AuthenticationService.instance.signOutCurrentUser { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("successfully signed out user")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
            SettingsView()
    }
}
