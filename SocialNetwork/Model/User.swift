//
//  User.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import Foundation

// MARK: - User
struct User: CacheObject, Identifiable {
    let id: Int?
    let name, username, email: String?
    let address: Address?
    let phone, website: String?
    let company: Company?
    
    func saveInCache() {
        CoredataContext.saveContext()
    }
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String?
    let geo: Geo?
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String?
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String?
}
