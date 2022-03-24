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
    
    // user defaults
    var userID: String
    
    init(userID: String) {
  
        self.userID = userID
        fetchData()
    }
    
    init() {
        
            self.userID =  UserDefaults.standard.string(forKey: CurrentUserDefaults.userID) ?? ""
    }
    
    
    func fetchData() {
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
                    self.isFinishedFetchingProfilePicture = true
                    self.isLoading = false
                }
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
