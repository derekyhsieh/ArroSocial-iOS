//
//  Constants.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import Foundation

struct AppFont {
    static let medium = "Medium"
    static let regular = "Regular"
    static let semiBold = "SemiBold"
    static let lobster = "Lobster-Regular"
}

struct AppPages {
    static let home = "house"
    static let messages = "message"
    static let search = "magnifyingglass"
    static let settings = "gear"
}

struct AppColors {
    static let background = "background"
    static let bg = "BgColor"
    static let secondary = "secondary"
    static let purple = "purple"
    static let blue = "blue"
    static let lightBlue = "lightBlue"
}

// Firestore Collection constants
struct FSCollections {
    static let users = "users"
    static let posts = "posts"
}

// Firestore user data constants
struct FSUserData {
    static let username = "username"
    static let fName = "first_name"
    static let lName = "last_name"
    static let profilePicture = "profile_picture"
    static let generatedProfilePictureBackgroundColorInHex = "generated_profile_picture_background_in_hex"

}

// Firestore post fields
struct FSPostFields {
    static let postID = "post_id"
    static let userID = "user_id"
    static let userName = "user_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
}


// User Defaults constants
struct CurrentUserDefaults {
    static let userID = "userID"
    static let username = "username"
    static let profilePicColor = "profilePictureColor"
    static let fName = "firstName"
    static let lName = "lastName"
    static let profilePicture = "importedProfilePicture"
}
