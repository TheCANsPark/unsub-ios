//
//  TermsViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 25/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var webViews: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://engag-terms-privacy.s3-eu-west-1.amazonaws.com/terms_and_conditions.html")
        webViews.loadRequest(URLRequest(url: url!))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func dsimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
