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
    
    // MARK: CREATE FUNCTION
    
    func uploadPost(image: UIImage, caption: String?, userName: String, userID: String, handler: @escaping(_ success: Bool,_ postID: String?) -> ()) {
        // create doc
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        ImageService.instance.uploadPostImage(postID: postID, image: image, imageCount: 0) { isSuccessful in
            if isSuccessful {
                // successfully uploaded image data to storage
                // post data to db
                
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
}
