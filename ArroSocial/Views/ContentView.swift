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
    var body: some View {
        
//        UploadView()
        
        if currentUserID == nil {

            WelcomeView(isShowingWelcome: $isShowingWelcome)
                .environment(\.colorScheme, .light)
                .transition(.move(edge: .leading))
        } else {
            
            ZStack {
                
            
                
                AppWrapperView()
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
