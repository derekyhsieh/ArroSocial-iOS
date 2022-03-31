//
//  ConvoModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/26/22.
//

import Foundation
struct ConvoModel: Identifiable, Codable, Equatable, Hashable {
    static func == (lhs: ConvoModel, rhs: ConvoModel) -> Bool {
        if(lhs.convoID == rhs.convoID) {
            return true
        } else {
            return false
        }
    }
    
    
    var id = UUID()
    var convoID: String
    var participantsID: [String]
    var lastMessageDate: Date?
    var lastMessage: String?
    var messages: [MessageModel]
    var lastMessageWasCurrentUser: Bool?
    
    // for filtering by username
    var isFiltered: Bool = true // false if should not show
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
