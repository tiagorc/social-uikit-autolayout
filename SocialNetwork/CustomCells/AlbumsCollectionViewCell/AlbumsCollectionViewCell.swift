//
//  AlbumsCollectionViewCell.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import UIKit

class AlbumsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(with image: UserImage) {
        self.customImageView.imageFromServerURL(image.thumbnailURL)
    }
}
