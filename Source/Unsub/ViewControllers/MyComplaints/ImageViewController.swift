//
//  ImageViewController.swift
//  Unsub
//
//  Created by codezilla-mac1 on 17/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    var img = UIImage()
    var imgUrl = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.setImgFromUrl(url: "\(imgUrl)")
     
        let data = try? Data(contentsOf: imgUrl as URL)
        if let imageData = data {
            let image = UIImage(data: imageData)
            imgView.image = image
        }else {
            imgView.image = UIImage(named: "placeholder")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
