//  ProfileUserPosts.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 8/15/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileUserPosts {
    
    //Post ID
    var postid : String?
    
    //Image
    var photoUrl: URL?
    
    //PostInformation View
    var name: String?
    var address: String?
    var breed : String?
    var phone : String?
    var city: String?
    var municipality: String?

    //Comments Count
    
    var petType: String?
    var postType: String?
    var genderType: String?
    var comments: String?
    
    //Timestamp
    var timestamp: Date?
    var timestampDouble: TimeInterval?
    
    func getDateFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter.string(from: self.timestamp!)
    }
}

extension ProfileUserPosts {
    
    static func transformPost(dict: [String: Any], key: String) -> ProfileUserPosts {
        
        let post = ProfileUserPosts()
        
        //Post Id
        post.postid = key
        
        //Post Picture
        let photoUrl = dict["photoUrl"] as? String
        post.photoUrl = URL(string: photoUrl!)
        
        //INFO POSTS
        post.city = dict["city"] as? String
        post.municipality = dict["municipality"] as? String
        post.name = dict["name"] as? String
        post.breed = dict["breed"] as? String
        post.phone = dict["phone"] as? String
        post.address = dict["address"] as? String
        post.comments = dict["comments"] as? String
        post.petType = dict["petType"] as? String
        post.postType = dict["postType"] as? String
        post.genderType = dict["gender"] as? String
        let timestamp = dict["timestamp"] as? Double
        post.timestamp = Date(timeIntervalSince1970: timestamp!/1000)
        
        return post
    }
}
