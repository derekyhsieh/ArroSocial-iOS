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
    var body: some View {
        
        if currentUserID == nil {

            WelcomeView(isShowingWelcome: $isShowingWelcome)
                .environment(\.colorScheme, .light)
                .transition(.move(edge: .leading))
        } else {

            AppWrapperView()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeInOut)
        }
  
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
