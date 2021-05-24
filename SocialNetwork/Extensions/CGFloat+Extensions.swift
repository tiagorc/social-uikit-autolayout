//
//  CGFloat+Extensions.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 24/05/21.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
