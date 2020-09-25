
//
//  Contacts.swift
//  Unsub
//
//  Created by codezilla-mac1 on 10/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Gloss

struct Contacts : JSONDecodable {
    let _id              : String?
    let name             : String?
    let contact_number   : String?
    let updatedAt        : String?
    let createdAt        : String?
    let __v              : Int?
    
    init?(json: JSON) {
        self._id = "_id" <~~ json
        self.name = "name" <~~ json
        self.contact_number = "contact_number" <~~ json
        self.updatedAt = "updatedAt" <~~ json
        self.createdAt = "createdAt" <~~ json
        self.__v = "__v" <~~ json
    }
}
