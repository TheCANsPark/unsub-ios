//
//  ChatViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 20/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
import IQKeyboardManagerSwift

class ChatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var txtQuery: UITextField!
    
    var ID = String()
    var incidentCommentsArr = [Comments]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        AppSharedData.sharedInstance.chatViewControllerRef = self
        self.title = "Chat"
        tableView.rowHeight = 300.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    //    getComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    //MARK:- Server Request
    func getComments() {
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getComments + ID, completion: {(response : NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                let res = response?.value(forKey: "data") as! NSDictionary
                if let com = [Comments].from(jsonArray: res.value(forKey: "incident_comments") as! [JSON]) {
                    self.incidentCommentsArr = com
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
        })
    }
    func commentQuery() {
        Loader.shared.show()
        let param = ["comment"       : txtQuery.text!,
                     "incident_id"   : ID]
        NetworkManager.sharedInstance.apiParsePostWithJsonEncoding(WEB_URL.commentQuery as NSString, postParameters: param as NSDictionary, completionHandler: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                let data = response?.value(forKey: "data") as! NSDictionary
                if let com = [Comments].from(jsonArray: data.value(forKey: "incident_comments") as! [JSON]) {
                    self.incidentCommentsArr = com
                    self.txtQuery.text = ""
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
                
            }else {
                AppSharedData.sharedInstance.alert(vc: self, message: "Could not load")
            }
        })
    }
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtQuery {

            if range.location == 0 && string == " " {
                return false
            } else if range.location > 1 && textField.text?.characters.last == " " && string == " " {
                return false
            }else{
                return true
            }

        }else {
            return true
        }
        
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if incidentCommentsArr.count != 0 {
          return incidentCommentsArr.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let incident = incidentCommentsArr[indexPath.row]
        if incident.commented_by == "victim" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VictimTableCell")
            let lblChat : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblDate : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
            lblDate.text = getDateFromUTC(dateStr: "\(incident.date ?? "")")
            lblChat.text = incident.comment!
            return cell!
            
        } else if incident.commented_by == "admin" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminTableCell")
            let lblChat : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblName : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
            let lblDate : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
            lblDate.text = getDateFromUTC(dateStr: incident.date!)
            lblName.text = incident.commented_by!
            lblChat.text = incident.comment!
            return cell!
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StackTableCell")
            let lblChat : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblName : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
            let lblDate : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
            lblDate.text = getDateFromUTC(dateStr: incident.date!)
            lblName.text = incident.user_id?.stackholder_name!
            lblChat.text = incident.comment!
            return cell!
        }
    }
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //MARK:- UIButtonActions
    @IBAction func askQuery(_ sender: Any) {
        if txtQuery.text == "" {
            
        } else {
            commentQuery()
        }
    }
    //MARK:- Helper
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.incidentCommentsArr.count != 0 {
                let indexPath = IndexPath(row: (self.incidentCommentsArr.count)-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } else { 
            }
        }
    }
    func getDateFromUTC(dateStr : String)-> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let showDate = inputFormatter.date(from: dateStr)
        inputFormatter.dateFormat = "MMM dd HH:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyBoardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardHeight = keyBoardFrame!.height
            if #available(iOS 11.0, *) {
                self.bottomConstraint.constant = -(keyBoardHeight - UIApplication.shared.keyWindow!.safeAreaInsets.bottom)
            } else {
                self.bottomConstraint.constant = -(keyBoardHeight)
            }
            
            /* if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }*/

      }
   }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }
 }
