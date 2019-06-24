//
//  Incidents.swift
//  Unsub
//
//  Created by codezilla-mac1 on 13/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Gloss

struct Incidents : JSONDecodable {
    let address              : Address?
    let name             : Name?
    let images   : [URL]?
    let videos        : [URL]?
    let status        : String?
    
    let viewed_on              : String?
    let comments_count             : Int?
    let timeline_actions_count   : Int?
    let _id        : String?
    let email        : String?
    
    let victims_contact_number              : String?
    let phone_number              : String?
    let submitter_contact_number             : String?
    let Category   : Category?
    let crime_details        : String?
    let incident_date        : String?
    
    let user_id              : String?
    let attachment             : String?
    let incident_comments   : [Comments]?
    let updatedAt        : String?
    let createdAt        : String?
    let complaint_number        : String?
    let updated_on        : String?
    
    init?(json: JSON) {
        self.address = "address" <~~ json
        self.name = "name" <~~ json
        self.images = "images" <~~ json
        self.videos = "videos" <~~ json
        self.status = "status" <~~ json
        
        self.viewed_on = "viewed_on" <~~ json
        self.comments_count = "comments_count" <~~ json
        self.timeline_actions_count = "timeline_actions_count" <~~ json
        self._id = "_id" <~~ json
        self.email = "email" <~~ json
    
        self.victims_contact_number = "victims_contact_number" <~~ json
        self.submitter_contact_number = "submitter_contact_number" <~~ json
         self.phone_number = "phone_number" <~~ json
        self.Category = "Category" <~~ json
        self.crime_details = "crime_details" <~~ json
        self.incident_date = "incident_date" <~~ json
        
        self.user_id = "_id" <~~ json
        self.attachment = "attachment" <~~ json
        self.incident_comments = "incident_comments" <~~ json
        self.updatedAt = "updatedAt" <~~ json
        self.createdAt = "createdAt" <~~ json
        self.complaint_number = "complaint_number" <~~ json
        self.updated_on = "updated_on" <~~ json
    }
}
struct Name : JSONDecodable {
    let first              : String?
    let last             : String?
   
    init?(json: JSON) {
        self.first = "first" <~~ json
        self.last = "last" <~~ json
    }
}
struct Address : JSONDecodable {
    let lat              : String?
    let long             : String?
    let address   : String?
   
    init?(json: JSON) {
        self.lat = "lat" <~~ json
        self.long = "long" <~~ json
        self.address = "address" <~~ json
    }
}
struct Category : JSONDecodable {
    let _id              : String?
    let name             : String?
  
    init?(json: JSON) {
        self._id = "_id" <~~ json
        self.name = "name" <~~ json
    }
}
struct Comments : JSONDecodable {
    let _id              : String?
    let comment          : String?
    let date             : String?
    let commented_by     : String?
    let user_id          : User?
    let name             : Name?
    
    init?(json: JSON) {
        self._id = "_id" <~~ json
        self.comment = "comment" <~~ json
        self.date = "date" <~~ json
        self.commented_by = "commented_by" <~~ json
        self.user_id = "user_id" <~~ json
        self.name = "name" <~~ json
    }
}
struct User : JSONDecodable {
    let fullName        : String?
    let stackholder_name   : String?
    let _id             : String?
    
    init?(json: JSON) {
        self.fullName = "fullName" <~~ json
        self.stackholder_name = "stackholder_name" <~~ json
        self._id = "_id" <~~ json
    }
}

