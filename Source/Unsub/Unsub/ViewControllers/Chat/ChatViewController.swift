//
//  ChatViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 20/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss

class ChatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var ID = String()
    var incidentCommentsArr = [Comments]()
    
    @IBOutlet weak var txtQuery: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        tableView.rowHeight = 300.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        getComments()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if statusCode == STATUS_CODE.success {
              //  self.isComment = 1
                self.txtQuery.text = ""
                self.getComments()
                
            }else {
                AppSharedData.sharedInstance.alert(vc: self, message: "Could not load")
            }
        })
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
            lblDate.text = getDateFromUTC(dateStr: incident.date!)
            lblChat.text = incident.comment!
            return cell!
            
        } else if incident.commented_by == "admin" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminTableCell")
            let lblChat : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblName : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
            let lblDate : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
            lblDate.text = getDateFromUTC(dateStr: incident.date!)
            lblName.text = incident.user_id?.fullName!
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
        inputFormatter.dateFormat = "MMM dd,yyyy EEEE HH:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
}
