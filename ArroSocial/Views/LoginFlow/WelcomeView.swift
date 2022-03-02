//
//  WelcomeView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct WelcomeView: View {
    @State var showNewUserWalkthrough: Bool = false
    @Binding var isShowingWelcome: Bool
    var body: some View {
        if showNewUserWalkthrough {
            GeometryReader { proxy in
                NewUserHomeView(isShowingNewUserWalkthrough: $showNewUserWalkthrough, isShowingWelcome: $isShowingWelcome, screenSize: proxy.size)

            }
                .transition(.move(edge: .trailing))
        } else {
            NavigationView {
                ZStack {
                    Color(AppColors.bg).edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        
                        Text("The Platform Made for the People")
                            .modifier(Poppins(fontWeight: AppFont.semiBold, .title2))
                            .multilineTextAlignment(.center)

                            Image("arro-logo")
                            .background(Color(AppColors.purple))
                            .cornerRadius(50)
                            .padding()
                        Spacer()
                        
                        NavigationLink {
                            LoginView()
                                .environment(\.colorScheme, .light)
                                .navigationBarHidden(true)
                                
                        } label: {
                            PrimaryButton(title: "Log In")
                        }
                        .navigationBarHidden(true)

                       
                  
                        
                        NavigationLink(
                            destination: SignUpView( showNewUserWalkthrough: $showNewUserWalkthrough)
                                .environment(\.colorScheme, .light)
                                .navigationBarHidden(true),
                            
                            label: {
                                Text("Sign Up")
                                    .modifier(Poppins(fontWeight: AppFont.medium, .subheadline))
                                    .foregroundColor(Color(AppColors.purple))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(50.0)
                                    .shadow(color: Color.black.opacity(0.1), radius: 60, x: 0.0, y: 16)
                                    .padding(.vertical)
                            })
                            .navigationBarHidden(true)
                        
                        Button(action: {
                            // open arro social website
                            guard let url = URL(string: "https://arro.io") else { return }
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Text("New around here? ")
                                    .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                                    .foregroundColor(Color.black)
                                Text("More about Arro Social")
                                    .foregroundColor(Color(AppColors.purple))
                                    .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                            }
                        }
                     
                    }
                    .padding()
                    .padding(.bottom)
                }
            }
        }

    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}


