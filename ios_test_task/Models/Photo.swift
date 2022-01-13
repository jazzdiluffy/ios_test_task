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
    let urls: [PhotoURL.RawValue: String]
}

enum PhotoURL: String {
    case raw
    case full
    case regular
    case small
    case thumb
}
