//
//  OrderCheckout.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 01/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GSImageViewerController

class OrderCheckout: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate {
    
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var viewCoupen: UIView!
    @IBOutlet weak var btnCheckWallet: UIButton!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var lblCashback: UILabel!
    @IBOutlet weak var imgIconWallet: UIImageView!
    @IBOutlet weak var CollectionImages: UICollectionView!
    @IBOutlet weak var lblOrderImage: UILabel!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var viewWallet: UIView!
    var IsReturnRequest:Bool = true
    // MARK: - IBOutlets
    @IBOutlet weak var tblCheckoutDetails: UITableView!
     @IBOutlet weak var lblTitle: UILabel!
    // MARK: - Variables
    @IBOutlet weak var lblSelectPaymentMethod: UILabel!
     @IBOutlet weak var viewMakeOnlinePayment: UIView!
     @IBOutlet weak var imgOnlinePayment: UIImageView!
     @IBOutlet weak var lblOnlinePayment: UILabel!
     @IBOutlet weak var btnOnlinePayment: UIButton!
     @IBOutlet weak var viewCashOnDelivery: UIView!
     @IBOutlet weak var imgCashOnDelivery: UIImageView!
     @IBOutlet weak var lblCashOnDelivery: UILabel!
     @IBOutlet weak var btnCashOnDelivery: UIButton!
    var userDefaults = UserDefaults.standard
    var arrCart:NSArray = NSArray()
    var arrImage:NSArray = NSArray()
    var arrunitName = ["","checkout_quantity".setlocalized(),"lbl_kilograms".setlocalized(),"lbl_Meter".setlocalized()]
    var arrCartMain:NSArray = NSArray()
    var arrShipping:NSArray = NSArray()
    var isFromOrders:Bool = false
    var ApName = ""
    var ApEmail = ""
    var ApMobile = ""
    var paymentMethod = ""
    var selectedDate = ""
    var date:Date = Date()
    var cardMessage = ""
    var selecedTime = ""
    var completeAddress:NSMutableString = NSMutableString()
    var address = ""
    var nCartType = "1"
    var isGuest = false
    var selectedAddressId = ""
    var isAppointment:Bool = false
    var fGrandTotal:Float = 0
    var fWalletTotal:Float = 0
    var fDeliveryTotal:Float = 0
    var fSubTotal:Float = 0
    var strCurrency = ""
    var paymenttype = 1
    var addressCellHeigt:CGFloat = 0
    var objCheckoutOrder = HttpWrapper()
     var objAppointmentOrder = HttpWrapper()
    var objOrderDetails = HttpWrapper()
    var objGetCartlist = HttpWrapper()
    var objReturnRequest = HttpWrapper()
    var objCouponCode = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var arrPlaceOrder:NSMutableArray = NSMutableArray()
    var arrCouponCode:NSMutableArray = NSMutableArray()
    var dicOrderDetails:NSDictionary = NSDictionary()
    var nOrderId = ""
    var isCouponCodeApply:Bool = false
    var fDiscountPrice:Float = 0.0
    var fCashbackPrice:Float = 0.0
    var strCoupon = ""
    
    
    var cBlock = ""
    var cStreet = ""
    var cAvenue = ""
    var cHouse = ""
    var cFloor = ""
    var cBuildingNo = ""
    var cName = ""
    var cAddressType = ""
    var cLandmark = ""
    var cBuildingName = ""
    var cOfficeName = ""
    
    var cMobileNo = ""
    var cAlterMobileNo = ""
    var cGovernorate = ""
    var cArea = ""
    var cSpecialInstruction = ""
    var fDeliveryCharge = ""
    var couponCell = OrderPlacedPayCell()
    @IBOutlet weak var viewCouponCode: UIView!
       @IBOutlet weak var txtCouponCode: UITextField!
       @IBOutlet weak var btnApply: UIButton!
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.cardMessage)
        currentScrren = "OrderCheckout"
        CollectionImages.delegate = self
        CollectionImages.dataSource = self
        lblOrderImage.text = "lbl_order_detail_order_Image".setlocalized()
        lblCashback.text = "lbl_wallet_checkoutscreen".setlocalized()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        
        
       
        if isFromOrders == false {
            
             if isAppointment == true
            {
                viewCoupen.isHidden = true
                viewHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: viewPayment.frame.height)
                self.view.layoutIfNeeded()
                
                if fGrandTotal > 0
                {
                   tblCheckoutDetails.tableHeaderView = viewHeader
                }
               
            }
            else
             {
                tblCheckoutDetails.tableHeaderView = viewHeader
            }
            
        }
        else
        {
           
        }
        
        if fWalletTotal > 0
        {
            
        }
        else
        {
            
        }
        if let url = "img_wallet_checkoutscreen".setlocalized() as? String {
                               imgIconWallet.cacheImage(urlString: url)
                            }
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
                   self.txtCouponCode.textAlignment = .left
               }
               else {
                   self.txtCouponCode.textAlignment = .right
               }
        
        viewCouponCode.layer.cornerRadius = 20
        viewCouponCode.layer.borderWidth = 1
        viewCouponCode.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
        viewCouponCode.clipsToBounds = true
        txtCouponCode.placeholder = "checkout_coupon_code_placeholder".setlocalized()
        let applyTap = MyApplyTap(target: self, action: #selector(onClickApply))
                                    btnApply.setTitle("checkout_coupon_code_apply".setlocalized(), for: .normal)
                                    applyTap.numberOfTapsRequired = 1
                                    //applyTap.cell = cell
                                    btnApply.isUserInteractionEnabled = true
                                    btnApply.addGestureRecognizer(applyTap)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                  self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                 // self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
                  self.paymentMethod = "ONLINE"
        
        self.viewMakeOnlinePayment.layer.cornerRadius = 2
            self.viewMakeOnlinePayment.layer.borderWidth = 1
            self.viewMakeOnlinePayment.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
            self.viewMakeOnlinePayment.clipsToBounds = true
            self.lblOnlinePayment.text = "step_two_make_online_payment".setlocalized()
            
            self.viewCashOnDelivery.layer.cornerRadius = 2
            self.viewCashOnDelivery.layer.borderWidth = 1
            self.viewCashOnDelivery.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
            self.viewCashOnDelivery.clipsToBounds = true
            self.lblCashOnDelivery.text = "step_two_make_cash_on_delivey".setlocalized()
            
            self.lblSelectPaymentMethod.text = "step_two_select_payment_method".setlocalized()
            let tapCODTap = UITapGestureRecognizer(target: self, action: #selector(onTapCOD))
            tapCODTap.numberOfTapsRequired = 1
            self.viewCashOnDelivery.isUserInteractionEnabled = true
            self.viewCashOnDelivery.addGestureRecognizer(tapCODTap)
            
            let tapMOPTap = UITapGestureRecognizer(target: self, action: #selector(onTapMOP))
            tapMOPTap.numberOfTapsRequired = 1
            self.viewMakeOnlinePayment.isUserInteractionEnabled = true
            self.viewMakeOnlinePayment.addGestureRecognizer(tapMOPTap)
        
        
        if isAppointment == true
               {
                   fWalletTotal = appDelegate.fWalletTotal
                   let valuestring = "lbl_wallet_totalbalance_checkoutscreen".setlocalized()
                                              lblWalletBalance.text = "\(valuestring):\(appDelegate.strCurrency) \(String(format: "%.3f", fWalletTotal))"
                   viewWallet.isUserInteractionEnabled = true
                   if fWalletTotal >= fGrandTotal
                   {
                       self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                       self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                                                         
                       self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                       // self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
                       self.paymentMethod = "Wallet"
                       CalculateData()
                   }
                   else if fWalletTotal > 0
                   {
                       self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                       self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                       self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                       //  self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
                       self.paymentMethod = "ONLINE"
                       CalculateData()
                   }
                   else
                   {
                       self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                       self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                       self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                   //  self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
                       self.paymentMethod = "ONLINE"
                       CalculateData()
                       viewWallet.alpha = 0.5
                       viewWallet.isUserInteractionEnabled = false
                   }
               }
        
        self.addNavigationBar()
        if isAppointment == true
        {
            self.address = completeAddress as String
        }
        else if isFromOrders == true {
            self.tabBarController?.tabBar.isHidden = false
            fGrandTotal = 0
            self.strCurrency = UserDefaults.standard.object(forKey: kCurrency) as! String
            self.getOrderDetails()
        }
        else {
            getCartList()
            
            if UserDefaults.standard.object(forKey: kcBillingAddress) != nil {
                self.address = UserDefaults.standard.object(forKey: kcBillingAddress) as! String
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
       
    @IBAction func onClickbtnWalletCheck(_ sender: Any) {
        
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
        
         self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                // self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
        self.paymentMethod = "Wallet"
        CalculateData()
    }
    @objc func onTapMOP() {
           self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
           self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        
         self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
         //  self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
           self.paymentMethod = "ONLINE"
        CalculateData()
       }
       
       @objc func onTapCOD() {
           self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
         self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
           self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
          // self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
           self.paymentMethod = "COD"
        
        CalculateData()
       }
    @objc func onClickApply(_ sender: MyApplyTap){
       // let cell = sender.cell
      //  self.couponCell = cell
        txtCouponCode.endEditing(true)
        let strCouponCode = txtCouponCode.text!
        
        if btnApply.titleLabel?.text == "checkout_coupon_code_cancel".setlocalized()
        {
            btnApply.setTitle("checkout_coupon_code_apply".setlocalized(), for: .normal)
            txtCouponCode.text = ""
             self.strCoupon = ""
             self.isCouponCodeApply = false
            fDiscountPrice = 0.0
            getCartList()
            btnApply.isUserInteractionEnabled = true
        }
        else
        {
            if AppHelper.isNull(strCouponCode) == true {
                       
                        AppHelper.showAlert("App_name".setlocalized(), message: "checkout_coupon_code_required".setlocalized())
                   }
                   else {
                       self.strCoupon = strCouponCode
                       self.applyCouponCode(couponCode: strCouponCode)
                   }
        }
       
    }

    func CalculateData()
    {
        tblCheckoutDetails.reloadData()
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
//                                if isGuest == true
//                                {
//                                    nCustomerId = appDelegate.GuestCustomerId
//                                }
//                                else
//                                {
//                                   
//                                }
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
                   
                   var url = URLComponents(string: kGetCartAndAllData)!

                   url.queryItems = [
                       URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                       URLQueryItem(name: "nLanguageId", value: nLanguageId),
                      URLQueryItem(name: "cDeviceId", value: deviceid),
                       URLQueryItem(name: "cToken", value: "\(cToken)"),
                       URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                       URLQueryItem(name: "nAddressId", value: "\(selectedAddressId)"),
                       URLQueryItem(name: "nCartType", value: "\(nCartType)")
                   ]
                   
                   AppHelper.showLoadingView()
                   self.objGetCartlist = HttpWrapper.init()
                   self.objGetCartlist.delegate = self
                   self.objGetCartlist.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
               }
           }
    
    
    @objc func ReturnRequest() {
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
    //                                if isGuest == true
    //                                {
    //                                    nCustomerId = appDelegate.GuestCustomerId
    //                                }
    //                                else
    //                                {
    //
    //                                }
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
                       
                       var url = URLComponents(string: kSampleOrderReturn)!

                       url.queryItems = [
                           URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                           URLQueryItem(name: "nLanguageId", value: nLanguageId),
                         
                          URLQueryItem(name: "nOrderId", value: nOrderId),
                         
                           URLQueryItem(name: "cToken", value: "\(cToken)"),
                           URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                          
                       ]
                       
                       AppHelper.showLoadingView()
                       self.objReturnRequest = HttpWrapper.init()
                       self.objReturnRequest.delegate = self
                       self.objReturnRequest.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
                   }
               }
        
    @objc func placedOrder() {
        
        let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
        
        var nCustomerId = "0"
                        var deviceid = ""
                                   if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                                       nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                                   }
                        else
                                   {
                                     if isGuest == true
                                     {
                                         nCustomerId = appDelegate.GuestCustomerId
                                     }
                                     else
                                     {
                                        deviceid = "\(appDelegate.DeviceId)"
                                     }
                                 
                        }
        
       // let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
        let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dtCartDate = dateFormatter.string(from: self.date)
        print(dtCartDate)
        
        var type = ""
        if nCartType == "1"
        {
           type = "Admin Order"
        }
        else
        {
            type = "Free Order"
        }
        var nLanguageId = ""
                   
                   if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                       nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                   }
        let jsonData = AppHelper.json(from: arrPlaceOrder)

        var strPaymentMethod = ""
        var iscredituse = "0"
        var fwalletprice:Float = 0
        if  self.paymentMethod == "Wallet"
        {
            strPaymentMethod = "ONLINE"
            iscredituse = "1"
            
            if fWalletTotal == fGrandTotal
            {
            fwalletprice = fGrandTotal
             }
            else  if fWalletTotal > fGrandTotal
            {
                  fwalletprice = fGrandTotal
            }
             else
            {
                fwalletprice = fWalletTotal 
           
             }
        }
        else
        {
            iscredituse = "0"
            strPaymentMethod = self.paymentMethod
        }
        
        let param = String(format: "%@?nUserId=%@&nCustId=%@&fTotal=%@&cPaymentTerms=%@&dtDelivaryDate=%@&cAddress=%@&cCountryCode=%@&cTime=%@&cJsonData=%@&cToken=%@&cCouponCode=%@&cOrderNotes=%@&cAddressSpecialInstructions=%@&fDeliveryCharge=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNo=%@&cName=%@&cMobileNo=%@&cAlterMobileNo=%@&cGovernorate=%@&cArea=%@&cSpecialInstruction=%@&nLanguageId=%@&cOrderType=%@&fCouponDiscount=%@&cAddressType=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&IsCredit=%@&fWalletAmount=%@&fCashBackAmount=%@",kPlaceOrder,"\(nUserId)","\(nCustomerId)","\(self.fGrandTotal)",strPaymentMethod,dtCartDate,self.address,self.strCurrency,self.selecedTime,jsonData!,cToken,self.strCoupon,self.cardMessage,"",fDeliveryCharge,cBlock,cStreet,cAvenue,cHouse,cFloor,cBuildingNo,cName,cMobileNo,cAlterMobileNo,cGovernorate,cArea,cSpecialInstruction,nLanguageId,"\(type)","\(fDiscountPrice)",cAddressType,cLandmark,cBuildingName,cOfficeName,iscredituse,"\(fwalletprice)","\(fCashbackPrice)")
        
        print(param)
        
       let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        AppHelper.showLoadingView()
        self.objCheckoutOrder = HttpWrapper.init()
        self.objCheckoutOrder.delegate = self
        self.objCheckoutOrder.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
    }
    
    
    @objc func placedAppointment() {
           
           let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
           
           var nCustomerId = "0"
                           var deviceid = ""
                                      if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                                          nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                                      }
                           else
                                      {
                                        if isGuest == true
                                        {
                                            nCustomerId = appDelegate.GuestCustomerId
                                        }
                                        else
                                        {
                                           deviceid = "\(appDelegate.DeviceId)"
                                        }
                                    
                           }
           
          // let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
           let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
           
           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale(identifier: "en")
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let dtCartDate = dateFormatter.string(from: self.date)
           print(dtCartDate)
           
           var type = ""
           if nCartType == "1"
           {
              type = "Admin Order"
           }
           else
           {
               type = "Free Order"
           }
           var nLanguageId = ""
                      
                      if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                          nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                      }
           let jsonData = AppHelper.json(from: arrPlaceOrder)

           var strPaymentMethod = ""
           var iscredituse = "0"
           var fwalletprice:Float = 0
           if  self.paymentMethod == "Wallet"
           {
               strPaymentMethod = "ONLINE"
               iscredituse = "1"
               
               if fWalletTotal == fGrandTotal
               {
               fwalletprice = fGrandTotal
                }
               else  if fWalletTotal > fGrandTotal
               {
                     fwalletprice = fGrandTotal
               }
                else
               {
                   fwalletprice = fWalletTotal
              
                }
           }
           else
           {
               iscredituse = "0"
               strPaymentMethod = self.paymentMethod
           }
           
       
           let param:NSMutableString = NSMutableString()
                     
             param.append(String(format:"%@?", kAddBooking))
             param.append(String(format:"nUserId=%@&", "\(nUserId)"))
         param.append(String(format:"cName=%@&", "\(ApName)"))
         param.append(String(format:"cCustomerEmailId=%@&", "\(ApEmail)"))
         param.append(String(format:"cMobileNo=%@&", "\(ApMobile)"))
         param.append(String(format:"nCustomerId=%@&", "\(nCustomerId)"))
        param.append(String(format:"cCustomerDeviceId=%@&", "\(appDelegate.DeviceId)"))
        param.append(String(format:"cAddress=%@&", "\(self.address)"))
        param.append(String(format:"nAddressId=%@&", "\(selectedAddressId)"))
        param.append(String(format:"cBookingTime=%@&", "\(selecedTime)"))
        param.append(String(format:"dtEndDate=%@&", "\(selectedDate)"))
        param.append(String(format:"IsCredit=%@&", "\(iscredituse)"))
         param.append(String(format:"fAmount=%@&", "\(fwalletprice)"))
        
             param.append(String(format:"nLanguageId=%@&", nLanguageId))
             param.append(String(format:"cToken=%@", cToken))
             
             print(param)
                     
                    
           
           print(param)
           
          let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
           
           AppHelper.showLoadingView()
           self.objAppointmentOrder = HttpWrapper.init()
           self.objAppointmentOrder.delegate = self
           self.objAppointmentOrder.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
       }
       
    
    @objc func back() {
        
        if isFromOrders == true
        {
             self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - Custom Method
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getOrderDetails()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getOrderDetails() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            
            let param:NSMutableString = NSMutableString()
            
            param.append(String(format:"%@?", kGetOrderDetails))
            param.append(String(format:"nUserId=%@&", "\(nUserId)"))
            param.append(String(format:"nOrderId=%@&", nOrderId))
            param.append(String(format:"nLanguageId=%@&", nLanguageId))
            param.append(String(format:"cToken=%@", cToken))
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objOrderDetails = HttpWrapper.init()
            self.objOrderDetails.delegate = self
            self.objOrderDetails.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func applyCouponCode(couponCode:String) {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
              var nCustomerId = "0"
                            var deviceid = ""
                                       if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                                           nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                                       }
                            else
                                       {
                                         if isGuest == true
                                         {
                                             nCustomerId = appDelegate.GuestCustomerId
                                         }
                                         else
                                         {
                                            deviceid = "\(appDelegate.DeviceId)"
                                         }
                                     
                            }
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            
            let date = Date()
            
            let todayDate = AppHelper.dateToString(date: date, strFormate: "yyyy-MM-dd")
            
            let param:NSMutableString = NSMutableString()
            
            let jsonData = AppHelper.json(from: arrCouponCode)
            
            print(arrCouponCode)

            param.append(String(format:"%@?", kCouponCode))
            param.append(String(format:"nUserId=%@&", "\(nUserId)"))
            param.append(String(format:"cCouponCode=%@&", couponCode))
            param.append(String(format:"nCustomerId=%@&", "\(nCustomerId)"))
            param.append(String(format:"dtdate=%@&", todayDate))
            param.append(String(format:"cJsonCartData=%@&", jsonData!))
            param.append(String(format:"cDeviceId=%@&", deviceid))
            param.append(String(format:"nCartType=%@&", nCartType))
            param.append(String(format:"nAddressId=%@&", "\(selectedAddressId)"))
            param.append(String(format:"nLanguageId=%@&", nLanguageId))
            param.append(String(format:"cToken=%@", cToken))
             
            print(param)
            
         let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            //
            AppHelper.showLoadingView()
            self.objCouponCode = HttpWrapper.init()
            self.objCouponCode.delegate = self
            self.objCouponCode.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func setShippingAddress()
    {
      
        
        let dicAddress = self.arrShipping.object(at: 0) as! NSDictionary
        if let address = dicAddress.object(forKey: "cName") as? String {
            cName = address
        }
        if let address = dicAddress.object(forKey: "cAddressType") as? String {
            cAddressType = address
        }
        
        if let address = dicAddress.object(forKey: "cLandmark") as? String {
            cLandmark = address
        }

        if let address = dicAddress.object(forKey: "cBuildingName") as? String {
            cBuildingName = address
        }
        
       
        
        if let address = dicAddress.object(forKey: "cOfficeName") as? String {
            cOfficeName = address
        }
        
        
        if let address = dicAddress.object(forKey: "nAreaId") as? NSNumber {
                   
            cArea = "\(address)"
        }
        if let address = dicAddress.object(forKey: "cCityName") as? NSString {
                          
            cGovernorate = "\(address)"
        }
        
        if let address = dicAddress.object(forKey: "cBlock") as? String {
            
            cBlock = address
        }
        if let address = dicAddress.object(forKey: "cStreet") as? String {
                   
            cStreet = address
        }
        if let address = dicAddress.object(forKey: "cAvenue") as? String {
                          
            cAvenue = address
        }
        if let address = dicAddress.object(forKey: "cHouse") as? String {
                          
            cHouse = address
        }
        if let address = dicAddress.object(forKey: "cFloor") as? String {
                   
            cFloor = address
        }
        if let address = dicAddress.object(forKey: "cBuildingNo") as? String {
                          
            cBuildingNo = address
        }
        if let address = dicAddress.object(forKey: "cSpecialInstruction") as? String {
                          
            cSpecialInstruction = address
        }
        if let address = dicAddress.object(forKey: "nMobileNo") as? String {
                   
            cMobileNo = address
        }
        if let address = dicAddress.object(forKey: "cAlterMoNo") as? String {
                          
            cAlterMobileNo = address
        }
        if let price1 = dicAddress.object(forKey: "fDeliveryCharge") as? NSNumber {
        let address = Float(truncating: price1)
                          
            fDeliveryCharge = "\(address)"
        }
    }
    func addNavigationBar(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        
        if isFromOrders == true {
            lblTitle.text = "lbl_my_order_detail_title".setlocalized()
        }
        else {
            lblTitle.text = "checkout_title".setlocalized()
        }
        
       // lblTitle.text = "checkout_title".setlocalized()//appDelegate.setLocalizationstring(string: "lbl_cart")
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
            buttonMenu.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            buttonMenu.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        buttonMenu.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonMenu.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonMenu = UIBarButtonItem.init(customView: buttonMenu)
        self.navigationItem.leftBarButtonItem = barButtonMenu
        
    }
    // MARK: - Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return self.arrCart.count
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFromOrders == true {
            if IsReturnRequest == true
            {
                 return 5
            }
            else
            {
                return 6
            }
           
        }
        else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && isFromOrders == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPlacedIdCell") as! OrderPlacedIdCell
            cell.lblOrderIdTitle.text = "checkout_order_id".setlocalized()
            cell.lblOrderId.text = self.nOrderId
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPlacedAddressCell") as! OrderPlacedAddressCell
            if arrShipping.count > 0
            {
                let dicAddress = self.arrShipping.object(at: 0) as! NSDictionary
                if let address = dicAddress.object(forKey: "cName") as? String {
                     
                     cell.lbltitle.text = address
                 }
                 
                 if let address = dicAddress.object(forKey: "nMobileNo") as? NSString {
                     
                     cell.lblMobile.text = "\(address)"
                 }

                  let city = String(format:"%@ : %@","City", dicAddress.object(forKey: "cCityName") as! String)
                 let area = String(format:"%@ : %@","Area", dicAddress.object(forKey: "cAreaName") as! String)
                 let block = String(format:"%@ : %@","block", dicAddress.object(forKey: "cBlock") as! String)
                  let street = String(format:"%@ : %@","Street", dicAddress.object(forKey: "cStreet") as! String)
                 let BuildingNum = String(format:"%@ : %@","Building No", dicAddress.object(forKey: "cBuildingNo") as! String)
                
                let fulladdress = String(format:"%@ ,%@ ,%@ ,%@ ,%@",city,area,block,street,BuildingNum)
                 cell.lblAddressDesc.text = fulladdress
                           
            }
            else if isAppointment == true
            {
               cell.lbltitle.text = appDelegate.bookingName
                cell.lblMobile.text = appDelegate.BookingNumber
                cell.lblAddressDesc.text = self.address
            }
           
           
            cell.lblAddressTitle.text = "checkout_address".setlocalized()
            
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPlacedPaymentMethodCell") as! OrderPlacedPaymentMethodCell
            cell.lblPaymentCOD.text = self.paymentMethod
            cell.lblPaymentMethodTitle.text = "checkout_payment_method".setlocalized()
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPlacedProductsCell") as! OrderPlacedProductsCell
            
            cell.lblQtyTitle.text = "checkout_quantity".setlocalized()
            cell.lblPriceTitle.text = "checkout_price".setlocalized()
            cell.lblSubTotalTitle.text = "checkout_subtotal".setlocalized()
            
          
           
//            if nCartType == "0"
//           {
//            cell.lblPriceTitle.isHidden = true
//            cell.lblSubTotalTitle.isHidden = true
//            cell.lblPriceData.isHidden = true
//            cell.lblSubtotalData.isHidden = true
//           }
            if isFromOrders == true {
                let productDetails = self.arrCart.object(at: indexPath.row) as! NSDictionary
                if let productName = productDetails.object(forKey: "cProductName") as? String {
                    cell.lblProductName.text = productName
                }
                var qty = 0
                
                if let price1 = productDetails.object(forKey: "fQuantity") as? NSNumber {
                let productQty = Float(truncating: price1)
                    qty = Int(productQty)
                    cell.lblQtyCount.text = "\(qty)"
                }
                
                if let price1 = productDetails.object(forKey: "fProductPrice") as? NSNumber {
                let fPrice = Float(truncating: price1)
                   // fSubTotal = fSubTotal + (fPrice * Float(qty))
                    
                    cell.lblPriceData.text = "\(self.strCurrency) \(String(format: "%.3f", fPrice))"
                    cell.lblSubtotalData.text = "\(self.strCurrency) \(String(format: "%.3f", fPrice * Float(qty)))"
                }
                
                var nUnitType = 0
                               if let stock = productDetails.value(forKey: "nUnitType") as? NSNumber
                                                    {
                                                        nUnitType = Int(stock)
                                                    }
                                                    else if let stock = productDetails.value(forKey: "nUnitType") as? String
                                                    {
                                                        nUnitType = Int(stock)!
                                                    }
                               
                               
                                cell.lblQtyTitle.text = arrunitName[nUnitType]
                
                if let productImgUrl = productDetails.object(forKey: "cProductImage") as? String {
                  cell.imgProduct.cacheImage(urlString: productImgUrl)
                }
                
            }
            else {
                let productDetails = self.arrCart.object(at: indexPath.row) as! NSDictionary
                
                if let stock = productDetails.value(forKey: "nCartType") as? NSNumber
                                     {
                                      cell.nCartType = Int(stock)
                                     }
                                     else if let stock = productDetails.value(forKey: "nCartType") as? String
                                     {
                                         cell.nCartType = Int(stock)!
                                     }
                
                var nUnitType = 0
                if let stock = productDetails.value(forKey: "nUnitType") as? NSNumber
                                     {
                                         nUnitType = Int(stock)
                                     }
                                     else if let stock = productDetails.value(forKey: "nUnitType") as? String
                                     {
                                         nUnitType = Int(stock)!
                                     }
                
                
                 cell.lblQtyTitle.text = arrunitName[nUnitType]
                var qty = 0
                let dicProduct:NSMutableDictionary = NSMutableDictionary()
                let dicCouponCode:NSMutableDictionary = NSMutableDictionary()
                if let price1 = productDetails.object(forKey: "nProductId")  as? NSNumber {
                    let productId = Float(truncating: price1)
                    dicProduct["nProductId"] = "\(Int(productId))"
                    dicCouponCode["nProductId"] = "\(Int(productId))"
                }
                
                if let productName = productDetails.object(forKey: "cName") as? String {
                    cell.lblProductName.text = productName
                }
                
                if let price1 = productDetails.object(forKey: "fQuantity") as? NSNumber {
                let productQty = Float(truncating: price1)
                    qty = Int(productQty)
                    dicProduct["nQuantity"] = productQty
                    dicCouponCode["nQuantity"] = productQty
                    cell.lblQtyCount.text = "\(productQty)"
                }
                
                if let currency = productDetails.object(forKey: "Currency") as? String {
                    strCurrency = currency
                    appDelegate.strCurrency = currency
                     if cell.nCartType == 0
                     {
                        if let price1 = productDetails.object(forKey: "fSamplePrice") as? NSNumber {
                        let fPrice = Float(truncating: price1)
                            if isCouponCodeApply != true {
                               // fGrandTotal = fGrandTotal + (fPrice * Float(qty))
                               // fSubTotal = fGrandTotal
                                print(fGrandTotal)
                            }
                          //  cell.lblPriceData.text = "\(currency) \(String(format: "%.3f", fPrice))"
                          //  cell.lblSubtotalData.text = "\(currency) \(String(format: "%.3f", fPrice * Float(qty)))"
                            dicProduct["fMRP"] = "\(fPrice)"
                            dicCouponCode["fMRP"] = "\(fPrice)"
                        }
                    }
                    else
                     {
                        
                        if let spcialprice1 = productDetails.object(forKey: "fSpecialPrice")  as? NSNumber {
                        
                        if Float(truncating: spcialprice1) > Float(0)
                        {
                             let fPrice = Float(truncating: spcialprice1)
                            dicProduct["fMRP"] = "\(fPrice)"
                            dicCouponCode["fMRP"] = "\(fPrice)"
                            }
                            else
                        {
                            if let price1 = productDetails.object(forKey: "fPrice") as? NSNumber {
                                                  let fPrice = Float(truncating: price1)
                                                      if isCouponCodeApply != true {
                                                         // fGrandTotal = fGrandTotal + (fPrice * Float(qty))
                                                         // fSubTotal = fGrandTotal
                                                          print(fGrandTotal)
                                                      }
                                                    //  cell.lblPriceData.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                                    //  cell.lblSubtotalData.text = "\(currency) \(String(format: "%.3f", fPrice * Float(qty)))"
                                                      dicProduct["fMRP"] = "\(fPrice)"
                                                      dicCouponCode["fMRP"] = "\(fPrice)"
                                                  }
                            }
                        }
                        else
                        {
                            if let price1 = productDetails.object(forKey: "fPrice") as? NSNumber {
                                                  let fPrice = Float(truncating: price1)
                                                      if isCouponCodeApply != true {
                                                         // fGrandTotal = fGrandTotal + (fPrice * Float(qty))
                                                         // fSubTotal = fGrandTotal
                                                          print(fGrandTotal)
                                                      }
                                                    //  cell.lblPriceData.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                                    //  cell.lblSubtotalData.text = "\(currency) \(String(format: "%.3f", fPrice * Float(qty)))"
                                                      dicProduct["fMRP"] = "\(fPrice)"
                                                      dicCouponCode["fMRP"] = "\(fPrice)"
                                                  }
                        }
                      
                    }
                    
                    
                }
                
                
                if let currency = productDetails.object(forKey: "Currency") as? String {
                  
                    if cell.nCartType == 0
                                            {
                                               if let price1 = productDetails.object(forKey: "fSamplePrice")  as? NSNumber {
                                               let fPrice = Float(truncating: price1)
                                                 
                                                   cell.lblPriceData.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                                   cell.lblSubtotalData.text = "\(currency) \(String(format: "%.3f", fPrice * Float(qty)))"
                                               }
                                           }
                    else
                    {
                        if let spcialprice1 = productDetails.object(forKey: "fSpecialPrice")  as? NSNumber {
                        
                        if Float(truncating: spcialprice1) > Float(0)
                        {
                            if let price1 = productDetails.object(forKey: "fPrice")  as? NSNumber {
                            let price = Float(truncating: price1)
                                let spcprice = Float(truncating: spcialprice1)
                              
                                let full = "\(currency) \(String(format: "%.3f", price)) \(currency) \(String(format: "%.3f", spcprice))"
                               // cell.lblPriceData.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                cell.lblSubtotalData.text = "\(currency) \(String(format: "%.3f", spcprice * Float(qty)))"
                                cell.lblPriceData.attributedText = appDelegate.setAttributedPrice(Priceone: "\(currency) \(String(format: "%.3f", price))", pricetwo: "\(currency) \(String(format: "%.3f", spcprice))", Fullstring: full, Font: cell.lblPriceData.font)
                                //cell.lblPrice.text = "\(currency) \(String(format: "%.3f", price))"
                            }
                            
                           
                        }
                        else{
                            if let price1 = productDetails.object(forKey: "fPrice")  as? NSNumber {
                                                         let fPrice = Float(truncating: price1)
                                                           
                                                             cell.lblPriceData.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                                             cell.lblSubtotalData.text = "\(currency) \(String(format: "%.3f", fPrice * Float(qty)))"
                                                         }
                        }
                    }
                  
                 
                  }
                  
                   
                }
                
                if let productImgUrl = productDetails.object(forKey: "cImage") as? String {
                    cell.imgProduct.cacheImage(urlString: productImgUrl)
                }
                
                print(productDetails)
                
                if let nSpecialPrice = productDetails.object(forKey: "nSpecialPrice") as? NSNumber {
                    dicCouponCode["nSpecialPrice"] = nSpecialPrice
                }
                
                if let dtSpecialPriceFrom = productDetails.object(forKey: "dtSpecialPriceFrom") as? String {
                    
                    let dateArr = dtSpecialPriceFrom.components(separatedBy: "T")
                    let gDate = dateArr[0]
                    
                    let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
                    
                    dicCouponCode["dtSpecialPriceFrom"] = "\(AppHelper.dateToString(date: dtDate, strFormate: "yyyy-MM-dd"))"
                }
                
                if let dtSpecialPriceTo = productDetails.object(forKey: "dtSpecialPriceTo") as? String {
                    
                    let dateArr = dtSpecialPriceTo.components(separatedBy: "T")
                    let gDate = dateArr[0]
                    
                    let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
                    
                    dicCouponCode["dtSpecialPriceTo"] = "\(AppHelper.dateToString(date: dtDate, strFormate: "yyyy-MM-dd"))"
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let cdate = Date()
                
                dicProduct["dtCartDate"] = dateFormatter.string(from: cdate)
                dicProduct["nWarrentyDuration"] = "1"
                dicProduct["cDescription"] = "abc"
                dicProduct["cWarrantyType"] = "Monthly"
                 dicProduct["nUnitType"] = nUnitType
                dicProduct["nCartType"] = cell.nCartType
                
                
                if !arrPlaceOrder.contains(dicProduct)
                {
                    self.arrCouponCode.add(dicCouponCode)
                    self.arrPlaceOrder.add(dicProduct)
                }
                
            }
            
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPlacedBillCell") as! OrderPlacedBillCell
            
            cell.lblTotalTitle.text = "checkout_total".setlocalized()
            cell.lblSubtotalTitle.text = "checkout_sub_total".setlocalized()
            cell.lblDiscountTitle.text = "checkout_discount".setlocalized()
            cell.lblDeliveryTitle.text = "checkout_delivery".setlocalized()
             cell.lblCreditTitle.text = "lbl_wallet_creditused_checkoutscreen".setlocalized()
            
            if isFromOrders == true {
                cell.lblDeliveryPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fDeliveryTotal))"
                cell.lblDiscountPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fDiscountPrice))"
                print(fGrandTotal)
                cell.lblSubtotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fSubTotal))"
                cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fGrandTotal))"
                
                cell.viewCredit.isHidden = true
            }
            else {
                
                
                if isAppointment == true
                                   {
                                    cell.viewDelivery.isHidden = true
                }
                if  self.paymentMethod == "Wallet"
                {
                    cell.viewCredit.isHidden = false
                }
                else
                {
                     cell.viewCredit.isHidden = true
                }
               
                
                cell.lblDeliveryPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fDeliveryTotal))"
                if isCouponCodeApply == true {
                    
                    if fDiscountPrice > 0
                    {
                         cell.lblDiscountPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fDiscountPrice))"
                    }
                    else
                    {
                        cell.lblDiscountPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fCashbackPrice))"
                    }
                   
                    cell.lblSubtotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fSubTotal))"
                    cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fGrandTotal))"
                }
                else {
                    cell.lblDiscountPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fDiscountPrice))"
                    cell.lblSubtotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fSubTotal))"
                    cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fGrandTotal))"
                }
                
                
                if  self.paymentMethod == "Wallet"
                {
                    
                    if isAppointment == true
                    {
                         if fWalletTotal > fGrandTotal
                                          {
                                           cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",0.000))"
                                           cell.lblCreditPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fGrandTotal))"
                                           }
                                           else
                                          {
                                           cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fGrandTotal-fWalletTotal))"
                                            cell.lblCreditPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fWalletTotal))"
                                           }
                    }
                    else
                    {
                       if fWalletTotal >= fGrandTotal
                                          {
                                           cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",0.000))"
                                           cell.lblCreditPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fGrandTotal))"
                                           }
                                           else
                                          {
                                           cell.lblTotalPrice.text = "\(strCurrency) \(String(format: "%.3f",fGrandTotal-fWalletTotal))"
                                            cell.lblCreditPrice.text = "\(strCurrency) \(String(format: "%.3f", self.fWalletTotal))"
                                           }
                    }
                    
                  
                    
                }
                else
                {
                    
                }
                
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPlacedPayCell") as! OrderPlacedPayCell
            cell.btnPay.layer.cornerRadius = btnRadius
            cell.btnPay.clipsToBounds = true
            
            cell.viewCouponCode.layer.cornerRadius = 20
            cell.viewCouponCode.layer.borderWidth = 1
            cell.viewCouponCode.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
            cell.viewCouponCode.clipsToBounds = true
            cell.txtCouponCode.placeholder = "checkout_coupon_code_placeholder".setlocalized()
            
            if self.strCoupon != "" {
                cell.txtCouponCode.text = strCoupon
                cell.btnApply.setTitle("checkout_coupon_code_cancel".setlocalized(), for: .normal)
                cell.btnApply.isUserInteractionEnabled = false
            }
            else {
                let applyTap = MyApplyTap(target: self, action: #selector(onClickApply))
                cell.btnApply.setTitle("checkout_coupon_code_apply".setlocalized(), for: .normal)
                applyTap.numberOfTapsRequired = 1
                applyTap.cell = cell
                cell.btnApply.isUserInteractionEnabled = true
                cell.btnApply.addGestureRecognizer(applyTap)
            }
            
          
//            cell.btnPay.setTitle("checkout_coupon_code_pay".setlocalized(), for: .normal)
//            if self.paymentMethod == "ONLINE" {
//
//            }
//            else {
//                cell.btnPay.setTitle("Confirm Order", for: .normal)
//            }
            
            if isFromOrders == true
            {
                let payTap = UITapGestureRecognizer(target: self, action: #selector(ReturnRequest))
                          payTap.numberOfTapsRequired = 1
                          cell.btnPay.isUserInteractionEnabled = true
                          cell.btnPay.addGestureRecognizer(payTap)
                cell.btnPay.setTitle("lbl_btn_ReturnRequest".setlocalized(), for: .normal)
            }
            else
            {
                if isAppointment == true
                {
                    let payTap = UITapGestureRecognizer(target: self, action: #selector(placedAppointment))
                    payTap.numberOfTapsRequired = 1
                    cell.btnPay.isUserInteractionEnabled = true
                    cell.btnPay.addGestureRecognizer(payTap)
                }
                else
                {
                    let payTap = UITapGestureRecognizer(target: self, action: #selector(placedOrder))
                    payTap.numberOfTapsRequired = 1
                    cell.btnPay.isUserInteractionEnabled = true
                    cell.btnPay.addGestureRecognizer(payTap)
                }
                
                if  self.paymentMethod == "Wallet"
                {
                cell.btnPay.setTitle("checkout_coupon_code_pay_Wallet".setlocalized(), for: .normal)
                }
                else
                {
                  cell.btnPay.setTitle("checkout_coupon_code_pay".setlocalized(), for: .normal)
                }
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if isFromOrders == true {
                return 40
            }
            else {
                return 0
            }
        }
        else if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section == 2 {
            return 0
        }
        else if indexPath.section == 3 {
            return 131
        }
        else if indexPath.section == 4 {
            return UITableViewAutomaticDimension
        }
        else  {
            if isFromOrders == true {
                if IsReturnRequest == true
                           {
                                return 0
                           }
                           else
                           {
                               return 115
                           }
            }
            else {
                return 115
            }
        }
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objCheckoutOrder {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                if self.paymentMethod != "COD" {
                    
                    var fwalletprice:Float = 0
                    if  self.paymentMethod == "Wallet"
                           {
                              
                               
                               if fWalletTotal >= fGrandTotal
                               {
                                    let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
                                     self.navigationController?.pushViewController(nextViewController, animated: true)
                                     let totalCartCount = 0
                                     UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
                                     let tabCart = self.tabBarController!.tabBar.items?[3]
                                     
                                     if let id = dicsResponse.object(forKey: "ID") as? String {
                                         nextViewController.orderId = "\(id)"
                                     }
                                     
                                     tabCart?.badgeValue = "\(totalCartCount)"
                                     if #available(iOS 10.0, *) {
                                         tabCart?.badgeColor = .white
                                         tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                                     }
                                     UserDefaults.standard.removeObject(forKey: kCartData)
                               }
                                else
                               {
                                let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPayment") as! CardPayment
                                                        
                                let param:NSMutableString = NSMutableString()
                                param.append(kbasePayment)
                                if let id = dicsResponse.object(forKey: "ID") as? String {
                                    param.appendFormat("?nOrderId=%@&","\(id)")
                                    nextViewController.orderId = "\(id)"
                                }
                                let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
                                nextViewController.fGrandTotal = fGrandTotal - fWalletTotal
                                param.appendFormat("nUserId=%@","\(nUserId)")
                                nextViewController.kentUrl = param  as String
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                                }
                            
                            
                           
                           }
                           else
                           {
                                let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPayment") as! CardPayment
                                                 
                                                 let param:NSMutableString = NSMutableString()
                                                 param.append(kbasePayment)
                                                 
                                                 if let id = dicsResponse.object(forKey: "ID") as? String {
                                                     param.appendFormat("?nOrderId=%@&","\(id)")
                                                     nextViewController.orderId = "\(id)"
                                                 }
                                                 
                                                 
                                                 let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
                                                 nextViewController.fGrandTotal = fGrandTotal
                                                 param.appendFormat("nUserId=%@","\(nUserId)")
                                                 nextViewController.kentUrl = param  as String
                                                 self.navigationController?.pushViewController(nextViewController, animated: true)
                           }
                    
                  
                }
                else {
                    let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    let totalCartCount = 0
                    UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
                    let tabCart = self.tabBarController!.tabBar.items?[3]
                    
                    if let id = dicsResponse.object(forKey: "ID") as? String {
                        nextViewController.orderId = "\(id)"
                    }
                    
                    tabCart?.badgeValue = "\(totalCartCount)"
                    if #available(iOS 10.0, *) {
                        tabCart?.badgeColor = .white
                        tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                    }
                    UserDefaults.standard.removeObject(forKey: kCartData)
                }
            }
            else{
               
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else if wrapper == objAppointmentOrder {
            
                       print(dicsResponse)
                       AppHelper.hideLoadingView()
                       if dicsResponse.value(forKey: "Success") as! String == "1" {
                           
                           if self.paymentMethod != "COD" {
                               
                               var fwalletprice:Float = 0
                            
                            if fGrandTotal == 00
                            {
                                let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
                                nextViewController.isAppointment = isAppointment
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                 let totalCartCount = 0
                                 UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
                                 let tabCart = self.tabBarController!.tabBar.items?[3]
                                 
                                 if let id = dicsResponse.object(forKey: "ID") as? String {
                                     nextViewController.orderId = "\(id)"
                                 }
                                 
                                 tabCart?.badgeValue = "\(totalCartCount)"
                                 if #available(iOS 10.0, *) {
                                     tabCart?.badgeColor = .white
                                     tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                                 }
                                 UserDefaults.standard.removeObject(forKey: kCartData)
                            }
                               else if  self.paymentMethod == "Wallet"
                                      {
                                         
                                          
                                          if fWalletTotal >= fGrandTotal
                                          {
                                               let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
                                               nextViewController.isAppointment = isAppointment
                                            self.navigationController?.pushViewController(nextViewController, animated: true)
                                                let totalCartCount = 0
                                                UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
                                                let tabCart = self.tabBarController!.tabBar.items?[3]
                                                
                                                if let id = dicsResponse.object(forKey: "ID") as? String {
                                                    nextViewController.orderId = "\(id)"
                                                }
                                                
                                                tabCart?.badgeValue = "\(totalCartCount)"
                                                if #available(iOS 10.0, *) {
                                                    tabCart?.badgeColor = .white
                                                    tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                                                }
                                                UserDefaults.standard.removeObject(forKey: kCartData)
                                          }
                                           else
                                          {
                                           let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPayment") as! CardPayment
                                             nextViewController.isAppointment = isAppointment
                                           let param:NSMutableString = NSMutableString()
                                           param.append(kbasePayment)
                                           if let id = dicsResponse.object(forKey: "ID") as? String {
                                               param.appendFormat("?nOrderId=%@&","\(id)")
                                               nextViewController.orderId = "\(id)"
                                           }
                                           let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
                                           nextViewController.fGrandTotal = fGrandTotal - fWalletTotal
                                           param.appendFormat("nUserId=%@","\(nUserId)")
                                           nextViewController.kentUrl = param  as String
                                       self.navigationController?.pushViewController(nextViewController, animated: true)
                                           }
                                       
                                       
                                      
                                      }
                                      else
                                      {
                                           let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPayment") as! CardPayment
                                                nextViewController.isAppointment = isAppointment
                                                            let param:NSMutableString = NSMutableString()
                                                            param.append(kbasePayment)
                                                            
                                                            if let id = dicsResponse.object(forKey: "ID") as? String {
                                                                param.appendFormat("?nOrderId=%@&","\(id)")
                                                                nextViewController.orderId = "\(id)"
                                                            }
                                                            
                                                            
                                                            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
                                                            nextViewController.fGrandTotal = fGrandTotal
                                                            param.appendFormat("nUserId=%@","\(nUserId)")
                                                            nextViewController.kentUrl = param  as String
                                                            self.navigationController?.pushViewController(nextViewController, animated: true)
                                      }
                               
                             
                           }
                           else {
                               let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
                              nextViewController.isAppointment = isAppointment
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                               let totalCartCount = 0
                               UserDefaults.standard.set("\(totalCartCount)", forKey: kGlobalCartCount)
                               let tabCart = self.tabBarController!.tabBar.items?[3]
                               
                               if let id = dicsResponse.object(forKey: "ID") as? String {
                                   nextViewController.orderId = "\(id)"
                               }
                               
                               tabCart?.badgeValue = "\(totalCartCount)"
                               if #available(iOS 10.0, *) {
                                   tabCart?.badgeColor = .white
                                   tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
                               }
                               UserDefaults.standard.removeObject(forKey: kCartData)
                           }
                       }
            else{
               
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
            else if wrapper == objGetCartlist {
                       AppHelper.hideLoadingView()
                       if dicsResponse.value(forKey: "Success") as! String == "1" {
                           if let arrProduct:NSArray = dicsResponse.value(forKey: "Result") as? NSArray {
                            self.arrCartMain = arrProduct.mutableCopy() as! NSMutableArray
                            if let item = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "Items") as? NSArray 
                                {
                                    self.arrCart = item.mutableCopy() as! NSMutableArray
                                }
                            
                            if let item = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "cShippingAddress") as? NSArray
                                                           {
                                self.arrShipping = item.mutableCopy() as! NSMutableArray
                                                            setShippingAddress()
                                                           }
                            
                            if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fSubTotal") as? Float
                           {
                                fSubTotal = st
                           }
                            else if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fSubTotal") as? NSNumber
                            {
                                fSubTotal = Float(truncating: st)
                            }
                            
                            if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fGrandTotal") as? Float
                            {
                                fGrandTotal = st
                            }
                            else  if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fGrandTotal") as? NSNumber
                            {
                                fGrandTotal = Float(truncating: st)
                            }
                            
                            if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fWalletAmount") as? Float
                            {
                                fWalletTotal = st
                            }
                            else  if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fWalletAmount") as? NSNumber
                            {
                                fWalletTotal = Float(truncating: st)
                            }
                            viewWallet.isUserInteractionEnabled = true
                            if fWalletTotal >= fGrandTotal
                            {
                                self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                                       self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                                       
                                        self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                                               // self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
                                       self.paymentMethod = "Wallet"
                                       CalculateData()
                            }
                            else if fWalletTotal > 0
                            {
                                                              self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                                                                 self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                                                              
                                                               self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                                                               //  self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
                                                                 self.paymentMethod = "ONLINE"
                                                              CalculateData()
                            }
                            else
                            {
                                self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                                   self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                                
                                 self.btnCheckWallet.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                                 //  self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
                                   self.paymentMethod = "ONLINE"
                                CalculateData()
                                viewWallet.alpha = 0.5
                                viewWallet.isUserInteractionEnabled = false
                            }
                            let valuestring = "lbl_wallet_totalbalance_checkoutscreen".setlocalized()
                            lblWalletBalance.text = "\(valuestring):\(appDelegate.strCurrency) \(String(format: "%.3f", fWalletTotal))"
                            
                            if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fShippingCharge") as? Float
                         {
                              fDeliveryTotal = st
                         }
                            else if let st = (arrProduct.object(at: 0) as! NSDictionary).value(forKey: "fShippingCharge") as? NSNumber
                            {
                                 fDeliveryTotal = Float(truncating: st)
                            }
                            
//                            if nCartType == "0"
//                            {
//                                fSubTotal = 0
//                                fGrandTotal = fDeliveryTotal
//                            }
                             
                               tblCheckoutDetails.reloadData()
                             
                           }
                       }
                       else
                       {
                          
                          
                       }
                   }
        else if wrapper == objOrderDetails {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.dicOrderDetails = (dicsResponse.object(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                if let strAddress = self.dicOrderDetails.object(forKey: "cAddress") as? String {
                    self.address = strAddress
                }
                
                if let Images:NSArray = self.dicOrderDetails.object(forKey: "Images") as? NSArray {
                    arrImage = Images
                }
                
                if arrImage.count > 0
                {
                     tblCheckoutDetails.tableFooterView = viewFooter
                }
                CollectionImages.reloadData()
                if let methodPayment = self.dicOrderDetails.object(forKey: "cPaymentTerms") as? String {
                    self.paymentMethod = methodPayment
                }
                if let methodPayment = self.dicOrderDetails.object(forKey: "cCurrencySymbol") as? String {
                    self.strCurrency = methodPayment
                }
                if let products = self.dicOrderDetails.object(forKey: "Item") as? NSArray {
                    self.arrCart = products.object(at: 0) as! NSArray
                }
                if let products = self.dicOrderDetails.object(forKey: "cReturnRequestStatus") as? NSString {
                    if products.length > 0
                    {
                        self.IsReturnRequest = true
                    }
                    else
                    {
                        self.IsReturnRequest = false
                    }
                    
                }
                
                
                if let item = self.dicOrderDetails.value(forKey: "cShippingAddress") as? NSArray
                                                                          {
                                               self.arrShipping = item.mutableCopy() as! NSMutableArray
                                                                           setShippingAddress()
                                                                          }
                
                if let price1 = self.dicOrderDetails.object(forKey: "fTotalPrice") as? NSNumber {
                let fTotalPrice = Float(truncating: price1)
                    self.fGrandTotal = fTotalPrice
                }
                
                if let fTotalPrice = self.dicOrderDetails.object(forKey: "fDeliveryCharge") as? Float
                {
                    self.fDeliveryTotal = fTotalPrice
                }
                if let st = self.dicOrderDetails.value(forKey: "fSubTotal") as? Float
                                          {
                                               fSubTotal = st
                                          }
                if let fTotalPrice = self.dicOrderDetails.object(forKey: "fCouponDiscount") as? Float
                {
                    self.fDiscountPrice = fTotalPrice
                }
              
                
                self.tblCheckoutDetails.reloadData()
                
            }
        }
        else if wrapper == objCouponCode {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.isCouponCodeApply = true
                let dicResult = (dicsResponse.object(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                
                if let Amount = dicResult.object(forKey: "fGrandTotal") as? String {
                    fGrandTotal = NSString(string: Amount).floatValue //Float(truncating: )
                }
                else if let Amount = dicResult.object(forKey: "fGrandTotal") as? NSNumber {
                    fGrandTotal = Float(truncating: Amount) //Float(truncating: )
                }
                
                if let IsFixAmount = dicResult.object(forKey: "IsFixAmount") as? Bool {
                    
                    if IsFixAmount == true
                    {
                        if let FixAmount = dicResult.object(forKey: "FixAmount") as? String {
                                           fDiscountPrice = NSString(string: FixAmount).floatValue // Float(truncating: FixAmount)
                                       }
                                       else  if let FixAmount = dicResult.object(forKey: "FixAmount") as? NSNumber
                                       {
                                           fDiscountPrice = Float(truncating: FixAmount) // Float(truncating: FixAmount)
                                       }
                    }
                    else
                    {
                        if let FixAmount = dicResult.object(forKey: "PercentageAmount") as? String {
                                           fDiscountPrice = NSString(string: FixAmount).floatValue // Float(truncating: FixAmount)
                                       }
                                       else  if let FixAmount = dicResult.object(forKey: "PercentageAmount") as? NSNumber
                                       {
                                           fDiscountPrice = Float(truncating: FixAmount) // Float(truncating: FixAmount)
                                       }
                    }
                }
                
                
               
                
                if let FixAmount = dicResult.object(forKey: "CashBackAmount") as? String {
                    fCashbackPrice = NSString(string: FixAmount).floatValue // Float(truncating: FixAmount)
                }
                else  if let FixAmount = dicResult.object(forKey: "CashBackAmount") as? NSNumber
                {
                    fCashbackPrice = Float(truncating: FixAmount) // Float(truncating: FixAmount)
                }
                
               
                
                if let st = dicResult.value(forKey: "fSubTotal") as? String
                {
                    fSubTotal = NSString(string: st).floatValue
                }
                else if let st = dicResult.value(forKey: "fSubTotal") as? NSNumber
                {
                    fSubTotal = Float(truncating: st)
                }
                                           
                                          
                                           
                if let st = dicResult.value(forKey: "fShippingCharge") as? String
                {
                    fDeliveryTotal = NSString(string: st).floatValue
                }
                else if let st = dicResult.value(forKey: "fShippingCharge") as? NSNumber
                {
                    fDeliveryTotal = Float(truncating: st)
                }
                
                if self.strCoupon != "" {
                             txtCouponCode.text = strCoupon
                             btnApply.setTitle("checkout_coupon_code_cancel".setlocalized(), for: .normal)
                            // btnApply.isUserInteractionEnabled = false
                         }
                         else {
                            
                         }
                
                self.arrCouponCode.removeAllObjects()
                self.arrPlaceOrder.removeAllObjects()
                
                self.tblCheckoutDetails.reloadData()
                AppHelper.showAlert("App_name".setlocalized(), message: "lbl_masage_coupan_code_apply".setlocalized())
            }
            else {
              //  couponCell.txtCouponCode.text = ""
                AppHelper.showAlert("App_name".setlocalized(), message: "checkout_coupon_code_Fail".setlocalized())
            }
        }
        else if wrapper == objReturnRequest {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                AppHelper.showAlert("App_name".setlocalized(), message: "lbl_Return_Requst_success_msg".setlocalized())
                
               getOrderDetails()
            }
            else {
              //  couponCell.txtCouponCode.text = ""
                AppHelper.showAlert("App_name".setlocalized(), message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        
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

extension OrderCheckout:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderDetailImage_Cell", for: indexPath) as! orderDetailImage_Cell
        if let img = (arrImage.object(at: indexPath.row) as! NSDictionary).value(forKey: "Image") as? String
        {
            cell.imgProduct.cacheImage(urlString: img)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell: orderDetailImage_Cell = self.CollectionImages.cellForItem(at: indexPath) as! orderDetailImage_Cell
        let imageInfo   = GSImageInfo(image: cell.imgProduct.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: cell.imgProduct)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView,
                              layout collectionViewLayout: UICollectionViewLayout,
                              sizeForItemAt indexPath: IndexPath) -> CGSize {
              return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
              
                
          }
    
}
class MyApplyTap: UITapGestureRecognizer {
    var cell = OrderPlacedPayCell()
}
