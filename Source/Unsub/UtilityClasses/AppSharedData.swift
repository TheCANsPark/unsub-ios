//
//  AppSharedData.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import UIKit

class AppSharedData {
    static var sharedInstance = AppSharedData()
    
    var contactViewControllerRef         : ContactViewController!
    var profileViewControllerRef         : ProfileViewController!
    var myComplaintsViewControllerRef    : MyComplaintsViewController!
    var timelineViewControllerRef        : TimelineViewController!
    var chatViewControllerRef            : ChatViewController!
    var homeViewControllerRef            : HomeViewController!
    var containerVCRef                   : ContainerViewController!
    
    var isBackIncident : Int = 0
    var keyboardHeight : CGFloat = 0
    var fcmToken = ""
    
    func getFormattedDurationString(fromSeconds: Int) -> String {
        let hrs = fromSeconds/3600
        let minutes = (fromSeconds - (hrs * 3600)) / 60
        let seconds = fromSeconds - ((hrs * 3600) + (minutes * 60))
        
        if hrs > 0 {
            return NSString(format: "%02d:%02d:%02d",hrs,minutes,seconds) as String
        }else {
            return NSString(format: "%02d:%02d", minutes,seconds) as String
        }
    }
    
    func alert(vc: UIViewController,message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    func isEmailValid(email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let boolValue = emailTest.evaluate(with: email)
        return boolValue
    }
    func saveAccessTokenAndRefreshToken(accessToken : String, refreshToken : String) {
        let dicTokens = ["accessToken"  : accessToken,
                         "refreshToken" : refreshToken]
        UserDefaults.standard.set(dicTokens, forKey: kDictTokens)
    }
    func getRefreshTokenAndAccessToken() -> NSDictionary{
        let dict = UserDefaults.standard.value(forKey: kDictTokens) as! NSDictionary
        return dict
    }
   
    func setGradientOnObject(_ object : AnyObject, colour1 : UIColor, colour2 : UIColor)  {
        let gradient = CAGradientLayer()
        let color2 = UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1).cgColor
        let color1 = UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1).cgColor
        gradient.colors = [color2,color1]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        if #available(iOS 12.0, *) {
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: object.frame.size.width, height: object.frame.size.height)
        } else {
            // Fallback on earlier versions
        }
        if object.tag == 500 {//view
            if #available(iOS 13.0, *) {
                object.layer.insertSublayer(gradient, at: 0)
            } else {
                // Fallback on earlier versions
            }
        } else {
            let image = getImageFrom(gradientLayer: gradient)
            object.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    func getUnsubFolderPath()->URL  {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let folderPath = documentsPath.appendingPathComponent("Unsub")
        return folderPath!
    }
    
    func getCaseStatus(status: String) -> String {
        if status == "pending" {
            return "Pending"
        }else if status == "approved" {
            return "Accepted"
        }else {
            return ""
        }
    }
//    func customizeNavigationBar(_ object : AnyObject) {
//        object.navigationController??.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        object.navigationController??.navigationBar.shadowImage = UIImage()
//        object.navigationController??.navigationBar.isTranslucent = true
//        object.navigationController??.view.backgroundColor = .clear
//    }
}
