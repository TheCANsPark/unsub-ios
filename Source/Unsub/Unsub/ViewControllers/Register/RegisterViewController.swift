//
//  RegisterViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var txtMail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAge: SkyFloatingLabelTextField!
    
    @IBOutlet weak var imgAcceptTerms: UIImageView!
    
    var isAgreed : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- ServerRequests
    func register() {
        Loader.shared.show()
        let param = ["fullName" : txtName.text!,
                     "email"    : txtMail.text!,
                     "password" : txtPassword.text!,
                     "mobile_number" : txtMobile.text!,
                     "age" : txtAge.text!]
        
        
        NetworkManager.sharedInstance.apiParsePost(WEB_URL.signUp as NSString, postParameters: param as NSDictionary, completionHandler: {(response : NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
                if statusCode == STATUS_CODE.success {
                    let refreshAlert = UIAlertController(title: "Alert", message: response?.value(forKey: "message") as? String, preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                   // AppSharedData.sharedInstance.alert(vc: self, message: "A verification link has been send to \(self.txtMail.text!).Please check your email")
                } else {
                    let msg = response?.value(forKey: "message") as! String
                    AppSharedData.sharedInstance.alert(vc: self, message: msg)
            }
        })
    }
    //MARK:- UIButtonActions
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func register(_ sender: Any) {
        if txtMail.text?.count == 0 || txtMobile.text?.count == 0 || txtPassword.text?.count == 0 || txtName.text?.count == 0 || txtAge.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter all the fields")
            
        } else if AppSharedData.sharedInstance.isEmailValid(email: txtMail.text!) == false {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter correct mail")
        } else if isAgreed == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please accept terms and conditions")
        } else {
            register()
        }
    }
    @IBAction func acceptTermsAndCon(_ sender: Any) {
        if isAgreed == 0 {
            isAgreed = 1
            imgAcceptTerms.image = #imageLiteral(resourceName: "checked")
        } else {
            imgAcceptTerms.image = #imageLiteral(resourceName: "unchecked")
            isAgreed = 0
        }
    }
    @IBAction func login(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
