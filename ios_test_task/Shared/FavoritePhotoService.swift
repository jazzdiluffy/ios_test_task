//
//  FavoritePhotoService.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 13.01.2022.
//

import Foundation

protocol FavoritePhotoServiceProtocol {
    func isLiked(with id: String) -> Bool
    func markAsLiked(with photo: AdditionalPhotoInfo)
    func unlike(with photo: AdditionalPhotoInfo)
    var liked: [AdditionalPhotoInfo] { get }
}

final class FavoritePhotoService: FavoritePhotoServiceProtocol {
    
    static let key = "com.ilyaB.ios-test-task.FavoritePhotoService.likedPhotos"
    static let notificationKey: NSNotification.Name = NSNotification.Name("com.ilyaB.ios-test-task.FavoritePhotoService.likedPhotosModified")
    
    static let shared: FavoritePhotoServiceProtocol = FavoritePhotoService()
    
    
    var liked: [AdditionalPhotoInfo] {
        
            let likedPhotos: [AdditionalPhotoInfo] =  UserDefaults.standard.getObject(forKey: Self.key, castTo: [AdditionalPhotoInfo].self) ?? []
            return likedPhotos
        
    }
    
    func isLiked(with id: String) -> Bool {
        var liked: [AdditionalPhotoInfo] = []
         
        liked = UserDefaults.standard.getObject(forKey: Self.key, castTo: [AdditionalPhotoInfo].self) ?? []
        
        
        for i in liked {
            if i.id == id {
                return true
            }
        }
        return false
    }
    
    func markAsLiked(with photo: AdditionalPhotoInfo) {
        do {
            var liked: [AdditionalPhotoInfo] = UserDefaults.standard.getObject(forKey: Self.key, castTo: [AdditionalPhotoInfo].self) ?? []
            liked.append(photo)
            
            try UserDefaults.standard.setObject(liked, forKey: Self.key)
            NotificationCenter.default.post(name: Self.notificationKey, object: nil)
        } catch {
            print("[DEBUG]: Cant mark as liked")
        }
        
    }
    
    func unlike(with photo: AdditionalPhotoInfo) {
        do {
            var liked: [AdditionalPhotoInfo] = UserDefaults.standard.getObject(forKey: Self.key, castTo: [AdditionalPhotoInfo].self) ?? []
            liked.removeAll {
                $0.id == photo.id
            }
            try UserDefaults.standard.setObject(liked, forKey: Self.key)
            NotificationCenter.default.post(name: Self.notificationKey, object: nil)
        } catch {
            print("[DEBUG]: Cant mark as liked")
        }
    }
}
