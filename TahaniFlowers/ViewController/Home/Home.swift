//
//  Home.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 15/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LNSideMenu


class Home: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,HomeNavigation, HttpWrapperDelegate,HomeProductNavigation,UITabBarDelegate {
    
    @IBOutlet weak var lblWomen: UILabel!
    @IBOutlet weak var lblMen: UILabel!
    @IBOutlet weak var lblAccesories: UILabel!
    @IBOutlet weak var imgWomen: UIImageView!
    @IBOutlet weak var imgMen: UIImageView!
    @IBOutlet weak var imgAccesories: UIImageView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet var viewNoDataFound: UIView!
     @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
    private let refreshControl = UIRefreshControl()
    // MARK: - Variables
    
    var arrBannerImage:NSArray = NSArray()
    var arrProductType:NSArray = ["home_shop_by_category".setlocalized(),"home_featured_products".setlocalized()]
    var arrProductDetails:NSArray = [["name":"Roses","image":"ic_img_roses"],["name":"Aster","image":"ic_img_aster"],["name":"Gerbera","image":"ic_img_gerbera"]]
    
    var arrCategoryList = NSArray()
    var arrFeatureProducts = NSArray()
    var searchBar = UISearchBar()
    var isMenuOpen:Bool = false
    
    var objCustomerDetails  = HttpWrapper()
    var objSlider = HttpWrapper()
    var objCategoryList = HttpWrapper()
    var objFeatureProducts = HttpWrapper()
    var objProductDetails = HttpWrapper()
    var objProductCategory = HttpWrapper()
    var objContactUsDetails = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    let userDefaults = UserDefaults.standard
    var arrContactDetails:NSArray = NSArray()
    
    // MARK: - ViewController Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.init().bounds.width, height: self.view.frame.width/1.5)
//        lblMen.text = "lbl_Home_men".setlocalized()
//        lblWomen.text = "lbl_Home_Women".setlocalized()
//        lblAccesories.text = "lbl_Home_Accesories".setlocalized()
//
//        if let url = "img_Home_Men".setlocalized() as? String {
//           imgMen.cacheImage(urlString: url)
//        }
//
//        if let url = "img_Home_women".setlocalized() as? String {
//           imgWomen.cacheImage(urlString: url)
//        }
//
//        if let url = "img_Home_Accesories".setlocalized() as? String {
//           imgAccesories.cacheImage(urlString: url)
//        }
//
//        tblHome.tableHeaderView = viewHeader
        
        var currentLanguage = ""
         if UserDefaults.standard.value(forKey: kLanguageCode) == nil {
             currentLanguage = "en"
         }
         else {
             currentLanguage = UserDefaults.standard.value(forKey: kLanguageCode) as! String
         }
         UserDefaults.standard.set(currentLanguage, forKey: kLanguageCode)
         if currentLanguage == "en" {
             UserDefaults.standard.set("1", forKey: kLanguageId)
         }
         else {
             UserDefaults.standard.set("2", forKey: kLanguageId)
         }
         
         self.addNavigationBar()
        
         
         if userDefaults.object(forKey: knUserId) == nil {
             userDefaults.set(1, forKey: knUserId)
         }
         
         if userDefaults.object(forKey: kcToken) == nil {
             userDefaults.set(KbasecToken, forKey: kcToken)
         }
         if userDefaults.object(forKey: kisLogin) != nil {
             print(userDefaults.object(forKey: kisLogin) as! String)
             self.getUserDetails()
         }
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblHome.refreshControl = refreshControl
        } else {
            tblHome.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        self.getSliderData()
        self.getCategoryList()
        self.getFeatureProducts()
        self.getContactUsDetails()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
//        if userDefaults.value(forKey: kGlobalCartCount) != nil {
//            let globalCartCount = userDefaults.value(forKey: kGlobalCartCount) as! String
//            let tabCart = self.tabBarController!.tabBar.items?[3]
//            
//            tabCart?.badgeValue = globalCartCount
//            if #available(iOS 10.0, *) {
//                tabCart?.badgeColor = .white
//                tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
//            }
//        }
        
        currentScrren = "Home"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        
        //        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        //        view.addSubview(button)
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.global().async {
                  let update = appDelegate.appUpdateAvailable()
                  
                  print("update",update)
                  DispatchQueue.main.async {
                      if update{
                          if appDelegate.isskipedUpdate == false
                          {
                              
                             self.popupUpdateDialogue();
                          }
                      }
                      
                  }
              }
    }
    
    func popupUpdateDialogue(){
        
        let modalViewController = AppUpdate_VC(nibName:"AppUpdate_VC",bundle: nil)
        modalViewController.modalPresentationStyle = .overFullScreen
              // modalViewController.delegate = self
              
               present(modalViewController, animated: true, completion: nil)
        
         
          
      }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        self.getSliderData()
        self.getCategoryList()
        self.getFeatureProducts()
        self.getContactUsDetails()
    }
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblHome.isHidden = false
        appDelegate.Filtertype = 1
        appDelegate.FilterDataArray.removeAllObjects()
        appDelegate.FilterDataArrayName.removeAllObjects()
//        let currentLanguage = Locale.current.languageCode
        var currentLanguage = ""
        if UserDefaults.standard.value(forKey: kLanguageCode) == nil {
            currentLanguage = "en"
        }
        else {
            currentLanguage = UserDefaults.standard.value(forKey: kLanguageCode) as! String
        }
        UserDefaults.standard.set(currentLanguage, forKey: kLanguageCode)
        if currentLanguage == "en" {
            UserDefaults.standard.set("1", forKey: kLanguageId)
        }
        else {
            UserDefaults.standard.set("2", forKey: kLanguageId)
        }
        
        self.addNavigationBar()
       
        
        if userDefaults.object(forKey: knUserId) == nil {
            userDefaults.set(1, forKey: knUserId)
        }
        
        if userDefaults.object(forKey: kcToken) == nil {
            userDefaults.set(KbasecToken, forKey: kcToken)
        }
        if userDefaults.object(forKey: kisLogin) != nil {
            print(userDefaults.object(forKey: kisLogin) as! String)
            self.getUserDetails()
        }
       
        
        if UserDefaults.standard.value(forKey: kisMessage) != nil {
            AppHelper.showMessage(view: self.view, message: UserDefaults.standard.value(forKey: kisMessage) as! String)
            UserDefaults.standard.removeObject(forKey: kisMessage)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appDelegate.getCount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @IBAction func OnClickWomen(_ sender: Any) {
        let section = 2
               
        
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        nextViewController.nCategoryId = "lbl_Home_category_woman_id".setlocalized()
        nextViewController.IsSubCategory = true
        nextViewController.cCategoryName = "lbl_Home_Women".setlocalized()
        nextViewController.api = kProductByCategory
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
//               if let categoryName = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "cCategoryName") as? NSString
//               {
//
//                   if let categoryId = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "nCategoryId") as? NSNumber
//                   {
//                       if let IsSubCategory = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "IsSubCategory") as? NSString
//                       {
//                           if  IsSubCategory == "1"
//                           {
//                               let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
//                               nextViewController.nCategoryId = "\(categoryId)"
//                               nextViewController.IsSubCategory = true
//                               nextViewController.cCategoryName = categoryName as String
//                                                 nextViewController.api = kProductByCategory
//                               self.navigationController?.pushViewController(nextViewController, animated: true)
//                           }
//                           else
//                           {
//                               let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
//                                                 nextViewController.nCategoryId = "\(categoryId)"
//                               nextViewController.cCategoryName = categoryName as String
//                                                 nextViewController.api = kProductByCategory
//                               self.navigationController?.pushViewController(nextViewController, animated: true)
//                           }
//
//                       }
//
//                   }
//
//               }
    }
    @IBAction func OnClickMen(_ sender: Any) {
        let section = 1
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        nextViewController.nCategoryId = "lbl_Home_category_man_id".setlocalized()
        nextViewController.IsSubCategory = true
        nextViewController.cCategoryName = "lbl_Home_men".setlocalized()
        nextViewController.api = kProductByCategory
        self.navigationController?.pushViewController(nextViewController, animated: true)
//               if let categoryName = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "cCategoryName") as? NSString
//               {
//
//                   if let categoryId = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "nCategoryId") as? NSNumber
//                   {
//                       if let IsSubCategory = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "IsSubCategory") as? NSString
//                       {
//                           if  IsSubCategory == "1"
//                           {
//
//                           }
//                           else
//                           {
//                               let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
//                                                 nextViewController.nCategoryId = "\(categoryId)"
//                               nextViewController.cCategoryName = categoryName as String
//                                                 nextViewController.api = kProductByCategory
//                               self.navigationController?.pushViewController(nextViewController, animated: true)
//                           }
//
//                       }
//
//                   }
//
//               }
    }
    
    @IBAction func OnClickAccesories(_ sender: Any) {
        
        //let section = 1
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        nextViewController.nCategoryId = "lbl_Home_category_Accesories_id".setlocalized()
        nextViewController.IsSubCategory = true
        nextViewController.cCategoryName = "lbl_Home_Accesories".setlocalized()
        nextViewController.api = kProductByCategory
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @objc func menuOpen() {
//        sideMenuManager?.toggleSideMenuView()
//        let rootObj: BarcodeScanner_VC = BarcodeScanner_VC(nibName: "BarcodeScanner_VC", bundle: nil)
//        self.navigationController?.pushViewController(rootObj, animated: true)
        
//        let rootObj: BookAppointMentTimeVc = BookAppointMentTimeVc(nibName: "BookAppointMentTimeVc", bundle: nil)
//               self.navigationController?.pushViewController(rootObj, animated: true)
       
        if UserDefaults.standard.object(forKey: kisLogin) != nil {
                 let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                  nextViewController.isAppointment = true
                         self.navigationController?.pushViewController(nextViewController, animated: true)
              }
            else if appDelegate.GuestCustomerId != "0"
        {
            let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                             nextViewController.isAppointment = true
            nextViewController.isGuest = true
           nextViewController.isfirstTime = true
            nextViewController.strGuestEmail = appDelegate.BookingEmail
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
              else {

                  let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login

            nextViewController.isAppointment = true
                         self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
                     
    }
    
    @objc func changeLanguage () {
        
        if UserDefaults.standard.object(forKey: knCustomerId) != nil {
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Wishlist_Vc") as! Wishlist_Vc
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else
        {
            let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        
       
//        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "SelectLanguage") as! SelectLanguage
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
     @objc func OpenNotifications () {
            
        if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Notificationlist_Vc") as! Notificationlist_Vc
                                       self.navigationController?.pushViewController(nextViewController, animated: true)
                      }
               else
               {
                   let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
                self.navigationController?.pushViewController(nextViewController, animated: true)
               }
        
           
    //        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "SelectLanguage") as! SelectLanguage
    //        self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    @objc func addSarchBar() {
           searchBar.alpha = 0
           navigationItem.titleView = searchBar
           
           let backButton:UIButton = UIButton()
           let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
           if currentLanguage == "en" {
               backButton.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
           }
           else{
               backButton.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
           }
           backButton.addTarget(self, action: #selector(self.hideSearchBar), for: UIControlEvents.touchUpInside)
           let backView = UIBarButtonItem(customView: backButton)
           self.navigationItem.leftBarButtonItems = [backView]
           
//           let languageButton:UIButton = UIButton()
//           languageButton.setImage(UIImage(named: "ic_language"), for: .normal)
//           languageButton.addTarget(self, action: #selector(self.hideSearchBar), for: UIControlEvents.touchUpInside)
//           let languageView = UIBarButtonItem(customView: languageButton)
           //self.navigationItem.rightBarButtonItems = [languageView]
           
        let buttonSearch = UIButton.init(type: .custom)
              buttonSearch.setImage(UIImage.init(named: "close"), for: UIControlState.normal)
              buttonSearch.addTarget(self, action:#selector(hideSearchBar), for: UIControlEvents.touchUpInside)
              buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 15, height: 15)
              
              let buttonLanguage = UIButton.init(type: .custom)
              
           //   let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
              if currentLanguage == "en" {
                  buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
              }
              else{
                  buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
              }
              
              buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
              buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 15, height: 15)
              
              
              let buttonNotification = UIButton.init(type: .custom)
              
             
              if currentLanguage == "en" {
                  buttonNotification.setImage(UIImage.init(named: "notification"), for: UIControlState.normal)
              }
              else{
                  buttonNotification.setImage(UIImage.init(named: "notification"), for: UIControlState.normal)
              }
              
              buttonNotification.addTarget(self, action:#selector(OpenNotifications), for: UIControlEvents.touchUpInside)
              buttonNotification.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 15, height: 15)
              
              let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
              let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
              let barButtonNotification = UIBarButtonItem.init(customView: buttonNotification)
              self.navigationItem.rightBarButtonItems = [barButtonNotification,barButtonLanguage,barButtonSearch]
        
           self.searchBar.tintColor = UIColor(hexString: "#000000")
           self.searchBar.setImage(UIImage(named: "ic_search_outline"), for: .search, state: .normal)
           let width = self.searchBar.frame.width
           let height = self.searchBar.frame.height
           let underline:UIView = UIView(frame: CGRect(x: 0, y: height, width: width, height: 1))
           underline.backgroundColor = UIColor(hexString: "#000000")
           self.searchBar.addSubview(underline)
           
           var txtSearchBarFiled: UITextField?
           if #available(iOS 13.0, *) {
               txtSearchBarFiled = searchBar.searchTextField
           } else {
               if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                   txtSearchBarFiled = searchField
               }
           }
           
           txtSearchBarFiled!.borderStyle = .none
           txtSearchBarFiled!.backgroundColor = UIColor.clear
                      txtSearchBarFiled!.textColor = UIColor(hexString: "#000000")
                      txtSearchBarFiled!.font = UIFont(name: RalewayLight, size: 17)
                      txtSearchBarFiled!.attributedPlaceholder = NSAttributedString(string: "home_search_flowers".setlocalized() ,
                                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#000000")])
           txtSearchBarFiled!.becomeFirstResponder()
           
          
           
           UIView.animate(withDuration: 0.5, animations: {
               self.searchBar.alpha = 1
           }, completion: { finished in
               
           })
       }
       
    
    @objc func hideSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 0
        }, completion: { finished in
            self.addNavigationBar()
        })
    }
    
    @objc func gotoProductList(sender:UITapGestureRecognizer) {
        let section = sender.view?.tag
        
        if let categoryName = (self.arrCategoryList.object(at: section! - 1) as! NSDictionary).value(forKey: "cCategoryName") as? NSString
        {
            
            if let categoryId = (self.arrCategoryList.object(at: section! - 1) as! NSDictionary).value(forKey: "nCategoryId") as? NSNumber
            {
                if let IsSubCategory = (self.arrCategoryList.object(at: section! - 1) as! NSDictionary).value(forKey: "IsSubCategory") as? NSString
                {
                    if  IsSubCategory == "1"
                    {
                        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                        nextViewController.nCategoryId = "\(categoryId)"
                        nextViewController.IsSubCategory = true
                        nextViewController.cCategoryName = categoryName as String
                        nextViewController.api = kProductByCategory
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                    else
                    {
                        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                        nextViewController.nCategoryId = "\(categoryId)"
                        nextViewController.cCategoryName = categoryName as String
                        nextViewController.api = kProductByCategory
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                    
                }
                
            }
            
        }
       
        
//        if section == 1 {
//            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductCategory") as! ProductCategory
//            nextViewController.isCategory = true
//            nextViewController.cCategoryName = arrProductType.object(at: section! - 1) as! String
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//        }
//        else if section == 2 {
//            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
//            nextViewController.isFeatureProducts = true
//            nextViewController.cCategoryName = arrProductType.object(at: section! - 1) as! String
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//        }
    }
    
    // MARK: - Custom Methods
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getSliderData()
                self.getCategoryList()
//                self.getFeatureProducts()
//                self.getContactUsDetails()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getContactUsDetails () {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&cPageName=%@&cToken=%@", kContactAbout,"\(nUserId)","Contact us","\(cToken)")
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objContactUsDetails = HttpWrapper.init()
            self.objContactUsDetails.delegate = self
            self.objContactUsDetails.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func getUserDetails() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = userDefaults.value(forKey: knUserId) as! Int
            let nCustomerId = userDefaults.value(forKey: knCustomerId) as! Int
            let cToken = userDefaults.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nCustomerId=%@&cToken=%@", kUserDetails,"\(nUserId)","\(nCustomerId)",cToken)
            print("Catlog: \(param)")
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            AppHelper.showLoadingView()
            self.objCustomerDetails = HttpWrapper.init()
            self.objCustomerDetails.delegate = self
            self.objCustomerDetails.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func getHomeData() {
        
    }
    
    func getSliderData() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = userDefaults.value(forKey: knUserId) as! Int
            let cToken = userDefaults.value(forKey: kcToken) as! String
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&cToken=%@&nLanguageId=%@", kAllBanner,"\(nUserId)",cToken,nLanguageId)
            
            print("Catlog: \(param)")
            
            AppHelper.showLoadingView()
            self.objSlider = HttpWrapper.init()
            self.objSlider.delegate = self
        self.objSlider.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func getCategoryList() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = userDefaults.value(forKey: knUserId) as! Int
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            
            let cToken = userDefaults.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&cToken=%@", kCategoryListHome,"\(nUserId)","\(nLanguageId)","\(cToken)")
            
            print("Catlog: \(param)")
            
            AppHelper.showLoadingView()
            self.objCategoryList = HttpWrapper.init()
            self.objCategoryList.delegate = self
            self.objCategoryList.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func getFeatureProducts(){
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = userDefaults.value(forKey: knUserId) as! Int
            
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            let cToken = userDefaults.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&cToken=%@", kFeatureProducts,"\(nUserId)","\(nLanguageId)","\(cToken)")
            print("Catlog: \(param)")
            AppHelper.showLoadingView()
            self.objFeatureProducts = HttpWrapper.init()
            self.objFeatureProducts.delegate = self
            self.objFeatureProducts.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func gotoCategoryToProducts(categoryId:Int,categoryName:String,api:String){
        let nUserId = userDefaults.value(forKey: knUserId) as! Int
        var nLanguageId = ""
        
        if UserDefaults.standard.object(forKey: kLanguageId) != nil {
            nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
        }
        let cToken = userDefaults.value(forKey: kcToken) as! String
        
        var param:String = ""
        
        param = String(format: "%@?nUserId=%@&nLanguageId=%@&cToken=%@", kFeatureProducts,"\(nUserId)","\(nLanguageId)","\(cToken)")
        print("Catlog: \(param)")
        AppHelper.showLoadingView()
        self.objFeatureProducts = HttpWrapper.init()
        self.objFeatureProducts.delegate = self
        self.objFeatureProducts.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
       // lblTitle.text = "lbl_home".setlocalized()
      // lbNavTitle.text = "lbl_home_title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        viewNoDataFound.backgroundColor  = navigationbarColor
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let buttonMenu = UIButton.init(type: .custom)
        buttonMenu.setImage(UIImage.init(named: "qr-code"), for: UIControlState.normal)
        buttonMenu.addTarget(self, action:#selector(menuOpen), for: UIControlEvents.touchUpInside)
        buttonMenu.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonMenu = UIBarButtonItem.init(customView: buttonMenu)
     self.navigationItem.leftBarButtonItem = barButtonMenu
        
        let buttonSearch = UIButton.init(type: .custom)
        buttonSearch.setImage(UIImage.init(named: "ic_search"), for: UIControlState.normal)
        buttonSearch.addTarget(self, action:#selector(addSarchBar), for: UIControlEvents.touchUpInside)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 15, height: 15)
        
        let buttonLanguage = UIButton.init(type: .custom)
        
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
        }
        else{
            buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
        }
        
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 15, height: 15)
        
        
        let buttonNotification = UIButton.init(type: .custom)
        
       
        if currentLanguage == "en" {
            buttonNotification.setImage(UIImage.init(named: "notification"), for: UIControlState.normal)
        }
        else{
            buttonNotification.setImage(UIImage.init(named: "notification"), for: UIControlState.normal)
        }
        
        buttonNotification.addTarget(self, action:#selector(OpenNotifications), for: UIControlEvents.touchUpInside)
        buttonNotification.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 30, height: 15)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
        let barButtonNotification = UIBarButtonItem.init(customView: buttonNotification)
        self.navigationItem.rightBarButtonItems = [barButtonNotification,barButtonLanguage,barButtonSearch]
       
       
        
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - Tableview Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCategoryList.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
            
        }else{
            let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblHome.frame.size.width, height: 35))
            var lblHeaderName:UILabel = UILabel()
            var btnViewMore:UIButton = UIButton()
            headerView.backgroundColor = navigationbarColor
            
            
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
                lblHeaderName = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 100, height: headerView.frame.size.height))
                btnViewMore = UIButton(frame: CGRect(x: headerView.frame.size.width - 100, y: 0, width: 100, height: headerView.frame.size.height))
            }
            else {
                lblHeaderName = UILabel(frame: CGRect(x: 100, y: 0, width: self.view.frame.size.width - 115, height: headerView.frame.size.height))
                btnViewMore = UIButton(frame: CGRect(x: 15, y: 0, width: 100, height: headerView.frame.size.height))
                
            }
            
            if let name = (self.arrCategoryList.object(at: section - 1) as! NSDictionary).value(forKey: "cCategoryName") as? NSString
            {
                lblHeaderName.text = name as String
            }
            
            //lblHeaderName.text = (arrProductType.object(at: section - 1) as! String)
            lblHeaderName.font = UIFont(name: RalewaySemiBold, size: 20)
            
            
            btnViewMore.setTitle("lbl_Home_Viewmore".setlocalized(), for: .normal)
            btnViewMore.titleLabel?.font = UIFont(name: RalewayRegular, size: 14)
            btnViewMore.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
            
            let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductList))
            openProductGesture.numberOfTapsRequired = 1
            btnViewMore.isUserInteractionEnabled = true
            btnViewMore.tag = section
            btnViewMore.addGestureRecognizer(openProductGesture)
            
            headerView.addSubview(lblHeaderName)
            headerView.addSubview(btnViewMore)
            
            return headerView
        }
        
    }
    
  
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            viewHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.init().bounds.width, height: self.view.frame.width/1.5)
            lblMen.text = "lbl_Home_men".setlocalized()
            lblWomen.text = "lbl_Home_Women".setlocalized()
            lblAccesories.text = "lbl_Home_Accesories".setlocalized()
            
            if let url = "img_Home_Men".setlocalized() as? String {
               imgMen.cacheImage(urlString: url)
            }
            
            if let url = "img_Home_women".setlocalized() as? String {
               imgWomen.cacheImage(urlString: url)
            }
            
            if let url = "img_Home_Accesories".setlocalized() as? String {
               imgAccesories.cacheImage(urlString: url)
            }
            return viewHeader
        
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBannerTableCell") as! HomeBannerTableCell
            cell.delegate = self
            cell.arrBanners = self.arrBannerImage
            cell.collectionBanner.layer.cornerRadius = 10
            cell.collectionBanner.reloadData()
            return cell
        }
            //        else if indexPath.section == 1 {
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductTableCell") as! HomeProductTableCell
            //
            //            if let array:NSArray = (self.arrCategoryList.object(at: indexPath.section) as! NSDictionary).value(forKey: "Items") as? NSArray
            //            {
            //               cell.arrProductDetails = array
            //            }
            //
            //            cell.delegate = self
            //            cell.currentIndex = 0
            //            cell.collectionProduct.reloadData()
            //            return cell
            //        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductTableCell") as! HomeProductTableCell
            if let array:NSArray = (self.arrCategoryList.object(at: indexPath.section - 1) as! NSDictionary).value(forKey: "Items") as? NSArray
            {
                cell.arrProductDetails = array
            }
            
            
            if let nCategoryId = (self.arrCategoryList.object(at: indexPath.section - 1) as! NSDictionary).value(forKey: "IsAccessories") as? NSNumber
            {
               if nCategoryId == 1
               {
                cell.isZigzagOn = true
                }
                else
               {
                cell.isZigzagOn = false
                }
            }
            else if let nCategoryId = (self.arrCategoryList.object(at: indexPath.section - 1) as! NSDictionary).value(forKey: "IsAccessories") as? String
            {
               if nCategoryId == "1"
               {
                cell.isZigzagOn = true
                }
                else
               {
                cell.isZigzagOn = false
                }
            }
            
            
            
            cell.currentIndex = 1
            cell.delegate = self
            cell.collectionProduct.reloadData()
            return cell
        }
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if "lbl_home_banner_is_visible".setlocalized() == "1" {
                return self.view.frame.size.width / 2 + 30
            }else{
                return 0
            }
        }
        else
        {
             return 220
        }
//        else if indexPath.section == 1 {
//            if self.arrCategoryList.count != 0 {
//                return 180
//            }
//            else {
//                return 0
//            }
//        }
//        else {
//            if self.arrFeatureProducts.count != 0 {
//                return 180
//            }
//            else {
//                return 0
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else
        {
            return 35
        }
//        else if section == 1 {
//            if self.arrCategoryList.count != 0 {
//                return 35
//            }
//            else {
//                return 0
//            }
//
//        }
//        else {
//            if self.arrFeatureProducts.count != 0 {
//                return 35
//            }
//            else {
//                return 0
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.view.frame.width/1.5
        }else{
            return 0
        }
    }
    
    // MARK: - Custom Delegate
    
    func navigateToProductDetails(id: Int, productName: String) {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
        nextViewController.productId = "\(id)"
        nextViewController.productName = productName
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func navigateToProductCaregory(id: Int, categoryName: String, api: String) {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        nextViewController.nCategoryId = "\(id)"
        nextViewController.IsSubCategory = true
        nextViewController.cCategoryName = categoryName
        nextViewController.api = api
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func navigateCategoryToProduct(categoryId: Int, categoryName: String, api: String, isSubCategory: String, parentCateogyId: Int) {
        
        if isSubCategory == "1" {
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductSubCategory") as! ProductSubCategory
            nextViewController.nParentCateogyId = "\(parentCateogyId)"
            //                nextViewController.isSubCategory = true
            nextViewController.cCategoryName = categoryName
            //                nextViewController.api = api
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else {
            
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
            nextViewController.nCategoryId = "\(categoryId)"
            nextViewController.cCategoryName = categoryName
            nextViewController.api = api
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func navigateToFeaturedProduct(productId: Int, ProductName: String) {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
        nextViewController.productId = "\(productId)"
        nextViewController.productName = ProductName
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - Searchbar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //    self.searchText = searchBar.text!
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.tblHome.isHidden = true
       // self.tblHome.backgroundColor = UIColor.white
     //   self.view.backgroundColor = UIColor.white
        nextViewController.searchText = searchBar.text!
        searchBar.resignFirstResponder()
        self.navigationController?.pushViewController(nextViewController, animated: false)
        
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        self.refreshControl.endRefreshing()
       // self.activityIndicatorView.stopAnimating()
        if wrapper == objCustomerDetails {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                let customerDetails = (dicsResponse.value(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                
                if let cCustomerFirstName  = customerDetails.value(forKey: "cCustomerFirstName") as? String {
                    if let cCustomerLastName  = customerDetails.value(forKey: "cCustomerLastName") as? String {
                        userDefaults.set(cCustomerFirstName, forKey: kcFirstName)
                        userDefaults.set(cCustomerLastName, forKey: kcLastName)
                        userDefaults.set("\(cCustomerFirstName) \(cCustomerLastName)", forKey: kcCustomerName)
                    }
                    else {
                        userDefaults.set("\(cCustomerFirstName)", forKey: kcCustomerName)
                    }
                }
                
                if let cCustomerContactNo  = customerDetails.value(forKey: "cCustomerContactNo") as? String {
                    userDefaults.set(cCustomerContactNo, forKey: kcContactNo)
                }
                
                if let cCustomerEmailId  = customerDetails.value(forKey: "cCustomerEmailId") as? String {
                    userDefaults.set(cCustomerEmailId, forKey: kcEmail)
                    userDefaults.set(cCustomerEmailId, forKey: kcUserName)
                }
                
                if let cCustomerImage = customerDetails.value(forKey: "cCustomerImage") as? String {
                    userDefaults.set(cCustomerImage, forKey: kcCustomerImage)
                }
                
                if let cBio  = customerDetails.value(forKey: "cBio") as? String {
                    userDefaults.set(cBio, forKey: kcBio)
                }
                userDefaults.synchronize()
            }
            else {
                AppHelper.hideLoadingView()
                //                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else if wrapper == objSlider {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let bannerImages = dicsResponse.object(forKey: "result") as? NSArray {
                    self.arrBannerImage = bannerImages
                }
                print(arrBannerImage)
                self.tblHome.reloadData()
            }
        }
        else if wrapper == objCategoryList {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let categoryList = dicsResponse.object(forKey: "result") as? NSArray {
                    self.arrCategoryList = categoryList
                }
                print(arrCategoryList)
                self.tblHome.reloadData()
            }
        }
        else if wrapper == objFeatureProducts {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let featureProducts = dicsResponse.object(forKey: "result") as? NSArray {
                    self.arrFeatureProducts = featureProducts
                }
                print(arrFeatureProducts)
                self.tblHome.reloadData()
            }
        }
        else if wrapper == objContactUsDetails {
            UserDefaults.standard.set("7", forKey: kDaysLimit)
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrContactDetails = dicsResponse.object(forKey: "Result") as! NSArray
                for index in 0..<self.arrContactDetails.count {
                    let dicResult = self.arrContactDetails.object(at: index) as! NSDictionary
                    if let cPageTitle = dicResult.object(forKey: "cPageTitle") as? String {
                        if cPageTitle == "Support Email" {
                            if let cPageContent = dicResult.object(forKey: "cPageContent") as? String {
                                UserDefaults.standard.set(cPageContent, forKey: kSupportEmail)
                            }
                        }
                        else if cPageTitle == "Days Limit" {
                            if let cPageContent = dicResult.object(forKey: "cPageContent") as? String {
                                UserDefaults.standard.set(cPageContent, forKey: kDaysLimit)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        AppHelper.hideLoadingView()
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
