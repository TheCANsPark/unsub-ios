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
        self.title = "Incidence Details"
        getComplaintDetail()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //timeline image
        let rightImage = UIButton(type: .custom)
        rightImage.setImage(UIImage(named:"top"), for: .normal) // Image can be downloaded from here below link
        rightImage.addTarget(self, action: #selector(ComplaintDetailViewController.timeline), for: .touchUpInside)
     //   self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightImage)
        let time = UIBarButtonItem(customView: rightImage)
        let menuBarItem = UIBarButtonItem(customView: rightImage)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        
        //chat image
        let chatImg = UIButton(type: .custom)
        chatImg.setImage(UIImage(named:"footer-profile-black"), for: .normal) // Image can be downloaded from here below link
        chatImg.addTarget(self, action: #selector(ComplaintDetailViewController.chatAction), for: .touchUpInside)
      //  self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: chatImg)
        let cha = UIBarButtonItem(customView: chatImg)
        let chatImgItem = UIBarButtonItem(customView: rightImage)
        let currWidth1 = chatImgItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth1?.isActive = true
        let currHeight1 = chatImgItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight1?.isActive = true
        
        self.navigationItem.rightBarButtonItems = [time, cha]
    }
    //MARK:- Server Request
    func getComplaintDetail() {
        //tableView.isHidden = true
        Loader.shared.show()
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getIncidentDetails + "\(complaintID)", completion: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            
            if statusCode == STATUS_CODE.success {
             //  self.tableView.isHidden = false
                if let com = Incidents.init(json: response?.value(forKey: "data") as! JSON) {
                    self.complaintDetailArr = com
                    self.tableView.reloadData()
                }
            } else {
                AppSharedData.sharedInstance.alert(vc: self, message: "Could not load")
            }
        })
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && (complaintDetailArr != nil) {
           return 1
        } else {
            return 0
        }
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
            let lblCategoryName : UILabel = cell?.contentView.viewWithTag(106) as! UILabel
            let lblDetail : UILabel = cell?.contentView.viewWithTag(107) as! UILabel
            let lblStatus : UILabel = cell?.contentView.viewWithTag(200) as! UILabel
            
            lblName.text = "\(detail.name?.first ?? "")" + " \(detail.name?.last ?? "")"
            lblVictimMobile.text = "\(detail.phone_number ?? "N/A")"
            lblAddress.text = "\(detail.address?.address ?? "")"
            lblMail.text = "\(detail.email ?? "")"
            lblComplaintNumber.text = "#\(detail.complaint_number!)"
            lblImage.text = ""
            lblStatus.text = detail.status!
            lblCategoryName.text = categoryName
            lblDetail.text = incidentString
            return cell!
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
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TimelineViewController") as? TimelineViewController
        vc?.complaintID = complaintID
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
