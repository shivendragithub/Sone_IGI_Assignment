//
//  User.swift
//  Medtrail_assignment
//
//  Created by shivendra pandey on 3/12/20.
//  Copyright © 2020 shivendra pandey. All rights reserved.
//

import Foundation
struct ResponceDataModel: Codable {
    let photos: PhotoDataModel
    let stat: String
}

struct PhotoDataModel: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let farm: Int
    let id: String
    let isfamily: Int
    let isfriend: Int
    let ispublic: Int
    let owner: String
    let secret: String
    let server: String
    let title: String
}



