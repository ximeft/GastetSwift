//
//  CommentTableViewCell.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 11/21/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    //Variables
    var homeVC: HomeViewController?
    
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: UserProfile? {
        didSet {
            setupUserInfo()
        }
    }
    
    //Funcs
    
    func updateView() {
        commentLabel.text = comment?.commentText
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        
        if let photoUrlString = user?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "user-placeholder.jpg"), options: .refreshCached, completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "user-placeholder.jpg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
