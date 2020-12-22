//
//  HomeViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 04/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    
    
    //MARK:- LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {  
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButtonActions
    @IBAction func btnRecord(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceRecordToReportVC") as! VoiceRecordToReportVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func fileComplaintAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileComplaintsViewController") as? FileComplaintsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func emergencyAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("loadContactViewController"), object: nil)
    }
    @IBAction func myComplaintsActio(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: kLogin) == true  {
            NotificationCenter.default.post(name: Notification.Name("loadIncidentsViewController"), object: nil)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginnViewController") as! LoginnViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func resourceCenterAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResourceCenterViewController") as? ResourceCenterViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   }
