//
//  Loader.swift
//  Unsub
//
//  Created by codezilla-mac1 on 06/06/19.
//  Copyright © 2019 codezilla-mac1. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class Loader: NSObject {
    
    static let shared = Loader()
    func show() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    func hide() {
        PKHUD.sharedHUD.hide()
    }
}
