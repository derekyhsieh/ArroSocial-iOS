//
//  FullScreenPostModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/23/22.
//

import Foundation
import UIKit

struct FullScreenPostModel {
    var postID: String
    var userID: String // ID for the user in Database
    var username: String // Username of user in Database
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool
    var postImage: UIImage
    var profileImage: UIImage
    var profilePictureColor: String
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
}
