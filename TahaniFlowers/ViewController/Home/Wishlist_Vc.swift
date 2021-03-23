//
//  Wishlist_Vc.swift
//  TahaniFlowers
//
//  Created by baps on 05/05/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Wishlist_Vc: UIViewController ,UITableViewDelegate,UITableViewDataSource ,HttpWrapperDelegate{

    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    var isfromprofile = false
     @IBOutlet weak var imgNoData: UIImageView!
    var strCurrency = ""
    var objgetwishlist = HttpWrapper()
    var objAddWishlist = HttpWrapper()
    var userDefaults = UserDefaults.standard
    var arrwishlist:NSArray = NSArray()
     var isFromTab = false
      @IBOutlet var viewNoDataFound: UIView!
          @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
         @IBOutlet weak var btnBackToShop: UIButtonX!
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tblview.delegate = self
        tblview.dataSource = self
        tblview.tableFooterView = UIView()
        
       
                 self.btnBackToShop.setTitle("placed_order_go_back".setlocalized(), for: .normal)
                 self.lblNoDataFound.text = "lbl_wishlist_nodata_title".setlocalized()
             self.lblNODataDetail.text = "lbl_wishlist_nodata_detail".setlocalized()
        // @IBOutlet weak var imgNoData: UIImageView!
        if let url = "lbl_NoData_wishlist".setlocalized() as? String {
           imgNoData.cacheImage(urlString: url)
        }
        addNavigationBar()
        getwishList()
        // Do any additional setup after loading the view.
    }
    // MARK: - @objc Actions
    override func viewWillAppear(_ animated: Bool) {
           self.addNavigationBar()
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
    // MARK: - Custom Method
        
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
           // lbNavTitle.text = "write_review_title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        lblTitle.text = "Wishlist"
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
        if isFromTab != true
        {
             self.navigationItem.leftBarButtonItem = barButtonBack
        }
        else
        {
             self.navigationItem.leftBarButtonItem = nil
        }
            
//            let buttonSearch = UIButton.init(type: .custom)
//            buttonSearch.setImage(UIImage.init(named: "ic_search"), for: UIControlState.normal)
//            buttonSearch.addTarget(self, action:#selector(addSarchBar), for: UIControlEvents.touchUpInside)
//            buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 20, height: 20)
//            
//            let buttonLanguage = UIButton.init(type: .custom)
//            buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
//            buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
//            buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
//            
//            let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
//            let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
    //        self.navigationItem.rightBarButtonItems = [barButtonLanguage,barButtonSearch]
            
         
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func AddWishlist(iswish:String,nProductId:String) {
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
                  
                  var url = URLComponents(string: kInsertData)!

                  url.queryItems = [
                      URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                      URLQueryItem(name: "nLanguageId", value: nLanguageId),
                      URLQueryItem(name: "nProductId", value: nProductId),
                      URLQueryItem(name: "cToken", value: "\(cToken)"),
                      URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)"),
                      URLQueryItem(name: "cWishList", value: "\(iswish)")
                     
                  ]
                  
                  AppHelper.showLoadingView()
                  self.objAddWishlist = HttpWrapper.init()
                  self.objAddWishlist.delegate = self
                  self.objAddWishlist.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
              }
          }
    func getwishList() {
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
                
                var url = URLComponents(string: kSelectAllWishlistProduct)!

                url.queryItems = [
                    URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                    URLQueryItem(name: "nLanguageId", value: nLanguageId),
                   URLQueryItem(name: "cDeviceId", value: deviceid),
                    URLQueryItem(name: "cToken", value: "\(cToken)"),
                    URLQueryItem(name: "nCustomerId", value: "\(nCustomerId)")
                ]
                
                AppHelper.showLoadingView()
                self.objgetwishlist = HttpWrapper.init()
                self.objgetwishlist.delegate = self
                self.objgetwishlist.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
            }
        }
    
    // MARK: - @objc Actions
       @IBAction func onClickBackToShop(_ sender: UIButtonX) {
              appDelegate.SetTabBarItem(0)
          }
       @objc func onClickDelete(sender:MyCartUpdateGesture) {
           
          // self.fGrandTotal = 0
           
           let cartAlert = UIAlertController(title: "lbl_home_title".setlocalized(), message: "lbl_wishlist_delete_message".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
           
           cartAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
               let index = sender.indexId
               let productDetails = self.arrwishlist.object(at: index) as! NSDictionary
               
               if let productQty = productDetails.object(forKey: "nProductId") as? NSNumber {
                  // self.DeleteCart(nCartId: "\(productQty)")
                
                self.AddWishlist(iswish: "0", nProductId: "\(productQty)")
               }
               
              
               
           }))
           
           cartAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
               print("Handle Cancel Logic here")
           }))
           
           present(cartAlert, animated: true, completion: nil)
       }
    
    // MARK: - Tableview Delegate and Datasource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrwishlist.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailsCell") as! CartDetailsCell
            let productDetails = arrwishlist.object(at: indexPath.row) as! NSDictionary
            cell.isSampel = true
              cell.btnDelete.layer.cornerRadius = 12.5
              cell.btnDelete.layer.borderWidth = 1
              cell.btnDelete.clipsToBounds = true
              cell.btnDelete.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
             
              
            
            let deleteTap = MyCartUpdateGesture(target: self, action: #selector(onClickDelete))
            deleteTap.numberOfTapsRequired = 1
            deleteTap.cell = cell
            deleteTap.indexId = indexPath.row
            cell.btnDelete.isUserInteractionEnabled = true
            cell.btnDelete.addGestureRecognizer(deleteTap)
            cell.lblQuantity.text = "cart_quantity".setlocalized()
            var qty = 0
            if let productName = productDetails.object(forKey: "cName") as? String {
                cell.lblProductName.text = productName
            }
                        
            if let currency = productDetails.object(forKey: "Currency") as? String {
                strCurrency = currency
                    
                if let price1 = productDetails.object(forKey: "fPrice") as? NSNumber {
                let fPrice = Float(truncating: price1)
                    // fGrandTotal = fGrandTotal + (fPrice * Float(qty))
                    cell.lblProductPrice.text = "\(currency) \(fPrice)"
                }
            }
                    
            if let productImgUrl = productDetails.object(forKey: "cImage") as? String {
                cell.imgProduct.cacheImage(urlString: productImgUrl)
            }
                           
        return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetails = arrwishlist.object(at: indexPath.row) as! NSDictionary
        if let productId = productDetails.object(forKey: "nProductId") as? NSNumber {
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
            nextViewController.productId = "\(productId)"
            if let productName = productDetails.object(forKey: "cName") as? String {
                nextViewController.productName = "\(productName)"
            }
            
           // self.present(nextViewController, animated: true) {
                
           // }
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0 {
                return 131
            }
            else {
                return 146
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        
    // MARK: - HttpWrapper Delegate
            
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objgetwishlist {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let arrProduct:NSArray = dicsResponse.value(forKey: "result") as? NSArray {
        
                    self.arrwishlist = arrProduct.mutableCopy() as! NSMutableArray
                    tblview.reloadData()
                    viewNoDataFound.isHidden = true
                }
            }
            else
            {
                      self.viewNoDataFound.frame.size.width = self.view.frame.size.width
                                                        self.viewNoDataFound.frame.size.height = self.view.frame.size.height
                                                        self.viewNoDataFound.isHidden = false
                                                        self.tblview.isHidden = true
                                                        self.view.addSubview(self.viewNoDataFound)
            }
        }
        else if wrapper == objAddWishlist {
                          AppHelper.hideLoadingView()
                          if dicsResponse.value(forKey: "Success") as! String == "1" {
                              getwishList()
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
