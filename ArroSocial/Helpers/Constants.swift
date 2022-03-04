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
}

// Firestore user data constants
struct FSUserData {
    static let username = "username"
    static let fName = "first_name"
    static let lName = "last_name"
    static let profilePicture = "profile_picture"
    static let generatedProfilePictureBackgroundColorInHex = "generated_profile_picture_background_in_hex"
}
