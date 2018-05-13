//
//  VC3.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import UIKit

class VC3: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn:UIButton = UIButton(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        btn.setTitle("VC3", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        self.view.addSubview(btn)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onClick(){
        super.onClick()
        print("You clicked me")
        UIManager.flowController?.navigate(url: "myapp://View")
    }
    
    override func reload(model: View) {
        
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
