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
    
    var isToOpenPolicy = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var strUrl: String?
        if isToOpenPolicy {
            strUrl = "https://unsub-prod.s3-eu-west-1.amazonaws.com/tnc/unsub_privacy.html"
        }else {
            strUrl = "https://unsub-prod.s3-eu-west-1.amazonaws.com/tnc/unsub_tnc.html"
        }
        
        //"https://engag-terms-privacy.s3-eu-west-1.amazonaws.com/terms_and_conditions.html"
        
        if let url = strUrl{
            if let myURL = URL(string:url) {
                let myRequest = URLRequest(url: myURL)
                webViews.loadRequest(myRequest)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dsimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
