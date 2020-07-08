//
//  PostViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 5/9/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import GoogleMaps

enum PostCategory: String {
    case lost = "lost"
    case found = "found"
    case adopt = "adopt"
}

enum PetKind: String {
    case dog
    case cat
    case other
}

enum Gender: String {
    case male, female
}

enum Reward: String {
    case withReward
    case withoutReward
    
}

enum ResponsibleAdoption: String {
    case yes
    case no
}

class PostViewController: UIViewController, UITextViewDelegate {
    
    //VARS
    var lost = Bool()
    var selectedImage : UIImage!
    var username: String?
    var photoUrl: URL?
    var rewardQuantityIntToDatabase: Int?
    var latitudeDouble: Double?
    var longitudDouble: Double?
    var municipalityString: String?
    var addressString: String?
    var neighborhood: String?

    
    var selectedPostCategory: PostCategory?
    var selectedPet: PetKind?
    var selectedGender: Gender?
    var selectedReward: Reward?
    var responsibleAdoption: ResponsibleAdoption?
    var currentUser = UserService.currentUserProfile
    
    
    //Gradients
    let colorTop = UIColor(displayP3Red: 224/255, green: 181/255, blue: 107/255, alpha: 1)
    let colorDown = UIColor(displayP3Red: 190/255, green: 126/255, blue: 57/255, alpha: 1)

    
    //@IBOUTLETS
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePosted: UIImageView!
    
    
    //postType View
    @IBOutlet weak var changeImageLostButton: UIButton!
    @IBOutlet weak var changeImageFoundButton: UIButton!
    @IBOutlet weak var changeImageAdoptButton: UIButton!
    @IBOutlet weak var otherPetStackView: UIStackView!
    
    //LocationView
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var selectLocationLabel: UILabel!
    @IBOutlet weak var locationViewTop: UIView!
    
    //petType View
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var otherPetButton: UIButton!
    
    //Reward View
    @IBOutlet weak var rewardView: UIView!
    @IBOutlet weak var rewardYesButton: UIButton!
    @IBOutlet weak var rewardNoButton: UIButton!
    @IBOutlet weak var rewardQuantityView: UIView!
    @IBOutlet weak var rewardQuantityTextField: UITextField!
    
    
    //name textfield
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!

    //gender View
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var responsibleAdoptionView: UIView!
    @IBOutlet weak var responsibleAdoptionYesButton: UIButton!
    @IBOutlet weak var responsibleAdoptionNoButton: UIButton!
    
    
    //breed View
    @IBOutlet weak var breed: UITextField!
    
    //phone View
    @IBOutlet weak var phone: UITextField!
    
    //comments
    @IBOutlet weak var commentsTextView: UITextView!
    
    //post whole ad
    @IBOutlet weak var postButton: UIButton!
    
    //BUTTONS PRESSED - LOST & FOUND
    
    @IBAction func lostPressedButton(_ sender: UIButton) {
        selectedPostCategory = .lost
        changeImageLostButton.setImage(UIImage(named:"icon_lost_active.png"), for: .normal)
        changeImageFoundButton.setImage(UIImage(named:"icon_found_inactive.png"), for: .normal)
        changeImageAdoptButton.setImage(UIImage(named: "icon_adoption_inactive.png"), for: .normal)
        lost = true
        otherPetStackView.isHidden = false
        nameView.isHidden = false
        rewardView.isHidden = false
        rewardQuantityView.isHidden = true
        responsibleAdoptionView.isHidden = true
        postTypeLabel.text = "Dónde se perdio?"
        enablePostButton()
    }
    
    @IBAction func foundPressedButton(_ sender: Any) {
        selectedPostCategory = .found
        changeImageLostButton.setImage(UIImage(named:"icon_lost_inactive.png"), for: .normal)
        changeImageFoundButton.setImage(UIImage(named:"icon_found_active.png"), for: .normal)
        changeImageAdoptButton.setImage(UIImage(named: "icon_adoption_inactive.png"), for: .normal)
        lost = false
        otherPetStackView.isHidden = false
        nameView.isHidden = true
        rewardView.isHidden = true
        rewardQuantityView.isHidden = true
        responsibleAdoptionView.isHidden = true
        postTypeLabel.text = "Dónde se encontro?"
        enablePostButton()
    }
    
    
    @IBAction func adoptPressedButton(_ sender: UIButton) {
        selectedPostCategory = .adopt
        changeImageLostButton.setImage(UIImage(named:"icon_lost_inactive.png"), for: .normal)
        changeImageFoundButton.setImage(UIImage(named:"icon_found_inactive.png"), for: .normal)
        changeImageAdoptButton.setImage(UIImage(named: "icon_adoption_active.png"), for: .normal)
        otherPetStackView.isHidden = true
        nameView.isHidden = true
        rewardView.isHidden = true
        rewardQuantityView.isHidden = true
        responsibleAdoptionView.isHidden = false
        postTypeLabel.text = "Dónde se adopta?"
        enablePostButton()
    
    }
    
    //@IBACTIONS - petType
    
    
    @IBAction func dogPressedButton(_ sender: UIButton) {
        selectedPet = .dog
        dogButton.setImage(UIImage(named: "icon_dog_active.png"), for: .normal)
        catButton.setImage(UIImage(named: "icon_cat_inactive.png"), for: .normal)
        otherPetButton.setImage(UIImage(named: "icon_otherpet_inactive.png"), for: .normal)
        enablePostButton()
    }
    
    @IBAction func catPressedButton(_ sender: UIButton) {
         selectedPet = .cat
        dogButton.setImage(UIImage(named: "icon_dog_inactive.png"), for: .normal)
          catButton.setImage(UIImage(named: "icon_cat_active.png"), for: .normal)
          otherPetButton.setImage(UIImage(named: "icon_otherpet_inactive.png"), for: .normal)
        enablePostButton()
    }

    @IBAction func otherPetPressedButton(_ sender: UIButton) {
        selectedPet = .other
        dogButton.setImage(UIImage(named: "icon_dog_inactive.png"), for: .normal)
          catButton.setImage(UIImage(named: "icon_cat_inactive.png"), for: .normal)
          otherPetButton.setImage(UIImage(named: "icon_otherpet_active.png"), for: .normal)
        enablePostButton()
    }
    
    //@IBACTIONS - Reward
    @IBAction func rewardYesButtonPressed(_ sender: UIButton) {
        selectedReward = .withReward
        rewardYesButton.setImage(UIImage(named: "checkmark_active.png"), for: .normal)
        rewardNoButton.setImage(UIImage(named: "cross_inactive.png"), for: .normal)
        rewardQuantityView.isHidden = false
        
    }
    
    
    @IBAction func rewardNoButtonPressed(_ sender: UIButton) {
        selectedReward = .withoutReward
        rewardYesButton.setImage(UIImage(named: "checkmark_inactive.png"), for: .normal)
        rewardNoButton.setImage(UIImage(named: "cross_active.png"), for: .normal)
        rewardQuantityView.isHidden = true
    }
    
    
    //@IBACTIONS - gender
    
    @IBAction func maleButtonPressed(_ sender: UIButton) {
        selectedGender = .male
        maleButton.setImage(UIImage(named: "icon_male_active.png"), for: .normal)
        femaleButton.setImage(UIImage(named: "icon_female_inactive.png"), for: .normal)
        enablePostButton()
    }
    
    @IBAction func femaleButtonPressed(_ sender: UIButton) {
        selectedGender = .female
        maleButton.setImage(UIImage(named: "icon_male_inactive.png"), for: .normal)
        femaleButton.setImage(UIImage(named: "icon_female_active.png"), for: .normal)
        enablePostButton()
    }
    
    //@IBACTION - ResponsibleAdoption
    
    @IBAction func responsibleAdoptionYesButtonPressed(_ sender: UIButton) {
        responsibleAdoption = .yes
        responsibleAdoptionYesButton.setImage(UIImage(named: "checkmark_active.png"), for: .normal)
        responsibleAdoptionNoButton.setImage(UIImage(named: "cross_inactive.png"), for: .normal)
        enablePostButton()
    }
    
    @IBAction func responsibleAdoptionNoButtonPressed(_ sender: UIButton) {
        responsibleAdoption = .no
        responsibleAdoptionYesButton.setImage(UIImage(named: "checkmark_inactive.png"), for: .normal)
        responsibleAdoptionNoButton.setImage(UIImage(named: "cross_active.png"), for: .normal)
        enablePostButton()
    }
    
    //IBAction - textFieldEditing for enable Button
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
   
    rewardQuantity()
    enablePostButton()
        
    }
    
    //Fetch User Information to send Author Information to Firebase
    
    func fetchUser() {
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                
                let stringPhotoUrl = dict["photoUrl"] as? String
                self.photoUrl = URL(string: stringPhotoUrl!)
                self.username = dict["username"] as? String
                print(self.photoUrl!)
                print(self.username!)
            }
        }
        
    }
    
    //FIREBASE CODE
    
    @IBAction func postButtonPressed(_ sender: Any) {

            postButton.setTitle("Publicar", for: .normal)
            postButton.isHidden = false
            ProgressHUD.show("En Proceso...")
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            //photo idstring gives us a unique string for any given time of the day. Garantied unique string
            let photoIdString = "\(NSUUID().uuidString).jpg"
            let imageReference = storageRef.child("posts").child(photoIdString)
            if let imageData = UIImageJPEGRepresentation(selectedImage, 0.4) {
                imageReference.putData(imageData).observe(.success) { (snapshot) in
                    imageReference.downloadURL(completion: { (url, error) in
                        
                        
                        if let downloadUrl = url {
                            let directoryURL : NSURL = downloadUrl as NSURL
                            let urlString:String = directoryURL.absoluteString!
                            guard let currentUser = Auth.auth().currentUser else {
                                return
                            }
                            
                            let toId = currentUser.uid
                            var dataToSend: [String: Any]
                            switch self.selectedPostCategory! {
                            case .lost:
                                dataToSend = [
                                    "location": [
                                        "latitude": self.latitudeDouble!,
                                        "longitude": self.longitudDouble!,
                                        "municipality": self.municipalityString ?? "",
                                        "neighborhood": self.neighborhood ?? "",
                                        "address": self.addressString ?? "",
                                    ],
                                    "photoUrl": urlString,
                                    "postType": self.selectedPostCategory!.rawValue,
                                    "petType": self.selectedPet!.rawValue,
                                    "name": self.nameTextField.text!,
                                    "reward": self.selectedReward!.rawValue,
                                    "rewardQuantity": self.rewardQuantityIntToDatabase!,
                                    "gender": self.selectedGender!.rawValue,
                                    "breed": self.breed.text!,
                                    "phone": self.phone.text!,
                                    "timestamp": ServerValue.timestamp(),
                                    "comments": self.commentsTextView.text!,
                                    "municipality": self.municipalityString ?? "",
                                    "address": self.addressString ?? "",
                                    "userid": toId
                                ]
                                
                                break
                                
                            case .found:
                                dataToSend = [
                                    "location": [
                                        "latitude": self.latitudeDouble!,
                                        "longitude": self.longitudDouble!,
                                        "municipality": self.municipalityString ?? "",
                                        "neighborhood": self.neighborhood ?? "",
                                        "address": self.addressString ?? "",
                                    ],
                                    "photoUrl": urlString,
                                    "postType": self.selectedPostCategory!.rawValue,
                                    "petType": self.selectedPet!.rawValue,
                                    "gender": self.selectedGender!.rawValue,
                                    "breed": self.breed.text!,
                                    "phone": self.phone.text!,
                                    "timestamp": ServerValue.timestamp(),
                                    "comments": self.commentsTextView.text!,
                                    "latitude": self.latitudeDouble!,
                                    "longitude": self.longitudDouble!,
                                    "municipality": self.municipalityString ?? "",
                                    "address": self.addressString ?? "",
                                    "userid": toId
                                ]
                                break
                                
                            case .adopt:
                                dataToSend = [
                                    "location": [
                                        "latitude": self.latitudeDouble!,
                                        "longitude": self.longitudDouble!,
                                        "municipality": self.municipalityString ?? "",
                                        "neighborhood": self.neighborhood ?? "",
                                        "address": self.addressString ?? "",
                                    ],
                                    "photoUrl": urlString,
                                    "postType": self.selectedPostCategory!.rawValue,
                                    "petType": self.selectedPet!.rawValue,
                                    "gender": self.selectedGender!.rawValue,
                                    "responsibleAdoption": self.responsibleAdoption!.rawValue,
                                    "breed": self.breed.text!,
                                    "phone": self.phone.text!,
                                    "timestamp": ServerValue.timestamp(),
                                    "comments": self.commentsTextView.text!,
                                    "latitude": self.latitudeDouble!,
                                    "longitude": self.longitudDouble!,
                                    "userid": toId
                                ]
                                break
                                
                            }
                            
                            self.sendDataToDatabase(data: dataToSend)
                        }
                        else {
                            ProgressHUD.showError("No has escogido una imagen")
                            print("couldn't get profile image url")
                            return
                        }
                    })
                }
            }
            else {
                
                ProgressHUD.showError("Tienes que subir una foto...")
            }
    }
    
// FUNCTION - ALERT

    func sendDataToDatabase(data:[String: Any]) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        //current user information
        newPostReference.setValue(data) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            ProgressHUD.showSuccess("Tu imagen ha sido publicada!")
            
            //set to empty fields
            self.empty()
  
            //TO HOME VIEW CONTROLLER
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func rewardQuantity() {
        
        let rewardQuantityInt = Int(self.rewardQuantityTextField.text!)
        
        switch self.selectedReward {
        case .withReward?:
            //Queremos igualar el valor del textfield a una variable para luego enviarla a Firebase
            rewardQuantityIntToDatabase = rewardQuantityInt
            print("Aqui esta el reward Quantity: \(rewardQuantityIntToDatabase)")
            break
            
        case .withoutReward?:
            rewardQuantityIntToDatabase = 0
            break
            
        default:
            break
        }
    }
    

    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func empty() {
        
        //Placeholder
        self.imagePosted.image = UIImage(named: "placeholder.png")
        
        //PostType
        self.changeImageLostButton.setImage(UIImage(named:"icon_lost_inactive.png"), for: .normal)
        self.changeImageFoundButton.setImage(UIImage(named:"icon_found_inactive.png"), for: .normal)
        self.changeImageAdoptButton.setImage(UIImage(named: "icon_adoption_inactive.png"), for: .normal)
        
        //PetType
        self.dogButton.setImage(UIImage(named: "icon_dog_inactive.png"), for: .normal)
        self.catButton.setImage(UIImage(named: "icon_cat_inactive.png"), for: .normal)
        self.otherPetButton.setImage(UIImage(named: "icon_otherpet_inactive.png"), for: .normal)
        
        //Gender
        self.maleButton.setImage(UIImage(named: "icon_male_inactive.png"), for: .normal)
        self.femaleButton.setImage(UIImage(named: "icon_female_inactive.png"), for: .normal)
        
        //ResponsibleAdoption
        self.responsibleAdoptionYesButton.setImage(UIImage(named: "checkmark_inactive.png"), for: .normal)
        self.responsibleAdoptionNoButton.setImage(UIImage(named: "cross_inactive.png"), for: .normal)
        
        //Reward
        self.rewardYesButton.setImage(UIImage(named: "checkmark_inactive.png"), for: .normal)
        self.rewardNoButton.setImage(UIImage(named: "cross_inactive.png"), for: .normal)
        self.rewardQuantityTextField.text = ""
        
        //Name
        self.nameTextField.text = ""
        
        //Breed
        self.breed.text = ""
        self.phone.text = ""
        
        //Comments
        self.commentsTextView.text = ""
        
    }

    //FUNCTIONS - to Hide button until information is inputed
    
    func enablePostButton() {
        
        var hideButton = false
        
        if selectedPostCategory == nil {
            hideButton = true
        }
        
        if selectedGender == nil {
            hideButton = true
        }
        
        if selectedPet == nil {
            hideButton = true
        }
        
        if selectedReward == .withReward, (rewardQuantityTextField.text?.count)! < 1 {
            hideButton = true
        }
        
        if selectedPostCategory == .adopt, (responsibleAdoption == nil)  {
            hideButton = true
        }
        
        if breed.text!.count < 1 {
            hideButton = true
        }
        
        if phone.text!.count < 1 {
            hideButton = true
        }
        
        if commentsTextView.text!.count < 1 {
               hideButton = true
        }
        
        
        if selectedPostCategory == .lost, (nameTextField.text?.count)!  < 1 {
            hideButton = true
        }

        postButton.isHidden = hideButton

    }

    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.allowsEditing = true
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    @objc func sendToMapView() {
        print("Se pico el locationView")
        
        performSegue(withIdentifier: "toLocationMap", sender: self)

    }
    
    
    
    
    func commentsTextViewIsEdited() {
        
        
        if commentsTextView.text! != "Commentarios Adicinales"   {
            commentsTextView.text = ""
            commentsTextView.textColor = UIColor.black
            
        }
        
        else {
            commentsTextView.textColor = UIColor.lightGray
        }
    }
    
    
    
    //prepare segue - this will help bring information from another ViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "toLocationMap":
            if let destinationViewController = segue.destination as? UINavigationController {
                destinationViewController.delegate = self
                if let vc = destinationViewController.viewControllers.first as? LocationViewController {
                    vc.delegate = self
                }
            }
            break
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tappable image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        imagePosted.addGestureRecognizer(tapGesture)
        imagePosted.isUserInteractionEnabled = true
        
        //TappableView
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.sendToMapView))
        locationView.addGestureRecognizer(locationTapGesture)
        locationView.isUserInteractionEnabled = true
        
        //User Info
        fetchUser()
        
        //LocationProtocol
        self.view.backgroundColor = UIColor.white
        scrollView.delegate = self
        
        commentsTextView.delegate = self
        
        enablePostButton()
        commentsTextViewIsEdited()
        rewardQuantity()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentsTextView.text = ""
        commentsTextView.textColor? = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        enablePostButton()
    }
}

//EXTENSION

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    
    {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            imagePosted.image = image
        }
        
        else {
            
            postButton.isHidden = true
            
        }
        
        
        self.dismiss(animated: true) {
            self.enablePostButton()
        }
        
    }
}

extension Date {
    
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension  PostViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView)
    }
    
}

extension PostViewController: MapViewControllerProtocol {
   

    func selectLocation(location: CLLocationCoordinate2D) {

        let geocoder = CLGeocoder()
        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(cllocation) { (places, error) in
            
            if let address = places?.first {
                let numero = "\(address.subThoroughfare ?? "")"
                let calleDireccion = "\(address.thoroughfare ?? "")"
                let addressTogether = "\(calleDireccion) \(numero)"
                self.addressString = addressTogether
                self.neighborhood = "\(address.subLocality ?? "")"
                self.municipalityString  = "\(address.locality ?? "")"
    
            }
            
            }
        
        
        self.latitudeDouble = location.latitude
        self.longitudDouble = location.longitude
        
        
        //GradientColor View
        locationViewTop.setGradientBackground(colorOne: colorTop, colorTwo: colorDown)
        self.selectLocationLabel.textColor = UIColor.white
        self.selectLocationLabel.text = "Ubicación Seleccionada"
    }
}

