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
    @Published var profilePicture: UIImage?
    
    // user defaults
    @AppStorage(CurrentUserDefaults.userID) var userID = ""
    
    func fetchData() {
        ImageService.instance.downloadProfileImage(userID: userID) { image in
            if let profileImage = image {
                self.profilePicture = profileImage
                self.isFinishedFetchingProfilePicture = true
            } else {
                self.isFinishedFetchingProfilePicture = true
            }
        }
        
    }
    
    // used when user signs out
    func wipeData() {
        self.profilePicture = nil
        self.isFinishedFetchingProfilePicture = false
    }
}
