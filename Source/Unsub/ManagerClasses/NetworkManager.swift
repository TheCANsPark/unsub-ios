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
import AES256CBC




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
      
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            let urlString  = url as String
            if urlString  == WEB_URL.commentQuery {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken)!
                header = ["Content-Type"   : "application/json",
                          "Authorization"  : "Bearer \(token)"]
            } else {
                header = ["Content-Type" : "application/x-www-form-urlencoded"]
            }
            
        }
        
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
            if statusCode == STATUS_CODE.tokenExpire {
                self.getNewRefreshTokenAndAccessToken(completionHandler: {(status :Int?) in
                    if status == STATUS_CODE.success {
                        self.apiParsePost(urlString as NSString,postParameters: postParameters , completionHandler: {
                            json , statusCode in
                            completionHandler(json as NSDictionary?, statusCode)
                        })
                    }else if status == STATUS_CODE.internalServerError {
                        UserDefaults.standard.set(nil, forKey: kDictTokens)
                        UserDefaults.standard.set(false, forKey: kLogin)
                        UserDefaults.standard.set(nil, forKey: kLoginResponse)
                    }
                })
            }
            completionHandler(json as NSDictionary?,statusCode)
        }
    }
    //MARK:- Put
    func apiParsePut(_ url:NSString, postParameters:NSDictionary?, completionHandler:@escaping ( _ response:NSDictionary?,_ statusCode: Int?)->()) {
        
        let urlString  = url as String
        var header = HTTPHeaders()
        
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            let urlString  = url as String
            if  urlString == WEB_URL.getProfile {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken)!
                header = ["Content-Type"   : "application/json",
                          "Authorization"  : "Bearer \(token)"]
            } else {
                header = ["Content-Type" : "application/x-www-form-urlencoded"]
            }
        }
        
        
        Alamofire.request(urlString, method: .put, parameters: postParameters as? Parameters, headers: header).responseJSON {
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
            if statusCode == STATUS_CODE.tokenExpire {
                self.getNewRefreshTokenAndAccessToken(completionHandler: {(status :Int?) in
                    if status == STATUS_CODE.success {
                        self.apiParsePost(urlString as NSString,postParameters: postParameters , completionHandler: {
                            json , statusCode in
                            completionHandler(json as NSDictionary?, statusCode)
                        })
                    }else if status == STATUS_CODE.internalServerError {
                        UserDefaults.standard.set(nil, forKey: kDictTokens)
                        UserDefaults.standard.set(false, forKey: kLogin)
                        UserDefaults.standard.set(nil, forKey: kLoginResponse)
                    }
                })
            }
            completionHandler(json as NSDictionary?,statusCode)
        }
    }
     //MARK:- Post With JsonEncoding
    func apiParsePostWithJsonEncoding(_ url:NSString, postParameters:NSDictionary?, completionHandler:@escaping ( _ response:NSDictionary?,_ statusCode: Int?)->()) {
        
        let urlString  = url as String
        var header = HTTPHeaders()
        
        if url as String == WEB_URL.createIncidents {
            if UserDefaults.standard.bool(forKey: kLogin) == true {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken)!
                header = ["Content-Type"   : "application/json",
                          "Authorization"  : "Bearer \(token)"]
            } else {
                header = ["Content-Type"   : "application/json",
                          "Authorization"  : "Bearer any"]
            }
        }
        if url as String == WEB_URL.commentQuery || urlString == WEB_URL.changePassword  {
            if UserDefaults.standard.bool(forKey: kLogin) == true {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken)!
                header = ["Content-Type"   : "application/json",
                          "Authorization"  : "Bearer \(token)"]
            }
        }
        
        print("Header: \(header)")
        
        Alamofire.request(urlString, method: .post, parameters: postParameters as? Parameters, encoding: JSONEncoding.default, headers: header).responseJSON {
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
               if statusCode == STATUS_CODE.tokenExpire {
                self.getNewRefreshTokenAndAccessToken(completionHandler: {(status :Int?) in
                    if status == STATUS_CODE.success {
                        self.apiParsePost(urlString as NSString,postParameters: postParameters , completionHandler: {
                            json , statusCode in
                            completionHandler(json as NSDictionary?, statusCode)
                        })
                    }else if status == STATUS_CODE.internalServerError {
                        UserDefaults.standard.set(nil, forKey: kDictTokens)
                        UserDefaults.standard.set(false, forKey: kLogin)
                        UserDefaults.standard.set(nil, forKey: kLoginResponse)
                    }
                })
             }
            completionHandler(json as NSDictionary?,statusCode)
        }
    }
    
    //MARK:- GetNewRefreshToken
    func getNewRefreshTokenAndAccessToken(completionHandler:@escaping(_ statusCode: Int?)->()){
        
        let param = ["refresh_token": AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kRefreshToken)!,
                      "grant_type" : "refresh_token"] as [String:Any]
        
        var header = HTTPHeaders()
        header = ["Authorization":"Basic VU5TVUI6VU5TVUIxMjM=",
                  "Content-Type" : "application/x-www-form-urlencoded"]
        
        let urlString = WEB_URL.login
        //Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ response in
        Alamofire.request(urlString, method: .post, parameters: param ,headers: header).responseJSON{ response in
            let  statusCode = response.response?.statusCode
            print(statusCode!)
            print("url is: \(urlString)")
            print("post parameters: \(String(describing: param))")
             print("header : \(header)")
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
                let userResponse = response?.value(forKey: "data") as! NSDictionary
                if let access_token = userResponse.value(forKey: "accessToken") , let refresh_token = userResponse.value(forKey: "refreshToken"){
                    AppSharedData.sharedInstance.saveAccessTokenAndRefreshToken(accessToken: access_token as! String, refreshToken: refresh_token as! String)
              
                }
            }
            completionHandler(statusCode)
        }
    }
    
    //MARK:- Get
    func apiParseGet(url: String,completion: @escaping (_ response: NSDictionary?,_ statusCode : Int?)-> ()){
        
        var header = HTTPHeaders()
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            if  url == WEB_URL.contacts || url == WEB_URL.getIncidents || url == WEB_URL.getProfile || url.contains(WEB_URL.getIncidentDetails) || url == WEB_URL.getResourceCategory || url == WEB_URL.getComments || url.contains(WEB_URL.getTimeline)   {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken) as! String
                header = ["Authorization"  : "Bearer \(token)"]
            }
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
                        if statusCode == STATUS_CODE.tokenExpire {
                            self.getNewRefreshTokenAndAccessToken(completionHandler: {(status :Int?) in
                                if status == STATUS_CODE.success {
                                    self.apiParseGet(url: url , completion: { json , statusCode in
                                        
                                        completion(json as NSDictionary?, statusCode)
                                    })
                                }else if status == STATUS_CODE.internalServerError {
                                    UserDefaults.standard.set(nil, forKey: kDictTokens)
                                    UserDefaults.standard.set(false, forKey: kLogin)
                                    UserDefaults.standard.set(nil, forKey: kLoginResponse)
                                }
                            })
                        }
                        completion(value as? NSDictionary, statusCode)
                    }
                case .failure(_):
                    completion(nil, statusCode)
                }
            }
        }
    }
    
    
    func uploadVideo(videoFileUrl: URL, isVideo: Bool, imageUrl: URL, isCamera: Bool, imageData : NSData, filePath: URL, isFile :Bool,isVoice :Bool = false, completionHandler :@escaping (_ urlImageVideo : URL) -> ()) {
        
        let ticks = Date().ticks
        var newKey: String = ""
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        if isCamera == true {
            var filePath:URL?
            let fileManager = FileManager.default
            
            if isVideo == true {
                newKey = "temp_folder/\(ticks).mp4"
                uploadRequest?.body = videoFileUrl as URL
                uploadRequest?.contentType = "movie/mp4"
                
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
                newKey = "temp_folder/\(ticks).mp4"
                uploadRequest?.body = videoFileUrl as URL
                uploadRequest?.contentType = "movie/mp4"
                
            } else {
                newKey = "temp_folder/\(ticks).jpeg"
                uploadRequest?.body = imageUrl as URL
                uploadRequest?.contentType = "image/jpeg"
            }
        }
        if isFile == true {
            newKey = "temp_folder/\(ticks).pdf"
            uploadRequest?.body = filePath as URL
            uploadRequest?.contentType = "file/pdf"
        }
        
        if isVoice == true {
            newKey = "temp_folder/\(ticks).wav"
            uploadRequest?.body = videoFileUrl as URL
            uploadRequest?.contentType = "audio/vnd.wav"
        }
        
        //uploadRequest?.body = videoFileUrl as URL
        uploadRequest?.key = newKey
        uploadRequest?.bucket = s3Bucket  //"unsub-test-media-bucket"
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicReadWrite  //publicRead
        //  uploadRequest?.contentType = "movie/mov"
        
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                let amountUploaded = totalBytesSent // To show the updating data status in label.
                print(amountUploaded)
            })
        }
        //url to be send on server
        var s3URL = NSURL(string: "\(newKey)")!
      //  completionHandler(s3URL as URL)
        
        //Export to server
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) in
            if task.error != nil {
                s3URL = NSURL()
                print(task.error.debugDescription)
                completionHandler(s3URL as URL)
                
            } else {
                completionHandler(s3URL as URL)
                //https://s3-eu-west-1.amazonaws.com/unsub-stage/temp_folder/636958313655505536.jpeg/
                //https://s3-eu-west-1.amazonaws.com/[[bucket_name]]/folder_name/file
                
                // Do something with your result.
                print("done")
            }
            return nil
        })
    }
    
    func uploadVoice(videoFileUrl: URL, isVideo: Bool, imageUrl: URL, isCamera: Bool, imageData : NSData, filePath: URL, isFile :Bool,isVoice: Bool = false, completionHandler :@escaping (_ urlImageVideo : URL) -> ()) {
        
        var completionHandler1: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        
        let Url = videoFileUrl
        
        let ticks = Date().ticks
        let key = "temp_folder/\(ticks).mp4"
        
        let expression  = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task: AWSS3TransferUtilityTask,progress: Progress) -> Void in
          print(progress.fractionCompleted)   //2
          if progress.isFinished{           //3
            print("Upload Finished...")
            //do any task here.
          }
        }
        
        expression.setValue("public-read-write", forRequestHeader: "x-amz-acl")   //4
        expression.setValue("public-read-write", forRequestParameter: "x-amz-acl")

        var s3URL = NSURL(string: "\(key)")!
        
        completionHandler1 = { (task:AWSS3TransferUtilityUploadTask, error:NSError?) -> Void in
            if(error != nil){
                print("Failure uploading file")
                s3URL = NSURL()
                completionHandler(s3URL as URL)
            }else{
                print("Success uploading file")
                completionHandler(s3URL as URL)
            }
        } as? AWSS3TransferUtilityUploadCompletionHandlerBlock
        
        //5
        AWSS3TransferUtility.default().uploadFile(Url, bucket: s3Bucket, key: String(key), contentType: "movie/mp4", expression: expression, completionHandler: completionHandler1).continueWith(block: { (task:AWSTask) -> AnyObject? in
            if(task.error != nil){
                print("Error uploading file: \(String(describing: task.error?.localizedDescription))")
                s3URL = NSURL()
                completionHandler(s3URL as URL)
            }
            if(task.result != nil){
                print("Starting upload...")
            }
            return nil
        })
        
//        let ticks = Date().ticks
//        let newKey = "temp_folder/\(ticks).wav"
//
//        let request = AWSS3TransferManagerUploadRequest()
//        request?.bucket = s3Bucket  //3
//        request?.key = newKey  //4
//        request?.body = videoFileUrl
//        request?.acl = .publicReadWrite  //5
//
//        request?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
//            DispatchQueue.main.async(execute: {
//                let amountUploaded = totalBytesSent // To show the updating data status in label.
//                print(amountUploaded)
//            })
//        }
//
//        //url to be send on server
//        var s3URL = NSURL(string: "\(newKey)")!
//
//        //6
//        let transferManager = AWSS3TransferManager.default()
//        transferManager.upload(request!).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
//
//            if task.result != nil {   //7
//                print("Uploaded \(s3URL)")
//                completionHandler(s3URL as URL)
//            }else {
//                s3URL = NSURL()
//                print(task.error.debugDescription)
//                completionHandler(s3URL as URL)
//            }
//
//            return nil
//        }
    }
    
    //MARK:- PutWithJsonEncoding
    func apiParsePutWithJsonEncoding(_ url:NSString, postParameters:NSDictionary?, completionHandler:@escaping ( _ response:NSDictionary?,_ statusCode: Int?)->()) {
        
        let urlString  = url as String
        var header = HTTPHeaders()
        
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            let urlString  = url as String
            if urlString  == WEB_URL.changePassword  {
                let token = AppSharedData.sharedInstance.getRefreshTokenAndAccessToken().value(forKey: kAccessToken)!
                header = ["Content-Type"   : "application/json",
                          "Authorization"  : "Bearer \(token)"]
            } else {
                header = ["Content-Type" : "application/x-www-form-urlencoded"]
            }
        }
        
        Alamofire.request(urlString, method: .put, parameters: postParameters as? Parameters, encoding: JSONEncoding.default, headers: header).responseJSON {
        
      //  Alamofire.request(urlString, method: .put, parameters: postParameters as? Parameters, headers: header).responseJSON {
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
            if statusCode == STATUS_CODE.tokenExpire {
                self.getNewRefreshTokenAndAccessToken(completionHandler: {(status :Int?) in
                    if status == STATUS_CODE.success {
                        self.apiParsePost(urlString as NSString,postParameters: postParameters , completionHandler: {
                            json , statusCode in
                            completionHandler(json as NSDictionary?, statusCode)
                        })
                    } else if status == STATUS_CODE.internalServerError {
                        UserDefaults.standard.set(nil, forKey: kDictTokens)
                        UserDefaults.standard.set(false, forKey: kLogin)
                        UserDefaults.standard.set(nil, forKey: kLoginResponse)
                    }
                })
            }
            completionHandler(json as NSDictionary?,statusCode)
        }
    }
    
    func downloadAndSaveFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        Loader.shared.show()
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    Loader.shared.hide()
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    
}



extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
