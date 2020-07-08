//
//  LoginViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 4/26/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet var panToClose: InteractionPanToClose!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //FIREBASE - COMPLETE CODE IN AuthService.swift
        AuthService.signIn(email: username.text!, password: password.text!, onSuccess: {
            self.performSegue(withIdentifier: "successfulLoginSegue", sender: self)
        }, onError: { error in
            print(error!)
        })
    }
    
    
    //ALERT
    
        func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
                                                        }

    override func viewDidLoad() {
        super.viewDidLoad()
        panToClose.setGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "successfulLoginSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
