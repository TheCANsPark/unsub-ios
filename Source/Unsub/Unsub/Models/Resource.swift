//
//  Resource.swift
//  Unsub
//
//  Created by codezilla-mac1 on 18/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Gloss

struct Resource : JSONDecodable {
    let _id              : String?
    let name             : String?
    let description   : String?
    let updatedAt        : String?
    let createdAt        : String?
    let media_url        : String?
    let category        : String?
    let __v              : Int?
    
    init?(json: JSON) {
        self._id = "_id" <~~ json
        self.name = "name" <~~ json
        self.description = "description" <~~ json
        self.updatedAt = "updatedAt" <~~ json
        self.createdAt = "createdAt" <~~ json
        self.media_url = "media_url" <~~ json
        self.category = "category" <~~ json
        self.__v = "__v" <~~ json
    }
}
