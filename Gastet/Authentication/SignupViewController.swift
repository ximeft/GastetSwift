//
//  ViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 4/9/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController, UITextFieldDelegate{

    var signupModeActive = true
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    @IBAction func switchLoginMode(_ sender: Any) {
        //BUTTON TO SWITCH FROM LOGIN TO SIGNUP MODE
        performSegue(withIdentifier: "toLoginViewController", sender: self)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if email.text == "" || password.text == "" || userTextField.text == "" {
            displayAlert(title: "Falta Información", message: "Necesitas proveernos con la información requerida: usuario, email, y contraseña")
        }
        else {
            AuthService.signUp(username: userTextField.text!, email: email.text!, password: password.text!, onSuccess: {
             self.performSegue(withIdentifier: "toProfileSelectImage", sender: self)
            }, onError: { error in
                print(error!)
                ProgressHUD.showError(error)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PROBLEM 2 - SO THAT I CAN USE KEYBOARD DISMISSAL FUNCTIONS
        email.delegate = self
        password.delegate = self
        
        //PROBLEM 1 - LISTEN TO WHAT KEYBOARD IS SAYING
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)

    }
    
    deinit {
        //PROBLEM 1 - Stop Listening for keyboard to hide/show  events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "signUpToHomeView", sender: self)
        }
    }
    
                                                //METHODS OR FUNCTIONS//
    
    
    // ALERTAS - FUNC hecho para utilizar Alertas dependindo del caso
    func displayAlert(title:String, message:String) {
        
        //ALERT FOR WHEN NO TEXT IS ENTERED IN EMAIL AND PASSWORD FIELD
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    //PROBLEM 2 - FUNC SO THAT WHEN YOU TOUCH OUTSIDE KEYBOARD IT WILL BE DISMISSED
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    //PROBLEM 2 - FUNC SO THAT KEYBOARD IS DISMISSED
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            textField.resignFirstResponder()
            
            // si quiero usar return para pasar al proximo text field usar el siguiente -- password.becomeFirstResponder()
            //password.becomeFirstResponder()
            
        } else if textField == password {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //PROBLEM 2 - MOVE SCREEN SO KEYBOARD DOESN'T HIDE TEXTFIELD
    @objc func keyboardWillChange(notification: Notification) {

        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
    
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame ||
            notification.name == Notification.Name.UIKeyboardDidChangeFrame {
            
            view.frame.origin.y =  -keyboardRect.height
            
        } else {
            //SOLVE 1 - TAKES TOO LONG TO RETURN TO ORIGINAL VIEW AND BLACK SPOT IS VIEWED
            
            view.frame.origin.y = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//PROBLEM 1 = Moving UITextfield View When the Keyboard Appears in Swift = because it covered textfield
//PROBLEM 2 = Hide Keyboard (Swift 4 + Xcode 9.0) = hiding keyboard

//SOLVE
// SOLVE 1 = When keyboard is returned to original view, you can see for a few seconds the black screen
//SOLVE 2 = Cuando un usuario que ya existe quiere volver a registrarse, la notificación aparece en ingles.

