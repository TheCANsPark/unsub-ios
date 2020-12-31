//
//  ContainerViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 04/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit
import AES256CBC

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
        
        appShared.containerVCRef = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadContact(notification:)), name: Notification.Name("loadContactViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadIncidences(notification:)), name: Notification.Name("loadIncidentsViewController"), object: nil)
        
        homeView.isHidden = false
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-active")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "my-complaints-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        customizeNavigationBar()
        setUpNavBarLoginBtn()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if AppSharedData.sharedInstance.isBackIncident == 1 {
            AppSharedData.sharedInstance.isBackIncident = 0 
            
        } else {
            homeView.isHidden = false
            profileView.isHidden = true
            chatView.isHidden = true
            contactView.isHidden = true
            
            imgHome.image = #imageLiteral(resourceName: "footer-home-active")
            imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
            imgChat.image = #imageLiteral(resourceName: "my-complaints-black")
            imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
            
            customizeNavigationBar()
            setUpNavBarLoginBtn()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.view.removeGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.view.addGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
    }
    override func viewWillDisappear(_ animated: Bool) {
       // AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!)
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!, colour1: UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1), colour2: UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1))
        
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavBarLoginBtn() {
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
    }
    
    func setBackBtnOnCaseList() {
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named:"back-arrow"), for: .normal) // Image can be downloaded from here below link
        backbutton.addTarget(self, action: #selector(home(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        let menuBarItem = UIBarButtonItem(customView: backbutton)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
    }
    
    func customizeNavigationBar() {
    //     AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //back
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(named:"C"), for: .normal) // Image can be downloaded from here below link
        infoButton.addTarget(self, action: #selector(ContainerViewController.info), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        let menuBarItem = UIBarButtonItem(customView: infoButton)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        
        self.title = ""
    }
    
    //MARK:-UIButtonActions
    @IBAction func home(_ sender: Any) {
        self.title = ""
        homeView.isHidden = false
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-active")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "my-complaints-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        customizeNavigationBar()
        setUpNavBarLoginBtn()
    }
    @IBAction func profile(_ sender: Any) {
        self.title = "Profile"
        
        if UserDefaults.standard.bool(forKey: kLogin) == true {
            homeView.isHidden = true
            profileView.isHidden = false
            chatView.isHidden = true
            contactView.isHidden = true
            
            imgHome.image = #imageLiteral(resourceName: "footer-home-black")
            imgProfile.image = #imageLiteral(resourceName: "footer-profile-active")
            imgChat.image = #imageLiteral(resourceName: "my-complaints-black")
            imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
            AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!, colour1: UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1), colour2: UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1))
            
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItems = nil
            
            AppSharedData.sharedInstance.profileViewControllerRef.getProfile()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginnViewController") as! LoginnViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func chat(_ sender: Any) {
        self.title = "My Case List"
        if UserDefaults.standard.bool(forKey: kLogin) == true {
           AppSharedData.sharedInstance.myComplaintsViewControllerRef.getIncidents()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginnViewController") as! LoginnViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = false
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "my-complaints-active")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!, colour1: UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1), colour2: UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1))
        self.setBackBtnOnCaseList()
        self.navigationItem.rightBarButtonItems = nil
        
    }
    @IBAction func contact(_ sender: Any) {
        self.title = "Emergency Numbers"
        AppSharedData.sharedInstance.contactViewControllerRef.getContacts()
        
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = false
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "my-complaints-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny")
        
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!, colour1: UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1), colour2: UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        
    }
    //MARK:- Helper
    @objc func login() -> Void {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginnViewController") as! LoginnViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func logout() -> Void {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            UserDefaults.standard.set(nil, forKey: kDictTokens)
            UserDefaults.standard.set(false, forKey: kLogin)
            UserDefaults.standard.set(nil, forKey: kLoginResponse)
            
            appShared.homeViewControllerRef.viewDidLoad() ////Update home record feature
            
            self.viewWillAppear(true)
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    @objc func loadContact(notification: Notification) {
        self.title = "Emergency Numbers"
        AppSharedData.sharedInstance.contactViewControllerRef.getContacts()
        
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = true
        contactView.isHidden = false
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "my-complaints-black")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny")
    AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!, colour1: UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1), colour2: UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1))
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        
    }
    @objc func loadIncidences(notification: Notification) {
        self.title = "My Case List"
    AppSharedData.sharedInstance.myComplaintsViewControllerRef.getIncidents()
        homeView.isHidden = true
        profileView.isHidden = true
        chatView.isHidden = false
        contactView.isHidden = true
        
        imgHome.image = #imageLiteral(resourceName: "footer-home-black")
        imgProfile.image = #imageLiteral(resourceName: "footer-profile-black")
        imgChat.image = #imageLiteral(resourceName: "my-complaints-active")
        imgContact.image = #imageLiteral(resourceName: "footer-emargeny-black")
        
        AppSharedData.sharedInstance.setGradientOnObject((self.navigationController?.navigationBar)!, colour1: UIColor(red: 255/255, green: 188/255, blue: 58/255, alpha: 1), colour2: UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1))
        
        setBackBtnOnCaseList()
        self.navigationItem.rightBarButtonItems = nil
    }
    @objc func info() -> Void {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpHomeViewController") as! PopUpHomeViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
  }
