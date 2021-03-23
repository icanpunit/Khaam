//
//  SampleCart.swift
//  TahaniFlowers
//
//  Created by baps on 05/05/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SampleCart: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate ,HttpWrapperDelegate,HomeProductNavigation{
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
    
    
    @IBOutlet weak var tblProduct: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var viewCheckoutMethod: UIView!
    @IBOutlet weak var lblCheckoutMethod: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCheckoutAsGuest: UIButton!
    @IBOutlet weak var btnRegisterAndCheckout: UIButton!
    @IBOutlet weak var heightCheckoutMethod: NSLayoutConstraint!
    @IBOutlet weak var viewBlack: UIView!
    var isBackRequired:Bool = false
    var isList = true
    @IBOutlet var viewNoDataFound: UIView!
     @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
    @IBOutlet weak var btnBackToShop: UIButtonX!
    var objAddToCart = HttpWrapper()
     var objCategoryList = HttpWrapper()
    var isfromprofile = false
    // MARK: - Variables
    var arrCategoryList = NSArray()
    var searchBar = UISearchBar()
    var cellDetails:CartDetailsCell = CartDetailsCell()
    var arrCart:NSMutableArray = NSMutableArray()
    var fGrandTotal:Float = 0
    var strCurrency = ""
    var isUpdatedCart:Bool = false
    var totalCartCount:Int = 0
    var isPlus:Bool = false
    
     var nCartType = "0"
    var objGetCartlist = HttpWrapper()
    var objDeleteCart = HttpWrapper()
    var userDefaults = UserDefaults.standard
    var arrCartlist:NSArray = NSArray()
   @IBOutlet weak var imgNoData: UIImageView!
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fGrandTotal = 0
        self.addNavigationBar()
         appDelegate.getCount()
        self.btnCheckout.layer.cornerRadius = btnRadius
        self.btnCheckout.clipsToBounds = true
        self.btnCheckout.setTitle("lbl_Samplecart_checkout".setlocalized(), for: .normal)
        
        self.btnLogin.layer.cornerRadius = btnRadius
        self.btnLogin.clipsToBounds = true
        self.btnLogin.setTitle("lbl_Samplecart_login".setlocalized(), for: .normal)
        self.btnLogin.backgroundColor = btnBackgroundColor
        self.btnLogin.setTitleColor(btnTitleColor, for: .normal)
        self.btnCheckoutAsGuest.layer.cornerRadius = btnRadius
        self.btnCheckoutAsGuest.layer.borderWidth = 1
        self.btnCheckoutAsGuest.layer.borderColor = UIColor.black.cgColor
        self.btnCheckoutAsGuest.clipsToBounds = true
        self.btnCheckoutAsGuest.setTitle("lbl_Samplecart_checkout_as_guest".setlocalized(), for: .normal)
        
        self.btnRegisterAndCheckout.layer.cornerRadius = btnRadius
        self.btnRegisterAndCheckout.layer.borderWidth = 1
        self.btnRegisterAndCheckout.layer.borderColor = UIColor.black.cgColor
        self.btnRegisterAndCheckout.clipsToBounds = true
        self.btnRegisterAndCheckout.setTitle("lbl_Samplecart_register_and_checkout".setlocalized(), for: .normal)
        
        self.btnBackToShop.backgroundColor = btnBackgroundColor
        self.btnBackToShop.setTitleColor(btnTitleColor, for: .normal)
        self.lblCheckoutMethod.text = "lbl_cart_choose_method".setlocalized()
        self.btnBackToShop.setTitle("placed_order_go_back".setlocalized(), for: .normal)
        self.lblNoDataFound.text = "lbl_samplecartlist_nodata_title".setlocalized()
        self.lblNODataDetail.text = "lbl_samplecartlist_nodata_detail".setlocalized()
        // @IBOutlet weak var imgNoData: UIImageView!
        if let url = "lbl_NoData_SampleCart".setlocalized() as? String {
           imgNoData.cacheImage(urlString: url)
        }
        getCartList()
        getCategoryList()
//        if UserDefaults.standard.object(forKey: kCartData) != nil {
//            arrCart = (AppHelper.convertToDictionary(text: UserDefaults.standard.object(forKey: kCartData) as! String) as! NSArray).mutableCopy() as! NSMutableArray
//            print(self.arrCart)
//            self.viewNoDataFound.removeFromSuperview()
//            self.tblCart.isHidden = false
//            self.tblCart.reloadData()
//        }
//        else {
//            self.viewNoDataFound.frame.size.width = self.view.frame.size.width
//            self.viewNoDataFound.frame.size.height = self.view.frame.size.height
//            self.viewNoDataFound.isHidden = false
//            self.tblCart.isHidden = true
//            self.view.addSubview(self.viewNoDataFound)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onClickOutside()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
        appDelegate.SetTabBarItem(0)
    }
    
    @IBAction func onClickCheckout(_ sender: UIButton) {
        
        if UserDefaults.standard.object(forKey: kisLogin) != nil {
            let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
            nextViewController.nCartType = nCartType
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else {
           let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
            nextViewController.isFromCartsample = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
//            let outerViewClose = UITapGestureRecognizer(target: self, action: #selector(self.onClickOutside))
//            outerViewClose.numberOfTapsRequired = 1
//            self.tabBarController?.tabBar.isHidden = true
//            self.viewBlack.addGestureRecognizer(outerViewClose)
//            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                self.viewCheckoutMethod.isHidden = false
//                self.viewBlack.isHidden = false
//
//                var popupBottomSpace = 0
//
//                if UIDevice().userInterfaceIdiom == .phone {
//                    switch UIScreen.main.nativeBounds.height {
//                    case 1136:
//                        print("iPhone 5 or 5S or 5C")
//
//                    case 1334:
//                        print("iPhone 6/6S/7/8")
//
//                    case 1920, 2208:
//                        print("iPhone 6+/6S+/7+/8+")
//
//                    case 2436:
//                        popupBottomSpace = 30
//                        print("iPhone X, XS")
//
//                    case 2688:
//                        popupBottomSpace = 30
//                        print("iPhone XS Max")
//
//                    case 1792:
//                        popupBottomSpace = 30
//                        print("iPhone XR")
//
//                    default:
//                        popupBottomSpace = 30
//                        print("Unknown")
//                    }
//                }
//
//                self.heightCheckoutMethod.constant = CGFloat(popupBottomSpace)
//                self.view.layoutIfNeeded()
//            }, completion: nil)
        }
    }
   
    @IBAction func onClickLogin(_ sender: UIButton) {
        let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
        nextViewController.isFromCartsample = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func onClickCheckoutAsGuest(_ sender: UIButton) {
        
        let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
        nextViewController.nCartType = nCartType
        nextViewController.isGuest = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func onClickRegisterAndCheckout(_ sender: UIButton) {
        let nextViewController = objMain.instantiateViewController(withIdentifier: "Signup") as! Signup
        nextViewController.isFromCartsample = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - @objc Actions
    
    @objc func onClickDelete(sender:MyCartUpdateGesture) {
        
        self.fGrandTotal = 0
        
        let cartAlert = UIAlertController(title: "lbl_home_title".setlocalized(), message: "lbl_samplecart_delete_message".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
        
        cartAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
            let index = sender.indexId
            let productDetails = self.arrCart.object(at: index) as! NSDictionary
            
            if let productQty = productDetails.object(forKey: "nCartId") as? NSNumber {
                self.DeleteCart(nCartId: "\(productQty)")
            }
            
           
            
        }))
        
        cartAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(cartAlert, animated: true, completion: nil)
    }
    
    @objc func onClickPlus(sender:MyCartUpdateGesture) {
        let cell = sender.cell
        let index = sender.view?.tag
        qtyCart = Float(cell.txtCounter.text!)!
        if qtyCart < 99 {
            qtyCart = qtyCart + 1
            cell.txtCounter.text = "\(qtyCart)"
            isPlus = true
            
            let productDetails = self.arrCart.object(at: index!) as! NSDictionary
            
            if let productQty = productDetails.object(forKey: "nCartId") as? NSNumber {
               if let nProductId = productDetails.object(forKey: "nProductId") as? NSNumber {
                    AddToCart(Qty: "\(qtyCart)", nCartId: "\(productQty)", nProductId: "\(nProductId)")
                }
            }
            
           
//            self.cartUpdate(index: index!)
//            self.tblCart.reloadData()
        }
    }
    
    func AddToCart(Qty:String,nCartId:String,nProductId:String) {
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
                
                var nCustomerId = "0"
                
                if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                    nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                }
                
                //let nCustomerId = userDefaults.value(forKey: knCustomerId) as! Int
                //let nProductId = self.productId
                let cToken = userDefaults.value(forKey: kcToken) as! String
                let format: DateFormatter = DateFormatter()
               format.dateFormat = "yyyy-MM-dd"
                format.locale = Locale(identifier: "en")
                let now: NSDate = NSDate()
                let TodayDate: String = format.string(from: now as Date)
               
    //            var param:String = ""
    //
    //            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nProductId=%@&cToken=%@", kProductDetials,"\(nUserId)","\(nLanguageId)","\(nProductId)","\(cToken)")
                
                var url = URLComponents(string: kCreateCart)!

                url.queryItems = [
                    URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                    URLQueryItem(name: "nLanguageId", value: nLanguageId),
                    URLQueryItem(name: "nProductId", value: nProductId),
                    URLQueryItem(name: "cToken", value: "\(cToken)"),
                    URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                    URLQueryItem(name: "dtCartDate", value: "\(TodayDate)"),
                    URLQueryItem(name: "nQuantity", value: "\(Qty)"),
                    URLQueryItem(name: "cDeviceToken", value: "\(appDelegate.DeviceId)"),
                    URLQueryItem(name: "nCartId", value: nCartId),
                    URLQueryItem(name: "nCartType", value: "0")
                ]
                
                AppHelper.showLoadingView()
                self.objAddToCart = HttpWrapper.init()
                self.objAddToCart.delegate = self
                self.objAddToCart.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
            }
        }
     func getCartList() {
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
                
                 var nCustomerId = "0"
                var deviceid = ""
                           if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                               nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                           }
                else
                           {
                         deviceid = "\(appDelegate.DeviceId)"
                }
               
                let cToken = userDefaults.value(forKey: kcToken) as! String
                let format: DateFormatter = DateFormatter()
               format.dateFormat = "yyyy-MM-dd"
                format.locale = Locale(identifier: "en")
                let now: NSDate = NSDate()
                let TodayDate: String = format.string(from: now as Date)
               
    //            var param:String = ""
    //
    //            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nProductId=%@&cToken=%@", kProductDetials,"\(nUserId)","\(nLanguageId)","\(nProductId)","\(cToken)")
                
                var url = URLComponents(string: kSelectAllCartProductByCustomer)!

                url.queryItems = [
                    URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                    URLQueryItem(name: "nLanguageId", value: nLanguageId),
                   URLQueryItem(name: "cDeviceId", value: deviceid),
                    URLQueryItem(name: "cToken", value: "\(cToken)"),
                    URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                    URLQueryItem(name: "nCartType", value: "0")
                ]
                
                AppHelper.showLoadingView()
                self.objGetCartlist = HttpWrapper.init()
                self.objGetCartlist.delegate = self
                self.objGetCartlist.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
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
               
               param = String(format: "%@?nUserId=%@&nLanguageId=%@&cToken=%@&nCategoryId=%@", kGetFeelItMostSellerProductWithCategory,"\(nUserId)","\(nLanguageId)","\(cToken)","0")
               
               print("Catlog: \(param)")
               
               AppHelper.showLoadingView()
               self.objCategoryList = HttpWrapper.init()
               self.objCategoryList.delegate = self
               self.objCategoryList.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
           }
       }
       
    
    func DeleteCart(nCartId:String) {
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
                   
                   var nCustomerId = "0"
                              
                              if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                                  nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                              }
                  
                   let cToken = userDefaults.value(forKey: kcToken) as! String
                   let format: DateFormatter = DateFormatter()
                  format.dateFormat = "yyyy-MM-dd"
                format.locale = Locale(identifier: "en")
                   let now: NSDate = NSDate()
                   let TodayDate: String = format.string(from: now as Date)
                  
       //            var param:String = ""
       //
       //            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nProductId=%@&cToken=%@", kProductDetials,"\(nUserId)","\(nLanguageId)","\(nProductId)","\(cToken)")
                   
                   var url = URLComponents(string: kDeleteCartRecord)!

                   url.queryItems = [
                       URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                       URLQueryItem(name: "nCartId", value: nCartId),
                      
                       URLQueryItem(name: "cToken", value: "\(cToken)")
                   ]
                   
                   AppHelper.showLoadingView()
                   self.objDeleteCart = HttpWrapper.init()
                   self.objDeleteCart.delegate = self
                   self.objDeleteCart.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
               }
           }
    
    func cartUpdate(index:Int) {
        totalCartCount = 0
        let dicProductDetials = arrCart.object(at: index) as! NSDictionary
        var dicCart:NSMutableArray = NSMutableArray()
//        isBackRequired = true
        var newDictProductDetails:NSMutableDictionary = NSMutableDictionary()
        if UserDefaults.standard.object(forKey: kCartData) != nil {
            dicCart = (AppHelper.convertToDictionary(text: UserDefaults.standard.object(forKey: kCartData) as! String) as! NSArray).mutableCopy() as! NSMutableArray
            print(dicCart)
            
            let currentProductId = dicProductDetials.object(forKey: "nProductId") as! NSNumber
            var cartCount = 0
            var selectctedIndex = 0
            for index in 0..<dicCart.count {
                let dictProductCart = dicCart.object(at: index) as! NSDictionary
                
                let oldProductId = dictProductCart.object(forKey: "nProductId") as! NSNumber
                if currentProductId == oldProductId {
                    if let productCount = dictProductCart.object(forKey: "nQty") as? String {
                        newDictProductDetails = dictProductCart.mutableCopy() as! NSMutableDictionary
                        cartCount = Int(productCount)!
                        selectctedIndex = index
                    }
                }
                
                if let productCount = dictProductCart.object(forKey: "nQty") as? String {
//                    totalCartCount = totalCartCount + Int(productCount)!
                }
                
            }
            
            if cartCount != 0 {
                if isPlus == true {
                    newDictProductDetails.setValue("\(cartCount+1)", forKey: "nQty")
//                    totalCartCount = totalCartCount + 1
                }
                else {
                    newDictProductDetails.setValue("\(cartCount-1)", forKey: "nQty")
//                    totalCartCount = totalCartCount - 1
                }
                
                dicCart.replaceObject(at: selectctedIndex, with: newDictProductDetails)
            }
        }
        print(dicCart)
        arrCart.removeAllObjects()
        arrCart = dicCart
        fGrandTotal = 0
        self.totalCartCount = arrCart.count
        UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
        let tabCart = self.tabBarController!.tabBar.items?[3]
        
        tabCart?.badgeValue = "\(totalCartCount)"
        if #available(iOS 10.0, *) {
            tabCart?.badgeColor = .white
            tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
        }
        
        let jsonData = AppHelper.json(from: dicCart)
        UserDefaults.standard.set(jsonData, forKey:kCartData)
        AppHelper.showMessage(view: self.view, message: "lbl_cart_updated_successfully".setlocalized())
    }
    
    @objc func onClickMinus(sender:MyCartUpdateGesture) {
        let cell = sender.cell
        let index = sender.view?.tag
        qtyCart = Float(cell.txtCounter.text!)!
        if qtyCart > 1 {
            qtyCart = qtyCart - 1
            cell.txtCounter.text = "\(qtyCart)"
            isPlus = false
            let productDetails = self.arrCart.object(at: index!) as! NSDictionary
                       
       if let productQty = productDetails.object(forKey: "nCartId") as? NSNumber {
                     if let nProductId = productDetails.object(forKey: "nProductId") as? NSNumber {
                          AddToCart(Qty: "\(qtyCart)", nCartId: "\(productQty)", nProductId: "\(nProductId)")
                      }
                  }
//            self.cartUpdate(index: index!)
//            self.tblCart.reloadData()
        }
    }
    
    @objc func onClickOutside() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.tabBarController?.tabBar.isHidden = false
            self.viewBlack.isHidden = true
            self.viewCheckoutMethod.isHidden = true
            self.heightCheckoutMethod.constant = -280
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func back() {
        if isfromprofile == true
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            appDelegate.SetTabBarItem(0)
        }
    }
    
    @objc func showpopup () {
        
        let modalViewController = FeelitPopup(nibName:"FeelitPopup",bundle: nil)
               modalViewController.modalPresentationStyle = .overCurrentContext
//               modalViewController.delegates = self
//               modalViewController.celltbl = cell
//               modalViewController.isFromAppointMent = true
               present(modalViewController, animated: true, completion: nil)
//        let logoutAlert = UIAlertController(title: "lbl_Feelit_Popup_Title".setlocalized(), message: "lbl_Feelit_Popup_Detail".setlocalized().htmlToString, preferredStyle: UIAlertControllerStyle.alert)
//
//        logoutAlert.addAction(UIAlertAction(title: "ok".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
//
//        }))
//
////        logoutAlert.addAction(UIAlertAction(title: "lbl_ProductDetail_Spinner_Cencel".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
////                                             print("Handle Cancel Logic here")
////
////                                         }))
//
//        present(logoutAlert, animated: true, completion: nil)
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
        
        let languageButton:UIButton = UIButton()
        languageButton.setImage(UIImage(named: "ic_language"), for: .normal)
        languageButton.addTarget(self, action: #selector(self.hideSearchBar), for: UIControlEvents.touchUpInside)
        let languageView = UIBarButtonItem(customView: languageButton)
        //self.navigationItem.rightBarButtonItems = [languageView]
        
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
    
    
    // MARK: - Custom Methods
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
       // lbNavTitle.text = appDelegate.setLocalizationstring(string: "lbl_cart")
        lbNavTitle.textColor = UIColor.black
        lblTitle.text = "lbl_SampleCart_title".setlocalized()//appDelegate.setLocalizationstring(string: "lbl_cart")
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        self.tblProduct.backgroundColor  = navigationbarColor
         viewNoDataFound.backgroundColor  = navigationbarColor
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let buttonBack = UIButton.init(type: .custom)
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        buttonBack.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonBack.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonBack = UIBarButtonItem.init(customView: buttonBack)
                   if currentLanguage == "en" {
                       buttonBack.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
                   }
                   else{
                       buttonBack.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
                   }
                  
        if isBackRequired == true {

             self.navigationItem.leftBarButtonItem = barButtonBack
        }
        else {
            let barButtonBack = UIBarButtonItem.init(customView: buttonBack)
            buttonBack.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            buttonBack.isUserInteractionEnabled = false
            self.navigationItem.leftBarButtonItem = barButtonBack
        }
        let buttonSearch = UIButton.init(type: .custom)
         buttonSearch.setImage(UIImage.init(named: "info"), for: UIControlState.normal)
       // buttonSearch.leftImage(image: UIImage.init(named: "info")!, renderMode: .alwaysTemplate)
        buttonSearch.addTarget(self, action:#selector(showpopup), for: UIControlEvents.touchUpInside)
        
       
                          if currentLanguage == "en" {
                               buttonSearch.semanticContentAttribute = .forceRightToLeft
                          }
                          else{
                            buttonSearch.semanticContentAttribute = .forceLeftToRight
                          }
        
       
        buttonSearch.tintColor = UIColor.black
        buttonSearch.setTitleColor(btnBackgroundColor, for: .normal)
        buttonSearch.setTitle(" \("lbl_SampleCart_Top_ViewMore".setlocalized()) ", for: .normal)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 45, height: 20)
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(showpopup), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
       
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
//        self.navigationItem.rightBarButtonItems = [barButtonLanguage,barButtonSearch]
        if isList == true
               {
                btnCheckout.isHidden = false
                    self.navigationItem.rightBarButtonItems = nil
               }
               else
               {
                btnCheckout.isHidden = true
                    self.navigationItem.rightBarButtonItems = [barButtonSearch]
               }
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - Tableview Delegate and Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblProduct
        {
            if arrCategoryList.count > 0
            {
                return 1
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            if section == 0 {
                       return arrCart.count
                   }
                   else {
                       return 1
                   }
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblProduct
               {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductTableCell") as! HomeProductTableCell
                              if let array:NSArray = (self.arrCategoryList.object(at: indexPath.section) as! NSDictionary).value(forKey: "Items") as? NSArray
                              {
                                  cell.arrProductDetails = array
                              }
                              cell.currentIndex = 1
                              cell.delegate = self
                              cell.collectionProduct.reloadData()
                              return cell
               }
               else
               {
                   if indexPath.section == 0 {
                              let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailsCell") as! CartDetailsCell
                             
                              let productDetails = arrCart.object(at: indexPath.row) as! NSDictionary
                              cell.txtCounter.layer.borderWidth = 1
                              cell.txtCounter.text = "\(qtyCart)"
                              cell.txtCounter.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
                              cell.isSampel = true
                              let plusTap = MyCartUpdateGesture(target: self, action: #selector(onClickPlus))
                              plusTap.numberOfTapsRequired = 1
                              plusTap.cell = cell
                              plusTap.indexId = indexPath.row
                              cell.btnPlus.isUserInteractionEnabled = true
                              cell.btnPlus.tag = indexPath.row
                              cell.btnPlus.addGestureRecognizer(plusTap)
                              
                              let minusTap = MyCartUpdateGesture(target: self, action: #selector(onClickMinus))
                              minusTap.numberOfTapsRequired = 1
                              minusTap.cell = cell
                              minusTap.indexId = indexPath.row
                              cell.btnMinus.isUserInteractionEnabled = true
                              cell.btnMinus.tag = indexPath.row
                              cell.btnMinus.addGestureRecognizer(minusTap)
                              
                              cell.btnDelete.layer.cornerRadius = 12.5
                              cell.btnDelete.layer.borderWidth = 1
                              cell.btnDelete.clipsToBounds = true
                              cell.btnDelete.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
                              cellDetails = cell
                              
                              let deleteTap = MyCartUpdateGesture(target: self, action: #selector(onClickDelete))
                              deleteTap.numberOfTapsRequired = 1
                              deleteTap.cell = cell
                              deleteTap.indexId = indexPath.row
                              cell.btnDelete.isUserInteractionEnabled = true
                              cell.btnDelete.addGestureRecognizer(deleteTap)
                              cell.lblQuantity.text = "lbl_cart_quantity".setlocalized()
                              var qty:Float = 0
                              
                              if let productName = productDetails.object(forKey: "cName") as? String {
                                  cell.lblProductName.text = productName
                              }
                              
                              
                              if isUpdatedCart == true {
                                  qty = qtyCart
                              }
                              else if let productQty = productDetails.object(forKey: "fQuantity") as? Float {
                                  qty = productQty
                                  cell.txtCounter.text = "\(productQty)"
                              }
                              else if let productQty = productDetails.object(forKey: "fQuantity") as? NSNumber {
                                             qty = Float(truncating: productQty)
                                             cell.txtCounter.text = "\(productQty)"
                                         }
                              if let currency = productDetails.object(forKey: "Currency") as? String {
                                strCurrency = currency
                                if let price1 = productDetails.object(forKey: "fSamplePrice")  as? NSNumber {
                                let price = Float(truncating: price1)
                                  
                                    cell.lblProductPrice.text = "\(currency) \(String(format: "%.3f", price))"
                                }
                                
                                 
                              }
                              
                              if let productImgUrl = productDetails.object(forKey: "cImage") as? String {
                                  cell.imgProduct.cacheImage(urlString: productImgUrl)
                              }
                              
                              return cell
                          }
                          else {
                              let cell = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell") as! CartTotalCell
                              
                              cell.lblSubTotal.text = "lbl_cart_sub_total".setlocalized()
                              cell.lblDiscount.text = "lbl_cart_discount".setlocalized()
                              cell.lblDelivery.text = "lbl_cart_delivery".setlocalized()
                              cell.lblTotal.text = "lbl_cart_total".setlocalized()
                              
                              cell.lblSubtoalPrice.text = "\(strCurrency) \(String(format:"%.3f", fGrandTotal))"
                              cell.lblTotalPrice.text = "\(strCurrency) \(String(format:"%.3f",fGrandTotal))"
                              cell.lblDiscountPrice.text = "\(strCurrency) \(String(format:"%.3f",0.00))"
                              return cell
                          }
               }
        
       
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblProduct
                            {
                               let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblProduct.frame.size.width, height: 35))
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
                                             
                                             if arrCategoryList.count > 0
                                             {
                                                                                             if let name = (self.arrCategoryList.object(at: section ) as! NSDictionary).value(forKey: "cCategoryName") as? NSString
                                                 {
                                                     lblHeaderName.text = name as String
                                                 }
                                             }
                                             else
                                             {
                                                
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
        else
        {
            return nil
        }
         
      }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           if tableView == tblProduct
                         {
                return 35
            }
            else
            {
                 return 0
            }
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblProduct
                     {
                         return 220
        }
        else
        {
            if indexPath.section == 0 {
                return 131
            }
            else {
                return 146
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
      @objc func gotoProductList(sender:UITapGestureRecognizer) {
            let section = sender.view?.tag
            
            if let categoryName = (self.arrCategoryList.object(at: section!) as! NSDictionary).value(forKey: "cCategoryName") as? NSString
            {
                
                if let categoryId = (self.arrCategoryList.object(at: section!) as! NSDictionary).value(forKey: "nCategoryId") as? NSNumber
                {
                    if let IsSubCategory = (self.arrCategoryList.object(at: section!) as! NSDictionary).value(forKey: "IsSubCategory") as? NSString
                    {
                        if  IsSubCategory == "1"
                        {
                            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                            nextViewController.nCategoryId = "\(categoryId)"
                            nextViewController.IsSubCategory = true
                            nextViewController.cCategoryName = categoryName as String
                                              nextViewController.api = kProductByCategory
                            nextViewController.isFeelit = true
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                        }
                        else
                        {
                            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                                              nextViewController.nCategoryId = "\(categoryId)"
                            nextViewController.cCategoryName = categoryName as String
                                              nextViewController.api = kProductByCategory
                             nextViewController.isFeelit = true
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
    
     // MARK: - HttpWrapper Delegate
        
        func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
            if wrapper == objGetCartlist {
                AppHelper.hideLoadingView()
                if dicsResponse.value(forKey: "Success") as! String == "1" {
                    if let arrProduct:NSArray = dicsResponse.value(forKey: "Result") as? NSArray {
                        fGrandTotal = 00
                        
                        if let price1 = dicsResponse.value(forKey: "fGrandTotal") as? NSNumber {
                        let st = Float(truncating: price1)
                        fGrandTotal = st
                        }
                        self.arrCart = arrProduct.mutableCopy() as! NSMutableArray
                        tblCart.reloadData()
                        tblProduct.isHidden = true
                        isList = true
                    }
                }
                else
                {
                    arrCart.removeAllObjects()
                     tblProduct.isHidden = false
                    
                    if self.arrCart.count != 0 {
                                   self.tblCart.reloadData()
                               }
                               else {
                                   UserDefaults.standard.removeObject(forKey: kCartData)
                                   self.viewNoDataFound.frame.size.width = self.view.frame.size.width
                                   self.viewNoDataFound.frame.size.height = self.view.frame.size.height/2
                                   self.viewNoDataFound.isHidden = false
                                   self.tblCart.isHidden = true
                        tblProduct.tableHeaderView = viewNoDataFound
                        isList = false
                        addNavigationBar()
                                 //  self.view.addSubview(self.viewNoDataFound)
                               }
                }
            }
                
            else if wrapper == objCategoryList {
                AppHelper.hideLoadingView()
                if dicsResponse.value(forKey: "Success") as! String == "1" {
                    if let categoryList = dicsResponse.object(forKey: "result") as? NSArray {
                        self.arrCategoryList = categoryList
                    }
                    print(arrCategoryList)
                    self.tblProduct.reloadData()
                }
            }
                
           else if wrapper == objDeleteCart {
               AppHelper.hideLoadingView()
               if dicsResponse.value(forKey: "Success") as! String == "1" {
                getCartList()
//                   if let arrProduct:NSArray = dicsResponse.value(forKey: "Result") as? NSArray {
//                       self.arrCart = arrProduct.mutableCopy() as! NSMutableArray
//                       tblCart.reloadData()
//
//                   }
               }
           }
            else if wrapper == objAddToCart {
                           AppHelper.hideLoadingView()
                           if dicsResponse.value(forKey: "Success") as! String == "1" {
                            getCartList()
            //                   if let arrProduct:NSArray = dicsResponse.value(forKey: "Result") as? NSArray {
            //                       self.arrCart = arrProduct.mutableCopy() as! NSMutableArray
            //                       tblCart.reloadData()
            //
            //                   }
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

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImageRenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }

    func rightImage(image: UIImage, renderMode: UIImageRenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}
