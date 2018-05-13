//
//  Router.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation

class Router{
    
    private var businessMgr:BusinessManager? = nil
    private var routerHelper:RouterHelper? = nil
    
    init( businessLayer: BusinessManager ){
        self.businessMgr  = businessLayer
        self.routerHelper = RouterHelper(businessLayer: self.businessMgr!)
    }
    
    func action( url: String ){
        
       
        let action:String  = url.components(separatedBy: "myapp://").last!
        let moduleData   = action.components(separatedBy: "?")
        let params       = moduleData.last?.components(separatedBy: "#")
        let moduleName   = moduleData.first
        let cmd          = params?.first
        let moduleCommand = cmd?.replacingOccurrences(of: "cmd=", with: "").components(separatedBy: "@").first
        let query       = params?.last?.components(separatedBy: "@")
        let viewId      = query?.last?.replacingOccurrences(of: "viewId=", with: "")
        let queryParams = query?.first
        
        if ( moduleName == "featureABC" ){
            
            if moduleCommand == "reserve"{
                self.routerHelper?.featureABCReserve(viewId: viewId!, params: queryParams!)
                return
            }
            
            if moduleCommand == "cancel"{
                self.routerHelper?.featureABCCancel(viewId: viewId!, params: queryParams!)
                return
            }
            
        }
        
        if ( moduleName == "featureXYZ" ){
            if moduleCommand == "getData"{
                self.routerHelper?.featureXYZGetData()
            }
        }
        
    }
    
}
