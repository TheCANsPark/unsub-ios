//
//  NetworkManager.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Alamofire
import AWSS3
import AWSAuthCore
import AWSMobileClient
import AWSUserPoolsSignIn
import AWSCognitoIdentityProviderASF

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
    
    
    func uploadVideo(videoFileUrl: URL, isVideo: Bool, imageUrl: URL, isCamera: Bool, imageData : NSData, filePath: URL, isFile :Bool, completionHandler :@escaping (_ urlImageVideo : URL) -> ()) {
        
        let ticks = Date().ticks
        var newKey: String = ""
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        if isCamera == true {
            var filePath:URL?
            let fileManager = FileManager.default
            
            if isVideo == true {
                newKey = "temp_folder/\(ticks).mov"
                uploadRequest?.body = videoFileUrl as URL
                uploadRequest?.contentType = "movie/mov"
                
            } else {
                let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                let folderPath = documentsPath.appendingPathComponent("\(1)")
                filePath = folderPath?.appendingPathComponent("\(ticks)")
                do {
                    try fileManager.createDirectory(atPath: folderPath!.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Unable to create directory!!!!")
                }
                do  {
                    try imageData.write(to: filePath!)
                    print("Successfully saved")
                } catch {
                    print("Unable to save file!!!!!")
                }
                newKey = "temp_folder/\(ticks).jpeg"
                uploadRequest?.body = filePath!
                uploadRequest?.contentType = "image/jpeg"
            }
            
            
        } else {//gallery
            if isVideo == true {
                newKey = "temp_folder/\(ticks).mov"
                uploadRequest?.body = videoFileUrl as URL
                uploadRequest?.contentType = "movie/mov"
                
            } else {
                newKey = "temp_folder/\(ticks).jpeg"
                uploadRequest?.body = imageUrl as URL
                uploadRequest?.contentType = "image/jpeg"
            }
        }
        
        //uploadRequest?.body = videoFileUrl as URL
        uploadRequest?.key = newKey
        uploadRequest?.bucket = "unsub-test-media-bucket"
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        //  uploadRequest?.contentType = "movie/mov"
        
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                let amountUploaded = totalBytesSent // To show the updating data status in label.
                print(amountUploaded)
            })
        }
        //url to be send on server
        var s3URL = NSURL(string: "https://s3-eu-west-1.amazonaws.com/unsub-test-media-bucket/\(newKey)")!
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) in
            if task.error != nil {
                s3URL = NSURL()
                print(task.error.debugDescription)
                completionHandler(s3URL as URL)
                
            } else {
                completionHandler(s3URL as URL)
                //https://s3-eu-west-1.amazonaws.com/unsub-test-media-bucket/temp_folder/636958313655505536.jpeg/
                //https://s3-eu-west-1.amazonaws.com/bucket_name/folder_name/file
                // Do something with your result.
                print("done")
            }
            return nil
        })
    }
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

    
    
    
    

