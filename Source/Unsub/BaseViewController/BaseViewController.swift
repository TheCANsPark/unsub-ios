//
//  BaseViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 04/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK:- LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        //back
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named:"back-arrow"), for: .normal) // Image can be downloaded from here below link
        backbutton.addTarget(self, action: #selector(BaseViewController.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        let menuBarItem = UIBarButtonItem(customView: backbutton)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Helper
    @objc func backAction() -> Void {
        navigationController?.popViewController(animated: true)
    }
   
}
