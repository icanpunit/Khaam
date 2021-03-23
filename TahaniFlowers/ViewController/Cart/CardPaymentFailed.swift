//
//  CardPaymentFailed.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 05/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CardPaymentFailed: UIViewController ,HttpWrapperDelegate{

    // MARK: - IBOutlets
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblOrderFailed: UILabel!
    @IBOutlet weak var btnGoBack: UIButton!
    @IBOutlet weak var lblPaymentProcessed: UILabel!
    var isAppointment:Bool = false
    var orderId = ""
    // MARK: - Variables
    var kentUrl = ""
    // MARK: - Viewcontroller Methods
    var objOrderStatusChange = HttpWrapper()
             var userDefaults = UserDefaults.standard
             var arrCartlist:NSArray = NSArray()
            
             var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAppointment == true
        {
           //changeStatusAppointment()
            self.lblOrderFailed.text = "card_payment_failed_title_booking".setlocalized()
                   self.lblPaymentProcessed.text = "card_payment_Detail_booking".setlocalized()
            
            if let url = "img_Payment_Failed_Booking".setlocalized() as? String {
                                        imgIcon.cacheImage(urlString: url)
                                     }
        }
        else
        {
            self.lblOrderFailed.text = "card_payment_failed_title".setlocalized()
                   self.lblPaymentProcessed.text = "card_payment_Detail".setlocalized()
            if let url = "img_Payment_Failed".setlocalized() as? String {
                             imgIcon.cacheImage(urlString: url)
                          }
            changeStatus()
        }
        
       
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
        
       
        self.btnGoBack.setTitle("card_payment_continue_shopping".setlocalized(), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func onClickGoBack(_ sender: UIButton) {
        
        if isAppointment == true
        {
            if let viewController = navigationController?.viewControllers.first(where: {$0 is OrderCheckout}) {
                   navigationController?.popToViewController(viewController, animated: false)
             }
        }
        else
        {
             appDelegate.SetTabBarItem(3)
        }
        
    }
    
    // MARK: - @objc Actions
    
    // MARK: - Custom Method
    
    func addNavigationBar(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "payment_title".setlocalized()
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
        
        let buttonMenu = UIButton.init(type: .custom)
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            buttonMenu.setImage(UIImage.init(named: "close"), for: UIControlState.normal)
        }
        else{
            buttonMenu.setImage(UIImage.init(named: "close"), for: UIControlState.normal)
        }
       buttonMenu.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonMenu.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonMenu = UIBarButtonItem.init(customView: buttonMenu)
        self.navigationItem.leftBarButtonItem = barButtonMenu
        
    }
    
    
    @objc func back()
    {
        appDelegate.SetTabBarItem(0)
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
                           URLQueryItem(name: "cPaymentstatus", value: "failed"),
                          URLQueryItem(name: "cDeviceId", value: deviceid),
                           URLQueryItem(name: "cToken", value: "\(cToken)"),
                           URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                           URLQueryItem(name: "nOrderId", value: orderId),URLQueryItem(name: "cTransactionId", value: "0")
                       ]
                       
                       AppHelper.showLoadingView()
                       self.objOrderStatusChange = HttpWrapper.init()
                       self.objOrderStatusChange.delegate = self
                       self.objOrderStatusChange.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
                   }
               }
        
          // MARK: - HttpWrapper Delegate
                
                func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
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
