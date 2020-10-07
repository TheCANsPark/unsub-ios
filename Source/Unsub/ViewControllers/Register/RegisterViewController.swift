//
//  RegisterViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Gloss
class RegisterViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var txtMail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAge: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAnnonymousName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    
    @IBOutlet weak var imgVolunteer: UIImageView!
    @IBOutlet weak var imgAcceptTerms: UIImageView!
    
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    
    var isAgreed : Int = 0
    var isVolunteer : Bool = false
    let datePicker:UIDatePicker = UIDatePicker()
    var dateUTC = String()
    let pickerStates:UIPickerView = UIPickerView()
    var selectedTextField:UITextField!
    var arrStates = [State]()
    var stateID = String()
    var stateName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStates()
        pickerStates.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- ServerRequests
    func register() {
        Loader.shared.show()
        let param = ["name.first"   : txtName.text!,
                     "email"        : txtMail.text!,
                     "password"     : txtPassword.text!,
                     "mobile_number": txtMobile.text!,
                     "age"          : dateUTC,
                     "annonymous_name": txtAnnonymousName.text!,
                     "name.last"     : txtLastName.text!,
                     "isVolunteer_intrested": isVolunteer,
                     "state"    : stateID] as [String : Any]
        
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
    func getStates() {
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getStates , completion: {(response: NSDictionary?, statusCode: Int?) in
            if statusCode == STATUS_CODE.success {
                if let sta = [State].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.arrStates = sta
                }
            }
            
        })
    }
    //MARK:- UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrStates.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return "\(arrStates[row].name!)"
        
    }
    //MARK:- UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateName = "\(arrStates[row].name!)"
        stateID = arrStates[row]._id!
    }
    //MARK:- UIPickerView
    func createStockPicker(_ textField: UITextField){
        pickerStates.delegate = self
        pickerStates.dataSource = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerDoneStock))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerCancelStock))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        textField.inputView = pickerStates
        selectedTextField = textField
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAge {
            createDatePicker()
        }
        if textField == txtState {
            createStockPicker(txtState)
        }
        return true
    }
    //MARK:- Date Picker
    func createDatePicker(){
        datePicker.datePickerMode = .date
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -12
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.date = minDate
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromTimePickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromTimePickerCancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtAge.inputAccessoryView = toolbar
        txtAge.inputView = datePicker
    }
    @objc func fromTimePickerDone(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        txtAge.text = formatter.string(from: datePicker.date)
        dateUTC = get_Date_time_from_UTC_time(string: txtAge.text!)
        self.view.endEditing(true)
    }
    func get_Date_time_from_UTC_time(string : String) -> String {
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "MMM dd,yyyy"
        let dt = string
        let dt1 = dateformattor.date(from: dt)
        dateformattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.string(from: dt1!)
    }
    @objc func fromTimePickerCancel(){
        self.view.endEditing(true)
    }
    
    //MARK:- UIButtonActions
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func register(_ sender: Any) {
        if txtName.text?.count == 0 || txtMail.text?.count == 0 || txtMobile.text?.count == 0 || txtPassword.text?.count == 0 || txtAge.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter all the fields")
            
        } else if AppSharedData.sharedInstance.isEmailValid(email: txtMail.text!) == false {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter correct mail")
            
        } else if txtPassword.text != txtConfirmPassword.text! {
            AppSharedData.sharedInstance.alert(vc: self, message: "Password and confirm password does not match")
        } else if txtState.text?.count == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Please enter state")
        } else if isAgreed == 0 {
            AppSharedData.sharedInstance.alert(vc: self, message: "Agree with Terms & Conditions to proceed")
            
        }else {
            register()
        }
    }
    @IBAction func acceptTermsAndCon(_ sender: Any) {
        if isAgreed == 0 {
            isAgreed = 1
            imgAcceptTerms.image = #imageLiteral(resourceName: "checked")
        } else {
            imgAcceptTerms.image = #imageLiteral(resourceName: "without-check")
            isAgreed = 0
        }
    }
    @IBAction func login(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func termsAndConditions(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.isToOpenPolicy = false
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.isToOpenPolicy = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func volunteer(_ sender: Any) {
        if isVolunteer == false {
            isVolunteer = true
            imgVolunteer.image = #imageLiteral(resourceName: "checked")
        } else {
            imgVolunteer.image = #imageLiteral(resourceName: "without-check")
            isVolunteer = false
        }
    }
    //MARK:- Helper
    @objc func pickerDoneStock(){
        txtState.text = stateName
        self.view.endEditing(true)
    }
    @objc func pickerCancelStock() {
        self.view.endEditing(true)
    }
}
