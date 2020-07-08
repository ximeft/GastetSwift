 //
//  FoundCollectionViewCell.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 5/30/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase
 
class FoundCollectionViewCell: UICollectionViewCell {
    
    
    //UserView
    @IBOutlet weak var usernameFoundLabel: UILabel!
    @IBOutlet weak var userFoundImage: UIImageView!
    @IBOutlet weak var timestampFoundLabel: UILabel!
    
    
    //Image
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var postedFoundUIImage: UIImageView!
    
    //PostInformation View
    @IBOutlet weak var cityFoundLabel: UILabel!
    @IBOutlet weak var municipalityFoundLabel: UILabel!
    @IBOutlet weak var breedFoundLabel: UILabel!
    @IBOutlet weak var phoneFoundTextView: UITextView!
    @IBOutlet weak var adressFoundLabel: UILabel!
    
    //Comments
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    //PostInformation PetType/Gender Pictures
    @IBOutlet weak var petTypeFoundImage: UIImageView!
    @IBOutlet weak var genderTypeFoundImage: UIImageView!

    
    //Variables
    var homeVC: HomeViewController?
    var commentsCount: String?
    
    var post: Posts? {
        didSet {
            updateFoundPosts()
            countComments()
        }
    }
    
    var user: UserProfile? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateFoundPosts() {
        
        func getDateFormattedString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, HH:mm"
            return formatter.string(from: post!.timestamp!)
        }
        
        self.postedFoundUIImage.image = nil
        if let postedPhotoUrl = post?.photoUrl {
            //sd_setImage --> comes from import SDWebImage cocoa pod
            postedFoundUIImage.sd_setImage(with: postedPhotoUrl, completed: nil)
        }
        
        adressFoundLabel.text = "Ultima vez visto en " + (post?.address!)!
        breedFoundLabel.text = post?.breed
        phoneFoundTextView.text = post?.phone
        cityFoundLabel.text = post?.city
        municipalityFoundLabel.text = post?.municipality
        timestampFoundLabel.text = "\(post!.getDateFormattedString())"
        
        switch post?.petType{
            
        case "dog":
            petTypeFoundImage.image = UIImage(named: "petType_dog.png")
            break
        case "cat":
            petTypeFoundImage.image = UIImage(named: "petType_cat.png")
            break
        case "other":
            petTypeFoundImage.image = UIImage(named: "petType_other.png")
            break
        default:
            break
        }
        
        switch post?.genderType {
        case "male":
            genderTypeFoundImage.image = UIImage(named: "gender_male.png")
            break
        case "female":
            genderTypeFoundImage.image = UIImage(named: "gender_female.png")
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
                    self.usernameFoundLabel.text = user.username
                    if let userPhotoUrl = user.photoUrl {
                        let photoUrl = URL(string: userPhotoUrl)
                        self.userFoundImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "user-placeholder.jpg"), options: .refreshCached, completed: nil)
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
