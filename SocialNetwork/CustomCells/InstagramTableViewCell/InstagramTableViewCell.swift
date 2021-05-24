//
//  InstagramTableViewCell.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 17/05/21.
//

import UIKit

protocol InstagramTableViewCellResponder: AnyObject {
    func didSelectUser(post: Post?, user: User?)
}

class InstagramTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    
    @IBOutlet weak var followProfileButton: UIButton!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likersLabel: UILabel!
    
    @IBOutlet weak var legendLabel: UILabel!
    
    @IBOutlet weak var firstLiker: UIImageView!
    @IBOutlet weak var secondLiker: UIImageView!
    @IBOutlet weak var thirdLiker: UIImageView!
    
    weak var responder: InstagramTableViewCellResponder?
    
    private var post: Post?
    private var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func bind(post: Post, user: User?, responder: InstagramTableViewCellResponder) {
        self.responder = responder
        
        self.post = post
        self.user = user
        
        profileUserImage.imageFromServerURL("http://lorempixel.com.br/\(32)/\(32)")
        profileUserImage.layer.cornerRadius = profileUserImage.frame.width/2.0
        
        firstLiker.imageFromServerURL("http://lorempixel.com.br/12/12")
        firstLiker.layer.cornerRadius = firstLiker.frame.width/2.0
        
        secondLiker.imageFromServerURL("http://lorempixel.com.br/12/12")
        secondLiker.layer.cornerRadius = secondLiker.frame.width/2.0
        
        thirdLiker.imageFromServerURL("http://lorempixel.com.br/12/12")
        thirdLiker.layer.cornerRadius = thirdLiker.frame.width/2.0
        
        let side = Int(UIScreen.main.nativeBounds.size.width)
        
        let placeholder = UIImage(named: "placeholder")
        postImageView.imageFromServerURL("http://lorempixel.com.br/\(side)/\(side)", placeHolder: placeholder)
        
        guard let user = user else { return }
        
        profileUserName.attributedText = NSMutableAttributedString()
            .bold( "\(user.username?.lowercased() ?? "") • ")
        
        likersLabel.attributedText = NSMutableAttributedString()
            .normal("Liked by ")
            .bold("profpedro ")
            .normal("and ")
            .bold("others ")
        
        legendLabel.attributedText =
            NSMutableAttributedString()
            .bold(user.username?.lowercased() ?? "")
            .normal(" \(post.title)" )
    }
    
    @IBAction func userDidClickInLikePost(_ sender: Any) {
    }
    
    @IBAction func userDidClickInCommentPost(_ sender: Any) {
    }
    
    @IBAction func userDidClickInSharePost(_ sender: Any) {
    }
    
    @IBAction func userDidClickInBookmark(_ sender: Any) {
    }
    
    @IBAction func userDidClickInFollow(_ sender: Any) {
    }
    
    @IBAction func userDidClickInOptions(_ sender: Any) {
    }
    
    @IBAction func userDidSelectShowProfile(_ sender: Any) {
        responder?.didSelectUser(post: post, user: user)
    }
}
