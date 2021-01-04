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
    var categoryName = String()
    var incidentString = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Case Details"     //Incidence
        getComplaintDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //timeline image
        let rightImage = UIButton(type: .custom)
        rightImage.setImage(UIImage(named:"chat"), for: .normal) // Image can be downloaded from here below link
        rightImage.addTarget(self, action: #selector(ComplaintDetailViewController.timeline), for: .touchUpInside)
     //   self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightImage)
        let time = UIBarButtonItem(customView: rightImage)
        let menuBarItem = UIBarButtonItem(customView: rightImage)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItems = [time]
    }
    //MARK:- Server Request
    func getComplaintDetail() {
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getIncidentDetails + "\(complaintID)", completion: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            
            if statusCode == STATUS_CODE.success {
                if let com = Incidents.init(json: response?.value(forKey: "data") as! JSON) {
                    self.complaintDetailArr = com
                    self.tableView.reloadData()
                    
                }
            } else {
                AppSharedData.sharedInstance.alert(vc: self, message: "Could not load")
            }
        })
    }
    
    //MARK: Helper
    func setTableViewHeight(tblHeightConstraint: NSLayoutConstraint, tableView: UITableView) {
        
        UIView.animate(withDuration: 0, animations: {
            tableView.layoutIfNeeded()
        }) { (complete) in
            var heightOfTableView: CGFloat = 0.0
            
            let cells = tableView.visibleCells
            for cell in cells {
                heightOfTableView += cell.frame.height
            }
            
            tblHeightConstraint.constant = heightOfTableView + 1   //The point here is to let it draw the next cell so that it will be counted in visibleCells as well by setting constraint constant to height + 1
        }
        
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if complaintDetailArr == nil {
            return 0
        } else {
            if tableView.tag == 999 {
                return complaintDetailArr.assignedstkHolders!.count
            }else {
               return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 999 { // AssigneStkholder Table
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StackholdersCell")
            let contentView:UIView = (cell?.contentView.viewWithTag(1000))!
            let lblName : UILabel = cell?.contentView.viewWithTag(11) as! UILabel
            let lblStatus : UILabel = cell?.contentView.viewWithTag(12) as! UILabel
            
            cell?.selectionStyle = .none
            
            contentView.layer.shadowColor = UIColor.darkGray.cgColor
            contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            contentView.layer.shadowRadius = 2
            contentView.layer.shadowOpacity = 0.5
            contentView.layer.cornerRadius = 5
            
            let stkHolder = self.complaintDetailArr.assignedstkHolders![indexPath.row]
            
            lblName.text =  stkHolder.stackholderDetail?.stackholder_name
            lblStatus.text = appShared.getCaseStatus(status: stkHolder.status ?? "")
            
            return cell!
            
        }else {
            
            let detail = complaintDetailArr!
            if indexPath.section == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableCell")
                let lblName : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
                let lblVictimMobile : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
                let lblMail : UILabel = cell?.contentView.viewWithTag(102) as! UILabel
                let lblComplaintNumber : UILabel = cell?.contentView.viewWithTag(103) as! UILabel
                let lblAddress : UILabel = cell?.contentView.viewWithTag(104) as! UILabel
                let lblCategoryName : UILabel = cell?.contentView.viewWithTag(106) as! UILabel
                let lblDetail : UILabel = cell?.contentView.viewWithTag(107) as! UILabel
                let lblStatus : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
                let lblDate : UILabel = cell?.contentView.viewWithTag(108) as! UILabel
                let lblAssignedStackholder : UILabel = cell?.contentView.viewWithTag(199) as! UILabel
                let tblAssigneStkholder = cell?.viewWithTag(999) as! UITableView
                
                for constraints in tblAssigneStkholder.constraints{
                    if constraints.identifier == "cnsTableHeight"{
                        //constraints.constant = 0
                        self.setTableViewHeight(tblHeightConstraint: constraints, tableView: tblAssigneStkholder )
                    }
                }
                
                if self.complaintDetailArr.assignedstkHolders!.count == 0 {
                    lblAssignedStackholder.isHidden = false
                }else {
                    lblAssignedStackholder.isHidden = true
                }
                
                lblName.text = "\(detail.name?.first ?? "")" + " \(detail.name?.last ?? "")"
                lblVictimMobile.text = "\(detail.phone_number ?? "N/A")"
                lblAddress.text = "\(detail.address?.address ?? "")"
                lblMail.text = "\(detail.email ?? "")"
                lblComplaintNumber.text = "\(detail.complaint_number ?? "")"
                lblStatus.text = appShared.getCaseStatus(status: detail.status ?? "")
                lblCategoryName.text = categoryName
                lblDetail.text = incidentString
                
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let showDate = inputFormatter.date(from: detail.incident_date ?? "")
                inputFormatter.dateFormat = "MMM dd,yyyy hh:mm a"
                let resultString = inputFormatter.string(from: showDate!)
                
                lblDate.text = resultString
                return cell!
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- UIButtonActions
    @IBAction func showImgVideo(_ sender: Any) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ComplaintImagesVideosVC") as? ComplaintImagesVideosVC
            vc?.imgArr = self.complaintDetailArr.images!
            self.navigationController?.pushViewController(vc!, animated: true)
    }
    //MARK:- Helper
    @objc func timeline() -> Void {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContainerChatTimeVC") as? ContainerChatTimeVC
        vc?.complaintID = complaintID
        vc?.ID = complaintDetailArr._id!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func chatAction() -> Void {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        vc?.ID = complaintDetailArr._id!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    override func backAction() {
        AppSharedData.sharedInstance.isBackIncident = 1
        self.navigationController?.popViewController(animated: true)
    }
}
