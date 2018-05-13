//
//  UIActionMapper.swift
//  test
//
//  Created by Haseeb on 1/5/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation
import UIKit

class UIActionMapper{
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let businessLayer:BusinessManager = BusinessManager.sharedInstance
    
    public func map(actionUrl: String){
        businessLayer.router?.action(url: actionUrl)
    }
}
