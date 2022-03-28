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
    private var REF_COMMENTS = DB_BASE.collection(FSCollections.comments)
    private var REF_CONVERSATIONS = DB_BASE.collection(FSCollections.conversations)
    
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
                print("Error uploading post image to firebase (DataService.uploadPost())")
                handler(false, postID)
                return
            }
        }
    }
    
    
    
    func createConversation(otherUserID: String, handler: @escaping(_ convoID: String?, _ success: Bool) -> ()) {
        let conversationDoc = REF_CONVERSATIONS.document()
        let convoID = conversationDoc.documentID
        
        let data: [String: Any] = [
            FSConvoFields.participants: FieldValue.arrayUnion([currentUserID!, otherUserID]),
            FSConvoFields.lastTimestamp: FieldValue.serverTimestamp()
        ]
        
        conversationDoc.setData(data) { error in
            if let error = error {
                print("\(error.localizedDescription): createConversation()")
                handler(nil, false)
            } else {
                handler(convoID, true)
            }
        }
    }
    
    func uploadMessage(conversationID: String?, otherUserID: String,  messageText: String, handler: @escaping(_ messageID: String?, _ conversationID: String?) -> ()) {
        if let conversationID = conversationID {
            // not first message since conversation document has already been created, so no need for creating participants field
            let messageDoc = REF_CONVERSATIONS.document(conversationID).collection(FSCollections.messages).document()
            let messageID = messageDoc.documentID
            
            let messageData: [String: Any] = [
                FSMessageFields.userID :(currentUserID!), 
                FSMessageFields.text: messageText,
                FSMessageFields.dateCreated: FieldValue.serverTimestamp()
            ]
            
            messageDoc.setData(messageData) { error in
                if let error = error {
                    // error uploading message
                    print("\(error.localizedDescription) - uploadMessage()")
                    handler(nil, nil)
                    return
                } else {
                    // success
                    handler(messageID, nil)
                    return
                }
            }
        } else {
            // case where conversation hasn't been created yet
            // 1: create document in conversation collection with convo id
            // 2: set participants to current user and other user id
            // 3: recursion this function to upload again
            
            let conversationDoc = REF_CONVERSATIONS.document()
            let convoID = conversationDoc.documentID
            
            let participantData: [String: Any] = [
                "participants": FieldValue.arrayUnion([currentUserID!, otherUserID])
            ]
            conversationDoc.setData(participantData) { error in
                if let error = error {
                    print("\(error.localizedDescription) uploadMessage(in creating new donverstaaion document)")
                    handler(nil, convoID)
                } else {
                    // success
                    print("successfully init new conversation document with new participants")
                    // recursion
                    self.uploadMessage(conversationID: convoID, otherUserID: otherUserID, messageText: messageText) { messageID, conversationID in
                        handler(messageID, conversationID)
                    }
                }
            }
            
            
        }
    }
    
    
    func uploadComment(postID: String, username: String, content: String, userID: String, handler: @escaping(_ isSuccessful: Bool, _ postID: String) -> ()) {
        let document = REF_COMMENTS.document()
        let commentID = document.documentID
        
        let commentData: [String: Any] = [
            FSCommentFields.postID: postID,
            FSCommentFields.userID: userID,
            FSCommentFields.username: username,
            FSCommentFields.content: content,
            FSCommentFields.dateCreated: FieldValue.serverTimestamp()
        ]
        
        document.setData(commentData) { error in
            print("finished DDD")
            if let error = error {
                // error setting comment data
                print("\(error.localizedDescription): UPLOAD COMMENT")
                handler(false, commentID)
                return
            } else {
               handler(true, commentID)
            return
            }
        }
    }
    
    func getDocumentReference(collection: String, documentID: String) -> DocumentReference {
        return DB_BASE.collection(collection).document(documentID)
    }
    
    func deleteDocument(docReference: DocumentReference, handler: @escaping(_ success: Bool) -> ()) {
        docReference.delete { err in
            if let err = err {
                print("error revmoing document: \(err)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
    }

    }
    
    
    /// downlaods limited number of posts to populate feed view
    /// - Parameters:
    ///   - userID: userID to filter out posts that are the user's
    ///   - handler: returns a PostModel array of posts
    func downloadPostsForFeed(userID: String, handler: @escaping(_ posts: [PostModel]) ->()) {
        // download 20 posts
            // can't use order by timestamp since firebase doesn't support multiple query fields at this moment
            REF_POSTS.whereField(FSPostFields.userID, isNotEqualTo: userID).limit(to: 20).getDocuments { querySnapshot, error in
                let posts = self.getPostsFromQuerySnapshot(querySnapshot: querySnapshot)
                // sort posts
                
                handler(self.sortPostsByDate(posts: posts))
        }
        
    }
    
    func downloadConvosForUser(userID: String, handler: @escaping(_ convos: [ConvoModel]) -> ()) {
        REF_CONVERSATIONS.whereField(FSConvoFields.participants, arrayContains: userID).getDocuments { querySnap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            let convos = self.getConvoFromSnapshot(snapshot: querySnap)
            
            handler(convos)
        }
    }
    
    
    /// Downloads posts from database that were posted by the user
    /// - Parameters:
    ///   - userID: userID of the user to get posts from
    ///   - handler: returns an array of PostModel of the user's posts
    func downloadPostsForProfile(userID: String, shouldGetTotalLikeCount: Bool?, handler: @escaping(_ posts: [PostModel], _ totalLikes: Int?) -> ()) {
        REF_POSTS.whereField(FSPostFields.userID, isEqualTo: userID).getDocuments { querySnapshot, error in
            
            let posts = self.getPostsFromQuerySnapshot(querySnapshot: querySnapshot)
            
   
            
            if(shouldGetTotalLikeCount ?? false) {
                var totalLikes: Int = 0
                for post in posts {
                    totalLikes += post.likeCount
                }
                handler(posts, totalLikes)
            } else {
                handler(posts, nil)
                return
            }
            
        }
    }
    
    func downloadCommentForPost(postID: String, handler: @escaping(_ commentArray: [CommentModel])->()) {
        REF_COMMENTS.whereField(FSCommentFields.postID, isEqualTo: postID).getDocuments { querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription): download comment for post")
            } else {
                let comments = self.getCommentsFromQuerySnapshot(querySnapshot: querySnapshot)
                handler(comments)
                return
            }
        }
    }
    
    // MARK: Search functions
    
//    func searchForUserWhoHasntHadConvo(searchQuery: String, handler: @escaping(_ returnedUsers: [UsersModel]) -> ()) {
//        searchForUser(searchQuery: searchQuery) { returnedUsers in
//
//        }
//    }
    
    
   
    
    func searchForUser(searchQuery: String, handler: @escaping(_ returnedUsers: [UsersModel]) -> ()) {
        REF_USERS.whereField(FSUserData.username, isGreaterThanOrEqualTo: searchQuery).whereField(FSUserData.username, isLessThanOrEqualTo: searchQuery + "z").limit(to: 10).getDocuments { querySnap, error in
            
            handler(self.getUsersFromQuerySnapshot(querySnapshot: querySnap))
            return
        }
        
    }
    
    
    // MARK: GET FUNCTIONS
    
    
    
    
    func getIfCurrentUserIsFollowingAndCount(currentUserID: String, targetUserID: String, handler: @escaping(_ isFollowing: Bool, _ followerCount: Int) -> ()) {
        getUserDocument(userID: targetUserID, handler: { doc in
            if let doc = doc {
                var followedByUser: Bool = false
                if let followerIDArray = doc.get(FSUserData.followers) as? [String], let userID = self.currentUserID {
                    // if current user id is in array user follows
                    followedByUser = followerIDArray.contains(userID)
                }
                
                let followerCount = doc.get(FSUserData.followerCount) as? Int
                
                handler(followedByUser, followerCount ?? 0)
                return
                
            }
        })
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
    
    
    func getUserDocument(userID: String, handler: @escaping(_ doc: DocumentSnapshot?)->()) {
        let userDocRef = REF_USERS.document(userID)
        
   
        userDocRef.getDocument { doc, error in
            if let doc = doc {
              handler(doc)
                return
            } else {
                print("error getting user document")
                
                handler(nil)
                return
            }
        }
    }
    
    
    // MARK: PRIVATE FUNCTIONS
    
    private func getCommentsFromQuerySnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        
        if let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 {
            for document in querySnapshot.documents {
                
                if let postID = document.get(FSCommentFields.postID) as? String,
                   let userID = document.get(FSCommentFields.userID) as? String,
                    let timestamp = document.get(FSPostFields.dateCreated) as? Timestamp,
                    let username = document.get(FSCommentFields.username) as? String {
                    let content = document.get(FSCommentFields.content) as? String
                    let date = timestamp.dateValue()
                   let commentID = document.documentID
                    let newComment = CommentModel(commentID: commentID, postID: postID, username: username, content: content ?? "", userID: userID, dateCreated: date)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        }
        return commentArray
    }
   
    private func getConvoFromSnapshot(snapshot: QuerySnapshot?) -> [ConvoModel] {
        var convoArray = [ConvoModel]()
        if let snapshot = snapshot {
            for doc in snapshot.documents {
                if let convoID = doc.documentID as? String, let participantsID = doc.get(FSConvoFields.participants) as? [String], let timestamp = doc.get(FSConvoFields.lastTimestamp) as? Timestamp {
                    let lastMessageDate = timestamp.dateValue()
                    let lastMessage = doc.get(FSConvoFields.lastMessage) as? String?
                    // check if last sender is current user
                    let lastMessageSender = doc.get(FSConvoFields.lastMessageSender)
                    var lastMessageWasCurrentUser: Bool? = nil
                    if lastMessageSender != nil {
                        lastMessageWasCurrentUser = (lastMessageSender as! String == currentUserID! ? true : false)
                    }
                    let newConvo = ConvoModel(convoID: convoID, participantsID: participantsID, lastMessageDate: lastMessageDate , lastMessage: lastMessage ?? nil, messages: [], lastMessageWasCurrentUser: lastMessageWasCurrentUser)
                    print(newConvo)
                    convoArray.append(newConvo)
                }
            }
            return convoArray
        } else {
            return convoArray
        }
        
    }
    
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
    
    private func getUsersFromQuerySnapshot(querySnapshot: QuerySnapshot?) -> [UsersModel] {
        var userArray = [UsersModel]()
        if let querySnapshot = querySnapshot {
            for doc in querySnapshot.documents {
                if let userID = doc.documentID as? String,
                   let username = doc.get(FSUserData.username) as? String {
                    let firstName = doc.get(FSUserData.fName) as? String
                    let lastName = doc.get(FSUserData.lName) as? String
                    let followerCount = doc.get(FSUserData.followerCount) as? Int
                    let followers = doc.get(FSUserData.followers) as? [String]
                    
                    let newUser = UsersModel(userID: userID, username: username, firstName: firstName!, lastName: lastName! , followerCount: followerCount ?? 0, followers: followers ?? [])
                    
                    userArray.append(newUser)
                }
            }
        }
        
        return userArray
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
    
    
    private func sortPostsByDate(posts: [PostModel]) -> [PostModel] {
        
        // sort by time stamp
        print(posts)
        
        let sortedPosts = posts.sorted {
            $0.dateCreated > $1.dateCreated
            
        }
        return sortedPosts
    }
    
// MARK: UPDATE FUNCTIONS
    
    /// follows a specific user on databse
    /// - Parameters:
    ///   - followerID: user's ID who does the following
    ///   - followedID: user's ID who is being followed
    func followUser(followerID: String, followedID: String) {
        let increment: Int64 = 1
        let data: [String: Any] = [
            FSUserData.followerCount: FieldValue.increment(increment),
            FSUserData.followers: FieldValue.arrayUnion([followerID])
        ]
        
        REF_USERS.document(followedID).updateData(data)
    }
    
    func unfollowUser(followerID: String, followedID: String) {
        let increment: Int64 = -1
        let data: [String: Any] = [
            FSUserData.followerCount: FieldValue.increment(increment),
            FSUserData.followers: FieldValue.arrayRemove([followerID])
        ]
        
        REF_USERS.document(followedID).updateData(data)
    }
    
    func likePost(postID: String, currentUserID: String) {
        // update post count
        // update the arra of users who liked the post
        
        let increment: Int64 = 1
        
        let data: [String: Any] = [
            FSPostFields.likeCount: FieldValue.increment(increment),
            FSPostFields.likedBy: FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String) {
        // update post count
        // update the arra of users who liked the post
        
        let increment: Int64 = -1
        
        let data: [String: Any] = [
            FSPostFields.likeCount: FieldValue.increment(increment),
            FSPostFields.likedBy: FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    
}
