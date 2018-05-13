//
//  ViewContext.swift
//  test
//
//  Created by Haseeb on 1/5/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation

class ViewContext{
    var id:String? = nil
    var model:View?  = nil
    
    init(viewId: String, model: View ){
        self.id = viewId
        self.model = model
    }
}
