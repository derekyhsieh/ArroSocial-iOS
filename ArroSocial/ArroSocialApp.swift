//
//  ArroSocialApp.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import SwiftUI
import Firebase

// add this if we need firebase cloud messsaging and other firebase services later

    /*
     class AppDelegate: NSObject, UIApplicationDelegate {
       func application(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
         FirebaseApp.configure()
         return true
       }
     }
    */

@main
struct ArroSocialApp: App {
    
    init() {
        // connect app to firebase
        FirebaseApp.configure()
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
