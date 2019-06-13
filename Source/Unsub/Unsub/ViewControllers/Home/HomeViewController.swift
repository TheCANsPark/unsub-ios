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
    
    
    @IBAction func fileComplaintAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileComplaintsViewController") as? FileComplaintsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func emergencyAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactViewController") as? ContactViewController
        vc?.isHome = 1
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func myComplaintsActio(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyComplaintsViewController") as? MyComplaintsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    @IBAction func resourceCenterAction(_ sender: Any) {
    }
    
    
    
    
}
