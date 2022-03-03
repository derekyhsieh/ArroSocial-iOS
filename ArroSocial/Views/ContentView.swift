//
//  ContentView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingWelcome: Bool = false
    var body: some View {
        
        if isShowingWelcome {
            
            WelcomeView(isShowingWelcome: $isShowingWelcome)
                .environment(\.colorScheme, .light)
        } else {
            
            AppWrapperView()
        }
  
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
