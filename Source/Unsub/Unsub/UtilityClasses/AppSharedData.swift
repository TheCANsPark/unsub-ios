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
        let dicTokens = ["accessToken"  : kAccessToken,
                         "refreshToken" : kRefreshToken]
        UserDefaults.standard.set(dicTokens, forKey: kDictTokens)
    }
    func getRefreshTokenAndAccessToken() -> NSDictionary{
        let dict = UserDefaults.standard.value(forKey: kDictTokens) as! NSDictionary
        return dict
    }
    func gradient() {
         var gradientLayer = CAGradientLayer()
        
        //   gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor(red: 253/255, green: 150/255, blue: 1/255, alpha: 1), UIColor(red: 253/255, green: 188/255, blue: 50/255, alpha: 1)]
        
       // gradientLayer.frame = (self.navigationController?.navigationBar.bounds)!
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
   //     navigationController?.navigationBar.layer.addSublayer(gradientLayer)
    }
    
}
