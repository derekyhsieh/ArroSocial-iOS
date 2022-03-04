//
//  AuthenticationService.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/3/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

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
                    return
                } else {
                    // success
                    handler(nil)
                    return
                }
            })
            
            // TODO: still need to implement deleting user when they have existing data
        }
    }
    
    
    /// Updates user account information in Firestore database
    /// - Parameters:
    ///   - profilePicture: user's profile picture
    ///   - username: username
    ///   - firstName: user's first name
    ///   - lastName: user's last name
    ///   - handler: returns optional error and userID
    ///   - profilePictureBackgroundColor: if user uses generated profile picture, saves background color of user selected color
    func updateUserInfo(profilePicture: Image?, username: String?, firstName: String?, lastName: String?, profilePictureBackgroundColor: String?, handler: @escaping(_ isError: Bool,  _ userID: String?) -> ()) {
        
        
        self.getCurrentUserID { errorMessage, userID in
            if(errorMessage != nil) {
                // error here getting user id
                print(errorMessage!)
                handler(true , nil)
                return
            } else {
                // no error getting user id
                let currentUserID = userID
                
                // writing data to firebase in the users collection
                
                // MARK: CASE 1: new user who needs to append username, first name, last name (onboarding new user case)
                if([profilePicture].allNil() == true) {
                    
                    // include color
                    let data: [String: Any] = [
                        FSUserData.username: username as Any,
                        FSUserData.fName:  firstName as Any,
                        FSUserData.lName: lastName as Any,
                        FSUserData.generatedProfilePictureBackgroundColorInHex: profilePictureBackgroundColor as Any
                    ]

                    
                    // can unwrap current user id with a bang since we checked before if user id was present
                    DB_BASE.collection(FSCollections.users).document(currentUserID!).setData(data) { error in
                        if let error = error {
                            // error returning
                            print(error)
                            handler(true, currentUserID)
                            return
                        } else {
                            // successfully written user data to db
                            handler(false, currentUserID)
                            return
                        }
                    }
                }
                
                // TODO: OTHER CASES
                
                
            }
        }
        
    }
    
    
    /// Signs in user using email and string with Firebase Authentication
    /// - Parameters:
    ///   - email: email linked to user's account
    ///   - password: password linked to user's account
    ///   - handler: returns an optional error message as a completion handler
    func signInUser(email: String, password: String, handler: @escaping(_ errorMessage: String?) -> ()) {
        //  
    }
    
    
    /// returns current logged in user's unique identifier
    /// - Parameter handler: returns optional error message and userID in callback
    private func getCurrentUserID(handler: @escaping(_ errorMessage: String?, _ userID: String?) -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else {
            // error
            handler("error getting current user ID [AUTH SERVICE]", nil)
            return
        }
        // no errors returned uid successfully
        handler(nil, userID)
        return
        
    }
    
    
    
    
}


