//
//  RBExceptionManager.swift
//  test
//
//  Created by Haseeb on 1/4/18.
//  Copyright © 2018 Haseeb. All rights reserved.
//

import Foundation

class ExceptionManager{
    private var logs:  Array<Error>
    private let loggingSystemURL:String?
    private var callback: (Error?) -> ()
    
    /**
     Initializer takes the remote logging system url. The initializer will be evolved in the next versions based on configurations
     
     - Author:
     Haseeb Afsar
     
     - parameters:
     * logSystem: String takes the remote system URL
     
     - returns:
     Returns [ExceptionManager] object
     
     */
    init( logSystem: String? ) {
        self.loggingSystemURL = logSystem
        self.logs = [Error]()
        self.callback = {_ in }
    }
    
    
    /**
     Interface to observe error.
     
     - Author:
     Haseeb Afsar
     
     - parameters:
     * observer: Closure(Error) It takes a closure and passes the Error object which is published from any other modules
     
     - returns:
     Returns nothing
     
     */
    func setObserver(observer: @escaping (Error?) -> ()) {
        self.callback = observer
    }
    
    
    /**
     Interface to publish error.
     
     - Author:
     Haseeb Afsar
     
     - parameters:
     * error: Error
     
     - returns:
     Returns nothing
     
     */
    func publish(error: Error){
        self.logs.append( error )
        self.callback( error )
    }
    
    
}

