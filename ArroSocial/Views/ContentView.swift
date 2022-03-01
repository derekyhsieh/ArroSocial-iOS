//
//  ContentView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
//                        AppWrapperView()
//            .environment(\.colorScheme, .dark)
//
        
        WelcomeView()
            .environment(\.colorScheme, .light)
        
//        GeometryReader { proxy in
//            let size = proxy.size
//
//            NewUserHomeView(screenSize: size)
//        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
