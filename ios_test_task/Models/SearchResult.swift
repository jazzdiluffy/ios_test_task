//
//  SearchResult.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import Foundation


struct SearchResult: Codable {
    let total: Int
    let results: [Photo]
}



struct UserInfo: Codable {
    let username: String
    let name: String
    let profile_image: [UserInfoAvatarURL.RawValue: String]
    
    enum UserInfoAvatarURL: String {
        case small
        case medium
        case large
    }
}
