//
//  AppDelegate.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 13/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import LNSideMenu
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseCore
import FirebaseDynamicLinks
import GoogleSignIn
import SQLite3
import SQLite
import SDWebImage
import FirebaseMessaging
import UserNotifications
import goSellSDK

let imageCache = NSCache<AnyObject, AnyObject>()
extension String {

    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}

extension URL {
    var parameters: [String: String]? {
        guard let urlQuery = self.query else { return nil }

        // Create all parameters dictionary
        let queryArray = urlQuery.split { $0 == "&" }.map(String.init)
        var parametersDict: [String: String] = [:]
        for queryParameter in queryArray {
            // split the queryParam into key / value
            let keyValueArray = queryParameter.split{ $0 == "=" }.map(String.init)
            let key = keyValueArray.first!
            let value = keyValueArray.last!.removingPercentEncoding!
            parametersDict.updateValue(value, forKey: key)
        }

        return parametersDict
    }
}

extension CGRect{
    var center: CGPoint {
        return CGPoint( x: self.size.width/2.0,y: self.size.height/2.0)
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UITabBarControllerDelegate , GIDSignInDelegate{
    
    private let dataModel = localizationDataModel()
     let gcmMessageIDKey = "gcm.message_id"
    var db: OpaquePointer?
       let tblLanguageFields = Table("tblLanguageFields")
    var window: UIWindow?
    var firstScreen_VC:LounchScreenManagement?
     var RememberMe:String = "false"
    var navLogin:UINavigationController! = nil
    var DeviceId:String = String()
     var objgetCount = HttpWrapper()
    var isLoadingViewVisible:Bool = false
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var tabBarController1 = UITabBarController()
    var userId = ""                 // For client-side use only!
    var idToken = ""// Safe to send to the server
    var fullName = ""
    var givenName = ""
    var familyName = ""
    var GuestCustomerId = "0"
     var newVerstion = String()
    var bookingName = ""
    var BookingNumber = ""
    var BookingEmail = ""
    var isskipedUpdate = false
    let userDefaults = UserDefaults.standard
     var StrFirebaseToken:String = "0"
    var email = ""
    var fWalletTotal:Float = 0
    var FilterDataArrayName:NSMutableArray = NSMutableArray()
    var FilterDataArray:NSMutableArray = NSMutableArray()
    var isDownloadDone = false
    var Filtertype = 0
    var isDeeplink = false
    var isFilterApply = false
     var DataDic:NSDictionary!
    var strCurrency = ""
    var isLoginScreen:Bool = true
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //        FirebaseCrashMessage("Cause Crash button clicked")
        //        fatalError()
        //        CrashReporting.Configure ();
        FirebaseApp.configure()
        
        //        SecretKey *secretKey = [[SecretKey alloc] initWithSandbox:@"sk_test_4USc05FMDhGniXguevLWwayl" production:@"sk_live_oCRBjOWFhU0KTnE4Dl5r3HIm"]; // (format of the key: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
        //        [GoSellSDK setSecretKey:secretKey];
        // Tap Payment
        let secretKey = SecretKey(sandbox: "sk_test_Fn1MUQztOqRPvI82HJWw9gc4", production: "sk_live_RLOQ8k1KumrYn4TJNHMlSCqP") // (format of the key: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
        // goSellSDK.secretKey = secretKey // Secret key (format: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
        GoSellSDK.secretKey = secretKey
        DeviceId = UIDevice.current.identifierForVendor!.uuidString
        
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "khaam.page.link"
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        ()
        
        //  deleteDatabase()
        
        IQKeyboardManager.shared.enable = true
        //com.mashatel.AppleStore
        //com.khaamfashion.AppleStore
        //com.tahaniflowers.app
        //com.khaamfashion.AppleStore.KhaamServiceExtension
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "1034180763254-6pasojgmjanqpn4t35m2egi7v7slpubr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        //  SetTabBarItem(0)
        
        //Push Notification
        //create the notificationCenter
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        Messaging.messaging().delegate = self
        
        //launch app when user click on notification in terminate mode
        
        
        //Added Code to display notification when app is in Foreground
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        if UserDefaults.standard.object(forKey: kLanguageCode) == nil {
            UserDefaults.standard.set("en", forKey: kLanguageCode)
        }
        
        
        if UserDefaults.standard.object(forKey: knotificaiton) == nil {
            UserDefaults.standard.set("1", forKey: knotificaiton)
        }
        
        
        let currentLanguage = UserDefaults.standard.object(forKey: knotificaiton) as! String //Locale.current.languageCode
        if currentLanguage == "1" {
            application.registerForRemoteNotifications()
            
        }
        else{
            application.unregisterForRemoteNotifications()
        }
        
        if UserDefaults.standard.object(forKey: knUserId) == nil {
            UserDefaults.standard.set(1, forKey: knUserId)
        }
        
        if UserDefaults.standard.object(forKey: kcToken) == nil {
            UserDefaults.standard.set(KbasecToken, forKey: kcToken)
        }
        
        if (isDeeplink == false)
        {
            isDeeplink = false
            window = UIWindow(frame:UIScreen.main.bounds)
            firstScreen_VC = LounchScreenManagement(nibName:"LounchScreenManagement",bundle: nil)
            navLogin = UINavigationController(rootViewController: firstScreen_VC!)
            window?.rootViewController = firstScreen_VC
            navLogin?.isNavigationBarHidden = true
            window?.makeKeyAndVisible()
        }
        
        
        
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
            DataDic = (notification as NSDictionary?)!
            if let strTemp = DataDic.object(forKey: "pageid") as? String
            {
                if(strTemp == "1")
                {
                    let RootObj = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                    
                    if let id = DataDic.object(forKey: "orderid") as? String
                    {
                        RootObj.nOrderId = id
                    }
                    else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                    {
                        RootObj.nOrderId = "\(id)"
                    }
                    RootObj.isFromOrders = true
                    window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                }
                else if(strTemp == "2")
                {
                    let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                    
                    if let id = DataDic.object(forKey: "orderid") as? String
                    {
                        RootObj.nCategoryId = id
                    }
                    else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                    {
                        RootObj.nCategoryId = "\(id)"
                    }
                    RootObj.IsSubCategory = true
                    RootObj.isFromOrders = true
                    window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                }
                else if(strTemp == "3")
                {
                    let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
                    
                    if let id = DataDic.object(forKey: "orderid") as? String
                    {
                        RootObj.productId = id
                    }
                    else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                    {
                        RootObj.productId = "\(id)"
                    }
                    
                    RootObj.isFromOrders = true
                    window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                }
            }
            else  if let strTemp = DataDic.object(forKey: "pageid") as? NSNumber
            {
                if("\(strTemp)" == "1")
                {
                    let RootObj = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                    if let id = DataDic.object(forKey: "orderid") as? String
                    {
                        RootObj.nOrderId = id
                    }
                    else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                    {
                        RootObj.nOrderId = "\(id)"
                    }
                    window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                }
                else if("\(strTemp)" == "2")
                {
                    let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                    
                    if let id = DataDic.object(forKey: "orderid") as? String
                    {
                        RootObj.nCategoryId = id
                    }
                    else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                    {
                        RootObj.nCategoryId = "\(id)"
                    }
                    RootObj.IsSubCategory = true
                    RootObj.isFromOrders = true
                    window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                }
                else if("\(strTemp)" == "3")
                {
                    let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
                    if let id = DataDic.object(forKey: "orderid") as? String
                    {
                        RootObj.productId = id
                    }
                    else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                    {
                        RootObj.productId = "\(id)"
                    }
                    
                    RootObj.isFromOrders = true
                    window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                }
            }
        }
                
        return true
    }
    
    
    func loginSuccess() {
        SetTabBarItem(0)
    }
    
    func FirstTime()
           {
//            window = UIWindow(frame:UIScreen.main.bounds)
//                                   selectLanguage_VC = SelectLanguage_VC(nibName:"SelectLanguage_VC",bundle: nil)
//                                   navigate = UINavigationController(rootViewController: selectLanguage_VC!)
//                                   window?.rootViewController = navigate
//                                   navigate?.isNavigationBarHidden = true
//                                   window?.makeKeyAndVisible()
               navLogin = objMain.instantiateViewController(withIdentifier: "NavStart") as! UINavigationController
                 let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "SelectLanguage") as! SelectLanguage
            
             navLogin = UINavigationController(rootViewController: nextViewController)
               //        navLogin = objSignupSB.instantiateViewController(withIdentifier: "KISignupNav") as! UINavigationController
       
               if self.window != nil {
                   UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                       let oldState: Bool = UIView.areAnimationsEnabled
                       UIView.setAnimationsEnabled(false)
                       self.window!.rootViewController = self.navLogin
                       UIView.setAnimationsEnabled(oldState)
                   }, completion: { (finished: Bool) -> () in
                   })
               }
       
       
           }
    
    func logout() {
       
    }

   
    //MARK: - Create TabBar Controller
    
    func appUpdateAvailable() -> Bool
       {
           var upgradeAvailable = false
           let bundle = Bundle.main
           if let infoDictionary = bundle.infoDictionary
           {
            
            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String
            {
                
                let appStoreMinimumVersion = "iOS_Minimum_Live_Version".setlocalized()
                let first = currentVersion.stripped.replacingOccurrences(of:".", with: "")
                let two = appStoreMinimumVersion.stripped.replacingOccurrences(of:".", with: "")
                 newVerstion = appStoreMinimumVersion
                let live = Int(two)
                let current = Int(first)
                                           
                print("\(live)")
                print("\(current)")
                if Float(current!) >= Float(live!)
                {
                    upgradeAvailable = false
                }
                else
                {
                    upgradeAvailable = true
                }
         
            }
               
           }
           return upgradeAvailable
}
    //MARK: - Create TabBar Controller
    
    func SetTabBarItem(_ buttotag : Int){
        
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        var tabBarController = UITabBarController()
        
        //        let controller1 = FlightMates_Next_VC(nibName: CheckDeviceType("FlightMates_Next_VC"), bundle: nil)
        //        let navController1 = UINavigationController(rootViewController: controller1)
        //        navController1.tabBarItem.image = UIImage(named: "footerhome")
        //        navController1.tabBarItem.title = "Home"
        //        controller1.navigationController?.isNavigationBarHidden = false
        //        SetNavigationBarColor(controller1, leftmenu: "", rightmenu: "")
        //first
        
        
        
        //       let controller1 = SJSwiftSideMenuController()
        //
        //        let sideVC_L : SideMenu_Vc = (objHomeSB.instantiateViewController(withIdentifier: "SideMenu_Vc") as? SideMenu_Vc)!
        //        // sideVC_L.menuItems = months as NSArray!
        //
        //        let sideVC_R : SideMenu_Vc = (objHomeSB.instantiateViewController(withIdentifier: "SideMenu_Vc") as? SideMenu_Vc)!
        //        //sideVC_R.menuItems = days as NSArray!
        //
        //        let rootVC = objHomeSB.instantiateViewController(withIdentifier: "Home") as UIViewController
        //
        //        SJSwiftSideMenuController.setUpNavigation(rootController: rootVC, leftMenuController: sideVC_L, rightMenuController: sideVC_R, leftMenuType: .SlideOver, rightMenuType: .SlideView)
        //
        //        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        //
        //        SJSwiftSideMenuController.enableDimbackground = true
        //        SJSwiftSideMenuController.leftMenuWidth = 280
        //        //=======================================
        
        let controller1 = objHomeSB.instantiateViewController(withIdentifier: "Home")as! Home
        let navController1 = UINavigationController(rootViewController: controller1)
        navController1.tabBarItem.image = UIImage(named: "ic_tab_home")
        navController1.tabBarItem.title = "tab_Home".setlocalized()
        
        // controller1.navigationController?.isNavigationBarHidden = false
        SetNavigationBarColor(controller1, leftmenu: "", rightmenu: "")
        
        //second
        
        let controller2: BarcodeScanner_VC = BarcodeScanner_VC(nibName: "BarcodeScanner_VC", bundle: nil)
        
        // let controller2 = objHomeSB.instantiateViewController(withIdentifier: "VendorList") as! VendorList
        //  let controller2 =  objCart.instantiateViewController(withIdentifier: "SampleCart")as! SampleCart
        
        //  let controller2 = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        //                               controller2.nCategoryId = "37"
        //                               controller2.IsSubCategory = true
        //        controller2.cCategoryName = "lbl_bundleCategory_Title".setlocalized()
        //                controller2.api = kProductByCategory
        //        controller2.isFromTab = true
        //            controller2.isCategory = true
        //     controller2.isFromTab = true
        //  controller2.cCategoryName = "home_shop_by_category".setlocalized()
        let navController2 = UINavigationController(rootViewController: controller2)
        
        navController2.tabBarItem.image = UIImage(named: "qr-code")
        navController2.tabBarItem.title = "lbl_scan_navbar".setlocalized()
        controller2.navigationController?.isNavigationBarHidden = false
        
        //Third
        var navController3 = UINavigationController()
        
        //        let controller3 =  objHomeSB.instantiateViewController(withIdentifier: "ProductCategory")as! ProductCategory
        //        controller3.isCategory = true
        //        controller3.isFromTab = true
        //        navController3 = SMNavigationController(rootViewController: controller3)
        //        navController3.tabBarItem.image = UIImage(named: "ic_Brand")
        //        navController3.tabBarItem.title = "tab_categorys".setlocalized()
        //        controller3.navigationController?.isNavigationBarHidden = false
        
        if (UserDefaults.standard.object(forKey: kisLogin) != nil) {
            let controller3 = objHomeSB.instantiateViewController(withIdentifier: "Wishlist_Vc")as! Wishlist_Vc
            controller3.isFromTab = true
            navController3 = UINavigationController(rootViewController: controller3)
            navController3.tabBarItem.image = UIImage(named: "ic_tab_wish")
            navController3.tabBarItem.title = "tab_wishlist".setlocalized()
            controller3.navigationController?.isNavigationBarHidden = false
        }
        else {
            let controller3 = objMain.instantiateViewController(withIdentifier: "Login")as! Login
            navController3 = UINavigationController(rootViewController: controller3)
            navController3.tabBarItem.image = UIImage(named: "ic_tab_wish")
            navController3.tabBarItem.title = "tab_wishlist".setlocalized()
            controller3.navigationController?.isNavigationBarHidden = false
        }
        
        
        
        
        //        //Fourth
        //        var objSB = objHome
        //        if UIDevice.current.userInterfaceIdiom == .pad
        //        {
        //            objSB = objProfileIpad
        //        }
        //        else
        //        {
        //            objSB = objHome
        //        }
        
        let controller4 = objCart.instantiateViewController(withIdentifier: "Cart")as! Cart
        let navController4 = UINavigationController(rootViewController: controller4)
        navController4.tabBarItem.image = UIImage(named: "ic_tab_cart")
        navController4.tabBarItem.title = "tab_cart".setlocalized()
        controller4.navigationController?.isNavigationBarHidden = false
        
        
        let controller5 = objProfile.instantiateViewController(withIdentifier: "Profile")as! Profile
        let navController5 = UINavigationController(rootViewController: controller5)
        navController5.tabBarItem.image = UIImage(named: "ic_tab_profile")
        navController5.tabBarItem.title = "tab_Me".setlocalized()
        controller5.navigationController?.isNavigationBarHidden = false
        
        
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let controller4 = storyBoard.instantiateViewController(withIdentifier: "Meetup_VC") as! Meetup_VC
        //        let navController4 = UINavigationController(rootViewController: controller4)
        //        navController4.tabBarItem.image = UIImage(named: "footer_meeting")
        //        navController4.tabBarItem.title = "Meetings"
        //        navController4.navigationController?.isNavigationBarHidden = false
        
        
        
        tabBarController.delegate = self
        
        tabBarController.viewControllers = [navController1, navController2,navController3,navController4 ,navController5]
        tabBarController.tabBar.selectedImageTintColor = btnBackgroundColor
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        UITabBar.appearance().barTintColor = UIColor.init(hexString: "ffffff")
        
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: RalewayRegular, size: 14)!], for: .normal)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: RalewayRegular, size: 14)!], for: .selected)
        
        let topBorder = CALayer()
        
        let borderHeight: CGFloat = 1
        tabBarController.selectedIndex = buttotag
        topBorder.borderWidth = borderHeight
        topBorder.borderColor = UIColor.init(hexString: "000000").cgColor
        
        topBorder.frame = CGRect(x: 0, y: -1, width: tabBarController.tabBar.frame.width, height: borderHeight)
        tabBarController.tabBar.layer.borderWidth = 0
        tabBarController.tabBar.layer.borderColor = UIColor.clear.cgColor
        //   tabBarController.tabBar.clipsToBounds = true
        let centerview = UIView()
        centerview.frame.size = CGSize(width: 45, height: 45)
        // centerview.layer.cornerRadius = 22.5
        // centerview.layer.borderWidth = 2
        centerview.clipsToBounds = true
        //  centerview.layer.borderColor = navigationbarColor.cgColor
        // centerview.backgroundColor =  navigationbarColor
        let centerimage = UIImageView()
        centerimage.frame.size = CGSize(width: 45, height: 45)
        centerimage.cacheImageForlogo(urlString: "lbl_Feelit_image".setlocalized())   // UIImage(named: "khaam-feather-1")
        centerimage.tintColor = UIColor.white
        centerimage.contentMode = .scaleAspectFill
        
        let button = UIButton()
        //   button.setImage(UIImage(named: "ic_snapchat"), for: .normal)
        // button.sizeToFit()
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(centerButtonClick), for: .touchUpInside)
        centerview.frame.size = CGSize(width: 45, height: 45)
        button.frame.size = CGSize(width: 45, height: 45)
        centerview.center = CGPoint(x: tabBarController.tabBar.frame.width / 2,
                                    y: tabBarController.tabBar.frame.center.y + 3)
        //  button.frame = CGRect(x: (self.window?.frame.width)!/2-25, y: 5, width: 50, height: 50)
        //button.backgroundColor = UIColor.black
        
        //                centerview.addSubview(centerimage)
        //                centerview.addSubview(button)
        //                tabBarController.tabBar.addSubview(centerview)
        //
        //                tabBarController.tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        //                tabBarController.tabBar.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        //                tabBarController.tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        //  tabBarController.tabBar.layer.addSublayer(topBorder)
        tabBarController1 = tabBarController
        window?.rootViewController = tabBarController1
    }
    
    
    @objc func centerButtonClick()
    {
        SetTabBarItem(2)
    }
    //MARK: - SetNavigationBarColor
    
    func SetNavigationBarColor(_ controller: UIViewController, leftmenu: String, rightmenu: String){
        
        controller.navigationController!.navigationBar.isTranslucent = false
        controller.navigationController!.isNavigationBarHidden = false
        controller.navigationController!.navigationBar.tintColor = UIColor.init(hexString: "D8131B")
        
        controller.navigationController!.navigationBar.barTintColor = UIColor.white
        
        controller.navigationController!.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        controller.navigationController!.navigationBar.shadowImage = UIImage(named: "")
        
        controller.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.init(hexString: "D8131B")
            , NSAttributedStringKey.font: UIFont(name: RalewayRegular, size: 18)!]
        
        
        
        if(leftmenu != ""){
            let left = UIBarButtonItem(image: UIImage(named: leftmenu), style: .plain, target: controller, action: Selector(("BackClick")))
            controller.navigationItem.leftBarButtonItem = left
        }
        
        
        if(rightmenu != ""){
            let right = UIBarButtonItem(image: UIImage(named: rightmenu), style: .plain, target: controller, action: Selector(("RightClick")))
            controller.navigationItem.rightBarButtonItem = right
        }
    }
    
   
    
    func SetNavigationBarWithoutColor(_ controller: UIViewController, rightmenu: String){
        
        controller.navigationController!.isNavigationBarHidden = false
        controller.navigationController!.navigationBar.tintColor = UIColor.white
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        controller.navigationController?.navigationBar.isTranslucent = true
        
        controller.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Dubai-Medium", size: 18)!]
        
        
        let left1 = UIBarButtonItem(image: UIImage(named: "backward"), style:  .plain, target: controller, action: Selector(("BackClick")))
        controller.navigationItem.leftBarButtonItem = left1
        
        if(rightmenu != ""){
            let right = UIBarButtonItem(image: UIImage(named: rightmenu), style: .plain, target: controller, action: Selector(("RightClick")))
            controller.navigationItem.rightBarButtonItem = right
        }
    }
    
    
    //MARK: - Get Localization string From Servar
       
       func createSqlDatabase()
       {
           //CREATE DATABASE
           let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent("HeroesDatabase.sqlite")
           
           
           if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("error opening database")
           }
           
           if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblLanguageFields (id INTEGER PRIMARY KEY AUTOINCREMENT, field_name TEXT,field_EN TEXT,field_AR TEXT)", nil, nil, nil) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error creating table: \(errmsg)")
           }
           
         // GetLabelDate()
       }
       //MARK: - get localization string From SQLLITE
//       func setLocalizationstring(string:String)-> String{
//           
//           //  Created by Punit tunwar
//           let queryString = "SELECT * from tblLanguageFields WHERE field_name='\(string)'"
//           
//           var stmt:OpaquePointer?
//           
//           if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
//               let errmsg = String(cString: sqlite3_errmsg(db)!)
//               print("error preparing insert: \(errmsg)")
//               return ""
//           }
//           
//           var ColumnNo = 2
//        
//        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String //Locale.current.languageCode
//        if currentLanguage == "en" {
//            ColumnNo = 2
//        }
//        else{
//            ColumnNo = 3
//        }
//        
////           if UserDefaults.standard.getlanguage() == "ar"
////           {
////              
////           }
////           else
////           {
////               
////           }
//           while(sqlite3_step(stmt) == SQLITE_ROW){
//               
//               if sqlite3_column_text(stmt, Int32(ColumnNo)) == nil
//               {
//                   return string
//               }
//               else
//               {
//                   return String(cString: sqlite3_column_text(stmt, Int32(ColumnNo)))
//               }
//               
//           }
//           
//           return ""
//       }
       
       //MARK: - CLEAR TABLELIST SQLLITE Database
       func DeleteTableAllrow()
       {
           let queryString = "DELETE FROM `tblLanguageFields`"
           
           
           var statement: OpaquePointer? = nil
           
           
           
           if sqlite3_prepare_v2(self.db, queryString, -1, &statement, nil) == SQLITE_OK {
               
               
               if sqlite3_step(statement) == SQLITE_DONE {
                   print("Successfully Delete row.")
               } else {
                   print("Could not Update row.")
               }
           } else {
               
               // forces SQLite to send error message
               let errorMessage = String.init(validatingUTF8: sqlite3_errmsg(self.db))!
               print("update failed! \(errorMessage)")
               
           }
           
           sqlite3_finalize(statement)
       }
       
       func deleteDatabase()
       {
           var dbc:Connection!
           let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent("HeroesDatabase.sqlite")
           
           let filemManager = FileManager.default
           do {
               let fileURL = NSURL(fileURLWithPath: fileURL.path)
               try dbc.run(appDelegate.tblLanguageFields.delete())
               print("Database Deleted!")
               createSqlDatabase()
           } catch {
               print("Error on Delete Database!!!")
           }
       }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
        // ...
      }

      return handled
    }
    
   

   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppHelper.hideLoadingView()
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: currentScrren), object: nil, userInfo: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let facebookDidHandle = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        let googleDidHandle =  GIDSignIn.sharedInstance().handle(url)

        
        return facebookDidHandle || googleDidHandle || application(app, open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: "")
        
      
    }
    
    func SetDateFormat(_ strDate: String)-> String{
        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let yourDate = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let convertdate: String = dateFormatter.string(from: yourDate)
        
        return convertdate
    }
    
    func setAttributedPrice(Priceone:String,pricetwo:String,Fullstring:String,Font:UIFont) -> NSMutableAttributedString
      {
        let yourAttributes: [NSAttributedString.Key: Any] = [
                      .font: UIFont(name: RalewayRegular, size: 10),
                      .foregroundColor: ColorLightgray]
        let yourAttributes2: [NSAttributedString.Key: Any] = [
        .font: Font,
        .foregroundColor: btnBackgroundColor]
                         
                        let main_string = Fullstring
                        let attributedString = NSMutableAttributedString(string: main_string,attributes:[NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7e7e7e")])
        
                         let string_to_color = Priceone
                         let string_to_color2 = pricetwo
                        
                         let range = (main_string as NSString).range(of: string_to_color)
                         let range2 = (main_string as NSString).range(of: string_to_color2)
                         
                         // Set the 'click here' substring to be the link
                         attributedString.setAttributes(yourAttributes, range: range)
        
                 attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                               value: NSUnderlineStyle.styleSingle.rawValue,
            range: range)
                         attributedString.setAttributes(yourAttributes2, range: range2)
                         
        
       return attributedString
    }
    
    func SetTimeFormat(_ strDate: String)-> String{
              
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "HH:mm:ss"
              
              let yourDate = dateFormatter.date(from: strDate)!
              dateFormatter.dateFormat = "h:mm aa"
              let convertdate: String = dateFormatter.string(from: yourDate)
              
              return convertdate
          }
    // MARK: Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
       if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
        if userActivity.webpageURL != nil {
          

            let params = userActivity.webpageURL!.parameters
            if let name = params?["link"] {
                isDeeplink = true
                let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
                let newURL = URL(string: name)!

                if ((Int(name)) != nil)
                {
                    nextViewController.productId = "\(name)"
                }
                else
                {
                    print(newURL.valueOf("productid"))
                                       
                                       nextViewController.productId = newURL.valueOf("productid")!
                }
               
                
                       nextViewController.isDeeplink = true
                     //   navLogin = SMNavigationController(rootViewController: nextViewController)
                                    //        navLogin = objSignupSB.instantiateViewController(withIdentifier: "KISignupNav") as! UINavigationController
                            
                                    if self.window != nil {
                                        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                                            let oldState: Bool = UIView.areAnimationsEnabled
                                            UIView.setAnimationsEnabled(false)
                                            self.window!.rootViewController = UINavigationController(rootViewController: nextViewController)
                                            UIView.setAnimationsEnabled(oldState)
                                            
                                        }, completion: { (finished: Bool) -> () in
                                            
                                        })
                                    }
                            
                print(name)
            }
             
          }
       }
       return false
    }
    
    // [END didfinishlaunching]
    
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
               // Handle the deep link. For example, show the deep-linked content or
               // apply a promotional offer to the user's account.
               // ...
               return true
        }
        else
        {
             return GIDSignIn.sharedInstance().handle(url)
        }
        return GIDSignIn.sharedInstance().handle(url)
    }
//    // [END openurl]
//    

   
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            if isLoginScreen == true {
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            }
            else {
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleSignupAuthUINotification"), object: nil, userInfo: nil)
            }
            
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
             userId = user.userID                  // For client-side use only!
             idToken = user.authentication.idToken // Safe to send to the server
             fullName = user.profile.name
             givenName = user.profile.givenName
             familyName = user.profile.familyName
             email = user.profile.email
            
            // [START_EXCLUDE]
            
            if isLoginScreen == true {
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                    object: nil,
                    userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            }
            else {
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleSignupAuthUINotification"),
                    object: nil,
                    userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            }
            
            // [END_EXCLUDE]
        }
    }
    // [END signin_handler]
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        if isLoginScreen == true {
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "User has disconnected."])
        }
        else{
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleSignupAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "User has disconnected."])
        }
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
}
extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

extension UIImageView {
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        if url == nil
        {
            return
        }
        image = nil
        
        self.sd_setImage(with: url , placeholderImage:  UIImage(named:"productlistPlaceholder"))
        
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            SVProgressHUD.dismiss()
//            return
//        }
//        self.image = UIImage(named:"ic_placeholder_square")
//        URLSession.shared.dataTask(with: url!) {
//            data, response, error in
//            if let response = data {
//                DispatchQueue.main.async {
//                    let imageToCache = UIImage(data: data!)
//                    
//                    if imageToCache != nil {
//                        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
//                        self.image = imageToCache
//                    }
//                    
//                    SVProgressHUD.dismiss()
//                }
//            }
//        }.resume()
    }
    
    func cacheImageForlogo(urlString: String){
            let url = URL(string: urlString)
            
            if url == nil
            {
                return
            }
            image = nil
            
            self.sd_setImage(with: url , placeholderImage:  UIImage(named:"khaam-feather-1"))
            
    //        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
    //            self.image = imageFromCache
    //            SVProgressHUD.dismiss()
    //            return
    //        }
    //        self.image = UIImage(named:"ic_placeholder_square")
    //        URLSession.shared.dataTask(with: url!) {
    //            data, response, error in
    //            if let response = data {
    //                DispatchQueue.main.async {
    //                    let imageToCache = UIImage(data: data!)
    //
    //                    if imageToCache != nil {
    //                        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
    //                        self.image = imageToCache
    //                    }
    //
    //                    SVProgressHUD.dismiss()
    //                }
    //            }
    //        }.resume()
        }
}

public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    
   func getFilesAndDirectories(folder:String, completionHandler:@escaping (String) -> Void)
    {
        
        let queryString = "SELECT * from tblLanguageFields WHERE field_name='\(localized())'"
                          
                          var stmt:OpaquePointer?
                          
               if sqlite3_prepare(appDelegate.db, queryString, -1, &stmt, nil) != SQLITE_OK{
                              let errmsg = String(cString: sqlite3_errmsg(appDelegate.db)!)
                              print("error preparing insert: \(errmsg)")
                              completionHandler(folder)
                          }
                          
                          var ColumnNo = 2
                       
                       let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String //Locale.current.languageCode
                       if currentLanguage == "en" {
                           ColumnNo = 2
                       }
                       else{
                           ColumnNo = 3
                       }
                       
               //           if UserDefaults.standard.getlanguage() == "ar"
               //           {
               //
               //           }
               //           else
               //           {
               //
               //           }
                          while(sqlite3_step(stmt) == SQLITE_ROW){
                              
                              if sqlite3_column_text(stmt, Int32(ColumnNo)) == nil
                              {
                                DispatchQueue.main.async {
                                                                             

                                                                              completionHandler(folder)
                                }
                                  
                              }
                              else
                              {
                                DispatchQueue.main.async {
                                              

                                               completionHandler(String(cString: sqlite3_column_text(stmt, Int32(ColumnNo))))
                                           }
                                
                               
                              }
                              
                          }
        
       
    }
   
   
    func setlocalized() -> String {
        
         //  Created by Punit tunwar
                   let queryString = "SELECT * from tblLanguageFields WHERE field_name='\(self)'"
                   
                   var stmt:OpaquePointer?
         
       
//      if appDelegate.isDownloadDone == false
//      {
//        return self
//        }
        if sqlite3_prepare(appDelegate.db, queryString, -1, &stmt, nil) != SQLITE_OK{
                       let errmsg = String(cString: sqlite3_errmsg(appDelegate.db)!)
                       print("error preparing insert: \(errmsg)")
                       return self
                   }
                   
                   var ColumnNo = 2
                
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String //Locale.current.languageCode
                if currentLanguage == "en" {
                    ColumnNo = 2
                }
                else{
                    ColumnNo = 3
                }
                
        //           if UserDefaults.standard.getlanguage() == "ar"
        //           {
        //
        //           }
        //           else
        //           {
        //
        //           }
                   while(sqlite3_step(stmt) == SQLITE_ROW){
                       
                       if sqlite3_column_text(stmt, Int32(ColumnNo)) == nil
                       {
                           return self//localized()
                       }
                       else
                       {
                           return String(cString: sqlite3_column_text(stmt, Int32(ColumnNo)))
                       }
                       
                   }
                   
                   return self//localized()
        
       // return localized(using: nil, in: .main)
    }

    
     func setlocalized2() -> String {
            
             //  Created by Punit tunwar
                       let queryString = "SELECT * from tblLanguageFields WHERE field_name='\(self)'"
                       
                       var stmt:OpaquePointer?
             
           
    //      if appDelegate.isDownloadDone == false
    //      {
    //        return self
    //        }
            if sqlite3_prepare(appDelegate.db, queryString, -1, &stmt, nil) != SQLITE_OK{
                           let errmsg = String(cString: sqlite3_errmsg(appDelegate.db)!)
                           print("error preparing insert: \(errmsg)")
                           return self
                       }
                       
                       var ColumnNo = 2
                    
                    let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String //Locale.current.languageCode
                    if currentLanguage == "en" {
                        ColumnNo = 2
                    }
                    else{
                        ColumnNo = 3
                    }
                    
            //           if UserDefaults.standard.getlanguage() == "ar"
            //           {
            //
            //           }
            //           else
            //           {
            //
            //           }
                       while(sqlite3_step(stmt) == SQLITE_ROW){
                           
                           if sqlite3_column_text(stmt, Int32(ColumnNo)) == nil
                           {
                               return ""//localized()
                           }
                           else
                           {
                               return String(cString: sqlite3_column_text(stmt, Int32(ColumnNo)))
                           }
                           
                       }
                       
                       return ""//localized()
            
           // return localized(using: nil, in: .main)
        }

  
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

    
    func application(_ application: UIApplication,
                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           Messaging.messaging().apnsToken = deviceToken as Data
       }

       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
           // Print full message.
           print(userInfo)

       }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
       {
           
         
           completionHandler([.alert, .sound])
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           
           print(response.notification.request.content.userInfo)
           if response.notification.request.identifier == "Local Notification" {
               print("Handling notifications with the Local Notification Identifier")
           }
           
           let state = UIApplication.shared.applicationState
                 if state == .background || state == .inactive {
                     // background
            DataDic = (response.notification.request.content.userInfo as NSDictionary)
                                
            print(DataDic)
            if let dics2 = DataDic.object(forKey: "aps") as? NSDictionary
            {
                                               
                   // DataDic = (notification as NSDictionary?)!
                    if let strTemp = DataDic.object(forKey: "pageid") as? String
                    {
                        if(strTemp == "1")
                        {
                            let RootObj = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
            
                            if let id = DataDic.object(forKey: "orderid") as? String
                            {
                                RootObj.nOrderId = id
                            }
                            else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                            {
                                RootObj.nOrderId = "\(id)"
                            }
                            RootObj.isFromOrders = true
                            window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                        }
                        else if(strTemp == "2")
                        {
                            let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
            
                            if let id = DataDic.object(forKey: "orderid") as? String
                            {
                                RootObj.nCategoryId = id
                            }
                            else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                            {
                                RootObj.nCategoryId = "\(id)"
                            }
                            RootObj.IsSubCategory = true
                            RootObj.isFromOrders = true
                            window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                        }
                        else if(strTemp == "3")
                        {
                            let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
               
                            if let id = DataDic.object(forKey: "orderid") as? String
                            {
                                RootObj.productId = id
                            }
                            else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                            {
                                RootObj.productId = "\(id)"
                            }
                          
                            RootObj.isFromOrders = true
                            window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                        }
                    }
                    else  if let strTemp = DataDic.object(forKey: "pageid") as? NSNumber
                    {
                        if("\(strTemp)" == "1")
                        {
                            let RootObj = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                            if let id = DataDic.object(forKey: "orderid") as? String
                            {
                                RootObj.nOrderId = id
                            }
                            else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                            {
                                RootObj.nOrderId = "\(id)"
                            }
                            window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                        }
                        else if("\(strTemp)" == "2")
                        {
                            let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                        
                            if let id = DataDic.object(forKey: "orderid") as? String
                            {
                                RootObj.nCategoryId = id
                            }
                            else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                            {
                                RootObj.nCategoryId = "\(id)"
                            }
                            RootObj.IsSubCategory = true
                            RootObj.isFromOrders = true
                            window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                        }
                        else if("\(strTemp)" == "3")
                        {
                            let RootObj = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
                            if let id = DataDic.object(forKey: "orderid") as? String
                            {
                                RootObj.productId = id
                            }
                            else if let id = DataDic.object(forKey: "orderid") as? NSNumber
                            {
                                RootObj.productId = "\(id)"
                            }
                                    
                            RootObj.isFromOrders = true
                            window?.rootViewController?.present(RootObj, animated: true, completion: nil)
                        }
                    }
                }
                 } else if state == .active {
                     // foreground
                    
                 }
                 
           completionHandler()
       }
    
 
}
extension AppDelegate : MessagingDelegate
{
    
   
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
      }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")
        StrFirebaseToken = fcmToken
      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
extension AppDelegate:HttpWrapperDelegate
{
    // MARK: - HttpWrapper Delegate
        
    func getCount() {
                 if net.isReachable == false {
      //               let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertController.Style.alert)
      //               alert.addAction(UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default, handler: nil))
      //               self.present(alert, animated: true, completion: nil)
                 }
                 else {
                  if userDefaults.object(forKey: knUserId) == nil {
                             userDefaults.set(1, forKey: knUserId)
                         }
                  
                     let nUserId = userDefaults.value(forKey: knUserId) as! Int
                                               var nLanguageId = ""
                                               
                                               if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                                                   nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                                               }
                                               
                                                var nCustomerId = "0"
                                               var deviceid = ""
                                                          if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                                                              nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                                                          }
                                               else
                                                          {
                                                        deviceid = "\(appDelegate.DeviceId)"
                                               }
                                              
                                              // let cToken = userDefaults.value(forKey: kcToken) as! String
                                               let format: DateFormatter = DateFormatter()
                                               format.dateFormat = "yyyy-MM-dd"
                  format.locale = Locale(identifier: "en")
                                               let now: NSDate = NSDate()
                                               let TodayDate: String = format.string(from: now as Date)
                     
                     var url = URLComponents(string: kCartCountbyCustomer)!

                                    url.queryItems = [
                                        URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                                        URLQueryItem(name: "nLanguageId", value: nLanguageId),
                                       URLQueryItem(name: "cDeviceId", value: deviceid),
                                        URLQueryItem(name: "cToken", value: "\(KbasecToken)"),
                                        URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)")
                                    ]
                                    
                     
                     //AppHelper.showLoadingView()
                     self.objgetCount = HttpWrapper.init()
                     self.objgetCount.delegate = self
                     self.objgetCount.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
                 }
             }
    
        func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
            if wrapper == objgetCount {
                 if dicsResponse.value(forKey: "Success") as! String == "1" {
                    if let featureProducts:NSArray = dicsResponse.object(forKey: "Result") as? NSArray {
                        if featureProducts.count > 0
                        {
                            if let count = (featureProducts.object(at: 0) as! NSDictionary).value(forKey: "Cartcount") as? NSNumber
                            {
                                userDefaults.set("\(count)", forKey: kGlobalCartCount)
                                let tabCart = tabBarController1.tabBar.items?[3]
                                if Int(count) > 0
                                {
                                    tabCart?.badgeValue = "\(count)"
                                                                           if #available(iOS 10.0, *) {
                                                                               tabCart?.badgeColor = .white
                                                                               tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                                                                           }
                                }
                                else
                                {
                                    tabCart?.badgeValue = nil
                                                                           if #available(iOS 10.0, *) {
                                                                               tabCart?.badgeColor = .white
                                                                               tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                                                                           }
                                }
                                       
                            }
                        }
                    }
                            
                }
              
                }
                else {
                 //   AppHelper.hideLoadingView()
    //                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
                }
          
    
            
        }
        
        func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
            
        }
        
}
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
