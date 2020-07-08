//
//  LostSelectedViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 10/23/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import Social
import FBSDKShareKit
import FirebaseDatabase

class LostSelectedViewController: UIViewController {


    //Variables
    var posts: Posts?
    
    //@IBOUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Data
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lostImage: UIImageView!
    @IBOutlet weak var postTypeImage: UIImageView!
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var petTypeImage: UIImageView!
    @IBOutlet weak var petTypeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rewardImage: UIImageView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var rewardStackView: UIStackView!
    
    
    //User
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    //Address View
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var municipalityLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    
    
    
    //@IBACTIONS
    @IBAction func cancelButtonTapped(_ sender: UIButton) {

    self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func shareWhattsappButtonTapped(_ sender: UIButton) {
        
        switch posts?.petType {
        case "dog":
            let shareMessage = "Hola! Estoy buscando a mi perro que es de raza \(posts!.breed!)). La ultima vez que lo vimos fue en \(posts!.address!)). Ayudenme a encontrarlo porfavor! Subi la foto con toda la información a Gastet. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
            shareWhatssapp(message: shareMessage)
            break
        
        case "cat":
            let shareMessage = "Hola! Estoy buscando a mi gato que es de raza \(posts!.breed!). La ultima vez que lo vimos fue en \(posts!.address!). Ayudenme a encontrarlo porfavor! Subi la foto con toda la información a Gastet. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
            shareWhatssapp(message: shareMessage)
            break
        
        case "other":
            let shareMessage = "Hola! Estoy buscando a mi mascota que es de raza \(posts!.breed!). La ultima vez que lo vimos fue en \(posts!.address!). Ayudenme a encontrarlo porfavor! Subi la foto con toda la información a Gastet. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
            shareWhatssapp(message: shareMessage)
            break
        default:
            break
        }
    }
    
    @IBAction func shareFacebookButtonTapped(_ sender: UIButton) {
        shareFacebook()
    }
    
    func shareFacebook() {

        let photoToShare : FBSDKSharePhoto = FBSDKSharePhoto()
        photoToShare.image = postTypeImage.image
        photoToShare.isUserGenerated = true
        
        let contentToShare : FBSDKShareLinkContent = FBSDKShareLinkContent()
        contentToShare.contentURL = NSURL(string: "https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8") as! URL
        
    }
    
    
//    func shareFacebook(message: String) {

    //UIACTIVITY INDICATOR
    
    //        let shareMessage = "Hola! Estoy buscando a mi mascota que es de raza \(posts!.breed!). La ultima vez que lo vimos fue en \(posts!.address!). Ayudenme a encontrarlo porfavor! Subi la foto con toda la información a Gastet. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"

    
    //        let share = [lostImage, shareMessage] as [Any]
    //        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
    //        activityViewController.popoverPresentationController?.sourceView = self.view
    //        self.present(activityViewController, animated: true, completion: nil)
    
    
    
    
//        let initialText = message
//        let facebookShareAction = UIAlertAction(title: "Facebook", style: .default) { (action) in
//            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
//                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//                facebookComposer?.setInitialText(initialText)
//                facebookComposer?.add(self.posts?.photoUrl)
//
//                self.present(facebookComposer!, animated: true, completion: nil)
//            }
//
//            else {
//                ProgressHUD.showError("Hubo un error... intentalo más tarde")
//            }
//        }
//
//    }
    
    func shareWhatssapp(message: String) {
        
        let msg = message
        let urlWhats = "whatsapp://send?text=\(msg)"
        if  let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if  UIApplication.shared.canOpenURL(whatsappURL as URL ) {
                    UIApplication.shared.open(whatsappURL as URL)
                }
            }
        }
    }
    
    func reward() {
        
        if posts?.reward == nil {
            rewardLabel.isHidden = true
            rewardImage.isHidden = true
            rewardStackView.isHidden = true
            
        }
        
        else {
            
            switch posts?.reward {
            case "withReward":
                rewardImage.image = UIImage(named: "icon_reward.png")
                break
            case "withoutReward":
                rewardImage.isHidden = true
                rewardLabel.isHidden = true
                rewardStackView.isHidden = true
                break
            default:
                break
            }
        }
        
    }
    
    
    @IBAction func callMeButtonTapped(_ sender: UIButton) {
      
        
        let phoneNumber = posts?.phone
        if let callNumber = phoneNumber, let aURL = NSURL(string: "telprompt://\(callNumber)") {
            
            
            if UIApplication.shared.canOpenURL(aURL as URL) {
                UIApplication.shared.openURL(aURL as URL)
            } else {
                print("error")
            }
        }
        else {
            
            ProgressHUD.showSuccess("Ha hábido un error, intenta más tarde")
            print("error")
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Author
        setupUserInfo()
        
        //Reward
        reward()
        
        //navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //scroll view
        scrollView.delegate = self
        
        
        //imagenes
        
        self.lostImage.image = nil

        ImageService.getImage(withUrl:(posts?.photoUrl)! ) { (image) in

            self.lostImage.image = image
 
        }
        
        //Post Data
        self.nameLabel.text = posts?.name
        self.postTypeLabel.text = "Perdido"
        self.postTypeImage.image = UIImage.init(named: "postType_lost.png")
        
        //PetType
        switch posts?.petType{
            
        case "dog":
            petTypeLabel.text = "Perro"
            petTypeImage.image = UIImage(named: "petType_dog.png")
            break
        case "cat":
            petTypeLabel.text = "Gato"
            petTypeImage.image = UIImage(named: "petType_cat.png")
            break
        case "other":
            petTypeLabel.text = "Otro"
            petTypeImage.image = UIImage(named: "petType_other.png")
            break
        default:
            break
        }
        
        self.breedLabel.text = posts?.breed
        
        //Gender
        switch posts?.genderType {
        case "male":
            genderLabel.text = "Macho"
            genderImage.image = UIImage(named: "genderPost_male.png")
            break
        case "female":
            genderLabel.text = "Hembra"
            genderImage.image = UIImage(named: "genderPost_female.png")
            break
        default:
            break
        }

        //Address
        self.cityLabel.text = posts?.city
        self.municipalityLabel.text = posts?.municipality
        self.addressLabel.text = posts?.address
        
        //Comments
        self.commentsTextView.text = posts?.comments
        
    }
    
    func setupUserInfo() {
        
        if let uid = posts?.userid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                
                if let dict = snapshot.value as? [String: Any] {
                    let user = UserProfile.transformUser(dict: dict)
                    self.userLabel.text = user.username
                    if let userPhotoUrl = user.photoUrl {
                        let photoUrl = URL(string: userPhotoUrl)
                        self.userProfilePicture.sd_setImage(with: photoUrl, completed: nil)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension  LostSelectedViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView)
    }
    
}
