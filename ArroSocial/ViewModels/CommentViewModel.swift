//
//  CommentViewModel.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/25/22.
//

import SwiftUI

class CommentViewModel: ObservableObject {
    @Published var commentArray: [CommentModel] = [CommentModel]()
    @Published var isUploading = false
    
    var postID: String
    
    init(postID: String) {
        self.postID = postID
        fetchComment()
    }
    
    func fetchComment() {
        DataService.instance.downloadCommentForPost(postID: postID) { commentArray in
//            self.commentArray = self.sortCommentsByDate()
            self.commentArray = self.sortCommentsByDate(commentArray: commentArray)
        }
    }
    
    func uploadComment(userID: String, postID: String, username: String, content: String, handler: @escaping(_ isFinished: Bool) -> ()) {
        self.isUploading = true
        DataService.instance.uploadComment(postID: postID, username: username, content: content, userID: userID) { isSuccessful, commentID in
            self.isUploading = false
        let newComment = CommentModel(commentID: commentID, postID: postID, username: username, content: content, userID: userID, dateCreated: Date())
            self.commentArray.append(newComment)
            handler(true)
            return
        }
        
    }
    
    
    private func sortCommentsByDate(commentArray: [CommentModel]) -> [CommentModel]{
        
        
        let sortedComments = commentArray.sorted {
            $0.dateCreated > $1.dateCreated
            
        }
        
        return sortedComments
        
    }
}
