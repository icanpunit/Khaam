//
//  Orders.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Orders: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,HttpWrapperDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var segmentState: UISegmentedControl!
    // MARK: - IBOutlets
    @IBOutlet weak var tblProductDetails: UITableView!
    @IBOutlet weak var viewBlack: UIView!
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var imgDone: UIImageView!
    @IBOutlet weak var lblAddedToCartTitle: UILabel!
    @IBOutlet weak var lblAddedToCartDesc: UILabel!
    var nCartType = "1"
    var index = 0
    @IBOutlet weak var btnShop: UIButton!
    var isfromprofile = false
    @IBOutlet weak var tblOrders: UITableView!
     @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet weak var btnBackToShop: UIButtonX!
    
    // MARK: - Variables
    @IBOutlet weak var imgNoData: UIImageView!
    var searchBar = UISearchBar()
    var objOrders = HttpWrapper()
    var objOrderDetails = HttpWrapper()
    var objOrderCancel = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var arrOrders:NSArray = NSArray()
    var orderId = ""
    var CustomerId = ""
    var totalCartCount:Int = 0
    var dicProductDetials:NSDictionary = NSDictionary()
    var arrProducts:NSMutableArray = NSMutableArray()
    
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScrren = "Orders"
        segmentState.selectedSegmentIndex = 1
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        self.getOrders()
        self.viewNoDataFound.frame.size.width = self.view.frame.size.width
        self.viewNoDataFound.frame.size.height = self.view.frame.size.height
        self.viewNoDataFound.isHidden = false
        if #available(iOS 13.0, *) {
            segmentState.selectedSegmentTintColor = btnBackgroundColor
        } else {
            // Fallback on earlier versions
        }
        
        segmentState.setTitle("lbl_sample_tab".setlocalized(), forSegmentAt: 0)
        segmentState.setTitle("lbl_tab_orders".setlocalized(), forSegmentAt: 1)
        self.lblNoDataFound.text = "lbl_orderlist_nodata_title".setlocalized()
               self.lblNODataDetail.text = "lbl_orderlist_nodata_detail".setlocalized()
               self.btnBackToShop.setTitle("placed_order_go_back".setlocalized(), for: .normal)
        // @IBOutlet weak var imgNoData: UIImageView!
                 if let url = "lbl_NoData_order".setlocalized() as? String {
                    imgNoData.cacheImage(urlString: url)
                 }
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleTextAttributes2 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentState.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentState.setTitleTextAttributes(titleTextAttributes2, for: .selected)
      //  tblOrders.tableHeaderView = viewHeader
       // self.view.addSubview(self.viewNoDataFound)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
        
        self.viewPopUp.frame.size.width = self.view.frame.size.width
        self.viewPopUp.frame.size.height = self.view.frame.size.height
        
        self.viewDialog.layer.cornerRadius = 5
        self.viewDialog.clipsToBounds = true
        
        self.btnOk.layer.cornerRadius = 3
        self.btnOk.clipsToBounds = true
        
        self.btnShop.layer.cornerRadius = 3
        self.btnShop.clipsToBounds = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    
    @IBAction func onChangeState(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0
        {
           nCartType = "0"
        }
        else
        {
            nCartType = "1"
        }
        getOrders()
    }
    
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
        appDelegate.SetTabBarItem(0)
    }
    
    // MARK: - IBActions
    
    @IBAction func onClickBtnYes(_ sender: UIButton) {
       // self.viewBlack.isHidden = true
        self.viewPopUp.removeFromSuperview()
        
        // index = sender.tag
        let dicOrder = self.arrOrders.object(at: index) as!NSDictionary
        print(dicOrder)
        if let idOrder = dicOrder.object(forKey: "nOrderId") as? NSNumber {
            orderId = "\(idOrder)"
        }
        if let idOrder = dicOrder.object(forKey: "nCustomerId") as? NSNumber {
            CustomerId = "\(idOrder)"
        }
        
       CancelOder()
        //self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBtnNo(_ sender: UIButton) {
        //self.viewBlack.isHidden = true
        self.viewPopUp.removeFromSuperview()
//        //        appDelegate.SetTabBarItem(3)
//        let nextViewController = objCart.instantiateViewController(withIdentifier: "Cart") as! Cart
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        isBackRequired = false
    }
    
    // MARK: - @objc Actions onTapCancelOder
    
    @objc func onTapCancelOder(_ sender:UITapGestureRecognizer) {
        
       // self.viewBlack.isHidden = false
        self.view.addSubview(self.viewPopUp)
        self.lblAddedToCartTitle.text = "lbl_Orders_Cancel_Title".setlocalized()
        self.lblAddedToCartDesc.text = "\("lbl_Order_CancelOrder_Detail".setlocalized())"
        self.btnOk.setTitle("menu_no".setlocalized(), for: .normal)
        index = sender.view!.tag

        self.btnOk.tag = index
        self.btnShop.setTitle("menu_yes".setlocalized(), for: .normal)
        self.btnOk.backgroundColor = btnBackgroundColor
        self.btnOk.setTitleColor(btnTitleColor, for: .normal)
        
        self.btnShop.backgroundColor = btnBackgroundColor
        self.btnShop.setTitleColor(btnTitleColor, for: .normal)
        
        
//        let index = sender.view?.tag
//        let dicOrder = self.arrOrders.object(at: index!) as!NSDictionary
//        print(dicOrder)
//        if let idOrder = dicOrder.object(forKey: "nOrderId") as? NSNumber {
//            orderId = "\(idOrder)"
//        }
//        getOrderDetails()
    }
    
    // MARK: - @objc Actions
    
    @objc func onTapOrderAgain(_ sender:UITapGestureRecognizer) {
        let index = sender.view?.tag
        let dicOrder = self.arrOrders.object(at: index!) as!NSDictionary
        print(dicOrder)
        if let idOrder = dicOrder.object(forKey: "nOrderId") as? NSNumber {
            orderId = "\(idOrder)"
        }
        getOrderDetails()
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
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getOrders()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addToCart() {
        var dicCart:NSMutableArray = NSMutableArray()
        var newDictProductDetails:NSMutableDictionary = NSMutableDictionary()
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: kCartData) != nil {
            dicCart = (AppHelper.convertToDictionary(text: userDefaults.object(forKey: kCartData) as! String) as! NSArray).mutableCopy() as! NSMutableArray
            
            print(arrProducts.count)
            print(arrProducts)
            
           
            for newOrderId in 0..<arrProducts.count {
                dicProductDetials = arrProducts.object(at: newOrderId) as! NSDictionary
                let currentProductId = dicProductDetials.object(forKey: "nProductId") as! NSNumber
                let newCartCount = dicProductDetials.object(forKey: "nQty") as! String
                var cartCount = 0
                var selectctedIndex = 0
                print(dicCart.count)
                for index in 0..<dicCart.count {
                    
                    let dictProductCart = dicCart.object(at: index) as! NSDictionary
                    
                    let oldProductId = dictProductCart.object(forKey: "nProductId") as! NSNumber
                    
                    if Int(truncating: currentProductId) == Int(truncating: oldProductId) {
                        if let productCount = dictProductCart.object(forKey: "nQty") as? String {
                            newDictProductDetails = dictProductCart.mutableCopy() as! NSMutableDictionary
                            cartCount = Int(productCount)!
                            selectctedIndex = index
                        }
                    }
                }
                
                if cartCount != 0 {
                    qtyCount = Float(Int(newCartCount)! + cartCount)
                    newDictProductDetails.setValue("\(qtyCount)", forKey: "nQty")
                    //                totalCartCount = (totalCartCount - cartCount) + qtyCount
                    dicCart.replaceObject(at: selectctedIndex, with: newDictProductDetails)
                }
                else {
                    newDictProductDetails = dicProductDetials.mutableCopy() as! NSMutableDictionary
                    newDictProductDetails["nQty"] = "\(qtyCount)"
                    //                totalCartCount = totalCartCount + qtyCount
                    dicCart.add(newDictProductDetails)
                }
            }
        }
        else {
            for newOrderId in 0..<arrProducts.count {
                dicProductDetials = arrProducts.object(at: newOrderId) as! NSDictionary
                newDictProductDetails = dicProductDetials.mutableCopy() as! NSMutableDictionary
                dicCart.add(newDictProductDetails)
            }
        }
        
        print(dicCart)
        totalCartCount = dicCart.count
        userDefaults.set("\(totalCartCount)", forKey: kGlobalCartCount)
        let tabCart = self.tabBarController!.tabBar.items?[3]
        
        tabCart?.badgeValue = "\(totalCartCount)"
        if #available(iOS 10.0, *) {
            tabCart?.badgeColor = .white
            tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
        }
        
        let jsonData = AppHelper.json(from: dicCart)
        userDefaults.set(jsonData, forKey:kCartData)
        
        let nextViewController = objCart.instantiateViewController(withIdentifier: "Cart") as! Cart
        nextViewController.isBackRequired = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
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
            param.append(String(format:"nOrderId=%@&", orderId))
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
    
    func CancelOder() {
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
            
            param.append(String(format:"%@?", kUpdateOrderStatusCustomer))
            param.append(String(format:"nUserId=%@&", "\(nUserId)"))
            param.append(String(format:"nOrderId=%@&", orderId))
            param.append(String(format:"nCustomerId=%@&", CustomerId))
            param.append(String(format:"cStatus=%@&", "Cancelled"))
            param.append(String(format:"cToken=%@", cToken))
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objOrderCancel = HttpWrapper.init()
            self.objOrderCancel.delegate = self
            self.objOrderCancel.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    func getOrders() {
        
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            var type = ""
                   if nCartType == "1"
                   {
                      type = "Admin Order"
                   }
                   else
                   {
                       type = "Free Order"
                   }
            let param:NSMutableString = NSMutableString()
            
            param.append(String(format:"%@?", kGetOrders))
            param.append(String(format:"nUserId=%@&", "\(nUserId)"))
            param.append(String(format:"nCustomerId=%@&", "\(nCustomerId)"))
            param.append(String(format:"cOrderType=%@&", "\(type)"))
            param.append(String(format:"cToken=%@", cToken))
             let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
//            param = String(format: "%@?nUserId=%@&nCustomerId=%@&cToken=%@", kGetOrders,"\(nUserId)","\(nCustomerId)","C14PwvwO4jjejXPcphTF")
            
            AppHelper.showLoadingView()
            self.objOrders = HttpWrapper.init()
            self.objOrders.delegate = self
            self.objOrders.requestWithparamdictParamPostMethodwithHeaderGet(url: NSMutableString(string: updatedUrl!) as String, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "lbl_Orderlist_Title".setlocalized()
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
    
    // MARK: - Tableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell") as! OrdersCell
        
        let dicOrder = self.arrOrders.object(at: indexPath.row) as!NSDictionary
        
        if let nOrderId = dicOrder.object(forKey: "nOrderId") as? NSNumber {
            cell.lblProductName.text = "\("lbl_orders_order_id".setlocalized()) \(nOrderId)"
        }
        
        if let data:NSArray = dicOrder.object(forKey: "Item") as? NSArray {
            if let data2:NSArray = data.object(at: 0) as? NSArray
            {
                if data2.count > 0
                {
                    if let productImgUrl = (data2.object(at: 0) as! NSDictionary).value(forKey: "cProductImage") as? String
                    {
                        cell.imgProduct.cacheImage(urlString: productImgUrl)
                    }
                }
               
            }
            else
            {
                
            }
        }
        if let price1 = dicOrder.object(forKey: "fTotalPrice") as? NSNumber {
        let fPrice = Float(truncating: price1)
            let currency = UserDefaults.standard.value(forKey: kCurrency) as! String
            cell.lblProductPrice.text = "\("lbl_orders_order_price".setlocalized()) \(currency) \(String(format: "%.3f", fPrice))"
        }

        if let strDate = dicOrder.object(forKey: "dtGeneratedDate") as? NSString {
            
            let dateArr = strDate.components(separatedBy: "T")
            let gDate = dateArr[0]
            
            let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
            cell.lblProductPlacedName.text = "\("lbl_orders_placed_on".setlocalized()) \(AppHelper.dateToString(date: dtDate, strFormate: "dd/MM/yyyy"))"
        }
        
        cell.viewOrders.layer.cornerRadius = 10
        cell.viewOrders.layer.borderWidth = 1
        cell.viewOrders.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
        cell.viewOrders.clipsToBounds = true
        
//        cell.btnOrderAgain.layer.cornerRadius = cell.btnOrderAgain.frame.size.height/2
       
        cell.btnOrderAgain.clipsToBounds = true
        if let type = dicOrder.object(forKey: "nStatusType") as? NSNumber {
            
//            Pending - Yellow
//            Process - Blue
//            Delivered - Green
//            Canelled - Red
//            Return - Orange
            
            
//            In Process nStatusType=1
//            Delivered nStatusType=2
//            Cancelled nStatusType=3
//            Return nStatusType=4
//            Pending nStatusType=5
            if type == 1
            {
                cell.btnStatus.setTitleColor(UIColor.init(hexString: "#2874A6"), for: .normal)
            }
            else if type == 2
            {
                cell.btnStatus.setTitleColor(UIColor.init(hexString: "#229954"), for: .normal)
            }
            else if type == 3
            {
                cell.btnStatus.setTitleColor(UIColor.init(hexString: "#E74C3C"), for: .normal)
            }
            else if type == 4
            {
                cell.btnStatus.setTitleColor(UIColor.init(hexString: "#D35400"), for: .normal)
            }
            else if type == 5
            {
                cell.btnStatus.setTitleColor(UIColor.init(hexString: "#B7950B"), for: .normal)
            }
            
//            cell.btnStatus.layer.shadowColor = UIColor.black.cgColor
//            cell.btnStatus.layer.shadowOffset = CGSize(width: 5, height: 5)
//            cell.btnStatus.layer.shadowRadius = 5
//            cell.btnStatus.layer.shadowOpacity = 1.0
        
        }
        
        
        if let cStatus = dicOrder.object(forKey: "cCurrentStatus") as? String {
            
            if cStatus == "Delivered" {
                cell.btnOrderAgain.isHidden = false
                cell.btnOrderAgain.isUserInteractionEnabled = true
                 cell.btnOrderAgain.setTitle("lbl_orders_order_again".setlocalized(), for: .normal)
                let orderAgainTap = UITapGestureRecognizer(target: self, action: #selector(onTapOrderAgain))
                orderAgainTap.numberOfTapsRequired = 1
                cell.btnOrderAgain.tag = indexPath.row
                cell.btnOrderAgain.addGestureRecognizer(orderAgainTap)
//                orderAgainTap.
            }
            else if cStatus == "Pending" {
                cell.btnOrderAgain.isHidden = false
                cell.btnOrderAgain.isUserInteractionEnabled = true
                cell.btnOrderAgain.setTitle("lbl_orders_order_Cancel".setlocalized(), for: .normal)
                
                let orderAgainTap = UITapGestureRecognizer(target: self, action: #selector(onTapCancelOder(_:)))
                orderAgainTap.numberOfTapsRequired = 1
                cell.btnOrderAgain.tag = indexPath.row
                cell.btnOrderAgain.addGestureRecognizer(orderAgainTap)
                //                orderAgainTap.
            }
            else {
                cell.btnOrderAgain.isHidden = true
            }
            
            cell.btnStatus.setTitle(cStatus, for: .normal)
            cell.btnStatus.isUserInteractionEnabled = false
        }
         cell.btnOrderAgain.setTitle("lbl_Orders_ViewOrder".setlocalized(), for: .normal)
        cell.btnOrderAgain.isUserInteractionEnabled = false
       // cell.btnOrderAgain.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicOrder = self.arrOrders.object(at: indexPath.row) as!NSDictionary
        if let nOrderId = dicOrder.object(forKey: "nOrderId") as? NSNumber {
            let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
            nextViewController.nOrderId = "\(nOrderId)"
            nextViewController.isFromOrders = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objOrders {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrOrders = dicsResponse.value(forKey: "Result") as! NSArray
                self.tblOrders.reloadData()
                
                self.tblOrders.alpha = 0
                UIView.animate(withDuration: 2.0, animations: {
                  self.tblOrders.alpha = 1
                }) { (true) in
                    
                }
                
               tblOrders.isHidden = false
                                 self.viewNoDataFound.isHidden = true
                
                
               
            }
            else{
                self.viewNoDataFound.isHidden = false
                               self.viewNoDataFound.frame.size.width = self.view.frame.size.width
                               self.viewNoDataFound.frame.size.height = self.view.frame.size.height
                               self.view.addSubview(self.viewNoDataFound)
                               tblOrders.isHidden = true
                //viewNoDataFound.isHidden = true
                self.arrOrders = NSArray()
                 self.tblOrders.reloadData()
               // viewNoDataFound.isHidden = false
                //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else if wrapper == objOrderCancel {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                //self.arrOrders = dicsResponse.value(forKey: "Result") as! NSArray
                //self.tblOrders.reloadData()
                //viewNoDataFound.isHidden = true
                self.getOrders()
            }
            else{
                
                //viewNoDataFound.isHidden = false
                //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else if wrapper == objOrderDetails {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let arrOldOrder = dicsResponse.value(forKey: "Result") as? NSArray {
                    if let dicOldOrder = arrOldOrder.object(at: 0) as? NSDictionary {
                        if let arrItem = dicOldOrder.object(forKey: "Item") as? NSArray {
                            var Currency = ""
                            if UserDefaults.standard.object(forKey: kCurrency) != nil {
                                Currency = UserDefaults.standard.object(forKey: kCurrency) as! String
                            }

                            let rowArrProducts = arrItem.object(at: 0) as! NSArray
                            for productIndex in 0..<rowArrProducts.count {
                                let rowDictProduct = rowArrProducts.object(at: productIndex) as! NSDictionary
                                let newDict = ["nProductId":rowDictProduct.object(forKey: "nProductId") as AnyObject,
                                               "cName":rowDictProduct.object(forKey: "cProductName") as! String,
                                               "Currency":Currency,
                                               "fPrice":rowDictProduct.object(forKey: "fProductPrice") as AnyObject,
                                               "cImage":rowDictProduct.object(forKey: "cProductImage") as! String,
                                               "nQty":"\(rowDictProduct.object(forKey: "fQuantity") as AnyObject)"] as [String : Any]
                                self.arrProducts.add(newDict)
                            }
                            self.addToCart()
                            print(self.arrProducts)
                        }
                    }
                }
            }
            else {
                
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

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}

extension Date {
    
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let strMonth = dateFormatter.string(from: self)
        
        return strMonth
    }
}
