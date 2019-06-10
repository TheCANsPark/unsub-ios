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
    
   
    var rightButtonTitle = UIBarButtonItem()
    let openMen = UIButton(type: .custom)
    
    
    //MARK:- LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        homeView.isHidden = false
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-active")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        customizeNavigationBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        homeView.isHidden = false
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-active")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        customizeNavigationBar()
        //loginImage
        let loginImg = UIButton(type: .custom)
        loginImg.setImage(UIImage(named:"login"), for: .normal) // Image can be downloaded from here below link
        let loginBar = UIBarButtonItem(customView: loginImg)
        let currWidth1 = loginBar.customView?.widthAnchor.constraint(equalToConstant: 13)
        currWidth1?.isActive = true
        let currHeight1 = loginBar.customView?.heightAnchor.constraint(equalToConstant: 13)
        currHeight1?.isActive = true
        
            if UserDefaults.standard.bool(forKey: kLogin) == true {
            rightButtonTitle = UIBarButtonItem.init(
                title: "LOGOUT",
                style: .done,
                target: self,
                action: #selector(ContainerViewController.logout)
            )
            
        } else {
            rightButtonTitle = UIBarButtonItem.init(
                title: "LOGIN",
                style: .done,
                target: self,
                action: #selector(ContainerViewController.login)
            )
        }
        //loginTitle
        rightButtonTitle.tintColor = UIColor.white
        rightButtonTitle.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Montserrat-SemiBold", size: 13)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItems = [rightButtonTitle,loginBar]
        self.navigationItem.leftBarButtonItem = nil

    }
    override func viewWillDisappear(_ animated: Bool) {
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!)
//        //menu
//        let menuBarItem = UIBarButtonItem(customView: openMen)
//        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
//        currWidth?.isActive = true
//        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
//        currHeight?.isActive = true
//        openMen.setImage(UIImage(named:"back-arrow"), for: .normal) // Image can be downloaded from here below link
//        openMen.addTarget(self, action: #selector(ContainerViewController.openMenu), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = menuBarItem

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
        
        customizeNavigationBar()
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
        
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!)
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
        
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!)
    }
    @IBAction func contact(_ sender: Any) {
        AppSharedData.sharedInstance.contactViewControllerRef.getContacts()
        
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = false
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "footer-comment-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny")
        
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!)
    }
    //MARK:- Helper
    func customizeNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    @objc func openMenu() -> Void {
        //        let popVC:SideBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideBarViewController") as! SideBarViewController
        //        popVC.modalTransitionStyle = .crossDissolve
        //        popVC.modalPresentationStyle = .overFullScreen
        //        popVC.delegate = self
        //        self.present(popVC, animated: true, completion: nil)
    }
    @objc func login() -> Void {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginnViewController") as! LoginnViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func logout() -> Void {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            UserDefaults.standard.set(nil, forKey: kDictTokens)
            UserDefaults.standard.set(false, forKey: kLogin)
            self.viewWillAppear(true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
  }
