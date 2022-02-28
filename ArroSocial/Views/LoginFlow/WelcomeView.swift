//
//  WelcomeView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/27/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
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
                            .environment(\.colorScheme, .dark)
                            .navigationBarHidden(true)
                            
                    } label: {
                        PrimaryButton(title: "Log In")
                    }
                    .navigationBarHidden(true)

                   
              
                    
                    NavigationLink(
                        destination: SignUpView()
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
                    
                    HStack {
                        Text("New around here? ")
                            .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                        Text("More about Arro Social")
                            .foregroundColor(Color(AppColors.purple))
                            .modifier(Poppins(fontWeight: AppFont.regular, .caption2))
                    }
                }
                .padding()
                .padding(.bottom)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


