//
//  ContainerChatTimeVC.swift
//  Unsub
//
//  Created by codezilla-mac1 on 28/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class ContainerChatTimeVC: BaseViewController {

    
    @IBOutlet weak var lblSlide: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    
    
    @IBOutlet weak var chatingView: UIView!
    @IBOutlet weak var timelineView: UIView!
    
    @IBOutlet weak var leadingConstraintLblSlider: NSLayoutConstraint!
    
    var ID = String()
    var complaintID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineView.isHidden = false
        chatingView.isHidden = true
        
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatViewController,
            segue.identifier == "chatSegue" {
            vc.ID = ID
        }
        if let vc1 = segue.destination as? TimelineViewController,
            segue.identifier == "timelineSegue" {
            vc1.complaintID = complaintID
        }
    }
    //MARK:- UIButtonActions
    @IBAction func chat(_ sender: Any) {
        AppSharedData.sharedInstance.chatViewControllerRef.getComments()
        chatingView.isHidden = false
        timelineView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            let width = self.lblSlide.frame.size.width
            self.leadingConstraintLblSlider.constant = width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func timeline(_ sender: Any) {
        AppSharedData.sharedInstance.chatViewControllerRef.txtQuery.resignFirstResponder()
        AppSharedData.sharedInstance.timelineViewControllerRef.getTimeline()
        timelineView.isHidden = false
        chatingView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.leadingConstraintLblSlider.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
