//
//  ChangePasswordViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 19/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPas: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    
    @IBOutlet weak var viewChangePassword: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewChangePassword.layer.cornerRadius = 20
        viewChangePassword.clipsToBounds = true
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
    func changePassword() {
        Loader.shared.show()
        let param = ["old_password" : txtCurrentPass.text!,
                     "new_password" : txtNewPas.text!]
        
        NetworkManager.sharedInstance.apiParsePutWithJsonEncoding(WEB_URL.changePassword as NSString , postParameters: param as NSDictionary, completionHandler: {(response :  NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                let refreshAlert = UIAlertController(title: "Alert", message: response?.value(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            } else if statusCode == STATUS_CODE.badRequest {
                AppSharedData.sharedInstance.alert(vc: self, message: response?.value(forKey: "msg") as! String)
            }
            
        })
    }
    //MARK:- UIButtonActions
    @IBAction func submit(_ sender: Any) {
        if txtCurrentPass.text?.count == 0 || txtNewPas.text?.count == 0 || txtConfirmPass.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter all the fields")
        } else if txtConfirmPass.text! != txtNewPas.text! {
            AppSharedData.sharedInstance.alert(vc: self, message: "Password and confirm password does not match")
        } else {
            changePassword()
        }
    }
    //MARK:- Helper
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
