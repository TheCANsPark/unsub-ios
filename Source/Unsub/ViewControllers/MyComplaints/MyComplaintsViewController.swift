//
//  MyComplaintsViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 13/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss

class MyComplaintsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var incidentArr = [Incidents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppSharedData.sharedInstance.myComplaintsViewControllerRef = self
        self.title = "My Case List"
        
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            getIncidents()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func getIncidents() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getIncidents, completion: {(response : NSDictionary?, statusCode : Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                if let inc = [Incidents].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.incidentArr = inc
                    self.tableView.reloadData()
                }
            } else {
                
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if incidentArr.count != 0 {
            return incidentArr.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintTableCell")
        let incident = incidentArr[indexPath.row]
        
        let lblCrimeDetail : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
        let lblComplaintID : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
        let lblCrimeDate : UILabel = cell?.contentView.viewWithTag(102) as! UILabel
        let lblCategoryName : UILabel = cell?.contentView.viewWithTag(103) as! UILabel
        let lblTimeline : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
        let lblComment : UILabel = cell?.contentView.viewWithTag(201) as! UILabel
        let imgRedDot : UIImageView = cell?.contentView.viewWithTag(202) as! UIImageView
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let updatedOnDate = formatter.date(from: incident.updated_on!)
        let viewedOnDate = formatter.date(from: incident.viewed_on!)
        
        if updatedOnDate! > viewedOnDate! {
           imgRedDot.isHidden = false
        } else {
            imgRedDot.isHidden = true
        }
  
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let showDate = inputFormatter.date(from: incident.incident_date ?? "")
        inputFormatter.dateFormat = "MMM dd,yyyy HH:mm a"
        let resultString = inputFormatter.string(from: showDate ?? Date())
        
        lblCrimeDetail.text = incident.crime_details ?? ""
        lblComplaintID.text = "Case ID: \(incident.complaint_number ?? "")"
        lblCrimeDate.text = "\(resultString)"
        lblCategoryName.text = incident.Category?.name ?? ""
        lblTimeline.text = "\(incident.timeline_actions_count ?? 0)"
        lblComment.text = "\(incident.comments_count ?? 0)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ComplaintDetailViewController") as? ComplaintDetailViewController
        vc?.complaintID = incidentArr[indexPath.row]._id ?? ""
        vc?.categoryName = (incidentArr[indexPath.row].Category?.name!) ?? ""
        vc?.incidentString = incidentArr[indexPath.row].crime_details ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func getDate(dateStr : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateStr) // replace Date String
    }
}
