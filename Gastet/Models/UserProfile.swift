//
//  UserProfile.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 7/27/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import Foundation

class UserProfile {
    
    var uid: String?
    var username: String?
    var photoUrl: String?
    var email: String?
}

extension UserProfile {

    static func transformUser(dict: [String: Any]) -> UserProfile {
        let user = UserProfile()
        user.email = dict["email"] as? String
        user.photoUrl = dict["photoUrl"] as? String
        user.username = dict["username"] as? String
        return user
    }
}
