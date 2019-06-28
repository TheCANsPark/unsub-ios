//
//  Timeline.swift
//  Unsub
//
//  Created by codezilla-mac1 on 18/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Gloss

struct TimelineData : JSONDecodable {
    let user_name              : String?
    let action             : String?
    let createdAt        : String?
    let subject        : String?
    
    init?(json: JSON) {
        self.user_name = "user_name" <~~ json
        self.action = "action" <~~ json
        self.createdAt = "createdAt" <~~ json
        self.subject = "subject" <~~ json
    }
}

struct  IncidentData : JSONDecodable {
    let incident_details              : String?
    let incident_date             : String?
    let complaint_number   : String?
   
    init?(json: JSON) {
        self.incident_details = "incident_details" <~~ json
        self.incident_date = "incident_date" <~~ json
        self.complaint_number = "complaint_number" <~~ json
       
    }
}
