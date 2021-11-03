//
//  ForumDetailViewController.swift
//  Unsub
//
//  Created by mac on 26/10/21.
//  Copyright © 2021 codezilla-mac1. All rights reserved.
//

import UIKit
import Gloss

class ForumDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var viewBottomToolBar: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    var arrForums = [Forum]()
    var arrComments = [ForumComment]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBottomToolBar.layer.cornerRadius = 17.5
        viewBottomToolBar.layer.borderWidth = 0.5
        viewBottomToolBar.layer.borderColor = UIColor.lightGray.cgColor
        viewBottomToolBar.clipsToBounds = true
        
        
        self.title = "Forums Details"
        tableView.separatorStyle = .none
        tableView.rowHeight = 300.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.inputContainerViewBottom.constant =  10
        getForumCommentServerRequest()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }
    // MARK: - Selector
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                //self.inputContainerViewBottom.constant =  40
                self.inputContainerViewBottom.constant =  10
                
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                if #available(iOS 11.0, *) {
                    let newHeight = keyboardHeight - UIApplication.shared.keyWindow!.safeAreaInsets.bottom
                    self.inputContainerViewBottom.constant = newHeight
                } else {
                    self.inputContainerViewBottom.constant = keyboardHeight
                }
                
                
                
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
            
        }
    }
    //MARK:- Helper
    func timeAgoStringFromDate(date: String) -> String? {
        
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let inputDate = df.date(from: date) else {return ""}
        
        
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < inputDate {
            
            
            
            let diff = Calendar.current.dateComponents([.second], from: inputDate, to: Date()).second ?? 0
            
            if diff <  0{
                return "just now"
            }else{
                return "\(diff) sec ago"
            }
            
            
            
        } else if hourAgo < inputDate {
            let diff = Calendar.current.dateComponents([.minute], from: inputDate, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < inputDate {
            let diff = Calendar.current.dateComponents([.hour], from: inputDate, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < inputDate {
            let diff = Calendar.current.dateComponents([.day], from: inputDate, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: inputDate, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
    //MARK:- UIButtonActions
    @IBAction func btnPostaComment(_ sender: Any) {
        if txtView.text == "" {
            
        } else {
            postCommentServerRequest()
        }
    }
    @IBAction func btnLikeForum(_ sender: Any) {
        forumLikeServerRequest()
    }

    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrForums.count
        }else{
            return arrComments.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForumTableCell")
            let lblTitle : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblBy : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
            let imgView : UIImageView = cell?.contentView.viewWithTag(102) as! UIImageView
            let lblTotalComments : UILabel = cell?.contentView.viewWithTag(103) as! UILabel
            let lblDescription : UILabel = cell?.contentView.viewWithTag(104) as! UILabel
            let lblLastUpdateDate : UILabel = cell?.contentView.viewWithTag(105) as! UILabel
            
            let lblTotalLikes : UILabel = cell?.contentView.viewWithTag(106) as! UILabel
            
           
            
            cell?.selectionStyle = .none
            
            let forum = arrForums[indexPath.row]
            lblTitle.text = forum.title ?? ""
            lblBy.text = ""
            lblDescription.text = "\(forum.description ?? "")"
            lblTotalComments.text = "\(arrComments.count)"
            lblTotalLikes.text = "\(forum.total_likes ?? 0)"
            imgView.setImgFromUrl(url: "\(forum.image_url ?? "")")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let updatedOnDate = formatter.date(from: forum.updatedAt ?? "")
            
            formatter.dateFormat = "dd-mm-yyyy hh:mm a"
            lblLastUpdateDate.text =  formatter.string(from: updatedOnDate ?? Date())
           
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForumCommentTableCell")
            let lblComment : UILabel = cell?.contentView.viewWithTag(100) as! UILabel
            let lblName : UILabel = cell?.contentView.viewWithTag(101) as! UILabel
            let lblAgoDate : UILabel = cell?.contentView.viewWithTag(102) as! UILabel
            
            let comment = arrComments[indexPath.row]
            lblComment.text = "\(comment.comment ?? "")"
            
            lblName.text = "\(comment.user_id?.name?.first ?? "") \(comment.user_id?.name?.last ?? "")"
            
            lblAgoDate.text = self.timeAgoStringFromDate(date: comment.updatedAt ?? "")
            
            return cell!
        }
        
        
        
    }
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
            let lbl = UILabel(frame: CGRect(x: 10, y: 10, width: 130, height: 10))
            lbl.text = "Comments:"
            lbl.font = UIFont.systemFont(ofSize: 12.0)
            viewHeader.addSubview(lbl)
            return viewHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
           
            return viewHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 25
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
    }
    //MARK:- Server Request
    func getForumCommentServerRequest() {
        Loader.shared.show()
        let urlStr = "\(WEB_URL.getForumsComments)/\(arrForums[0]._id ?? "")"
        NetworkManager.sharedInstance.apiParseGet(url: urlStr, completion: {(response :NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                if let res = [ForumComment].from(jsonArray: response?.value(forKey: "data") as! [JSON]) {
                    self.arrComments = res
                    self.tableView.reloadData()
                }
            }
        })
    }
    func postCommentServerRequest() {
        view.endEditing(true)
        Loader.shared.show()
        let param = ["comment": txtView.text!]
        let urlStr = "\(WEB_URL.getForumsComments)/\(arrForums[0]._id ?? "")"
        NetworkManager.sharedInstance.apiParsePostWithJsonEncoding(urlStr as NSString, postParameters: param as NSDictionary, completionHandler: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            self.txtView.text! = ""
            if statusCode == STATUS_CODE.success {
                self.getForumCommentServerRequest()
                
            }else {
                AppSharedData.sharedInstance.alert(vc: self, message: "Could not load")
            }
        })
    }
    
    func forumLikeServerRequest() {
        view.endEditing(true)
        Loader.shared.show()
        let urlStr = "\(WEB_URL.getForums)/\(arrForums[0]._id ?? "")"
        NetworkManager.sharedInstance.apiParsePostWithJsonEncoding(urlStr as NSString, postParameters: nil, completionHandler: {(response : NSDictionary?, statusCode :Int?) in
            Loader.shared.hide()
            if statusCode == STATUS_CODE.success {
                self.arrForums[0].total_likes = (self.arrForums[0].total_likes ?? 0) + 1
                self.tableView.reloadData()
                
            }else {
                AppSharedData.sharedInstance.alert(vc: self, message: "Could not load")
            }
        })
    }

}
