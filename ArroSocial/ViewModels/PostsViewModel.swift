//
//  PostsViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/20/22.
//

import Foundation
import SwiftUI

class PostsViewModel: ObservableObject {
    @Published var dataArray = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    var currentUserID: String?
    
    
    // INIT USED FOR USER PROFILE POSTS
    /// Used for populating profile view posts
    /// - Parameter userID: target user id
    init(userID: String) {
        DataService.instance.downloadPostsForProfile(userID: userID) { posts in
            self.dataArray = posts
        }
    }
    
    /// Init used for feed
    /// - Parameter currentUserID: current user id of user
    init(currentUserID: String) {
        self.currentUserID = currentUserID
        print("GET POSTS FOR FEED")
        
        DataService.instance.downloadPostsForFeed(userID: self.currentUserID!) { posts in
            self.dataArray = posts
        }
    }
    
    func fetchPosts(handler: @escaping(_ finished: Bool) -> ()) {
        DataService.instance.downloadPostsForFeed(userID: self.currentUserID!) { newPosts in
            /// LOGIC: first get difference between two, then get subarray of new post which will yield differences in posts since all posts are fetched chronologically
            
            
            if newPosts == self.dataArray {
                handler(true)
            } else {
                self.dataArray = newPosts
                handler(true)
            }
        }
    }
    
    func deletePost(postID: String, handler: @escaping(_ finished: Bool) -> ()) {
        let docRef = DataService.instance.getDocumentReference(collection: FSCollections.posts, documentID: postID)
        DataService.instance.deleteDocument(docReference: docRef) { success in
            // delete from local dataarray
            for(index, post) in self.dataArray.enumerated() {
                
                if post.postID == postID {
                    withAnimation(.linear) {
                        self.dataArray.remove(at: index)
                    }
                }
            }
            
        }
        ImageService.instance.deletePostImage(postID: postID) { success in
        
        }
    }
}
