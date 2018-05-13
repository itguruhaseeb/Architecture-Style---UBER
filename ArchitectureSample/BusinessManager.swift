//
//  BusinessManager.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation
import UIKit

class BusinessManager{
    static let sharedInstance = BusinessManager()
    let networkManager:NetworkManager? = NetworkManager()
    var router:Router? = nil
    var moduleManager:ModuleManager? = nil
    
    init(){
        self.router = Router(businessLayer: self)
        self.moduleManager =  ModuleManager(businessLayer: self)
    }
    
}
