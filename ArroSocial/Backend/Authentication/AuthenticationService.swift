//
//  AuthenticationService.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/3/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let DB_BASE = Firestore.firestore()

// deals with log in, log out, create new user, delete user, check for existing username etc based functions
class AuthenticationService {
    
    // MARK: PROPERTIES
    
    static let instance = AuthenticationService()
    private var REF_USERS = DB_BASE.collection("users")
    
    
    // MARK: AUTH FUNCTIONS
    
    
    /// Creates a new user in Firebase Auth using email and password
    /// - Parameters:
    ///   - email: email of the user trying to create a new account
    ///   - password: password of user trying to create a new account
    ///   - handler: completion handler includes an error message in case of error during creation of user, and email and password
    func createNewUser(email: String, password: String, handler: @escaping(_ errorMessage: String?,_ email: String) -> ()) {
        // cut off excess whitespace
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: cleanedEmail, password: password) { authResult, error in
            print(authResult as Any)
            if let error = error {
                // error occured returning error message with completition handler
                handler(error.localizedDescription, cleanedEmail)
                return
            } else {
                // everything went successfully
                handler(nil, cleanedEmail)
                return
            }
        }
    }
    
    /// delete user accounts from Firebase Auth and Firestore database if they have existing data
    /// - Parameters:
    ///   - hasUserCompletedOnboarding: if is current user has completed onboarding inputing username, name, and profile picture yet
    ///   - userHasData: if user has existing data in the form of posts in firestore databse
    ///   - handler: returns an optional error  if deleting has issues
    func deleteUser(hasUserCompletedOnboarding: Bool, userHasData: Bool, handler: @escaping(_ error: Error?) -> ()) {
        
        // only use this if deleting user before they create an account in onboarding
        if(!hasUserCompletedOnboarding) {
            
            let currentUser = Auth.auth().currentUser
            
            currentUser?.delete(completion: { error in
                // check for errors
                if let error = error {
                    // error occured
                   handler(error)
                } else {
                    // success
                    handler(nil)
                }
            })
            
            // TODO: still need to implement deleting user when they have existing data
        }
        
        
    }
    
    
    
    
}
