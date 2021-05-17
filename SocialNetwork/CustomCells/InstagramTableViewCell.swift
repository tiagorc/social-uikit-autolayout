//
//  InstagramTableViewCell.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 17/05/21.
//

import UIKit

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
    
    private let kUsername = "eulertiago"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(post: Post) {
        
        profileUserImage.imageFromServerURL("http://lorempixel.com.br/\(32)/\(32)", placeHolder: nil)
        profileUserImage.layer.cornerRadius = profileUserImage.frame.width/2.0
        
        firstLiker.imageFromServerURL("http://lorempixel.com.br/12/12", placeHolder: nil)
        firstLiker.layer.cornerRadius = firstLiker.frame.width/2.0
        
        secondLiker.imageFromServerURL("http://lorempixel.com.br/12/12", placeHolder: nil)
        secondLiker.layer.cornerRadius = secondLiker.frame.width/2.0
        
        thirdLiker.imageFromServerURL("http://lorempixel.com.br/12/12", placeHolder: nil)
        thirdLiker.layer.cornerRadius = thirdLiker.frame.width/2.0
        
        let side = Int(UIScreen.main.nativeBounds.size.width)
        
        let placeholder = UIImage(named: "placeholder")
        postImageView.imageFromServerURL("http://lorempixel.com.br/\(side)/\(side)", placeHolder: placeholder)
        
        profileUserName.attributedText = NSMutableAttributedString()
            .bold( "\(kUsername) • ")
        
        likersLabel.attributedText = NSMutableAttributedString()
            .normal("Liked by ")
            .bold("profpedro ")
            .normal("and ")
            .bold("others ")
        
        legendLabel.attributedText =
            NSMutableAttributedString()
            .bold(kUsername)
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
    
}
