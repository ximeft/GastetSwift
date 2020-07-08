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
        


        
        performSegue(withIdentifier: "toHome", sender: self)
        
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
