//
//  AdditionalPhotoInfo.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import Foundation

struct AdditionalPhotoInfo: Codable {
    let id: String
    let created_at: String
    let downloads: Int
    let location: PhotoLocation?
    let urls: [PhotoURL.RawValue: String]
    let user: UserInfo
    let liked_by_user: Bool
}


struct PhotoLocation: Codable {
    let city: String?
    let country: String?
}
