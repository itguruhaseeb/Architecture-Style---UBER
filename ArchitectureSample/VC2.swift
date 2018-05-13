//
//  VC2.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import UIKit

class VC2: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewId = "View2"
        
        let btn:UIButton = UIButton(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        btn.setTitle("VC3", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(onNavigate), for: .touchUpInside)
        
        self.view.addSubview(btn)
        
        let btn2:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 150, height: 50))
        btn2.setTitle("Get Data", for: .normal)
        btn2.titleLabel?.textColor = UIColor.white
        btn2.backgroundColor = UIColor.blue
        btn2.addTarget(self, action: #selector(onGetData), for: .touchUpInside)
        
        self.view.addSubview(btn2)
    }
    
    func onGetData(){
        UIManager.flowController?.navigate(url: "myapp://featureXYZ?cmd=getData@viewId="+self.viewId)
    }
    
    override func reload( model: View ){
        super.reload(model: model)
        print("Here is the data from my model :: \(model.data!)")
    }
    
    func onNavigate(){
       UIManager.flowController?.navigate(url: "myapp://VC3")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
