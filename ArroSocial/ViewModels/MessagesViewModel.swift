//
//  MessagesViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/29/22.
//

import Foundation

class MessagesViewModel: ObservableObject {
    @Published var messagesArray: [MessageModel] = [MessageModel]()
    var convoID: String
    
    init(convoID: String) {
        self.convoID = convoID
    }
    
    
    func fetchMessages(handler: @escaping(_ finished: Bool) -> ()) {
        print("fetching messages")
        DataService.instance.downloadMessages(convoID: convoID) { messages in
            self.messagesArray = messages ?? []
            print("THESE ARE THE MESSAGES \(self.messagesArray)")        }
            handler(true)
    }
}
