//
//  BaseVC.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var viewId:String = "SomeId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Divarse of any resources that can be recreated.
        
    }
    
    func onClick(){
        
    }
    
    func reload( model: View ){
        print("Control coming here \(self.viewId)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
