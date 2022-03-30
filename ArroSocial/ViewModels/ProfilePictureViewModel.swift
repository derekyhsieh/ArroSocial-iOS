//
//  ProfilePictureViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/20/22.
//

import Foundation
import SwiftUI

class ProfilePictureViewModel: ObservableObject {
    
    @Published var isFinishedFetchingProfilePicture: Bool = false
    @Published var isLoading: Bool = true
    @Published var profilePicture: UIImage?
    @Published var hexColor: String?
    
    
    // user defaults
    var userID: String = "62lnkEVO6WZpXnlm1zAOybFOHfW2"
    
    init(userID: String) {
  
        self.userID = userID
        print(userID)
//        fetchData(userID: self.userID)
        
    }
    
    init() {
        
            self.userID =  UserDefaults.standard.string(forKey: CurrentUserDefaults.userID) ?? "62lnkEVO6WZpXnlm1zAOybFOHfW2"
        fetchData(userID: self.userID)
    }
    
    
    func fetchData(userID: String?) {
        if let userID = userID {
            ImageService.instance.downloadProfileImage(userID: userID) { image, hexColor in
                
                if let profileImage = image {
                    withAnimation {
                        self.profilePicture = profileImage
                        self.isFinishedFetchingProfilePicture = true
                        self.isLoading = false
                    }
                } else {
    //                self.profilePicture = UIImage(named: "placeholder")
                    withAnimation {
                        self.hexColor = hexColor
                        self.isFinishedFetchingProfilePicture = true
                        self.isLoading = false
                    }
                }
                
            }
        } else {
            ImageService.instance.downloadProfileImage(userID: self.userID) { image, hexColor in
                
                if let profileImage = image {
                    withAnimation {
                        self.profilePicture = profileImage
                        self.isFinishedFetchingProfilePicture = true
                        self.isLoading = false
                    }
                } else {
    //                self.profilePicture = UIImage(named: "placeholder")
                    withAnimation {
                        self.hexColor = hexColor
                        self.isFinishedFetchingProfilePicture = true
                        self.isLoading = false
                    }
                }
                
            }
        }
  
        
    }
    
    func getUsername(userID: String, handler: @escaping(_ username: String?)->()) {
        DataService.instance.getUserDocument(userID: userID) { doc in
            if let doc = doc {
                let username = doc.get(FSUserData.username) as? String
               handler(username)
                return
            } else {
                handler(nil)
                return
            }
        }
    }
    
    // used when user signs out
    func wipeData() {
        self.profilePicture = nil
        self.isFinishedFetchingProfilePicture = false
    }
    
    
    
    // used when user uploads new profile picture
    func updateUserProfilePicture(profilePic: UIImage) {
        ImageService.instance.uploadProfileImage(userID: userID, image: profilePic)
    }
}
