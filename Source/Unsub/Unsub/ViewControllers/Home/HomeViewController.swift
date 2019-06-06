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
    }
    
    
    @IBAction func emergencyAction(_ sender: Any) {
    }
    
    
    @IBAction func myComplaintsActio(_ sender: Any) {
    }
    
    
    
    @IBAction func resourceCenterAction(_ sender: Any) {
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}
