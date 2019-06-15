//
//  ComplaintDetailViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 15/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
class ComplaintDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    var complaintID = String()
    var complaintDetailArr : Incidents!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Complaint Details"
        getComplaintDetail()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Server Request
    func getComplaintDetail() {
        tableView.isHidden = true
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getIncidentDetails + "\(complaintID)", completion: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            
            if statusCode == STATUS_CODE.success {
               self.tableView.isHidden = false
                if let com = Incidents.init(json: response?.value(forKey: "data") as! JSON) {
                    self.complaintDetailArr = com
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && (complaintDetailArr != nil) {
           return 1
        } else if section == 1 && (complaintDetailArr != nil) {
            return (complaintDetailArr!.incident_comments?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = complaintDetailArr!
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableCell")
            let lblName : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblVictimMobile : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
            let lblMail : UILabel = cell?.contentView.viewWithTag(102) as! UILabel
            let lblComplaintNumber : UILabel = cell?.contentView.viewWithTag(103) as! UILabel
            let lblAddress : UILabel = cell?.contentView.viewWithTag(104) as! UILabel
            let lblImage : UILabel = cell?.contentView.viewWithTag(105) as! UILabel
            let lblSubmitterMobile : UILabel = cell?.contentView.viewWithTag(106) as! UILabel
            
            lblName.text = "\(detail.name?.first ?? "")" + " \(detail.name?.last ?? "")"
            lblVictimMobile.text = "\(detail.victims_contact_number ?? "N/A")"
            lblSubmitterMobile.text = "\(detail.submitter_contact_number ?? "N/A")"
            lblAddress.text = "\(detail.address?.address ?? "")"
            lblMail.text = "\(detail.email ?? "")"
            lblComplaintNumber.text = "#\(detail.complaint_number!)"
            lblImage.text = ""
            
            return cell!
            
        } else if indexPath.section == 1 {
            let commentDetail = detail.incident_comments![indexPath.row]
            
            if commentDetail.commented_by == "admin" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdminTableCell")
                let lblName : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
                let lblDate : UILabel = cell?.contentView.viewWithTag(201) as! UILabel
                let lblComment : UILabel = cell?.contentView.viewWithTag(202) as! UILabel
                
                lblName.text = commentDetail.user_id?.fullName!
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let showDate = inputFormatter.date(from: commentDetail.date!)
                inputFormatter.dateFormat = "MMM dd,yyyy EEEE HH:mm a"
                let resultString = inputFormatter.string(from: showDate!)
                lblDate.text = "\(resultString)"
                lblComment.text = commentDetail.comment!
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableCell")
                let lblName : UILabel = cell?.contentView.viewWithTag(300) as! UILabel
                let lblDate : UILabel = cell?.contentView.viewWithTag(301) as! UILabel
                let lblComment : UILabel = cell?.contentView.viewWithTag(302) as! UILabel
                
                lblName.text = commentDetail.user_id?.fullName!
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let showDate = inputFormatter.date(from: commentDetail.date!)
                inputFormatter.dateFormat = "MMM dd,yyyy EEEE HH:mm a"
                let resultString = inputFormatter.string(from: showDate!)
                lblDate.text = "\(resultString)"
                lblComment.text = commentDetail.comment!
                
                return cell!
            }
        }
       
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
