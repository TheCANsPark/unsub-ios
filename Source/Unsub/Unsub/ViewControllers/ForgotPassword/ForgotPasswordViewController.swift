//
//  ForgotPasswordViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 19/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var txtMail: UITextField!
    
    @IBOutlet weak var viewPassword: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPassword.layer.cornerRadius = 20
        viewPassword.clipsToBounds = true
        
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- ServerRequest
    func forgotPass() {
        let param = ["email" : txtMail.text!]
        NetworkManager.sharedInstance.apiParsePost(WEB_URL.forgotPassword as NSString, postParameters: param as NSDictionary, completionHandler: {(response :NSDictionary?, statusCode :Int?) in
            if statusCode == STATUS_CODE.success {
                let refreshAlert = UIAlertController(title: "Alert", message: response?.value(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            } else if statusCode == STATUS_CODE.internalServerError {
                AppSharedData.sharedInstance.alert(vc: self, message: response?.value(forKey: "msg") as! String)
            }
        })
    }
    //MARK:- UIButtonActions
    @IBAction func submit(_ sender: Any) {
        if txtMail.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter all the fields.")
            
        } else  if AppSharedData.sharedInstance.isEmailValid(email: txtMail.text!) == false {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter correct mail")
            
        }else {
            forgotPass()
        }
    }
    //MARK:- Helper
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
