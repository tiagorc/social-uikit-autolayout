//
//  Collection+Extensions.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
