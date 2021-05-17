//
//  NSMutableAttributtedString+Extensions.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 17/05/21.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult
    func bold(_ text: String, size: CGFloat = 14.0) -> NSMutableAttributedString {
        let attrs = [NSMutableAttributedString.Key.font : UIFont.boldSystemFont(ofSize: size)]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult
    func normal(_ text: String, size: CGFloat = 14.0)->NSMutableAttributedString {
        let attrs = [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: size)]
        let normal = NSAttributedString(string: text, attributes: attrs)
        self.append(normal)
        return self
    }
}

