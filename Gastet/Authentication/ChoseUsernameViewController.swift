//
//  ChoseUsernameViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 4/28/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import Parse
import FirebaseDatabase
import FirebaseAuth

class ChoseUsernameViewController: UIViewController {
    
    //@IBOUTLET
    
    @IBOutlet weak var userTextField: UITextField!
    
    //FUNCTION ALERT
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //@IBACTION - NEED TO PUT IF LET STATEMENTS FOR WHEN USERNAME IS TAKEN
    
    @IBAction func nextTapButton(_ sender: Any) {
 
        //FIREBASE

        let user = Auth.auth().currentUser
    
        if (user) != nil {
            let reference = Database.database().reference()
            let userReference = reference.child("users")
            let uid = user?.uid
            let newUserReference = reference.child(uid!)
            newUserReference.setValue(["username": self.userTextField.text!])
        }
        //Invita amigos
        let shareMessage = "Hola! Me acabo de inscribir al app de Gastet para poder reportar una mascota. Me podrías ayudar a pasar la voz al meterte al app y compartir mi publicación por whatsapp? Te paso el link del app: https://itunes.apple.com/mx/app/gastet/id1407059324?l=en&mt=8"
        shareWhatssapp(message: shareMessage)

        //segue
        performSegue(withIdentifier: "toHome", sender: self)
        
 
    }
    
    //whatsapp
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
