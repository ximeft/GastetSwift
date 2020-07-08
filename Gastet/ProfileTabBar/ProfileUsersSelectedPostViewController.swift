//
//  ProfileUsersSelectedPostViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 10/26/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit

class ProfileUsersSelectedPostViewController: UIViewController {

    //Variables
    var selectedpostsuser: ProfileUserPosts?
    
    //IBOUTLETS

    @IBOutlet weak var imagePosted: UIImageView!
    
    //Data
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postTypeImage: UIImageView!
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var petTypeImage: UIImageView!
    @IBOutlet weak var petTypeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    
    //Address
    @IBOutlet weak var titleAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var municipalityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var callToActionLabel: UILabel!
    
    
    //IBACTION
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func shareWhatsappButtonTapped(_ sender: UIButton) {
        
        switch selectedpostsuser?.postType {
        case "lost":
            let shareMessageLost = "Hola! Estoy buscando a mi \(selectedpostsuser?.petType) que es de raza \(selectedpostsuser?.breed). La ultima vez que lo vimos fue en \(selectedpostsuser?.address). Ayudenme a encontrarlo porfavor! Subi la foto con toda la información a Gastet. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
            shareWhatssapp(message: shareMessageLost)
            break
            
        case "found":
            let shareMessageFound = "Hola! Encontre a un \(selectedpostsuser?.petType) de raza \(selectedpostsuser?.breed) en \(selectedpostsuser?.address). Ayudenme a encontrar su dueño porfavor! Subi la foto con toda la información a Gastet, el app que ayuda a encontrar los dueños de mascotas encontradas. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
            shareWhatssapp(message: shareMessageFound)
            break
        case "adoption":
            
            let shareMessageAdoption = "Hola! Tenemos un \(selectedpostsuser?.petType) en adopción, de raza \(selectedpostsuser?.breed). Ayudenme a encontrarle una casa! Subi la foto con toda la información a Gastet, el app que ayuda a posicionar mascotas en adopción. Pueden verlo aquí: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
            shareWhatssapp(message: shareMessageAdoption)
            break
        default:
            break
            
        }
    }
    
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
    
    
    @IBAction func contactmeButtonTapped(_ sender: UIButton) {
        
        let phoneNumber = selectedpostsuser?.phone
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
    
    
    //VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.imagePosted.image = nil
        
        ImageService.getImage(withUrl:(selectedpostsuser?.photoUrl)! ) { (image) in
            
            self.imagePosted.image = image
            
        }
        
        //PostType
        switch selectedpostsuser?.postType{
            
        case "lost":
            postTypeLabel.text = "Perdido"
            postTypeImage.image = UIImage(named: "postType_lost.png")
            titleAddressLabel.text = "Donde fue la última vez visto?"
            nameLabel.text = selectedpostsuser?.name
            breedLabel.text = selectedpostsuser?.breed
            callToActionLabel.text = "Lo encontraste?"
            break
            
        case "found":
            postTypeLabel.text = "Encontrado"
            postTypeImage.image = UIImage(named: "postType_found.png")
            titleAddressLabel.text = "Encontrado en: "
            nameLabel.text = selectedpostsuser?.breed
            breedLabel.isHidden = true
            callToActionLabel.text = "Es tuyo?"
            
            break
        case "adopt":
            postTypeLabel.text = "Adopción"
            postTypeImage.image = UIImage(named: "postType_adoption.png")
            titleAddressLabel.text = "Donde lo puedes adoptar?"
            nameLabel.text = selectedpostsuser?.breed
            breedLabel.isHidden = true
            callToActionLabel.text = "Quieres adoptar?"
            break
        default:
            break
        }
        
        //PetType
        switch selectedpostsuser?.petType{
            
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
        
        //Gender
        switch selectedpostsuser?.genderType {
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
        self.cityLabel.text = selectedpostsuser?.city
        self.municipalityLabel.text = selectedpostsuser?.municipality
        self.addressLabel.text = selectedpostsuser?.address
        
        //Comments
        self.commentsLabel.text = selectedpostsuser?.comments

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
