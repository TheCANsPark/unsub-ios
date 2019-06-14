//
//  ProfileViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 14/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
class ProfileViewController: BaseViewController {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var txtMail: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtAge: UITextField!
    
    
    
    @IBOutlet weak var viewContents: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    AppSharedData.sharedInstance.profileViewControllerRef = self
    imgProfile.layer.borderWidth = 2.0
    imgProfile.layer.borderColor = UIColor(red: 240/255, green: 166/255, blue: 74/255, alpha: 1).cgColor
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            viewContents.isHidden = false
        } else {
            viewContents.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Server Request
    func getProfile() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getProfile, completion: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                self.viewContents.isHidden = false
                let res = response?.value(forKey: "data") as! NSDictionary
                self.txtMail.text = res.value(forKey: "email") as? String
                self.lblName.text = res.value(forKey: "fullName") as? String
                self.txtPhone.text = res.value(forKey: "mobile_number") as? String
                self.txtAge.text = res.value(forKey: "age") as? String
            }
        })
    }
    //MARK:- UIButtonActions
    @IBAction func changePassword(_ sender: Any) {
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            UserDefaults.standard.set(nil, forKey: kDictTokens)
            UserDefaults.standard.set(false, forKey: kLogin)
            self.viewDidLoad()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
}
