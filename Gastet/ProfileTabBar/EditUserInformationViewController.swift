//
//  EditUserInformationViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 6/11/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditUserInformationViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //vars
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var selectedImage : UIImage!
    
    
    //@IBOUTLETS

    @IBOutlet weak var textFieldUiView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    //@IBACTIONS
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        
        saveButton.isHidden = false
        
    }
    
    
    @IBAction func saveInformationButton(_ sender: UIButton) {
        
        ProgressHUD.show("En Proceso...")
        //1. First you need to check that the user is logged in
        if let userId = Auth.auth().currentUser?.uid {
            
            //UPLOAD NEW PIC
            //create access point for Firebase Storage - profile pic
            let storageItem = storageRef.child("profileImages").child(userId)
            //get image from imageView
            guard let image = profilePicture.image else {return}
            
            if let newImage = UIImagePNGRepresentation(image) {
                
                storageItem.putData(newImage, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!)
                        ProgressHUD.showError("Ha habido un error. Intenta más tarde.")
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                            ProgressHUD.showError("Ha habido un error. Intenta más tarde.")
                            return
                        }
                        if let profilePhotoUrl = url?.absoluteString {
                            
                             //2. you create a new let statement to change the infomation
                             guard let newUserName = self.userTextField.text else {return}
                            
                            //3. now you need to create a new dictionary in order to write it back to the firebase dictionary
                            let newValuesForProfile =
                                [   "photoUrl" : profilePhotoUrl,
                                    "username": newUserName]
                            
                            //4. update firebase data for user
                            self.databaseRef.child("users").child(userId).updateChildValues(newValuesForProfile) { (error, ref) in
                                if error != nil {
                                    ProgressHUD.showError("Ha habido un error. Intenta más tarde.")
                                    print(error!)
                                    return
                                }
                                ProgressHUD.showSuccess("Tu perfil se ha editado!")
                                
                                //5. perform segue
                                self.dismiss(animated: true, completion: {
                                    self.tabBarController?.selectedIndex = 1
                                })
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    //make image tappable
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.allowsEditing = true
        self.present(pickerController, animated: true, completion: nil)
    }
    
    //chose image - image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
        
    {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profilePicture.image = image
        }
        
        else {
            
            saveButton.isHidden = true
            
        }
        
        self.dismiss(animated: true, completion: {
            self.saveButton.isHidden = false
            
        })
    }
    
    
    // display current user info
    
    func displayUserInformation() {
        
        let uid = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                self.userTextField.text = dict["username"] as? String
                
                if let profileImageUrl = dict["photoUrl"] as? String {
                    
                    let url = URL(string: profileImageUrl)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.profilePicture?.image = UIImage(data: data!)
                        }
                    }).resume()
                }
                
            }}, withCancel: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tappable image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
        
        saveButton.isHidden = true
        
        displayUserInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
