//
//  Comment.swift
//  Gastet
//
//  Created by Ximena Flores de la Tijera on 11/22/18.
//  Copyright © 2018 ximeft29. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Comment {
    
    //Information
    var commentText: String?
    var userid: String?
    
}

extension Comment {
    
    static func transformComment(dict: [String: Any]) -> Comment {
        
        let comment = Comment()
        
        //INFO POSTS
        comment.commentText = dict["commentText"] as? String
        comment.userid = dict["userid"] as? String
        return comment
        
    }
}
