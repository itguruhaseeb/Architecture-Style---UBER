//
//  ViewController.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import UIKit

class VC1: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewId = "View1"
        
        UIManager.register(view: self)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn:UIButton = UIButton(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        btn.setTitle("Navigate to VC2", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(onNavigate), for: .touchUpInside)
        
        let btn2:UIButton = UIButton(frame: CGRect(x: 100, y: 300, width: 150, height: 50))
        btn2.setTitle("Reserve", for: .normal)
        btn2.titleLabel?.textColor = UIColor.white
        btn2.backgroundColor = UIColor.blue
        btn2.addTarget(self, action: #selector(onReserve), for: .touchUpInside)
        
        
        let btn3:UIButton = UIButton(frame: CGRect(x: 100, y: 375, width: 150, height: 50))
        btn3.setTitle("Cancel", for: .normal)
        btn3.titleLabel?.textColor = UIColor.white
        btn3.backgroundColor = UIColor.blue
        btn3.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        self.view.addSubview(btn)
        self.view.addSubview(btn2)
        self.view.addSubview(btn3)

    }
    
    func onNavigate(){
        UIManager.flowController?.navigate(url: "myapp://VC2")
    }
    
    func onReserve(){
        UIManager.flowController?.navigate(url: "myapp://featureABC?cmd=reserve#reservationId=82348@viewId="+self.viewId)
        print("You clicked me")
    }
    
    func onCancel(){
        UIManager.flowController?.navigate(url: "myapp://featureABC?cmd=cancel#reservationId=82348@viewId="+self.viewId)
        print("You clicked me")
    }
    
    override func reload(model: View) {
        print("\(model.data!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

