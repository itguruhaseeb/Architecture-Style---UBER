//
//  UIManager.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//
import Foundation
import UIKit

class UIManager{
    static var sharedInstance = UIManager()
    static let flowController:FlowController? = FlowController()
    private var navCont:UINavigationController? = nil
    
    
    static func reload( viewContext:ViewContext? ){
        let viewId = viewContext?.id
        let view   = self.flowController?.getViewById(viewId: viewId!)
        view?.reload(model: (viewContext?.model!)!)
    }
    
    static func displayOverlayProgress(){
        print("Control coming here")
    }
    
    static func hideOverlayProgress(){
    
    }
    
    static func register( view: BaseVC ){
        self.flowController?.register( view: view)
    }
    
}
