//
//  UserDetailsTableViewCell.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 24/05/21.
//

import UIKit

protocol UserDetailsTableViewCellProtocol: AnyObject {
    func userDidClickInPhotos()
}

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    weak var responder: UserDetailsTableViewCellProtocol?

    func bind(user: User?, responder: UserDetailsTableViewCellProtocol?) {
        self.responder = responder
        
        guard let user = user else { return }
        
        profileUserImage.imageFromServerURL("http://lorempixel.com.br/16/16")
        profileUserImage.layer.cornerRadius = profileUserImage.frame.width/2.0
        profileUserImage.layer.borderColor = UIColor.random().cgColor
        profileUserImage.layer.borderWidth = 2.0
        
        nameLabel.text = user.name
        userNameLabel.text = user.username
        emailLabel.text = user.email
    }
    
    @IBAction func userDidClickInPhotos(_ sender: Any) {
        responder?.userDidClickInPhotos()
    }
}
