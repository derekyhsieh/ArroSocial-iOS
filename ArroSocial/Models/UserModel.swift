//
//  UserModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/26/22.
//

import Foundation

struct UsersModel: Identifiable {
    var id = UUID()
    var userID: String
    var username: String
    var firstName: String
    var lastName: String
    var followerCount: Int
    var followers: [String]
}
