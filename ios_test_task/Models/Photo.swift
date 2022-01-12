//
//  Photo.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: Int
    let height: Int
    let liked_by_user: Bool
    let description: String?
    let user: UserInfo
    let urls: [PhotoURL.RawValue: String]
    let created_at: String
    let location: PhotoLocation?
}

enum PhotoURL: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

struct PhotoLocation: Codable {
    let city: String?
    let country: String?
}
