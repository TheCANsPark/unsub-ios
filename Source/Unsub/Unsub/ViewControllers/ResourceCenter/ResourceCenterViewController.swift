//
//  ResourceCenterViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 18/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss
class ResourceCenterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var resourceArr = [Resource]()
    let documentInteractiveVC = UIDocumentInteractionController()
    var fileName = String()
    var fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Resource Category"
        getResourceCenter()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Server Request
    func getResourceCenter() {
        Loader.shared.show()
        tableView.isHidden = true
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getResourceCategory, completion: {(response :NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                if let res = [Resource].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.resourceArr = res
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        })
    }
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resourceArr.count != 0 {
            return resourceArr.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCenterTableCell")
        let lblName : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
        let resource = resourceArr[indexPath.row]
        lblName.text = resource.name!
        return cell!
    }
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResourceDetailViewController") as? ResourceDetailViewController
        vc?.ID = resourceArr[indexPath.row]._id!
        vc?.titleStr = resourceArr[indexPath.row].name!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
   
 }