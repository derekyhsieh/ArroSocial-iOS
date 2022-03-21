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
            self.dataArray.append(contentsOf: posts)
        }
    }
}
