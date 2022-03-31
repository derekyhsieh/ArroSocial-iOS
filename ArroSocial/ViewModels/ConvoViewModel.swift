//
//  ConvoViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/26/22.
//

import Foundation
import SwiftUI

class ConvoViewModel: ObservableObject {
    @Published var convosArray: [ConvoModel] = [ConvoModel]()
    @Published var alreadyChattingUserIDs: [String] = [String]()
    @Published var isFetching = false
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String = ""
   
    init() {
       fetchCurrentUserConversations()
    }
    
    func fetchCurrentUserConversations() {
        self.isFetching = true
       // get current from dataservice
        
        
        // make a blacklisted array for other user id's that aren't the user's
        DataService.instance.downloadConvosForUser(userID: currentUserID) { convos in
            
            // blacklist users array
            for convo in convos {
                self.alreadyChattingUserIDs.append(self.returnOtherParticipantID(convo: convo))
            }
            print(self.alreadyChattingUserIDs)
            self.convosArray = self.sortByDate(convos: convos)
            
            
//            self.convosArray.append(contentsOf: testdata)
//             test case
            
            self.isFetching = false
        }
    }
    
    func uploadNewConvo(userID: String, handler: @escaping(_ success: Bool?)-> ()) {
        DataService.instance.createConversation(otherUserID: userID) { convoID, success in
            if let convoID = convoID {
                let newConvo = ConvoModel(convoID: convoID, participantsID: [userID, self.currentUserID], lastMessageDate: Date(), lastMessage: nil, messages: [],
                                          lastMessageWasCurrentUser: nil)
                self.convosArray.insert(newConvo, at: 0)
            }
            
           
           handler(success)
            return
        }
    }
    
    func sortByDate(convos: [ConvoModel]) -> [ConvoModel] {
        let sortedConvos = convos.sorted {
            $0.lastMessageDate! > $1.lastMessageDate!
        }
        return sortedConvos
    }
    
    private func returnOtherParticipantID(convo: ConvoModel) -> String {
        for participant in convo.participantsID {
            if participant != (currentUserID) { return participant }
        }
        
        return ""
    }
    
}

let testdata: [ConvoModel] = [
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),
ConvoModel(convoID: "convo", participantsID: ["62lnkEVO6WZpXnlm1zAOybFOHfW2"], messages: []),


]
