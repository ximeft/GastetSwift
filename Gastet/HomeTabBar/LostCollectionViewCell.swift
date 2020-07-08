//
//  LostCollectionViewCell.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 5/29/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FBSDKShareKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth

class LostCollectionViewCell: UICollectionViewCell {
    
    //Comments View
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsLabel: UILabel!

    
    // UserView
    @IBOutlet weak var usernameLostLabel: UILabel!
    @IBOutlet weak var userLostImage: UIImageView!
    @IBOutlet weak var timestampLostLabel: UILabel!
    
    // Image
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var postedLostUIImage: UIImageView!
    
    // PostInformation View
    @IBOutlet weak var cityLostLabel: UILabel!
    @IBOutlet weak var municipalityLostLabel: UILabel!
    @IBOutlet weak var nameLostLabel: UILabel!
    @IBOutlet weak var breedLostLabel: UILabel!
    @IBOutlet weak var phoneLostTextView: UITextView!
    @IBOutlet weak var adressLostLabel: UILabel!
    
    
//    PostInformation PetType/Gender Pictures
    @IBOutlet weak var petTypeLostImage: UIImageView!
    @IBOutlet weak var genderLostImage: UIImageView!

    //Variables
    var homeVC: HomeViewController?
    var postRef: DatabaseReference!
    var commentsCount: String?

    
    
    var post: Posts? {
        didSet {
            updateLostPosts()
            countComments()
        }
    }
    
    var user: UserProfile? {
        didSet {
            setupUserInfo()
        }
    }

    func updateLostPosts() {
        
        //Timestamp
        func getDateFormattedString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, HH:mm"
            return formatter.string(from: post!.timestamp!)
        }
        
        //Images
        
        self.postedLostUIImage.image = nil
        if let postedPhotoUrl = post?.photoUrl {
            postedLostUIImage.sd_setImage(with: postedPhotoUrl, completed: nil)
        }
        
        adressLostLabel.text = "Ultima vez visto en " + (post?.address ?? "")
        municipalityLostLabel.text = post?.municipality ?? ""
        
        nameLostLabel.text = post?.name
        breedLostLabel.text = post?.breed
        phoneLostTextView.text = post?.phone
        cityLostLabel.text = post?.city
        timestampLostLabel.text = "\(post!.getDateFormattedString())"
        
        switch post?.petType{
            
        case "dog":
           petTypeLostImage.image = UIImage(named: "petType_dog.png")
            break
        case "cat":
            petTypeLostImage.image = UIImage(named: "petType_cat.png")
            break
        case "other":
            petTypeLostImage.image = UIImage(named: "petType_other.png")
            break
        default:
            break
        }
        
        switch post?.genderType {
        case "male":
           genderLostImage.image = UIImage(named: "gender_male.png")
            break
        case "female":
            genderLostImage.image = UIImage(named: "gender_female.png")
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
                    self.usernameLostLabel.text = user.username
                    if let userPhotoUrl = user.photoUrl {
                        let photoUrl = URL(string: userPhotoUrl)
                        self.userLostImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "user-placeholder.jpg"), options: .refreshCached, completed: nil)
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
         usernameLostLabel.text = ""
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLostImage.image = UIImage(named: "user-placeholder.jpg")
    }
    
    }

