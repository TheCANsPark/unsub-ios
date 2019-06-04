//
//  ContainerViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 04/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class ContainerViewController: BaseViewController {

    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var contactView: UIView!
    
    
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var imgContact: UIImageView!
    
    
    //MARK:- LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        homeView.isHidden = false
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-active")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:-UIButtonActions
    
    @IBAction func home(_ sender: Any) {
        homeView.isHidden = false
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-active")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
    }
    
    
    @IBAction func profile(_ sender: Any) {
        homeView.isHidden = true
        profileView.isHidden = false
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-active")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
    }
    
    
    @IBAction func chat(_ sender: Any) {
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = false
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
    }
    
    
    @IBAction func contact(_ sender: Any) {
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = false
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny")
    }
    
    

}
