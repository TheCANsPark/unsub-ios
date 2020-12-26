//
//  VoiceRecordToReportVC.swift
//  Unsub
//
//  Created by mac on 22/12/20.
//  Copyright © 2020 codezilla-mac1. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceRecordToReportVC: UIViewController, AVAudioRecorderDelegate {

    private var arrVoiceName = [String]()
    var voiceURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showAlert(message: String) {
        
        let refreshAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK:- Server Request
    func createIncidents() {
        
        let param = [
                     "incident_type"             : 2,
                     "voice_file"                : arrVoiceName,
                     "first_name"                : "",
                     "last_name"                 : "",
                     "email"                     : "",
                     "age"                       : "",
                     "phone_number"              : "",
                     "Category"                  : "",
                     "crime_details"             : "",
                     "images"                    : [""],
                     "videos"                    : [""],
                     "incident_date"             : "",
                     "lat"                       : 0.0,
                     "long"                      : 0.0,
                     "address"                   : "",
                     "attachment"                : "",
                     "submitted_by"              : "",
                     "annonymous_name"           : "",
                     "tertiary"                  : "",
                     "victims_count"             : "",
                     "violators"                 : "",
                     "lga"                       : "",
                     "state"                     : ""
            ] as [String : Any]
        
        NetworkManager.sharedInstance.apiParsePostWithJsonEncoding(WEB_URL.createIncidents as NSString, postParameters: param as NSDictionary, completionHandler: {(response : NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                
                self.showAlert(message: response?.value(forKey: "message") as? String ?? "")
                
            } else if statusCode == STATUS_CODE.internalServerError {
                
                self.showAlert(message: "Please wait while the file is being uploaded")
                //AppSharedData.sharedInstance.alert(vc: self, message: response?["message"] as? String ?? "Please wait while the file is being uploaded")
            }
        })
    }
    
    //MARK:- UIButtonActions
    @IBAction func btnUpload(_ sender: Any) {
        
        Loader.shared.show()
        
        NetworkManager.sharedInstance.uploadVideo(videoFileUrl: voiceURL!, isVideo: true, imageUrl: URL(string: "http://")!, isCamera: false, imageData: UIImageJPEGRepresentation(#imageLiteral(resourceName: "without-check"), 0.1)! as NSData, filePath: URL(string: "http://")!, isFile: false) { (urlVoice) in
            
            let str = String(describing: urlVoice)
            let fileArray = str.components(separatedBy: "/")
            let finalFileName = fileArray.last
            
            self.arrVoiceName.append(finalFileName ?? "")
            
            self.createIncidents()
            
            print(urlVoice)
        }
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
