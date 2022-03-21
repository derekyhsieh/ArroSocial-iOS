//
//  PostsViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/20/22.
//

import Foundation

class PostsViewModel: ObservableObject {
    @Published var dataArray = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    
    // INIT USED FOR FEED
    init() {
        
        print("GET POSTS FOR FEED")
        DataService.instance.downloadPostsForFeed { posts in
            self.dataArray = posts
        }
    }
    
    func fetchPosts(handler: @escaping(_ finished: Bool) -> ()) {
        DataService.instance.downloadPostsForFeed { newPosts in
            /// LOGIC: first get difference between two, then get subarray of new post which will yield differences in posts since all posts are fetched chronologically
            
            
            if(newPosts.count < self.dataArray.count) {
                // someone deleted their posts
                self.dataArray = newPosts
                handler(true)
                return
            } else {
                let differenceBetweenTwo = abs(newPosts.count - self.dataArray.count)
                
                if differenceBetweenTwo == 0 {
                    // both are same do nothing
                } else if differenceBetweenTwo == 1 {
                    // only 1 difference so just insert first new post into data array
                    self.dataArray.insert(newPosts[0], at: 0)
                } else {
                   // diff is more than 1 so get subarray
                    let subArray = newPosts[0...differenceBetweenTwo-1]
                    self.dataArray.insert(contentsOf: subArray, at: 0)
                }
            }
            handler(true)
        }
    }
}
