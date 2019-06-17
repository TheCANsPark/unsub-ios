//
//  LoginnViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class LoginnViewController: UIViewController {

    
    @IBOutlet weak var txtMail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- ServerRequests
    func loginRequest() {
        Loader.shared.show()
        let param = ["grant_type":  "password",
                     "username"  :  txtMail.text!,
                     "password"  :  txtPassword.text!,
                     "scope"     :  "3"] 
        NetworkManager.sharedInstance.apiParsePost(WEB_URL.login as NSString, postParameters: param as NSDictionary, completionHandler: {(response :NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                
                let refreshAlert = UIAlertController(title: "Alert", message: "Login successful", preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                    let data = response?.value(forKey: "data") as! NSDictionary
                    AppSharedData.sharedInstance.saveAccessTokenAndRefreshToken(accessToken: data.value(forKey: kAccessToken) as! String, refreshToken: data.value(forKey: kRefreshToken) as! String)
                    UserDefaults.standard.set(true, forKey: kLogin)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
                
            } else if statusCode == STATUS_CODE.pendingAction {
                let msg = response?.value(forKey: "message") as! String
                AppSharedData.sharedInstance.alert(vc: self, message: msg)
            } else if statusCode == STATUS_CODE.verifyEmail {
                AppSharedData.sharedInstance.alert(vc: self, message: "Please verify email")
            } else if AppSharedData.sharedInstance.isEmailValid(email: self.txtMail.text!) == false {
                AppSharedData.sharedInstance.alert(vc: self, message: "Please enter correct mail")
            } else {
                let data = response?.value(forKey: "data") as! NSDictionary
                AppSharedData.sharedInstance.alert(vc: self, message: data.value(forKey: "message") as! String)
            }
        })
    }
    //MARK:- UIButtonAction
    @IBAction func login(_ sender: Any) {
        if AppSharedData.sharedInstance.isEmailValid(email: txtMail.text!) == false {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter correct mail")
            
        } else if txtMail.text?.count == 0 || txtPassword.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter all the fields")
            
        } else {
            loginRequest()
        }
        
    }
    
    @IBAction func forgotpassword(_ sender: Any) {
    }
    @IBAction func goToRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
