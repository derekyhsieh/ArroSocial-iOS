//
//  UsersViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/26/22.
//

import Foundation
import MapKit

class UsersViewModel: ObservableObject {
    @Published var usersArray: [UsersModel] = [UsersModel]()
    @Published var isFetching: Bool = false
    var userQuery: String
    
    init(userQuery: String) {
        self.userQuery = userQuery
        fetchUsersFromQuery()
//        checkIfUserAlreadyHasConvo(otherUserID: "dsf")
    }
    
    func fetchUsersFromQuery() {
        self.isFetching = true
        DataService.instance.searchForUser(searchQuery: userQuery.lowercased()) { returnedUsers in
            print("returned users: \(returnedUsers)")
            self.usersArray = returnedUsers
            self.isFetching = false
        }
    }
    
//    func checkIfUserAlreadyHasConvo(otherUserID: String) {
//        DataService.instance.checkIfUserIsAlreadyChatting(otherUserID: "GxHg4pPikUg24ucrOWpimKZbqzI3")
//    }
    
    
    func updateUsersFromQuery(userQuery: String) {
        self.userQuery = userQuery
        fetchUsersFromQuery()
    }
}
