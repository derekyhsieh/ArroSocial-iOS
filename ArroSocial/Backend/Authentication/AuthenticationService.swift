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
        
        
        self.getCurrentUserID { errorMessage, userID in if(errorMessage != nil) { // error here getting user id print(errorMessage!)
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
                            // sign them in and set user defaults so app brings them to home view
                            
                            self.setCurrentUserDefaultsWhenSignedIn { isSuccessful in
                                if isSuccessful {
                                    print("succesfully set all user data in user defaults")
                                } else {
                                    handler(true, currentUserID)
                                    return
                                }
                            }
                            handler(false, currentUserID)
                            return
                        }
                    }
                }
                
                // TODO: OTHER CASES
                
                
            }
        }
        
    }
    
    
    // TODO: write documentation for this function later
    func getUserInfo(userID: String, handler: @escaping(_ error: Error?, _ userID: String?, _ username: String?, _ firstName: String?, _ lastName: String?, _ profilePictureBackgroundColor: String?, _ profilePicture: Image?) -> ()) {
        // reference for document
        let documentRef = DB_BASE.collection(FSCollections.users).document(userID)
        
        documentRef.getDocument { document, error in
            // check if document with user id exists
            
            if let error = error {
                print("error: \(error): [AuthService.getUserInfo()]")
                handler(error, nil, nil, nil, nil, nil, nil)
                return
            }
            if let document = document, document.exists {
                
                let userID = document.documentID
                let username = document.get(FSUserData.username) as! String
                let firstName = document.get(FSUserData.fName) as! String
                let lastName = document.get(FSUserData.lName) as! String
                let profilePictureBackgroundColor = document.get(FSUserData.generatedProfilePictureBackgroundColorInHex) as! String
                
                // TODO: LATER CHECK IF UPLOADED PROFILE PICTURE EXISTS
                
                handler(nil, userID, username, firstName, lastName, profilePictureBackgroundColor, nil)
                return
            }
              
        }
        
        
     }
    
    
    /// Signs in user using email and string with Firebase Authentication
    /// - Parameters:
    ///   - email: email linked to user's account
    ///   - password: password linked to user's account
    ///   - handler: returns an optional error message as a completion handler
    func signInUser(email: String, password: String, handler: @escaping(_ error: Error?) -> ()) {
        let cleanedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: cleanedEmail, password: password) { authDataResult, error in
            if let error = error {
                print("error in AuthenticationService.signInUser()")
                handler(error)
                return
            }
            print("successfully signed in to user")
            self.setCurrentUserDefaultsWhenSignedIn { isSuccessful in
                if isSuccessful {
                    print("succesfully set all user data in user defaults")
                } else {
                    handler(CustomError.userDefaultsNotSet)
                    return
                }
            }
            
            handler(nil)
            return
        }
    }
    
    
    ///  Checks whether username exists in Firestore user collection "username" field (if someone already has that same username)
    /// - Parameters:
    ///   - username: check for this username
    ///   - handler: completition handler returns an error from database and boolean that tells if username exists in database
    func checkIfUsernameExistsInDatabase(username: String, handler: @escaping(_ error: Error?, _ usernameExists: Bool) -> ()) {
        
        // sanitizing username
        let cleanedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let DB_REF = DB_BASE.collection(FSCollections.users).whereField(FSUserData.username, isEqualTo: cleanedUsername).limit(to: 1)
        DB_REF.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                // error fetching
                handler(error, false)
                return
            }
            
            if let documents = querySnapshot?.documents{
                if(documents.isEmpty) {
                    // didnt find anything
                    handler(nil, false)
                    return
                } else {
                    // did find user with that username
                    handler(nil, true)
                    return
                }
            }
        }
        
    }
    
    func signOutCurrentUser(handler: @escaping(_ error: Error?) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error signing out: \(error) [AuthSerivce.signOutCurrentUser()]")
            handler(error)
            return
        }
        
        // wipe all user defaults stored
        self.resetAllUserDefaults()
        handler(nil)
    }
    
    ///  persists user data for basic user data (username, first name, last name, and profile picture background color if they did not upload their own) when user signs in to app
    /// - Parameter handler: completition handler that returns a boolean whether the operation was succesfull
    private func setCurrentUserDefaultsWhenSignedIn(handler: @escaping(_ isSuccessful: Bool) -> ()) {
        self.getCurrentUserID { errorMessage, userID in
            // after getting user id
            if let errorMessage = errorMessage {
                // no user id
                print(errorMessage)
                handler(false)
                return
            } else {
                self.getUserInfo(userID: userID!) { error, userID, username, firstName, lastName, profilePictureBackgroundColor, profilePicture in
                    if let error = error {
                        // error
                        print(error.localizedDescription)
                        handler(false)
                           return
                    }
                    // no error set user defaults
                    withAnimation {
                        UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                        UserDefaults.standard.set(username, forKey: CurrentUserDefaults.username)
                        UserDefaults.standard.set(firstName, forKey: CurrentUserDefaults.fName)
                        UserDefaults.standard.set(lastName, forKey: CurrentUserDefaults.lName)
                        UserDefaults.standard.set(profilePictureBackgroundColor, forKey: CurrentUserDefaults.profilePicColor)
                        if let profilePicture = profilePicture {
                            UserDefaults.standard.set(profilePicture, forKey: CurrentUserDefaults.profilePicture)
                        }
                    }
                   
                    
                }
            }
        }
    }
    
    
    
    // MARK: PRIVATE VARIABLES
    
    
    /// Removes and resets all user defaults stored
    private func resetAllUserDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    /// returns current logged in user's unique identifier
    /// - Parameter handler: returns optional error message and userID in callback
    private func getCurrentUserID(handler: @escaping(_ errorMessage: String?, _ userID: String?) -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else {
            // error
            handler("error getting current user ID [AuthService.getCurrentUserID()]", nil)
            return
        }
        // no errors returned uid successfully
        handler(nil, userID)
        return
        
    }
    
    
    
    
}


// MARK: Command to put in Firebase console to delete all users created - saves 2 clicks and automates
/*
 setInterval(() => {
 document.getElementsByClassName('edit-account-button mat-focus-indicator mat-menu-trigger mat-icon-button mat-button-base')[0].click()
 let deleteButtonPosition = document.getElementsByClassName('mat-focus-indicator mat-menu-item ng-star-inserted').length - 1
 document.getElementsByClassName('mat-focus-indicator mat-menu-item ng-star-inserted')[deleteButtonPosition].click()
 document.getElementsByClassName('confirm-button mat-focus-indicator mat-raised-button mat-button-base mat-warn')[0].click()
 }, 1000)
 */
