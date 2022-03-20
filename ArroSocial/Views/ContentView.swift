//
//  ContentView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingWelcome: Bool = true
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @State private var animate = false
    @State private var endSplash = false
    @StateObject var profilePicVM: ProfilePictureViewModel = ProfilePictureViewModel()
    
    init() {
        // hidden since tab bar will be custom
        UITabBar.appearance().isHidden = true
        
    }
    
    
    var body: some View {
        
//        UploadView()
        
        if currentUserID == nil {

            WelcomeView(isShowingWelcome: $isShowingWelcome)
                .environment(\.colorScheme, .light)
                .transition(.move(edge: .leading))
                .onDisappear {
                    profilePicVM.fetchData()
                }
        } else {
            
            ZStack {
                
            
                
                AppWrapperView(profilePicVM: profilePicVM)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                
                SplashScreen()
            
                
            }

           
        }

    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
