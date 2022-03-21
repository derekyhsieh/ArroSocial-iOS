//
//  DataService.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/17/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import SwiftUI

class DataService {
    static let instance = DataService()
    
    
    private var REF_POSTS = DB_BASE.collection(FSCollections.posts)
    private var REF_USERS = DB_BASE.collection(FSCollections.users)
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    // MARK: CREATE FUNCTION
    
    /// Uploads post data to Firestore database "posts" collection and image data to Firebase storage
    /// - Parameters:
    ///   - image: image of post that will be uploaded to firebase storage
    ///   - caption: caption of post that will be uploaded to firestore databse
    ///   - userName: username of user who posted the post
    ///   - userID: userID of user who posted the post
    ///   - handler: returns a success boolean and optional postID of uploaded post if successful
    func uploadPost(image: UIImage, caption: String?, userName: String, userID: String, handler: @escaping(_ success: Bool,_ postID: String?) -> ()) {
        // create doc
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        ImageService.instance.uploadPostImage(postID: postID, image: image, imageCount: 0) { isSuccessful in
            if isSuccessful {
                // successfully uploaded image data to storage
                // post data to db
                
                self.uploadPostIDToFirestoreUser(postID: postID, userID: userID) { success in
                }
                
                var postData: [String: Any] = [
                    FSPostFields.postID: postID,
                    FSPostFields.userID: userID,
                    FSPostFields.userName: userName,
                    FSPostFields.dateCreated: FieldValue.serverTimestamp()
                ]
                
                if let caption = caption {
                    postData[FSPostFields.caption] = caption
                }
                
                document.setData(postData) { error in
                    if let error = error {
                        print("error uploading data to post doc. \(error) (DataService.uploadPost())")
                        // error
                        handler(false, postID)
                        return
                    } else {
                        // all successful
                        handler(true, postID)
                        return
                    }
                }
                
            } else {
                print("Errior uploading post image to firebase (DataService.uploadPost())")
                handler(false, postID)
                return
            }
        }
    }
    
    /// initially used to download a limited number of posts displayed in the feed
    /// - Parameter handler: returns an array of PostModel of returned posts
    func downloadPostsForFeed(handler: @escaping(_ posts: [PostModel]) ->()) {
        // download 25 posts
        REF_POSTS.order(by: FSPostFields.dateCreated, descending: true).limit(to: 20).getDocuments { querySnapshot, error in
            handler(self.getPostsFromQuerySnapshot(querySnapshot: querySnapshot))
        }
    }
    
    /// Fetches user profile background color in hex code when user hasn't uploaded profile picture
    /// - Parameters:
    ///   - userID: userID of desired user data
    ///   - handler: returns an optional hex color string of the background color
    func getUserProfileBackgroundColor(userID: String, handler: @escaping(_ hexColor: String?) -> ()) {
        let userDocRef = REF_USERS.document(userID)
        
        userDocRef.getDocument( ) { doc, error in
            if let document = doc {
                let hexColorField = document.get(FSUserData.generatedProfilePictureBackgroundColorInHex) as? String
                handler(hexColorField)
                return
            } else {
                print(error!.localizedDescription)
                print("document doesnt exist (DataService.getUserProfileBackgroudnColor())")
                handler(nil)
                return
            }
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    /// Decodes posts from query snapshot into a PostModel array
    /// - Parameter querySnapshot: Firebase QuerySnapshot of post data
    /// - Returns: array of type PostModel
    private func getPostsFromQuerySnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] {
        var postArray = [PostModel]()
        
        if let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 {
            for document in querySnapshot.documents {
                if
                    let userID = document.get(FSPostFields.userID) as? String,
                    let timestamp = document.get(FSPostFields.dateCreated) as? Timestamp,
                    let username = document.get(FSPostFields.userName) as? String {
                    
                    let caption = document.get(FSPostFields.caption) as? String
                    let date = timestamp.dateValue()
                    let likeCount = document.get(FSPostFields.likeCount) as? Int ?? 0
                    let postID = document.documentID
                    
                    var likedByUser: Bool = false
                    if let userIDArray = document.get(FSPostFields.likedBy) as? [String], let userID = self.currentUserID {
                        // if current user id is in array user liked it
                        likedByUser = userIDArray.contains(userID)
                    }
                    
                    let newPost = PostModel(postID: postID, userID: userID, username: username, caption: caption, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
                    postArray.append(newPost)
                }
            }
            return postArray
        } else {
            print("no documents in snapshot found")
            return postArray
        }
    }
    
    /// Uploads the post ID of new post to user data array (may be deprecated in the future and instead use firestore queries for post filtering)
    /// - Parameters:
    ///   - postID: postID of specific post
    ///   - userID: userID of user who posted
    ///   - handler: returns a success boolean 
    private func uploadPostIDToFirestoreUser(postID: String, userID: String, handler: @escaping(_ success: Bool) -> ()) {
        
        let userRef = REF_USERS.document(userID)
        
        // update user posts array
        
        // remove array with "arrayRemove"
        userRef.updateData([
            FSUserData.userPosts: FirebaseFirestore.FieldValue.arrayUnion([postID])
        ]) { error in
            if let error = error {
                print("error uploading post id to firestore db users: \(error) (DataService.uploadPostIDToFirestoreUser())")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
}
