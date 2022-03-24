//
//  SettingsView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/2/22.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @AppStorage(CurrentUserDefaults.profilePicColor) var profilePicColorBackground: String = ""
    @AppStorage(CurrentUserDefaults.fName) var firstName: String = ""
    @AppStorage(CurrentUserDefaults.lName) var lastName: String = ""
    @AppStorage(CurrentUserDefaults.username) var username: String = ""
    @AppStorage(CurrentUserDefaults.email) var email: String?
    
    @State private var isShowingPhotoPicker: Bool = false
    @StateObject var profilePictureVM: ProfilePictureViewModel
    @State private var profilePic: UIImage = UIImage(named: "placeholder")!
    @State private var floatMessage: String = ""
    @State private var showingFloat: Bool = false
    @State private var floatColor: Color = Color.green
    
    
    
    @Binding var selectedTab: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .background(Color.white.opacity(0.3))
                    .modifier(Poppins(fontWeight: AppFont.semiBold, .subheadline))
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack(alignment: .bottomTrailing) {
                        
                        
                        
                        if profilePictureVM.isFinishedFetchingProfilePicture {
                            if profilePictureVM.profilePicture != nil {
                                Image(uiImage: profilePictureVM.profilePicture!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 125, height: 125)
                                    .clipShape(Circle())
                                    .font(.custom("Poppins-SemiBold", size: 20))
                                    .foregroundColor(.white)
                                    .padding(.trailing, 5)
                            } else {
                                Circle()
                                    .fill(Color(hexString: profilePicColorBackground) ?? Color(AppColors.purple))
                                    .frame(width: 125, height: 125)
                                    .overlay(Text(username.prefix(2)))
                                    .font(.custom("Poppins-SemiBold", size: 40))
                                    .foregroundColor(.white)
                                    .padding(.trailing, 5)
                                
                            }
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 125, height: 125)
                                .redacted(reason: profilePictureVM.isLoading ? .placeholder : [])
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        Button(action: {
                            
                            self.isShowingPhotoPicker = true
                            
                        }) {
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
                                .navigationBarHidden(true)
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
                            ChangeEmailView(floatMessage: $floatMessage, isShowingFloat: $showingFloat)
                                .navigationBarHidden(true)
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
                        
                        
                        
                        Button(action: {
                            
                            //
                            self.sendPasswordResetEmail { isSuccessful in
                                if isSuccessful {
                                    // success float
                                    self.floatMessage = "Successfully sent password reset to your email"
                                    self.floatColor = Color.green
                                    self.showingFloat = true
                                    
                                } else {
                                    // unsuccessful float
                                    self.floatMessage = "Error sending password reset to your email"
                                    self.floatColor = Color.red
                                    self.showingFloat = true
                                    
                                }
                            }
                            
                        }) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.title.bold())
                                    .background(
                                        Circle()
                                            .fill(Color.gray)
                                    )
                                Text("Edit Password")
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
        .present(isPresented: $showingFloat, type: .floater(), position: .top, animation: Animation.spring(), autohideDuration: 1.5, closeOnTap: true, closeOnTapOutside: true) {
            Floats.instance.createSuccessFloat(message: self.floatMessage, color: floatColor)
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(image: $profilePic)
                .onDisappear {
                    // makes sure user uploaded a picture (isn't the placeholder)
                    if !profilePic.isEqual(UIImage(named: "placeholder")) {
                        self.profilePictureVM.profilePicture = self.profilePic
                        self.profilePictureVM.updateUserProfilePicture(profilePic: self.profilePic)
                        
                    }
                }
            
        }
    }
    
    private func signOut() {
        // sign out logic
        withAnimation {
            AuthenticationService.instance.signOutCurrentUser { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("successfully signed out user")
                    self.selectedTab = tabs[0]
                    profilePictureVM.wipeData()
                }
            }
            
        }
    }
    
    private func sendPasswordResetEmail(handler: @escaping(_ isSuccessful: Bool) -> ()) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            Auth.auth().sendPasswordReset(withEmail: user.email ?? "") { error in
                if let error = error {
                    // error sending pass reset
                    print(error.localizedDescription)
                    handler(false)
                    return
                } else {
                    // success
                    handler(true)
                    return
                }
            }
        }
        
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//            SettingsView()
//    }
//}
