//
//  PopUpHomeViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 25/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class PopUpHomeViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var viewPop: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewPop.layer.cornerRadius = 5
        viewPop.clipsToBounds = true
        
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopUpHomeViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openBrowser(_ sender: Any) {
        print("dfer")
        guard let url = URL(string: "http://cwcdafrica.org") else { return }
        UIApplication.shared.open(url)
    }
    //MARK:- Helper
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
        //self.dismiss(animated: true, completion: nil)
    }
}
