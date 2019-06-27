//
//  ContactViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 07/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
class ContactViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var txtDepartment: UITextField!
    var contactArr = [Contacts]()
    let pickerContacts:UIPickerView = UIPickerView()
    var selectedTextField:UITextField!
    var deptName = String()
    var contactNumber = String()
    var isHome = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHome == 1 {
            self.title = "Emergency Contact"
            self.view.backgroundColor = UIColor.white
            //back
            let backbutton = UIButton(type: .custom)
            backbutton.setImage(UIImage(named:"back-arrow"), for: .normal) // Image can be downloaded from here below link
            backbutton.addTarget(self, action: #selector(BaseViewController.backAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
            
            let menuBarItem = UIBarButtonItem(customView: backbutton)
            let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
            currWidth?.isActive = true
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
            currHeight?.isActive = true
            self.navigationItem.rightBarButtonItem = nil
            getContacts()
            
        } else {
            AppSharedData.sharedInstance.contactViewControllerRef = self
            
            
            
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Server Request
    func getContacts() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.contacts, completion: {(response : NSDictionary?,statusCode : Int?) in
            Loader.shared.hide()
            if let con = [Contacts].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                self.contactArr = con
                self.txtDepartment.text = ""
            }
        })
    }
    //MARK:- UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.contactArr.count != 0 {
            createStockPicker(txtDepartment)
        } else {
            AppSharedData.sharedInstance.alert(vc: self, message: "Contact is empty.")
        }
        return true
    }
    
    //MARK:- UIPickerView
    func createStockPicker(_ textField: UITextField){
        pickerContacts.delegate = self
        pickerContacts.dataSource = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerCancel))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        textField.inputView = pickerContacts
        selectedTextField = textField
    }
    //MARK:- UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contactArr.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return "\(contactArr[row].name!)"
        
    }
    //MARK:- UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deptName = "\(contactArr[row].name!)"
        contactNumber = contactArr[row].contact_number!
        
    }
    @objc func pickerDone(){
        txtDepartment.text = deptName
        self.view.endEditing(true)
        
    }
    @objc func pickerCancel(){
        self.view.endEditing(true)
    }
    @IBAction func callNow(_ sender: Any) {
        if txtDepartment.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please select department")
        } else {
            if let phoneCallURL = URL(string: "telprompt://\(contactNumber)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        application.openURL(phoneCallURL as URL)
                    }
                }
            }
        }
    }
    
    
}
