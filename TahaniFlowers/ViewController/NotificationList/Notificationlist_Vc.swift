//
//  Notificationlist_Vc.swift
//  HeyFlyer
//
//  Created by baps on 30/08/1940 Saka.
//  Copyright © 1940 nikunj. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Notificationlist_Vc: UIViewController ,UITableViewDataSource , UITableViewDelegate,HttpWrapperDelegate{
    
    var arrImageType = ["flight","Meeting-request","Meeting-Suggestions","user","discount","Weather"]
    var arrNotificaitonlist:NSMutableArray = NSMutableArray()
    var isread:Bool = false
    @IBOutlet weak var tblMain: UITableView!
    var objGetnotificationlist = HttpWrapper()
    var objNotificationView = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var isfromprofile = false
    var nPageIdNumber = 0
    var DataDic:NSDictionary = NSDictionary()
    @IBOutlet var viewNoDataFound: UIView!
       @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblNODataDetail: UILabel!
      @IBOutlet weak var btnBackToShop: UIButtonX!
    override func viewDidLoad() {
        super.viewDidLoad()
        GetAllNotification()
        addNavigationBar()
        tblMain.tableFooterView = UIView()
      
        self.lblNoDataFound.text = "lbl_notificationlist_nodata_title".setlocalized()
        self.lblNODataDetail.text = "lbl_notificationlist_nodata_detail".setlocalized()
        self.btnBackToShop.setTitle("placed_order_go_back".setlocalized(), for: .normal)
        self.btnBackToShop.backgroundColor = btnBackgroundColor
        self.btnBackToShop.setTitleColor(btnTitleColor, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       addNavigationBar()
        GetAllNotification()
    }
    
     func addNavigationBar(){
            self.navigationController?.isNavigationBarHidden = false
            let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
            lbNavTitle.textAlignment = .center
            lbNavTitle.text = "lbl_NotificationList_Title".setlocalized()
            lbNavTitle.textColor = UIColor.black
            tblMain.backgroundColor  = navigationbarColor
            lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
            self.navigationItem.titleView = lbNavTitle
            self.navigationController?.navigationBar.isTranslucent = false
             navigationController?.navigationBar.barTintColor = navigationbarColor
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
            viewNoDataFound.backgroundColor  = navigationbarColor
            self.view.backgroundColor  = navigationbarColor
           //  viewNoDataFound.backgroundColor  = navigationbarColor
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
        
    @objc func BackClick(){
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = true
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - @objc Actions
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
           appDelegate.SetTabBarItem(0)
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
   // MARK: - Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotificaitonlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationList_Cell", for: indexPath) as! NotificationList_Cell
        let dic = (arrNotificaitonlist.object(at: indexPath.row) as? NSDictionary)

        if let StrTemp = dic?.object(forKey: "IsSeen") as? NSNumber {
            if StrTemp == 0
            {
                cell.contentView.backgroundColor = UIColor.init(hexString: "ffeeec")
            }
            else
            {
                cell.contentView.backgroundColor = UIColor.white
            }

        }

        if let StrTemp = dic?.object(forKey: "cTitle") as? String {

            cell.lblTitle.text = StrTemp

        }

        if let StrTemp = dic?.object(forKey: "cContent") as? String {

            cell.lblDetails.text = StrTemp

        }
        
        if let StrTemp = dic?.object(forKey: "cImage") as? String {

             cell.imgUser.sd_setImage(with: URL(string:StrTemp), placeholderImage: UIImage(named: "photo"))

        }
        

//        if let type = dic?.object(forKey: "nNotificationType") as? String {
//
//            if type == "2" || type == "4"
//            {
//                if let StrTemp = (dic?.object(forKey: "cInfoContent") as? NSDictionary)?.value(forKey: "profileimage") as? String {
//
//                     cell.imgUser.sd_setImage(with: URL(string:StrTemp), placeholderImage: UIImage(named: "photo"))
//
//                }
//                else
//                {
//                    let index = Int(type)
//                    cell.imgUser.image = UIImage.init(named: arrImageType[index!-1])
//                }
//
//            }
//            else
//            {
//                let index = Int(type)
//                cell.imgUser.image = UIImage.init(named: arrImageType[index!-1])
//            }
//
//
//
//        }
        if let StrTemp = dic?.object(forKey: "dtCreatedDate") as? String {


            if(StrTemp != "0000-00-00"){

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
               // let Fulldate = StrTemp+" "+strTime
                let Fromdate = dateFormatter.date(from: StrTemp )!
                let date = StrTemp.split(separator: "T")
                if Calendar.current.isDateInToday(Fromdate)
                {

                    cell.lblDate.text = appDelegate.SetTimeFormat(String(date[1]))
                }
                else
                {
                    cell.lblDate.text = appDelegate.SetDateFormat(String(date[0]))
                }

            }
            else{

            }


        }
        //cell.contentView.backgroundColor = UIColor.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
 
      let dic = arrNotificaitonlist.object(at: indexPath.row) as? NSDictionary
        DataDic = dic!
        if let type = dic?.object(forKey: "ndtlNotificationId") as? NSNumber {
            
            if let no = dic?.object(forKey: "nPageIdNumber") as? NSNumber {
                       
                nPageIdNumber = Int(no)
                       view_notification(nNotificationID: "\(type)", Data: dic!)
                   }
        }
 

    }
    
    func view_notification(nNotificationID:String , Data:NSDictionary){
        
        

        if net.isReachable == false {
        let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        else {
        let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
        // let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
        let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
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

        let param:NSMutableString = NSMutableString()

        param.append(String(format:"%@?", kUpdateNotificationIsSeen))
        param.append(String(format:"nUserId=%@&", "\(nUserId)"))
        param.append(String(format:"ndtlNotificationId=%@&", nNotificationID))
      //  param.append(String(format:"nLanguageId=%@&", nLanguageId))
        param.append(String(format:"cToken=%@", cToken))

        print(param)

        let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        AppHelper.showLoadingView()
        self.objNotificationView = HttpWrapper.init()
        self.objNotificationView.delegate = self
        self.objNotificationView.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }

    }
    
    //MARK:- journey_listbyid_second
   
    func GetAllNotification(){
        
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
           // let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
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
            
            let param:NSMutableString = NSMutableString()
            
            param.append(String(format:"%@?", kSelectAllNotification))
            param.append(String(format:"nUserId=%@&", "\(nUserId)"))
            param.append(String(format:"nCustomerId=%@&", nCustomerId))
            param.append(String(format:"nLanguageId=%@&", nLanguageId))
            param.append(String(format:"cToken=%@", cToken))
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objGetnotificationlist = HttpWrapper.init()
            self.objGetnotificationlist.delegate = self
            self.objGetnotificationlist.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }

    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objGetnotificationlist {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let products = dicsResponse.value(forKey: "result") as? NSArray {
                 self.arrNotificaitonlist = products.mutableCopy() as! NSMutableArray
                 self.tblMain.reloadData()
                 }
                tblMain.isHidden = false
                  self.viewNoDataFound.isHidden = true
            }
            else{
                
                self.viewNoDataFound.isHidden = false
                self.viewNoDataFound.frame.size.width = self.view.frame.size.width
                self.viewNoDataFound.frame.size.height = self.view.frame.size.height
                self.view.addSubview(self.viewNoDataFound)
                tblMain.isHidden = true
              //  viewNoDataFound.isHidden = false
                //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else  if wrapper == objNotificationView {
                   print(dicsResponse)
                   AppHelper.hideLoadingView()
                   if dicsResponse.value(forKey: "Success") as! String == "1" {
                    
                    if nPageIdNumber == 1
                    {
                        let RootObj = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                                                             
                       if let id = DataDic.object(forKey: "nTypeId") as? String
                       {
                           RootObj.nOrderId = id
                       }
                       else if let id = DataDic.object(forKey: "nTypeId") as? NSNumber
                       {
                           RootObj.nOrderId = "\(id)"
                       }
                       RootObj.isFromOrders = true
                        self.navigationController?.pushViewController(RootObj, animated: true)
                    }
                    else if nPageIdNumber == 2
                    {
                        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                        
                        if let id = DataDic.object(forKey: "nTypeId") as? String
                                              {
                                                  nextViewController.nCategoryId = id
                                              }
                                              else if let id = DataDic.object(forKey: "nTypeId") as? NSNumber
                                              {
                                                  nextViewController.nCategoryId = "\(id)"
                                              }
                        
                       
                        nextViewController.IsSubCategory = true
                        if let id = DataDic.object(forKey: "cCategoryName") as? String
                                                                                                                  {
                                                                                                                      nextViewController.cCategoryName = id
                                                                                                                  }
                       // nextViewController.cCategoryName = categoryName
                        nextViewController.api = ""
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                    else if nPageIdNumber == 3
                    {
                        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
                        
                        if let id = DataDic.object(forKey: "nTypeId") as? String
                                                                    {
                                                                        nextViewController.productId = id
                                                                    }
                                                                    else if let id = DataDic.object(forKey: "nTypeId") as? NSNumber
                                                                    {
                                                                        nextViewController.productId = "\(id)"
                                                                    }
                                              
                        if let id = DataDic.object(forKey: "cProductName") as? String
                                                                                           {
                                                                                               nextViewController.productName = id
                                                                                           }
//                        nextViewController.productId = "\(id)"
//                        nextViewController.productName = productName
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                    GetAllNotification()
                        self.tblMain.reloadData()
                        
                   }
                   else{
                       
                     //  viewNoDataFound.isHidden = false
                       //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UILabel {
    
    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
