//
//  MyAppointmentListVC.swift
//  TahaniFlowers
//
//  Created by baps on 25/09/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

 func shadowOnviewWithcornerRadius(YourView:UIView)
{
    
    
        YourView.layer.shadowColor = UIColor.lightGray.cgColor;
        YourView.layer.shadowOpacity = 0.5;
        YourView.layer.shadowRadius  = 5;
        YourView.layer.shadowOffset  = CGSize(width :0, height :0)
        YourView.layer.masksToBounds = false;
        YourView.layer.cornerRadius  =  5.0;
       // YourView.layer.borderWidth   = 0.5;
        YourView.backgroundColor     = UIColor.white;
}

extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
      //  backgroundColor = UIColor.white
        let backgroundCGColor = backgroundColor?.cgColor
       
        layer.backgroundColor =  backgroundCGColor
        
        
    }
}


class MyAppointmentListVC: UIViewController ,UITableViewDataSource , UITableViewDelegate,HttpWrapperDelegate{

    @IBOutlet var viewNoDataFound: UIView!
       @IBOutlet weak var lblNoDataFound: UILabel!
         @IBOutlet weak var lblNODataDetail: UILabel!
         @IBOutlet weak var imgNoData: UIImageView!
     var isfromprofile = false
     var arrWalletList:NSArray = NSArray()
    var objNotificationView = HttpWrapper()
     var objDeleteCart = HttpWrapper()
      var userDefaults = UserDefaults.standard
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var objOrders = HttpWrapper()
     var arrAppointmentlist:NSMutableArray = NSMutableArray()
    @IBOutlet weak var tblMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        tblMain.delegate = self
        tblMain.dataSource = self
        let nib = UINib(nibName: "MyAppointmentTable_Cell", bundle: nil)
        tblMain.register(nib, forCellReuseIdentifier: "MyAppointmentTable_Cell")
         addNavigationBar()
        getAppointment()
     
                      self.lblNoDataFound.text = "lbl_Booking_empty_title".setlocalized()
                      self.lblNODataDetail.text = "lbl_Booking_empty_Detail".setlocalized()
              
               
               if let url = "img_Booking_emptyimage".setlocalized() as? String {
                   imgNoData.cacheImage(urlString: url)
               }
               
            //    self.view.addSubview(self.viewNoDataFound)
               viewNoDataFound.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func addNavigationBar(){
           self.navigationController?.isNavigationBarHidden = false
           let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
           lbNavTitle.textAlignment = .center
        lbNavTitle.text = "menu_my_Booking".setlocalized()
           lbNavTitle.textColor = UIColor.black
        //   lblTitle.text = "step_one_title".setlocalized()//appDelegate.setLocalizationstring(string: "lbl_cart")
           lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
           self.navigationItem.titleView = lbNavTitle
           self.navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = navigationbarColor
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          
           self.view.backgroundColor  = navigationbarColor
           tblMain.backgroundColor  = navigationbarColor
          // collectionDateTime.backgroundColor  = navigationbarColor
        viewNoDataFound.backgroundColor  = navigationbarColor
           
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
    
    func DeleteAppointment(nCartId:String) {
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
                      
                      var url = URLComponents(string: kDeleteBooking)!

                      url.queryItems = [
                          URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                          URLQueryItem(name: "nAppointmentId", value: nCartId),
                          URLQueryItem(name: "nLanguageId", value: "\(nLanguageId)"),
                          URLQueryItem(name: "cToken", value: "\(cToken)")
                      ]
                      
                      AppHelper.showLoadingView()
                      self.objDeleteCart = HttpWrapper.init()
                      self.objDeleteCart.delegate = self
                      self.objDeleteCart.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
                  }
              }
    
    func getAppointment() {
               
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
                            deviceid = "\(appDelegate.DeviceId)"
                   }
                   let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
                  var nLanguageId = ""
                             
                             if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                                 nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                             }
                   let param:NSMutableString = NSMutableString()
                   
                   param.append(String(format:"%@?", kGetBookingDetails))
                   param.append(String(format:"nUserId=%@&", "\(nUserId)"))
                   param.append(String(format:"nCustomerId=%@&", "\(nCustomerId)"))
                  param.append(String(format:"cCustomerDeviceId=%@&", "\(deviceid)"))
                   param.append(String(format:"nLanguageId=%@&", "\(nLanguageId)"))
                   param.append(String(format:"cToken=%@", cToken))
                    let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                   
       //            param = String(format: "%@?nUserId=%@&nCustomerId=%@&cToken=%@", kGetOrders,"\(nUserId)","\(nCustomerId)","C14PwvwO4jjejXPcphTF")
                   
                   AppHelper.showLoadingView()
                   self.objOrders = HttpWrapper.init()
                   self.objOrders.delegate = self
                   self.objOrders.requestWithparamdictParamPostMethodwithHeaderGet(url: NSMutableString(string: updatedUrl!) as String, headers: nil)
               }
           }
    
      // MARK: - HttpWrapper Delegate
        
        func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
            if wrapper == objOrders {
                print(dicsResponse)
                AppHelper.hideLoadingView()
                if dicsResponse.value(forKey: "Success") as! String == "1" {
                    self.arrWalletList = dicsResponse.value(forKey: "Result") as! NSArray
                    self.tblMain.reloadData()
                 
                 
                 if arrWalletList.count > 0
                 {
                    // tblMain.tableHeaderView = viewHeader
                     viewNoDataFound.isHidden = true
                 }
                 else
                 {
                     tblMain.tableHeaderView = nil
                     viewNoDataFound.isHidden = false
                 }
                 
                // viewNoDataFound.isHidden = false
                }
                else{
                    //tblOrders.tableFooterView = viewNoDataFound
                    //viewNoDataFound.isHidden = true
                    self.arrWalletList = NSArray()
                     self.tblMain.reloadData()
                 if arrWalletList.count > 0
                 {
                    
                     viewNoDataFound.isHidden = true
                 }
                 else
                 {
                    
                     viewNoDataFound.isHidden = false
                 }
                   // viewNoDataFound.isHidden = false
                    //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
                }
            }
           else if wrapper == objDeleteCart {
                          AppHelper.hideLoadingView()
                          if dicsResponse.value(forKey: "Success") as! String == "1" {
                           getAppointment()
                           appDelegate.getCount()
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
    

    
     // MARK: - Tableview Methods
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrWalletList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTable_Cell", for: indexPath) as! MyAppointmentTable_Cell
          
            
            let deleteTap = MyAppointmentUpdateGesture(target: self, action: #selector(onClickDelete))
                       deleteTap.numberOfTapsRequired = 1
                       deleteTap.cell = cell
                       deleteTap.indexId = indexPath.row
                       cell.btnOption.isUserInteractionEnabled = true
                       cell.btnOption.addGestureRecognizer(deleteTap)
            
            if let strDate = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "dtEndDate") as? String {
                       
                       let dateArr = strDate.components(separatedBy: "T")
                       let gDate = dateArr[0]
                       
                       let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
                       cell.lblDate.text = "\(AppHelper.dateToString(date: dtDate, strFormate: "dd"))"
                   }
             
            if let strDate = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "dtEndDate") as? String {
                                  
                                  let dateArr = strDate.components(separatedBy: "T")
                                  let gDate = dateArr[0]
                                  
                                  let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
                                  cell.lblMonth.text = "\(AppHelper.dateToString(date: dtDate, strFormate: "MMM"))"
                              }
            
            
            if let strDate = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "dtEndDate") as? String {

                                  let dateArr = strDate.components(separatedBy: "T")
                                  let gDate = dateArr[0]

                                  let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
                                  cell.lblDay.text = "\(AppHelper.dateToString(date: dtDate, strFormate: "EE"))"
                              }
            
                    if let value = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "cCustomerName") as? String {
                       cell.lblName.text = value
                   }
                   
            
            if let value = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "cStatus") as? String {
                cell.lblTypeValue.text = value
            }
            
            if let value = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "cOrderBookTime") as? String {
                           cell.lblTime.text = value
                       }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
     
        

        }
        
    
    // MARK: - @objc Actions
       
       @objc func onClickDelete(sender:MyAppointmentUpdateGesture) {
           
           
           let cartAlert = UIAlertController(title: "lbl_home_title".setlocalized(), message: "lbl_Booking_delete_message".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
           
           cartAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
               let index = sender.indexId
               let productDetails = self.arrWalletList.object(at: index) as! NSDictionary
               
               if let productQty = productDetails.object(forKey: "nAppointmentId") as? NSNumber {
                   self.DeleteAppointment(nCartId: "\(productQty)")
               }
               
              
               
           }))
           
           cartAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
               print("Handle Cancel Logic here")
           }))
           
           present(cartAlert, animated: true, completion: nil)
       }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
