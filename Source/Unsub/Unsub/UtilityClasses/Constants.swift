//
//  Constants.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import UIKit

//Keys
let kDictTokens       = "dictTokens"
let kAccessToken      = "accessToken"
let kRefreshToken     = "refreshToken"
let kLogin            = "isLogin"
//Variables
var isLogin : Bool = false

//URL
let BASE_URL = "http://192.168.1.109:4000/"

//let BASE_URL = "http://104.154.76.106:4000" //Live


struct WEB_URL {
    static let signUp                    = BASE_URL + "user/sign-up"
    static let login                     = BASE_URL + "login"
    static let contacts                  = BASE_URL + "emergency-contacts"
    static let categories                = BASE_URL + "categories"
    static let createIncidents           = BASE_URL + "user/incident"
    static let getIncidents              = BASE_URL + "incidents/user/list"
    static let getProfile                = BASE_URL + "user/profile"
}


struct STATUS_CODE {
    static let badRequest          = 400
    static let pendingAction       = 404
    static let success             = 200
    static let successButEmpty     = 204
    static let urlNotFound         = 404
    static let internalServerError = 500
    static let verifyEmail         = 403
    static let tokenExpire         = 401
}
