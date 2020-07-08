//
//  AdoptionCollectionViewCell.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 10/18/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AdoptionCollectionViewCell: UICollectionViewCell {
    
    
    //UserView
    @IBOutlet weak var usernameAdoptionLabel: UILabel!
    @IBOutlet weak var userAdoptionImage: UIImageView!
    @IBOutlet weak var timestampAdoptionLabel: UILabel!
    
    //Image
    @IBOutlet weak var postedAdoptionUIImage: UIImageView!
    
    //Comments
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    //PostInformation View
    @IBOutlet weak var cityAdoptionLabel: UILabel!
    @IBOutlet weak var municipalityAdoptionLabel: UILabel!
    @IBOutlet weak var breedAdoptionLabel: UILabel!
    @IBOutlet weak var phoneAdoptionTextView: UITextView!
    @IBOutlet weak var commentsAdoptionLabel: UILabel!
    
    //PostInformation PetType/Gender Pictures
    @IBOutlet weak var petTypeAdoptionImage: UIImageView!
    @IBOutlet weak var genderTypeAdoptionImage: UIImageView!
    
    
    //Variables
    var homeVC: HomeViewController?
    var commentsCount: String?
    
    var post: Posts? {
        didSet {
            updateAdoptionPosts()
            countComments()
        }
    }
    
    var user: UserProfile? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateAdoptionPosts() {
        
        
        self.postedAdoptionUIImage.image = nil
        if let postedPhotoUrl = post?.photoUrl {
            postedAdoptionUIImage.sd_setImage(with: postedPhotoUrl, completed: nil)
        }

        
        commentsAdoptionLabel.text = post?.comments
        breedAdoptionLabel.text = post?.breed
        phoneAdoptionTextView.text = post?.phone
        cityAdoptionLabel.text = post?.city
        municipalityAdoptionLabel.text = post?.municipality
        timestampAdoptionLabel.text = "\(post!.getDateFormattedString())"
        
        
        switch post?.petType{
            
        case "dog":
            petTypeAdoptionImage.image = UIImage(named: "petType_dog.png")
            break
        case "cat":
            petTypeAdoptionImage.image = UIImage(named: "petType_cat.png")
            break
        case "other":
            petTypeAdoptionImage.image = UIImage(named: "petType_other.png")
            break
        default:
            break
        }
        
        switch post?.genderType {
        case "male":
            genderTypeAdoptionImage.image = UIImage(named: "gender_male.png")
            break
        case "female":
            genderTypeAdoptionImage.image = UIImage(named: "gender_female.png")
            break
        default:
            break
        }

    }
    
    func setupUserInfo() {
        
        if let uid = post?.userid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                
                if let dict = snapshot.value as? [String: Any] {
                    let user = UserProfile.transformUser(dict: dict)
                    self.usernameAdoptionLabel.text = user.username
                    if let userPhotoUrl = user.photoUrl {
                        let photoUrl = URL(string: userPhotoUrl)
                        self.userAdoptionImage.sd_setImage(with: photoUrl, completed: nil)
                    }
                }
            }
        }
    }
    
    func countComments() {
        
        
        let postCommentRef = Database.database().reference().child("post-comments").child((post?.postid)!)
        postCommentRef.observe(.value) { (snapshot) in
            let binaryUInt = snapshot.childrenCount
            let commentsCountString = String(binaryUInt)
            self.commentsCount = commentsCountString
            
            switch binaryUInt {
            case 0 :
               self.commentsLabel.text = "comenta aquí"
                break
            case 1 :
                self.commentsLabel.text = "1 comentario"
                break
            default:
                self.commentsLabel.text = "\(commentsCountString) comentarios"
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
    
        if let id = post?.postid {
            homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
    }
}
