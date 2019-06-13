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
        
        self.title = "Complaint List"
        getIncidents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getIncidents() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getIncidents, completion: {(response : NSDictionary?) in
            Loader.shared.hide()
            if let inc = [Incidents].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                self.incidentArr = inc
                self.tableView.reloadData()
            }
            
        })
    }
//ComplaintTableCell
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
        
        lblCrimeDetail.text = incident.crime_details!
        lblComplaintID.text = "Complaint ID #\(incident.complaint_number!)"
        lblCrimeDate.text = "Date: \(incident.incident_date!)"
        lblCategoryName.text = incident.Category?.name!
        lblTimeline.text = "\(incident.timeline_actions_count!)"
        lblComment.text = "\(incident.comments_count!)"
        
        return cell!
    }
}
