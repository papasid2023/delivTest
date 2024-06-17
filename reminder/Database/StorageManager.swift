//
//  StorageManager.swift
//  reminder
//
//  Created by Руслан Сидоренко on 18.05.2024.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageManager {
    
    public static let shared = StorageManager()
    
    public let container = Storage.storage()
    
    init(){}
    
    public func uploadAvatar(email: String,
                             image: UIImage?,
                             completion: @escaping (Bool)-> Void
    ){
        
        let emailPath = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        guard let jpegData = image?.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        container.reference(withPath: "usersAvatars/\(emailPath)/avatar.jpeg").putData(jpegData, metadata: nil
        ) {
            metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func downloadUrlForAvatar(path: String,
                                     completion: @escaping (URL?)-> Void
    ){
        container
            .reference(withPath: path)
            .downloadURL { url, _ in
            completion(url)
        }
    }
    
    public func uploadPostImage(email: String,
                             image: UIImage,
                             postId: String,
                             completion: @escaping (Bool)-> Void
    ){
        
        let emailPath = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        guard let jpegData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        container.reference(withPath: "usersPosts/\(emailPath)/\(postId).jpeg").putData(jpegData, metadata: nil
        ) {
            metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func downloadUrlForPostImage(email: String,
                                        postId: String,
                                        completion: @escaping (URL?)-> Void
    ){
        
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        container
            .reference(withPath: "usersPosts/\(emailComponent)/\(postId).jpeg")
            .downloadURL { url, _ in
            completion(url)
        }
    }
}
