//
//  PostsCollectionViewCell.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 8/14/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postUIImage: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var phoneLabel: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var municipalityLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var deletePostButton: UIButton!
    
    //Comments
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    
    //PostInformation PetType/Gender Pictures
    @IBOutlet weak var postTypeImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    
    //Vars
    var postIdCell: String?
    var post: ProfileUserPosts?
    var profileVC: ProfileViewController?
    var commentsCount: String?
    
    func set(post: ProfileUserPosts) {

        ImageService.getImage(withUrl: post.photoUrl!) { (image) in
            self.postUIImage.image = image
        }
        
        breedLabel.text = post.breed
        phoneLabel.text = post.phone
        commentsLabel.text = post.comments
        
        cityLabel.text = post.city
        municipalityLabel.text = post.municipality
        postIdCell = post.postid
        
        
        //PostType
        
        //Esto sale nillll, why?!
        
        switch post.postType {
        case "lost":
            postTypeImage.image = UIImage(named: "postType_lost.png")
            break
        case "found":
            postTypeImage.image = UIImage(named: "postType_found.png")
            break
        case "adopt":
            postTypeImage.image = UIImage(named: "postType_adoption.png")
            break
        default:
            break
        }
        
        //Gender
        switch post.genderType {
        case "male":
            genderImage.image = UIImage(named: "gender_male.png")
            break
        case "female":
            genderImage.image = UIImage(named: "gender_female.png")
            break
        default:
            break
        }
        
        countComments()
    }
    
    func countComments() {
        
        let postCommentRef = Database.database().reference().child("post-comments").child(postIdCell!)
        
        postCommentRef.observe(.value) { (snapshot) in
            
            
            let binaryUInt = snapshot.childrenCount
            let commentsCountString = String(binaryUInt)
            self.commentsCount = commentsCountString
            print("Nuevo comment aquí:" + commentsCountString)
            
            switch binaryUInt {
            case 0 :
                self.postCommentsLabel.text = "comenta aquí"
                break
            case 1 :
                self.postCommentsLabel.text = "1 comentario"
                break
            default:
                self.postCommentsLabel.text = "\(commentsCountString) comentarios"
                break
                
            }
            
        }
        
    }
    
    override func awakeFromNib() {

        //Make Comments View Clickable
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentsViewPressed))
        commentsView.addGestureRecognizer(tapGesture)
        commentsView.isUserInteractionEnabled = true
    }
    
    @objc func commentsViewPressed() {
        print("View was touched! Yay")
        
        print("CommentsViewWasPressed key:" + postIdCell!)
        
        if let id = postIdCell {
            print("Antes del segue")
            profileVC?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
    }
    
    
    
}
