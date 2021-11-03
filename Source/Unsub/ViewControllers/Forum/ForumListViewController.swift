//
//  ForumListViewController.swift
//  Unsub
//
//  Created by mac on 25/10/21.
//  Copyright © 2021 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss

class ForumListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var arrForums = [Forum]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Forums"
        tableView.separatorStyle = .none
        tableView.rowHeight = 300.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        getForumListServerRequest()

        // Do any additional setup after loading the view.
    }
    

    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForumTableCell")
        let lblTitle : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
        let lblBy : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
        let imgView : UIImageView = cell?.contentView.viewWithTag(102) as! UIImageView
        let lblTotalComments : UILabel = cell?.contentView.viewWithTag(103) as! UILabel
        let lblDescription : UILabel = cell?.contentView.viewWithTag(104) as! UILabel
        let lblLastUpdateDate : UILabel = cell?.contentView.viewWithTag(105) as! UILabel
        
        cell?.selectionStyle = .none
        
        let forum = arrForums[indexPath.row]
        lblTitle.text = forum.title ?? ""
        lblBy.text = ""
        lblDescription.text = "\(forum.description ?? "")"
        lblTotalComments.text = "\(forum.total_likes ?? 0) comments"
        imgView.setImgFromUrl(url: "\(forum.image_url ?? "")")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let updatedOnDate = formatter.date(from: forum.updatedAt ?? "")
        
        formatter.dateFormat = "dd-mm-yyyy hh:mm a"
        lblLastUpdateDate.text =  formatter.string(from: updatedOnDate ?? Date())
       
        return cell!
        
    }
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController
        vc?.arrForums.append(arrForums[indexPath.row])
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //MARK:- Server Request
    func getForumListServerRequest() {
        Loader.shared.show()
        tableView.isHidden = true
        NetworkManager.sharedInstance.apiParseGet(url: WEB_URL.getForums, completion: {(response :NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                if let res = [Forum].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.arrForums = res
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        })
    }

}
