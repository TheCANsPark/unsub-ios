//
//  CustomView.swift
//  DealDio
//
//  Created by codezilla-mac1 on 09/03/18.
//  Copyright © 2018 codezilla-mac1. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
     override init (frame : CGRect) {
           super.init(frame : frame)
           self.customInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.customInit()
       }
       
       
       func customInit()  {
           self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.4
           self.layer.shadowOffset = CGSize.zero
           self.layer.shadowRadius = 5
           self.layer.cornerRadius = 10
    }
    
}
