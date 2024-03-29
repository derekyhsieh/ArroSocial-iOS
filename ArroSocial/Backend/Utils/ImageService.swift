//
//  ImageManager.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 3/15/22.
//

import Foundation
import FirebaseStorage // holds images and videos of app
import UIKit

// cache user profile image
let imageCache = NSCache<AnyObject, UIImage>()

class ImageService {
    // MARK: PROPERTIES
    
    static let instance = ImageService()
    
    private var REF_STORAGE = Storage.storage()
    
    // MARK: PUBLIC FUNCTIONS
    
    func uploadProfileImage(userID: String, image: UIImage) {
        // get path to saved image
        let path = getProfileImagePath(userID: userID)
        
        // upload image to path
        
        
        uploadImage(path: path, image: image) { success in
            
        }
        
    }
    
    /// Downloads image of a specific post from its post ID from Firebase storage
    /// - Parameters:
    ///   - postID: post specific ID
    ///   - handler: returns an optional downloaded UIImage that is may be nil if not found
    func downloadPostImage(postID: String, handler: @escaping(_ image: UIImage?) -> ()) {
        // get path wehere image is saved
        let path = getPostImagePath(postID: postID, imageCount: 0)
        
        // donwload image from path
        downloadImage(path: path) { returnedImage in
            handler(returnedImage)
        }
        
    }
    
    /// Uploads image of a post to Firebase storage
    /// - Parameters:
    ///   - postID: post specific ID
    ///   - image: image that will be uploaded assigned to the post
    ///   - imageCount: which image number it is, in case of mulitple images per post
    ///   - handler: returns a boolean for isSuccessful or not.
    func uploadPostImage(postID: String, image: UIImage, imageCount: Int, handler: @escaping(_ isSuccessful: Bool) -> ()) {
        
        let path = getPostImagePath(postID: postID, imageCount: imageCount)
        
        uploadImage(path: path, image: image) { success in
            if success {
                handler(true)
                return
            } else {
                handler(false)
                return
            }
        }
        
    }
    
    /// Downloads profile image from specific UserID
    /// - Parameters:
    ///   - userID: userID for where the image will be downloaded for
    ///   - handler: returns an optinal user profile image (uiImage) and an optinal hexcolor code for the profile picture backgropund if user did not upload their own user profile image and uses the generated one
    func downloadProfileImage(userID: String, handler: @escaping(_ image: UIImage?, _ hexColor: String?) -> ()) {
        // get path where image is saved
        
        let path = getProfileImagePath(userID: userID)
        
        // download image from storage using path
       print(path)
        downloadImage(path: path) { returnedImage in
            if returnedImage == nil {
               // user has no profile pic and we need to get profile pic background color from user store
                DataService.instance.getUserProfileBackgroundColor(userID: userID) { hexColor in
                    if let hexColor = hexColor {
                        handler(nil, hexColor)
                    } else {
                        // didnt get hex color
                        handler(nil, nil)
                    }
                }
            }
            handler(returnedImage, nil)
        }
        
    }
    
    func deletePostImage(postID: String, handler: @escaping(_ success: Bool)->()) {
        let path = getPostImagePath(postID: postID, imageCount: 0)
        path.delete { error in
            if let error = error {
               print("error deleting image from storage path: \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
    
    
    // MARK: PRIVATE FUNCTIONS
    
    /// returns Firebase storage path reference from user id
    /// - Parameter userID: User's unique user id
    /// - Returns: returns a firebasestorage reference
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        
        let storagePath = REF_STORAGE.reference(withPath: userPath)
        
        return storagePath
    }
    
    private func getPostImagePath(postID: String, imageCount: Int) -> StorageReference {
        // image count is for possible post with multiple pictures
        let postPath = "posts/\(postID)/\(imageCount)"
        
        let storagePath = REF_STORAGE.reference(withPath: postPath)
        
        return storagePath
    }
    
    
    
    /// Uploading an image to the storage path
    /// - Parameters:
    ///   - path: This is the path where the image will be uploaded to
    ///   - image: the image that is uploaded to the path
    ///   - handler: returns a success boolean that tells whether uploading to storage was successful
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping(_ success: Bool) -> ()) {
        
        var compression: CGFloat = 1.0 // loops down by 0.05
        let maxFileSize: Int = 240 * 240 // max file size that is saved
        let maxCompresion: CGFloat = 0.05 // max compression allowed
        
        // get image data
        guard var originalData = image.jpegData(compressionQuality: 1.0) else {
            print("Error getting data from image (IMAGE MANAGER - UPLOAD IAMGE)")
            handler(false)
            return
        }
        
        // check max file size
        while (originalData.count > maxFileSize) && (compression > maxCompresion) {
            // lower compression if original data bigger than max file size
            compression -= 0.05
            
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
        }
        
        // get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        // uploading data to storage path
        path.putData(originalData, metadata: metadata) { _, error in
            if let error = error {
                // error
                print("error uploading image. \(error) (IMAGE MANAGER - UPLOAD IMAGE)")
                handler(false)
                return
            } else {
                // success
                print("successfully uploaded image")
                handler(true)
                return
            }
        }
    }
    
    /// Download's image from a specific Firebase storage path
    /// - Parameters:
    ///   - path: path of the desired image to be downloaded
    ///   - handler: returns an optional image 
    private func downloadImage(path: StorageReference, handler: @escaping(_ image: UIImage?) -> ()) {
        // check if image is already cached
        print(path)
        if let cachedImage = imageCache.object(forKey: path) {
            print("image found in cache")
            handler(cachedImage)
            return
        } else {
            path.getData(maxSize: 27 * 1024 * 1024) { returnedImageData, error in
                if let data = returnedImageData, let image = UIImage(data: data) {
                    // success getting image data
                    imageCache.setObject(image, forKey: path)
                    handler(image)
                    return
                } else {
                    
                    print("error getting data from path for image")
                    print(error!.localizedDescription)
                    handler(nil)
                    return
                }
            }
            
        }
        
        
    }
    
}
