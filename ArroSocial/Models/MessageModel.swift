//
//  Message.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import Foundation

struct MessageModel: Identifiable, Codable, Hashable {
    var id = UUID()
    var messageID: String
    var text: String
    var received: Bool // if user is receiver, false, if user is recipient then true
    var timestamp: Date
}
