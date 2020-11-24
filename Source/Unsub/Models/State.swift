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

struct LGA : JSONDecodable {
    let _id              : String?
    let name             : String?
    
    init?(json: JSON) {
        self._id = "_id" <~~ json
        self.name = "name" <~~ json
        
    }
}


/*"_id" = 5c3c436f8a734a43f54a3503;
name = GULANI;
state = 5c3c436d8a734a43f54a31d4;*/
