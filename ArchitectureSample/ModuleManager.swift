//
//  ModuleManager.swift
//  test
//
//  Created by Haseeb on 1/5/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation

class ModuleManager{
    private var businessMgr:BusinessManager? = nil
    var featureXYZ:FeatureXYZService? = nil
    var featureABC:FeatureABCService? = nil
    
    init( businessLayer: BusinessManager ){
        self.businessMgr = businessLayer
        
        self.featureXYZ = FeatureXYZService()
        self.featureABC = FeatureABCService(businessLayer: self.businessMgr!)
    }
    
    
}
