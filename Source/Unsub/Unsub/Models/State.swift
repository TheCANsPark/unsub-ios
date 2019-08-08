//
//  State.swift
//  Unsub
//
//  Created by codezilla-mac1 on 08/08/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Gloss

struct State : JSONDecodable {
    let _id              : String?
    let name             : String?
    
    
    init?(json: JSON) {
        self._id = "_id" <~~ json
        self.name = "name" <~~ json
        
    }
}
