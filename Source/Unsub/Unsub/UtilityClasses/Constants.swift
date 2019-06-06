//
//  Constants.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import UIKit


let BASE_URL = "http://192.168.1.109:4000/"


struct WEB_URL {
    static let signUp                    = BASE_URL + "user/sign-up"
}


struct STATUS_CODE {
    static let badRequest          = 400
    static let tokenExpire         = 401
    static let success             = 200
    static let successButEmpty     = 204
    static let urlNotFound         = 404
    static let internalServerError = 500
}
