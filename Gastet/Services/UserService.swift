//
//  UserService.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 7/27/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import Foundation
import Firebase


class UserService {
    
    static var users = [UserProfile]()
    static var currentUserProfile:UserProfile?
    
    //ORIGINAL CODE TO GRAB AUTHOR
    
//    static func observeUserProfile(_ uid: String, completion: @escaping ((_ userProfile: UserProfile?)-> ()) ) {
//
//        let userRef = Database.database().reference().child("users/\(uid)")
//        userRef.observe(.value) { (snapshot) in
//            var userProfile:UserProfile?
//
//            if let dict = snapshot.value as? [String: Any],
//                let username = dict["username"] as? String,
//                let photoUrl = dict["photoUrl"] as? String,
//                let url = URL(string: photoUrl) {
//
////                userProfile = UserProfile(uid: snapshot.key, username: username, photoUrl: url)
//
//                userProfile = UserProfile.transformUser(dict: dict)
//            }
//            completion(userProfile)
//
//        }
//    }
    
//    static func observeUserProfile( userid: String, completed:  @escaping ()-> Void) {
//
//            Database.database().reference().child("users").child(userid).observeSingleEvent(of: .value) { (snapshot) in
//                if let dict = snapshot.value as? [String: Any] {
//                    let user = UserProfile.transformUser(dict: dict)
//                    self.users.append(user)
//                    completed()
//                }
//            }
//    }


}
