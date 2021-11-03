//
//  Forum.swift
//  Unsub
//
//  Created by mac on 26/10/21.
//  Copyright © 2021 codezilla-mac1. All rights reserved.
//

import Foundation
import Gloss

struct Forum : JSONDecodable {
    let _id              : String?
    let description      : String?
    let image_url        : String?
    let title            : String?
    var total_likes      : Int?
    let user_id          : String?
    let updatedAt        : String?
    
    init?(json: JSON) {
        self._id         = "_id" <~~ json
        self.description = "description" <~~ json
        self.image_url   = "image_url" <~~ json
        self.title       = "title" <~~ json
        self.total_likes = "total_likes" <~~ json
        self.user_id      = "user_id" <~~ json
        self.updatedAt    = "updatedAt" <~~ json
    }
}


struct ForumComment : JSONDecodable {
    let _id              : String?
    let comment          : String?
    let total_likes      : Int?
    let forum_id         : String?
    let updatedAt        : String?
    let user_id          : ForumUser?
    
    init?(json: JSON) {
        self._id         = "_id" <~~ json
        self.comment     = "comment" <~~ json
        self.total_likes  = "total_likes" <~~ json
        self.forum_id       = "forum_id" <~~ json
        self.updatedAt = "updatedAt" <~~ json
        self.user_id      = "user_id" <~~ json
    }
}


struct ForumUser : JSONDecodable {
    let _id              : String?
    let name             : ForumUserName?
  
    
    init?(json: JSON) {
        self._id         = "_id" <~~ json
        self.name        = "name" <~~ json
       
    }
}

struct ForumUserName : JSONDecodable {
    let first            : String?
    let last             : String?
    
    
    init?(json: JSON) {
        self.first         = "first" <~~ json
        self.last     = "last" <~~ json
    }
}
