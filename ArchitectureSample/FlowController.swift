//
//  FlowController.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation
import UIKit

class FlowController{
    private var nav:UINavigationController? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var history     = Array<String>()
    var views:Array<BaseVC> = Array<BaseVC>()
    private let actionMapper:UIActionMapper? = UIActionMapper()
    
    public func navigate( url: String ){
      
      let str:Array = url.components(separatedBy: "myapp://")
      let controllerName:String = str.last!
      
      if let targetVC:UIViewController = viewControllerFromString(viewControllerName:controllerName){
        targetVC.view.backgroundColor = .white;
        targetVC.title = str.last!
        
        
        if ( appDelegate.window?.rootViewController == nil ){
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            appDelegate.window?.makeKeyAndVisible()
            
            self.nav = UINavigationController(rootViewController: targetVC)
            appDelegate.window?.rootViewController = self.nav
            history.append(url)
            return;
            
        }
        
        self.nav?.pushViewController(targetVC, animated: true)
        history.append(url)
        self.actionMapper?.map(actionUrl: url)

      }else{
            self.actionMapper?.map(actionUrl: url)
           // print("View controller doesnt exist \(url)")
      }
        
        
    }
    
    func getViewById(viewId: String) -> BaseVC{
        
        let view = self.views.filter({ (view) -> Bool in
            view.viewId == viewId
        }).first
        
        return (view == nil) ? BaseVC() : view!
        
    }
    
    func register( view: BaseVC ){
        if let viewExists:BaseVC = self.getViewById(viewId: view.viewId ),
            viewExists.viewId != "SomeId"{
           // print( "View does exist \(viewExists)" )
            return
        }
        
        self.views.append(view)
    }
    
    func viewControllerFromString(viewControllerName: String) -> UIViewController? {
        
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            print("CFBundleName - \(appName)")
            if let viewControllerType = NSClassFromString("\(appName).\(viewControllerName)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }
        
        return nil
    }
   

}
