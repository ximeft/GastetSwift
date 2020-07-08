//
//  AuthService.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 7/20/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping ()-> Void, onError: @escaping (_ errorMessage: String?)-> Void) {
    
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
            onError(error!.localizedDescription)
            return
            }
            onSuccess()
            }
    }
    
    static func signUp(username: String, email: String, password: String, onSuccess: @escaping ()-> Void, onError: @escaping (_ errorMessage: String?)-> Void) {
       
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                onError(error!.localizedDescription)
                return
                }
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let usersReference = ref.child("users")
                let uid = Auth.auth().currentUser?.uid
                let newUserReference = usersReference.child(uid!)
                newUserReference.setValue(["username": username, "email": email])
            })
                onSuccess()
        }
    
    static func currentUserSigned(onSuccess: @escaping ()-> Void, onError: @escaping (_ errorMessage: String?)-> Void) {
        
        Auth.auth().addStateDidChangeListener() { auth, user in
        if user != nil {
            // User is signed in.
            print("start login success: " + (user?.email)! )
            //self.performSegue(withIdentifier: loginToList, sender: nil)
        } else {
            // No user is signed in.
            print("No user is signed in.")
        }
        
        }

    }
    
}


//VIDEOS USED FOR THESE PRACTICES: https://www.youtube.com/watch?v=Lng4NPCr-Io&t=103s
