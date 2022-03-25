//
//  CommentModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import Foundation

struct CommentModel: Hashable, Identifiable {
    var id = UUID()
    var commentID: String
    var postID: String
    var username: String
    var content: String
    var userID: String
    var dateCreated: Date
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
