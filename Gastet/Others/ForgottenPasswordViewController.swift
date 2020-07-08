//
//  ForgottenPasswordViewController.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 5/2/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import Parse

class ForgottenPasswordViewController: UIViewController {

    func displayAlert(title:String, message:String) {
        
        //ALERT FOR WHEN NO TEXT IS ENTERED IN EMAIL AND PASSWORD FIELD
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var panToClose: InteractionPanToClose!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func recoverPasswordButton(_ sender: Any) {
    
        PFUser.requestPasswordResetForEmail(inBackground: emailTextField.text!, block: { (success, error) in
            
            if self.emailTextField != nil {
               
                //PONER UN SPINNER - CHECA UDEMY
                
                self.displayAlert(title: "Revisa tu correo electronico", message: "Se ha mandado un link para recuperar contraseña exitosamente. Sigue las instrucciones.")
                
                print("Se ha mandado un link para recuperar contraseña exitosamente")
                
            } else {
                
                var errorText = "Error desconocido: porfavor intente de nuevo"
                
                if let error = error {
                    
                    errorText = error.localizedDescription
                }
                self.displayAlert(title: "El email no es valido", message: errorText)
                
            }
        })
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        panToClose.setGestureRecognizer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
