//
//  UserService.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import Foundation

class UserService {
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com/"
    
    private let requestor = Requestor()
    
    private let expireTime: CacheTime = .m15
    
    func loadUsers(completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        guard let url = URL(string: kBaseURL + "users") else { return }
        
        if let users = User.loadAll(primaryKey: url.absoluteString), !users.isEmpty {
            completion(users, nil)
            return
        }
        
        requestor.get(url: url, class: [User].self) { (users, error) in
            guard let users = users as? [User] else { return }
            
            users.forEach({ User.saveInCache(primaryKey: url.absoluteString, cacheObject: $0, expirationTime: self.expireTime)})

            completion(users, error)
        }
    }
    
    func loadPosts(completion: @escaping (_ posts: [Post]?, _ error: Error?) -> Void) {
        guard let url = URL(string: kBaseURL + "posts") else { return }
        
        if let posts = Post.loadAll(primaryKey: url.absoluteString), !posts.isEmpty {
            completion(posts, nil)
            return
        }
        
        requestor.get(url: url, class: [Post].self) { (posts, error) in
            guard let posts = posts as? [Post] else { return }
            
            posts.forEach { Post.saveInCache(primaryKey: url.absoluteString, cacheObject: $0, expirationTime: self.expireTime) }
            
            completion(posts, error)
        }
    }
    
    func loadAlbums(userId: String, completion: @escaping (_ albums: [Album]?, _ error: Error?) -> Void) {
        guard let url = URL(string: "\(kBaseURL)users/\(userId)/albums") else { return }
        
        let primaryKey = url.absoluteString + userId
        if let albums = Album.loadAll(primaryKey: primaryKey), !albums.isEmpty {
            completion(albums, nil)
            return
        }
        
        requestor.get(url: url, class: [Album].self) { (albums, error) in
            guard let albums = albums as? [Album] else { return }
            
            albums.forEach { Album.saveInCache(primaryKey: primaryKey, cacheObject: $0, expirationTime: self.expireTime) }
            
            completion(albums, error)
        }
    }
    
    func loadPostsForSpecificUser(userId: String, completion: @escaping (_ posts: [Post]?, _ error: Error?) -> Void) {
        guard let url = URL(string: "\(kBaseURL)posts/\(userId)/posts") else { return }
        
        let primaryKey = url.absoluteString + userId
        if let posts = Post.loadAll(primaryKey: primaryKey), !posts.isEmpty {
            completion(posts, nil)
            return
        }
        
        requestor.get(url: url, class: [Post].self) { (posts, error) in
            guard let posts = posts as? [Post] else { return }
            
            posts.forEach { Post.saveInCache(primaryKey: primaryKey, cacheObject: $0, expirationTime: self.expireTime) }
            
            completion(posts, error)
        }
    }
    
    func loadPhotosFromUser(userId: String, completion: @escaping (_ photos: [UserImage]?, _ error: Error?) -> Void) {
        guard let url = URL(string: "\(kBaseURL)photos/\(userId)/photos") else { return }
        let primaryKey = url.absoluteString + userId
        if let photos = UserImage.loadAll(primaryKey: primaryKey), !photos.isEmpty {
            completion(photos, nil)
        }
        
        requestor.get(url: url, class: [UserImage].self) { (photos, error) in
            guard let photos = photos as? [UserImage] else { return }
            
            photos.forEach { UserImage.saveInCache(primaryKey: primaryKey, cacheObject: $0, expirationTime: self.expireTime) }
            
            completion(photos, error)
        }
    }
    
    func loadPhotosFromAlbum(albumId: String, completion: @escaping (_ photos: [UserImage]?, _ error: Error?) -> Void) {

        guard let url = URL(string: "\(kBaseURL)albums/\(albumId)/photos") else { return }
        
        let primaryKey = url.absoluteString + albumId
        
        if let photos = UserImage.loadAll(primaryKey: primaryKey), !photos.isEmpty {
            completion(photos, nil)
        }
        
        requestor.get(url: url, class: [UserImage].self) { (photos, error) in
            guard let photos = photos as? [UserImage] else { return }
            
//            photos.forEach { UserImage.saveInCache(primaryKey: primaryKey, cacheObject: $0, expirationTime: self.expireTime) }
            
            completion(photos, error)
        }
    }
}
