//
//  RouterHelper.swift
//  test
//
//  Created by Haseeb on 1/5/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation

class RouterHelper{
    private var businessMgr:BusinessManager? = nil
    
    init( businessLayer: BusinessManager ){
        self.businessMgr = businessLayer
    }

    
    func featureABCReserve(viewId: String, params:String){
        self.businessMgr?.moduleManager?.featureABC?.reserve(viewId: viewId, params: params)
    }
    
    func featureABCCancel( viewId: String, params:String ){
        self.businessMgr?.moduleManager?.featureABC?.cancel(viewId: viewId, params: params)
    }
    
    func featureXYZGetData(){
        self.businessMgr?.moduleManager?.featureXYZ?.getData()
    }
    
    func testModelLayer(){
        
    }
    
}
