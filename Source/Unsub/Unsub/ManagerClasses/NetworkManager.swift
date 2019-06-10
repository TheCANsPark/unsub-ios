//
//  NetworkManager.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Alamofire
class NetworkManager {
    static let sharedInstance = NetworkManager()
    //MARK:- Post
    func apiParsePost(_ url:NSString, postParameters:NSDictionary?, completionHandler:@escaping ( _ response:NSDictionary?,_ statusCode: Int?)->()) {
        
        let urlString  = url as String
        var header = HTTPHeaders()   
        if url as String == WEB_URL.login {
            header = ["Authorization"    : "Basic VU5TVUI6VU5TVUIxMjM=",
                      "Content-Type"     : "application/x-www-form-urlencoded"]
        } else {
            header = ["Content-Type" : "application/x-www-form-urlencoded"]
        }
        
        
             //   header = ["Authorization" : "Token \(token)",
                         //"Content-Type" : "application/json"]
        
        Alamofire.request(urlString, method: .post, parameters: postParameters as? Parameters, headers: header).responseJSON {
            response in
            
            let  statusCode = response.response?.statusCode
            print(statusCode ?? "")
            print("url is: \(urlString)")
            print("post parameters: \(String(describing: postParameters))")
            print("header : \(header)")
            print("response is: \(response)")
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(nil,statusCode)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("Response is not in JSON format")
                //print("Error: \(response.result.error ?? "" as? String)")
                completionHandler(nil,statusCode)
                return
            }
         /*   if statusCode == STATUS_CODE.tokenExpire {
                self.getNewRefreshTokenAndAccessToken(completionHandler: {(status :Int?) in
                    if status == STATUS_CODE.success {
                        self.apiParsePost(urlString as NSString,postParameters: postParameters , completionHandler: {
                            json , statusCode in
                            completionHandler(json as NSDictionary?, statusCode)
                        })
                    }
                })
            }*/
            completionHandler(json as NSDictionary?,statusCode)
        }
    }
    //MARK:- GetNewRefreshToken
   /* func getNewRefreshTokenAndAccessToken(completionHandler:@escaping(_ statusCode: Int?)->()){
        
        let param = ["refresh_token":AppSharedData.sharedInstance.getAccessTokenAndRefreshToken()!.value(forKey: kRefreshToken)!] as [String:Any]
        
        //        var header = HTTPHeaders()
        //        header = ["Authorization":"Token \(AppSharedData.sharedInstance.getAccessTokenAndRefreshToken()!.value(forKey: kAccessToken)!)"]
        let urlString = WEB_URL.getRefeshToken
        Alamofire.request(urlString, method: .post, parameters: param ,headers: nil).responseJSON{ response in
            let  statusCode = response.response?.statusCode
            print(statusCode!)
            print("url is: \(urlString)")
            print("post parameters: \(String(describing: param))")
            //  print("header : \(header)")
            print("response is: \(response)")
            
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(0)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("Response is not in JSON format")
                print("Error: \(response.result.error!)")
                completionHandler(0)
                return
            }
            if statusCode == STATUS_CODE.success {
                let response = json as NSDictionary?
                let userResponse = response?.value(forKey: "response") as! NSDictionary
                if let access_token = userResponse.value(forKey: "access_token") , let refresh_token = userResponse.value(forKey: "refresh_token"){
                    AppSharedData.sharedInstance.saveAccessTokenAndRefreshToken(accessToken: access_token as! String, refreshtoken: refresh_token as! String)
                }
            }
            completionHandler(statusCode)
        }
    }*/
    
    //MARK:- Get
    func apiParseGet(url: String,completion: @escaping (_ response: NSDictionary?)-> ()){
        
        var header = HTTPHeaders()
        if UserDefaults.standard.bool(forKey: kLogin) == true && url == WEB_URL.contacts {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken) as! String
                header = ["Authorization"  : "Token \(token)"]
        } else {
            header = [:]
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {(responseData) -> Void in
            
            
            let  statusCode = responseData.response?.statusCode
            print(statusCode ?? "")
            print("url is: \(url)")
            print("header : \(header)")
            print("response is: \(responseData)")
            // Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                switch responseData.result {
                case .success:
                    if let value = responseData.result.value {
                        completion(value as? NSDictionary)
                    }
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
}
