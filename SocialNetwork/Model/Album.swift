//
//  Album.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 24/05/21.
//

import Foundation


// MARK: - AlbumElement
struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
