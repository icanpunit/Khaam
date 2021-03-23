//
//  OrderPlaced.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderPlaced: UIViewController,UISearchBarDelegate ,HttpWrapperDelegate{

    // MARK: - IBOutlets
    @IBOutlet weak var imgOrderPlaced: UIImageView!
    @IBOutlet weak var lblCongratulations: UILabel!
    @IBOutlet weak var lblOrderPlacedMessage: UILabel!
    @IBOutlet weak var btnGoBack: UIButton!
//    @IBOutlet weak var lblOrderMessage: UILabel!
    @IBOutlet weak var lblThankYou: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
//    @IBOutlet weak var lblInstructions: UILabel!
    
 //   internal var paymentItems: [PaymentItem] = Serializer.deserialize()
       
     var isAppointment:Bool = false
    var searchBar = UISearchBar()
    var orderId = ""
    var cTransactionId = ""
    // MARK: - Viewcontroller Methods
    var objOrderStatusChange = HttpWrapper()
          var userDefaults = UserDefaults.standard
          var arrCartlist:NSArray = NSArray()
         
          var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    override func viewDidLoad() {
        super.viewDidLoad()

       // @IBOutlet weak var imgNoData: UIImageView!
                          
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
        
        self.btnGoBack.layer.cornerRadius = btnRadius
        self.btnGoBack.clipsToBounds = true

       
//        self.lblOrderPlacedMessage.text = "placed_order_order_message".setlocalized()
        self.btnGoBack.setTitle("placed_order_go_back".setlocalized(), for: .normal)
        if isAppointment == true
        {
            
            if let url = "lbl_NoData_OrderPlaced_booking".setlocalized() as? String {
                                         imgOrderPlaced.cacheImage(urlString: url)
                                      }
            
            self.lblCongratulations.text = "placed_Booking_congratulations".setlocalized()
                   
                   self.lblOrderPlacedMessage.text = "placed_booking_your_order_has_been_receive".setlocalized()
                   self.lblThankYou.text = "placed_booking_thank_you_for_your_purchase".setlocalized()
                   self.lblOrderId.text = "\("placed_booking_your_order_is".setlocalized()) \(self.orderId)"
            
           changeStatusAppointment()
        }
        else
        {
            if let url = "lbl_NoData_OrderPlaced".setlocalized() as? String {
                                         imgOrderPlaced.cacheImage(urlString: url)
                                      }
            self.lblCongratulations.text = "placed_order_congratulations".setlocalized()
                   
                   self.lblOrderPlacedMessage.text = "placed_order_your_order_has_been_received".setlocalized()
                   self.lblThankYou.text = "placed_order_thank_you_for_your_purchase".setlocalized()
                   self.lblOrderId.text = "\("placed_order_your_order_is".setlocalized()) \(self.orderId)"
            
            changeStatus()
        }
        
        let totalCartCount = 0
        UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
        let tabCart = self.tabBarController!.tabBar.items?[3]
        
        UserDefaults.standard.removeObject(forKey: kCartData)
        
        tabCart?.badgeValue = "\(totalCartCount)"
        if #available(iOS 10.0, *) {
            tabCart?.badgeColor = .white
            tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    @IBAction func onClickGoBack(_ sender: UIButton) {
        
        if UserDefaults.standard.object(forKey: kisLogin) != nil {
            
            if isAppointment == true
            {
                
                let nextViewController: MyAppointmentListVC = MyAppointmentListVC(nibName: "MyAppointmentListVC", bundle: nil)
                                                                            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            }
            else
            {
                let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Orders") as! Orders
                                  self.navigationController?.pushViewController(nextViewController, animated: true)
            }
                  
               }
        else
        {
            appDelegate.SetTabBarItem(0)
        }
        
    }

    // MARK: - @objc Actions
    
    @objc func back() {
        appDelegate.SetTabBarItem(0)
    }
    
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
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
    
    
    // MARK: - Custom Method

    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "placed_order_title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let buttonBack = UIButton.init(type: .custom)
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            buttonBack.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            buttonBack.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        buttonBack.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonBack.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonBack = UIBarButtonItem.init(customView: buttonBack)
        self.navigationItem.leftBarButtonItem = barButtonBack
        
        let buttonSearch = UIButton.init(type: .custom)
        buttonSearch.setImage(UIImage.init(named: "ic_search"), for: UIControlState.normal)
        buttonSearch.addTarget(self, action:#selector(addSarchBar), for: UIControlEvents.touchUpInside)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 20, height: 20)
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
//        self.navigationItem.rightBarButtonItems = [barButtonLanguage,barButtonSearch]
        
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    
    func changeStatus() {
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
                      
                      var url = URLComponents(string: kUpdatePaymentStatusv2)!

                      url.queryItems = [
                          URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                          URLQueryItem(name: "cPaymentstatus", value: "success"),
                         URLQueryItem(name: "cDeviceId", value: deviceid),
                          URLQueryItem(name: "cToken", value: "\(cToken)"),
                          URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                          URLQueryItem(name: "nOrderId", value: orderId),
                          URLQueryItem(name: "cTransactionId", value: cTransactionId)
                      ]
                    
                    
                      
                     // AppHelper.showLoadingView()
                      self.objOrderStatusChange = HttpWrapper.init()
                      self.objOrderStatusChange.delegate = self
                      self.objOrderStatusChange.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
                  }
              }
    
    
    func changeStatusAppointment() {
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
                         
                         var url = URLComponents(string: kUpdatePaymentStatus)!

                        
                        
                        


                        
                        

                         url.queryItems = [
                             URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                             URLQueryItem(name: "nLanguageId", value: nLanguageId),
                            URLQueryItem(name: "cDeviceId", value: deviceid),
                             URLQueryItem(name: "cToken", value: "\(cToken)"),
                            // URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                             URLQueryItem(name: "nAppointmentId", value: orderId),
                             URLQueryItem(name: "ReferenceId", value: cTransactionId)
                         ]
                       
                       
                         
                        // AppHelper.showLoadingView()
                         self.objOrderStatusChange = HttpWrapper.init()
                         self.objOrderStatusChange.delegate = self
                         self.objOrderStatusChange.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
                     }
                 }
       
         // MARK: - HttpWrapper Delegate
               
               func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
                AppHelper.hideLoadingView()
                   if wrapper == objOrderStatusChange {
                       AppHelper.hideLoadingView()
                       if dicsResponse.value(forKey: "Success") as! String == "1" {
                          
                       }
                       else
                       {
                          
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
