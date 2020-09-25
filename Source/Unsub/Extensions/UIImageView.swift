//
//  UIImageView.swift
//  Unsub
//
//  Created by codezilla-mac1 on 11/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView{
    
    func setImgFromUrl(url: String) {
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: urlString!), placeholder: UIImage(named: "placeholder"), options:[.transition(.none)], progressBlock: nil, completionHandler: nil)
        
    }
}
