//
//  DataService.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/17/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class DataService {
    static let instance = DataService()
    
    
    private var REF_POSTS = DB_BASE.collection(FSCollections.posts)
    private var REF_USERS = DB_BASE.collection(FSCollections.users)
    
    // MARK: CREATE FUNCTION
    
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
