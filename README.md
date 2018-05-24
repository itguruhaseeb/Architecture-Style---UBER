<h1> What is Architecture Style UBER?</h1>

I've coined the term "UBER" for an architecture style and what it does. UBER is an architecture style. It applies set of architecture , software design patterns in an efficient way. Which provides structural conformance of the overall architecture in a holistic manner. Rather limited to individual view, model and respective controller. This architecture style begins with focus on layers, concerns defining building blocks, ( User Interface, Business, Entities/Model and Exception, REST) control points, inter module communication which collectively sounds UBER :-).


<h1>Why Architecture Style - UBER?</h1>
<p>Traditionally there is a lot of emphasis given from the get go whilst building mobile apps to choose an architecture pattern that is MVC, MVVM, Reactive or MVP etc. So let's assume you chose MVC as your mobile app architecture pattern. As the mobile app evolves with more features and extensive code base. Let's try to envision what the mobile architecture would look like? The diagram below illustrates a common scenario for a large number of mobile apps</p>

<p><h2>Architecture patterns are redundant silos without a proper architecture style</h2></p>
<img src="https://media.licdn.com/dms/image/C4D12AQFcaRqzCjNUMw/article-inline_image-shrink_1500_2232/0?e=2126476800&v=beta&t=emW3GGWpSPwOahp4i119CALF0JAZUfJrsxPadVYSoOo" title="UBER Architecture style - Architecture patterns redundant silos without architecture style " />

<p><h2>This sample project illustrates the implementation of this architecture style for iOS + Swift</h2></p>
<img src="https://media.licdn.com/dms/image/C4E12AQGcPNw9ALZ16A/article-inline_image-shrink_1500_2232/0?e=2126476800&v=beta&t=FV87J4INYIjgUPaMGnDsIna8NJLRxrg8FQqUg2DTOsc" title="UBER Architecture Style Diagram" />

<h1>Sample Project - How it works?</h1>
<ul>
  <li> iOS App with single window</li>
  <li>Consists of 3 views (UIViewController) namely VC1, VC2, VC3. </li>
  <li>All of them sub-classed from base class with the a field viewId and method reload</li>
<li>VC1 will have 3 buttons "Navigate to VC2" - Will navigate the user to another view controller called VC2, "Reserve" - Invokes a business service or module called FeatureABC to make some dummy reservation, "Cancel" - Invokes a business service or module called FeatureABC to cancel a dummy reservation.</li>
</ul>

<h2> Project Structure </h2>
<img src="https://media.licdn.com/dms/image/C4E12AQFWK8NeIO7d-w/article-inline_image-shrink_1500_2232/0?e=2126476800&v=beta&t=5TJbrM9T_yrWv065hnJSC3ejLIimhkYod6k215M8m3s" title="UBER Architecture Style - Project Structure" />

<h4>UILayer</h4>
<p><b>UIManager.swift</b> - This is the bridge and control point for communication between views and rest of the app. All the communication to views will be channeled through this. It will also be responsible to manage navigation of views, routing view actions to respective business services. Receiving updates for views from business services</p>


```
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
```

<p> <b>FlowController.swift</b> - Its part of the UILayer responsible for managing the navigation flow between views.</p>

```
import Foundation

import UIKit



class FlowController{

    private var nav:UINavigationController? = nil

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var history     = Array<String>()

    var views:Array<BaseVC> = Array<BaseVC>()

    private let actionMapper:UIActionMapper? = UIActionMapper()

    
    /*Maps the action url from view based on url parsing
      to navigate from current view to another view. If not
      maps the requested action to respective business service
    */
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

            print("View controller doesnt exist \(url)")

      }
        
    }
    
    /*
      When the business service needs to update respective view for
      updates it will communicate to the UIManager with the respective view
      id. This method enables the UIManager to lookup for that specific view
      to propogate the update to that view.
    */ 
    func getViewById(viewId: String) -> BaseVC{

        let view = self.views.filter({ (view) -> Bool in

            view.viewId == viewId

        }).first

        
        return (view == nil) ? BaseVC() : view! 

    }

    
    //Registers the view controller for updates from business services
    func register( view: BaseVC ){

        if let viewExists:BaseVC = self.getViewById(viewId: view.viewId ),

            viewExists.viewId != "SomeId"{

            print( "View does exist \(viewExists)" )

            return

        }

        self.views.append(view)

    }

    //Loads the view controller found in the custom uri scheme
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

```
<p><b>UIActionMapper.swift</b> - Its part of the UILayer responsible for routing actions from view to business layer.</p>

```
import Foundation

import UIKit



class UIActionMapper{

    

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let businessLayer:BusinessManager = BusinessManager.sharedInstance

    
    //Forwards the url action to business layer to invoke the respective business service
    public func map(actionUrl: String){

        businessLayer.router?.action(url: actionUrl)

    }

}

```
<h1>Views - All the view controllers are grouped into this.</h1>

<p><h4>BaseVC.swift</h4><p>

```
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

    
    //This is the method which will be invoked by UIManager//When the business service wants to notify respective for updates
    func reload( model: View ){

        print("Control coming here \(self.viewId)")

    }

}
```

<p><h4>VC1.swift</h4></p>

```
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

    
    /*
      Here the view registers an action to UIManager
      requesting navigation is required to another view controller
      called VC2
    */
    func onNavigate(){

        UIManager.flowController?.navigate(url: "myapp://VC2")

    }

    
    /*
      Informs UIManager through custom uri scheme below
      that there is an action from this view "Reserve" which exists
      under a module called "FeatureABC" and it relies on a parameter
      called reservationId. Then its upto the UIManager to route this request
      to respective business service
    */
    func onReserve(){

        UIManager.flowController?.navigate(url: "myapp://featureABC?cmd=reserve#reservationId=82348@viewId="+self.viewId)

        print("You clicked me")

    }

    

        
    /*
      Informs UIManager through custom uri scheme below
      that there is an action from this view "Cancel" which exists
      under a module called "FeatureABC" and it relies on a parameter
      called reservationId. Then its upto the UIManager to route this request
      to respective business service
    */

    func onCancel(){

        UIManager.flowController?.navigate(url: "myapp://featureABC?cmd=cancel#reservationId=82348@viewId="+self.viewId)

        print("You clicked me")

    }

    
    /*
      This method is invoked by the UIManager whenever there is an
      update available for the view. Here the view can handle the 
      refreshing of its UI Elements
    */
    override func reload(model: View) {

        print("\(model.data!)")

    }



    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.

    }

}
```

<p><h4>VC2.swift</b></h4>

```
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

    
    /*
      Informs UIManager through custom uri scheme below
      that there is an action from this view "getData" which exists
      under a module called "FeatureXYZ". Then its upto the UIManager 
      to route this request to respective business service
    */

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

}
```

<p><h4>VC3.swift</h4></p>

```
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

}
```


<p><h2>BusinessLayer</h2></p>
<p><h4>BusinessManager.swift</h4> This is responsible for the following:</p>
<ul>
  <li>Routes the action from views coming from UIManager to respective business service</li>
  <li>Holds reference to network layer which the business services can have access to make network calls</li>
  <li>Holds reference to module manager which has a registry of all the service modules.</li>
</ul>

```
import Foundation

import UIKit


class BusinessManager{

    static let sharedInstance = BusinessManager()

    let networkManager:NetworkManager? = NetworkManager()

    var router:Router? = nil

    var moduleManager:ModuleManager? = nil

    

    init(){

        self.router = Router(businessLayer: self)

        self.moduleManager =  ModuleManager(businessLayer: self)

    }

}
```


<p><h4>Router.swift</h4> - Responsible to map actions to respective module services</p>

```
import Foundation

class Router{

    
    private var businessMgr:BusinessManager? = nil

    private var routerHelper:RouterHelper? = nil

    

    init( businessLayer: BusinessManager ){

        self.businessMgr  = businessLayer

        self.routerHelper = RouterHelper(businessLayer: self.businessMgr!)

    }

    
    /*
       This method parses the url into different components namely
          - module or feature
          - module or feature action
          - parameters
          - view identifier

      Note: The action method can be further optimized. This implementation
      is quick and dirty implementation to get the job done FYI
    */
    func action( url: String ){

        

       

        let action:String  = url.components(separatedBy: "myapp://").last!

        let moduleData   = action.components(separatedBy: "?")

        let params       = moduleData.last?.components(separatedBy: "#")

        let moduleName   = moduleData.first

        let cmd          = params?.first

        let moduleCommand = cmd?.replacingOccurrences(of: "cmd=", with: "").components(separatedBy: "@").first

        let query       = params?.last?.components(separatedBy: "@")

        let viewId      = query?.last?.replacingOccurrences(of: "viewId=", with: "")

        let queryParams = query?.first

        

        if ( moduleName == "featureABC" ){

            

            if moduleCommand == "reserve"{

                self.routerHelper?.featureABCReserve(viewId: viewId!, params: queryParams!)

                return

            }

            

            if moduleCommand == "cancel"{

                self.routerHelper?.featureABCCancel(viewId: viewId!, params: queryParams!)

                return

            }

            

        }

        

        if ( moduleName == "featureXYZ" ){

            if moduleCommand == "getData"{

                self.routerHelper?.featureXYZGetData()

            }

        }

        

    }

}
```

<p><h4>RouterHelper.swift</h4> - A utility or helper class to the main Router.swift class which provides module specific invocation interfaces</p>

```
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
```

<p><h4>ModuleManager.swift</h4> - Registry for all the modules. Where the respective module or business services are initialized</p>

```
import Foundation

class ModuleManager{

    private var businessMgr:BusinessManager? = nil

    var featureXYZ:FeatureXYZService? = nil

    var featureABC:FeatureABCService? = nil

    

    init( businessLayer: BusinessManager ){

        self.businessMgr = businessLayer

        

        self.featureXYZ = FeatureXYZService()

        self.featureABC = FeatureABCService(businessLayer: self.businessMgr!)

    }
  
}
```

<p><h4> FeatureABC -> FeatureABCService.swift</h4></p>
<p>Modules or feature are grouped into the respective group name. Followed by their respective business services. Here the reservation and cancellation action are part of this sample module called FeatureABC which lies under the service FeatureABCService</p>

```
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
```

<p><h4>FeatureXYZ -> FeatureXYZService.swift</h4></p>

```
import Foundation

class FeatureXYZService{

    func getData(){

        //Get remote data from server and update the view.//Perhaps you can try it out by following the same approach//illustrated in FeatureABCService. This method is invoked by button//"Get Data" from VC2.swift

    }

}
```

<p><h4>Models -> View.swift</h4></p>
<p>The group Models is meant to contain all the models. Here the model View.swift has very basic fields data and error. This is associated with views (VC1, VC2, VC3) as the respective view model.</p>

```
import Foundation

class View{

    var error:String?

    var data:String?

    

    init( error: String?, data: String? ){

        self.error = error

        self.data  = data

    } 

}
```

<p><h4>Models -> ViewContext.swift</h4></p>
<p>The ViewContext is what the UIManager relies on for pushing updates to the respective view. Here the view id and model constitutes the view context that the business service has to provide in order to notify the updates.</p>

```
import Foundation

class ViewContext{

    var id:String? = nil

    var model:View?  = nil

    

    init(viewId: String, model: View ){

        self.id = viewId

        self.model = model

    }

}
```

<p><h2>NetworkLayer -> NetworkManager.swift</h2></p>
<p>The NetworkLayer group is meant for network services and adapters. The NetworkManager has a very simple shell here. However the NetworkManager can have different adapters for different network services such as REST, MQTT, Bluetooth Connection etc. For the sake of this example instead of implementing full blown adapters. I've just implemented a method to mock a rest call. Perhaps you can take this and extend it further :-)</p>

```
import Foundation

class NetworkManager{

    let mqttManager:Any? = nil

    func restCall(url: String, onSuccess success: () -> Void){

        success()

    }

}
```

<p><h2>ExceptionLayer -> ExceptionManager.swift</h2></p>
<p>The ExceptionManager.swift provides 2 interfaces one for publishing the error and the other for subscribing to errors. The modules or services can use the publish interface to throw error. All the errors can be caught and handled in a central place which is the subscriber callback. Please refer the inline comments of this class for API docs. Also we could capture these errors and log it to a remote server for remote debugging purposes as well.</p>

```
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
```

<p>Please find below the screenshot for usage of ExceptionManager.swift<p>

<p><h4>Exception Layer - Initialization and Subscription</h4></p>
<img src="https://media.licdn.com/dms/image/C4E12AQHf-6vSKzV6wA/article-inline_image-shrink_1500_2232/0?e=2126476800&v=beta&t=YKj4bUyKuRef7Sm6I9-o0gKwS0s2GWctCzNPLvBREUc" title="Architecture style UBER - Exception Layer Initialization" />

<p><h4>Publishing Exception</h4></p>
<img src="https://media.licdn.com/dms/image/C4E12AQGakTPYmmdOvA/article-inline_image-shrink_1500_2232/0?e=2126476800&v=beta&t=LFHp9nIh_wAGUZ9QrulYmXU1Ly2-SuPE4KZgw0nD5-Q" title="Architecture style UBER - Exception Layer publishing exceptions" />

<p>Again for the sake of this architecture example. ExceptionLayer has a basic implementation. You can take this and extend it further.</p>

<p>To wrap this up last but not the least. I would like to show you the call stack propagation from view (VC2) to its respective business service (which is FeatureABCService). Also update back. Please refer the diagram below</p>

<img src="https://media.licdn.com/dms/image/C4E12AQFwXwSQvoWAiQ/article-inline_image-shrink_1500_2232/0?e=2126476800&v=beta&t=FCER3-UeojwPw61SvpCb9cgcJIHRXm46F0ZKMPJKoww" title="UBER Architecture Style - Demo" />

<p>So in the diagram above you can see it on the left side under "Thread 1" from 10 to 0. How the communication between different layers is streamlined. This provides a clean separation of concern which will make the mobile app scalable, testable and maintainable.</p>

<p><h1>Final Thoughts</h1></p>
<ul>
<li>Architecture style focuses on the overall system rather individual module or sub-module. This provides greater control to steer towards a robust architecture. UBER is nothing but an architecture style</li>
<li>Architecture Pattern's and Design Pattern's together enables realization of an architecture style. Their impact is localized and focuses on each individual module, classes and objects etc</li>
<li>This architecture style or approach is also known as layered architecture and its been use in the industry for a long time in server side application, infra-structure deployment etc</li>
<li> This clear seperation of layers would also enable us to unit test business services and each individual module</li>
</ul>
