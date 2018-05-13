//
//  BookWorkSpaceManager.swift
//  test
//
//  Created by Haseeb on 1/5/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation



class FeatureABCService{
    
    private var businessMgr:BusinessManager? = nil
    
    
    
    init( businessLayer: BusinessManager ){
        
        self.businessMgr = businessLayer
        
    }
    
    
    
    
    /*
     Here the interface reserve takes viewId and params associated
     Since this is a example feature mocks making some reservation. We try to resemble
     a network call with self.businessMgr?.networkManager?.restCall which will always
     execute the onSuccess callback for now. Where we assume that we've got a successful
     response from the server and inside the block we invoke the UIManager
     to update the respective view with some static sample data which is
     some string here
     
     To update a view the UIManager needs something called ViewContext
     The ViewContext is made up of the following:
     - view identifier - viewId (String)
     - view Model      - model (View)
     
     */
    func reserve(viewId: String, params: String){
        
        var reservationId = params.replacingOccurrences(of: "reservationId=", with: "")
        
        self.businessMgr?.networkManager?.restCall(url: "some service url goes here", onSuccess: {
            
            let newModel = View(error: nil, data: "Reservation done successfully confirmation id: #8347838")
            
            let context:ViewContext = ViewContext(viewId: viewId, model: newModel)
            
            
            
            UIManager.reload(viewContext: context)
            
        })
        
    }
    
    
    /*
     Here the interface reserve takes viewId and params associated
     Since this is a example feature mocks a cancellation of reservation.
     We try to resemble a network call with self.businessMgr?.networkManager?.restCall which will always
     execute the onSuccess callback for now. Where we assume that we've got a successful
     response from the server and inside the block we invoke the UIManager
     to update the respective view with some static sample data which is
     some string here
     
     To update a view the UIManager needs something called ViewContext
     The ViewContext is made up of the following:
     - view identifier - viewId (String)
     - view Model      - model (View)
     
     
     */
    
    func cancel(viewId: String, params: String){
        
        var reservationId = params.replacingOccurrences(of: "reservationId=", with: "")
        
        self.businessMgr?.networkManager?.restCall(url: "some service url goes here", onSuccess: {
            
            let newModel = View(error: nil, data: "Reservation cancelled successfully for reservation id: #\(reservationId)")
            
            let context:ViewContext = ViewContext(viewId: viewId, model: newModel)
            
            
            
            UIManager.reload(viewContext: context)
            
        })
        
    }
    
    
    
    func update(){
        
        //to be implemented
        
    }
    
}

