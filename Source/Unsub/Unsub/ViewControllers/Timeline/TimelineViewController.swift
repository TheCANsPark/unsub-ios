//
//  TimelineViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 18/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
class TimelineViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblIncidenceDetail: UILabel!
    @IBOutlet weak var lblComplaintID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewData: UIView!
    
    @IBOutlet weak var heightConstraintView: NSLayoutConstraint!
    
    var incidentDataArr : IncidentData!
    var timelineArr = [TimelineData]()
    var complaintID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timeline"
        viewData.isHidden = true
        tableView.isHidden = true
        getTimeline()
        
        //timeline image
        let rightImage = UIButton(type: .custom)
        rightImage.setImage(UIImage(named:"top"), for: .normal) // Image can be downloaded from here below link
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightImage)
        
        let menuBarItem = UIBarButtonItem(customView: rightImage)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Server Request
    func getTimeline() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getTimeline + "\(complaintID)", completion: {(response: NSDictionary?, statusCode: Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                if let inc = IncidentData.init(json: response?.value(forKey: "incident_data") as! JSON) {
                    self.incidentDataArr = inc
                    self.viewData.isHidden = false
                    let incident = self.incidentDataArr!
                    
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let showDate = inputFormatter.date(from: (incident.incident_date!))
                    inputFormatter.dateFormat = "MMM dd,yyyy hh:mm a" 
                    let resultString = inputFormatter.string(from: showDate!)
                    self.lblDate.text = resultString
                    self.lblIncidenceDetail.text = incident.incident_details!
                    self.lblComplaintID.text = "Incidence ID: #\(incident.complaint_number!)"
                    
                    self.heightConstraintView.constant = self.heightForView(text: incident.incident_details!) + 70

                    
                }
                if let time = [TimelineData].from(jsonArray: response?.value(forKey: "timeline_data") as! [JSON]) {
                    self.timelineArr = time
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timelineArr.count != 0 {
           return timelineArr.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableCell")
        let lblDateTimeLine : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
        let lblAction : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
        let timeline = timelineArr[indexPath.row]
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let showDate = inputFormatter.date(from: timeline.createdAt!)
        inputFormatter.dateFormat = "MMM dd,yyyy hh:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        
        lblDateTimeLine.text = resultString
        lblAction.text = timeline.action!
        
        return cell!
    }
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //MARK:- Helper
    func heightForView(text:String) -> CGFloat{
        let label : UILabel = UILabel(frame: CGRect(x: 25, y: 0, width: 325, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
