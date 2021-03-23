//
//  ProductDetails.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LNSideMenu
import FirebaseDynamicLinks
import Lightbox
import GSImageViewerController
var qtyCount:Float = 1



extension String {
var atributedText: NSMutableAttributedString {
let style = NSMutableParagraphStyle()
      let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
    if currentLanguage == "en" {
               style.alignment = NSTextAlignment.left
              }
              else{
                 style.alignment = NSTextAlignment.right
              }
              
    
//    let attrStr = try? NSAttributedString( // do catch
//                           data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
//                           options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
//                           documentAttributes: nil)

    guard let data = self.data(using: .unicode) else { return NSMutableAttributedString() }
guard let attrStr = try? NSMutableAttributedString(
                    data: data,
                    options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType: NSMutableAttributedString.DocumentType.html],
                    documentAttributes: nil)
    else { return NSMutableAttributedString() }

attrStr.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attrStr.length))
return attrStr
 }
}

extension ProductDetails: UITextFieldDelegate {
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if Int(str)! >= 1 && Int(str)! <= 99 {
            qtyCount = Float(str)!
            return true
        }
        return false
    }
}

extension ProductDetails:showAttributeImageDelegate,HomeProductNavigation
{
    func showImagepopup(data: NSDictionary) {
        let modalViewController = FeelitPopup(nibName:"FeelitPopup",bundle: nil)
        modalViewController.modalPresentationStyle = .overCurrentContext
       // modalViewController.delegate = self
        modalViewController.data = data
        modalViewController.isSize = true
        present(modalViewController, animated: true, completion: nil)
    }
    
    func navigateCategoryToProduct(categoryId: Int, categoryName: String, api: String, isSubCategory: String, parentCateogyId: Int) {
           
          
       }
       
       func navigateToFeaturedProduct(productId: Int, ProductName: String) {
           
        self.productId = "\(productId)"
           productName = ProductName
        
        self.getProductDetails()
           
       }
}
extension ProductDetails :ShowimageDelegate
{
    func OnclickShowImage(cell: ProducDetailsImageCollectionCell) {
        
        
        var image:[LightboxImage] = [LightboxImage]()
        if let urlImage:NSArray = self.dicProductDetials.object(forKey: "Images") as? NSArray {
                      
            for data in urlImage
            {
                let newdata = data as! NSDictionary
                if let url = newdata.value(forKey: "Image") as? String
                {
                    if url != "" {
                        let img = LightboxImage(imageURL: URL(string: url)!)
                        image.append(img)
                    }
                    else {
                        //cell.imgProduct.image = UIImage(named: "ic_product_image")
                    }
                }
                
            }
      
                        }
        
        let controller = LightboxController(images: image)
               controller.dynamicBackground = true
               
               present(controller, animated: true, completion: nil)
        
//        let imageInfo   = GSImageInfo(image: cell.imgProduct.image!, imageMode: .aspectFit)
//            let transitionInfo = GSTransitionInfo(fromView: cell.imgProduct)
//            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
//            present(imageViewer, animated: true, completion: nil)
    }
    
    
}

extension ProductDetails :UnitSelectDelegate
{
    func onSelectUnit(value: Float) {
        qtyCount = value
    }
    
    
}

class ProductDetails: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate,HttpWrapperDelegate,UITabBarControllerDelegate,PopupFeelitDelegate {
    func popupFeelitClose() {
        let logoutAlert = UIAlertController(title: "lbl_free_cartdialog_title".setlocalized(), message: "lbl_free_cartdialog_description".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                                                                               
                                              logoutAlert.addAction(UIAlertAction(title: "lbl_free_cartdialog_continue_shopping".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
                                                  self.back()
                                              }))
                                                                               
                                              logoutAlert.addAction(UIAlertAction(title: "lbl_free_cartdialog_viewcart".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                                                                                   print("Handle Cancel Logic here")
                                              self.GoInCart()
                                                                               }))
                                                                               
                                              present(logoutAlert, animated: true, completion: nil)
    }
    
   
    @IBOutlet weak var btnSample: UIButton!
    var stockQnty = 0
    var minstockQnty = 0
    @IBOutlet var viewFooter: UIView!
    
     var isZigzagOn = true
    @IBOutlet weak var viewBottom: UIView!
    // MARK: - IBOutlets
    @IBOutlet weak var tblProductDetails: UITableView!
    @IBOutlet weak var viewBlack: UIView!
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var imgDone: UIImageView!
    @IBOutlet weak var lblAddedToCartTitle: UILabel!
    @IBOutlet weak var lblAddedToCartDesc: UILabel!
    var URLViewImage = String()
    var nUnitType = 1
    var isDeeplink = false
     var isFromOrders:Bool = false
    var fFeelItStock = 0
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var btnFeelit: UIButton!
    var arrunitName = ["","checkout_quantity".setlocalized(),"lbl_kilograms".setlocalized(),"lbl_Meter".setlocalized()]
    let buttonWishlist = UIButton.init(type: .custom)
    @IBOutlet weak var btnShop: UIButton!
    // MARK: - Variables
    var searchBar = UISearchBar()
    var arrUnit:[String] = [String]()
    var arrBannerImage:NSArray = ["","",""]
    var arrProductType:NSArray = ["home_shop_by_category".setlocalized(),"home_featured_products".setlocalized()]
    var arrProductDetails:NSArray = NSArray()
    var arrAssignedProduct:NSArray = NSArray()
    var descCellHeight:CGFloat = 0
    var productId:String = ""
    var productName:String = ""
    var objProductDetails = HttpWrapper()
    var objAddWishlist = HttpWrapper()
    var objAddToCart = HttpWrapper()
    var userDefaults = UserDefaults.standard
    var dicProductDetials:NSDictionary = NSDictionary()
    var totalCartCount:Int = 0
    var isUpdated:Bool = false
    var firstCellHeight:CGFloat = 0
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    // MARK: - ViewController Methods
    var iscart = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        qtyCount = 0
        tblProductDetails.alpha = 0
        self.viewBottom.isHidden = true
        self.btnSample.layer.cornerRadius = btnSample.frame.height/2
   //   self.btnSample.setTitle("write_review_submit".setlocalized(), for: .normal)
       self.btnSample.clipsToBounds = true
        //tblProductDetails.tableFooterView = viewFooter
        currentScrren = "ProductDetails"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        
       btnAddCart.setImage(UIImage.init(named: "shopping-cart (1)")?.withRenderingMode(.alwaysTemplate), for: .normal)
       //   btnAddCart.setTitle(" \("lbl_ProductDetail_add_To_Cart".setlocalized())", for: .normal)
        btnAddCart.tintColor = btnBackgroundColor
        btnAddCart.backgroundColor = UIColor.white
        btnAddCart.layer.borderColor = btnBackgroundColor.cgColor
        btnAddCart.layer.borderWidth = 1
        btnAddCart.layer.cornerRadius = btnRadius
        btnFeelit.layer.cornerRadius = btnRadius
         btnFeelit.backgroundColor = btnBackgroundColor
        btnFeelit.setTitleColor(btnTitleColor, for: .normal)
        btnFeelit.setTitle(" \("lbl_btn_feel_it_for".setlocalized())", for: .normal)
        btnFeelit.setImage(UIImage.init(named: "Feelit")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnFeelit.tintColor = UIColor.white
       //btnFeelit.isHidden = true
        // Do anxy additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
        self.getProductDetails()
       appDelegate.tabBarController1.tabBar.isHidden = true
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
       
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    @objc func GoInCart() {
         appDelegate.tabBarController1.tabBar.isHidden = true
           self.viewBlack.isHidden = true
                   self.viewPopUp.removeFromSuperview()
                   
              appDelegate.SetTabBarItem(3)
//                   let nextViewController = objCart.instantiateViewController(withIdentifier: "Cart") as! Cart
//                   nextViewController.isBackRequired = true
//                   self.navigationController?.pushViewController(nextViewController, animated: true)
       }
    
    @IBAction func onClickBtnViewImage(_ sender: UIButton) {
       
            
            let url = URL(string: URLViewImage)
            print("URL",url)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            var imageview:UIImageView = UIImageView()
            imageview.image = UIImage(data: data!)
        
       
        let imageInfo   = GSImageInfo(image: UIImage(data: data!)!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    @IBAction func onClickBtnShop(_ sender: Any) {
        self.viewBlack.isHidden = true
        self.viewPopUp.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickOkay(_ sender: UIButton) {
        self.viewBlack.isHidden = true
        self.viewPopUp.removeFromSuperview()
//        appDelegate.SetTabBarItem(3)
        appDelegate.SetTabBarItem(3)
//        let nextViewController = objCart.instantiateViewController(withIdentifier: "Cart") as! Cart
//        nextViewController.isBackRequired = true
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }

    // MARK: - @objc Actions
    
    @IBAction func onClickbtnAddCart(_ sender: Any) {
        
        if let IsCartExists = self.dicProductDetials.object(forKey: "IsCartExists") as? NSNumber {
                              
            if IsCartExists == 1
            {
          self.viewBlack.isHidden = true
                    self.viewPopUp.removeFromSuperview()
                 appDelegate.SetTabBarItem(3)
                
//                    let nextViewController = objCart.instantiateViewController(withIdentifier: "Cart") as! Cart
//                nextViewController.isBackRequired = true
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
            }
            else
            {
                iscart = false
                       if qtyCount > 0
                       {
                           AddToCart(Qty: "\(qtyCount)", nCartType: "1")
                       }
                       else
                       {
                           AppHelper.showMessage(view: self.view, message: "lbl_ProductDetail_Select_qty".setlocalized())
                       }
                                        
            }
        }
        
       
    }
    @IBAction func onClickBtnFeelit(_ sender: Any) {
        
        if fFeelItStock > 0
        {
            
            if let IsCartExists = self.dicProductDetials.object(forKey: "IsFeelItCartExists") as? NSNumber {
                                                     
                if IsCartExists == 1
                {
                    let logoutAlert = UIAlertController(title: "lbl_free_cartdialog_title".setlocalized(), message: "lbl_FeelitPopup_Detail_Productincart".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                                                                                          
//                    logoutAlert.addAction(UIAlertAction(title: "lbl_cartdialog_continue_shopping".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
//
//                                                         }))
                                                                                          
                    logoutAlert.addAction(UIAlertAction(title: "lbl_ok".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                                                                                              print("Handle Cancel Logic here")
                                                            
                        }))
                                                                                          
                    present(logoutAlert, animated: true, completion: nil)
                }
                else
                {
                                     
                    iscart = true
                                                                
                    AddToCart(Qty: "\(1)", nCartType: "0")
                }
         }
         
        }
        else
        {
           
            let modalViewController = FeelitPopup(nibName:"FeelitPopup",bundle: nil)
            modalViewController.modalPresentationStyle = .overCurrentContext
          //  modalViewController.delegate = self
            modalViewController.isFeelitStock = true
                               //               modalViewController.celltbl = cell
                               //               modalViewController.isFromAppointMent = true
           present(modalViewController, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func onClickOrderSample(_ sender: Any) {
        
        iscart = true
        
        AddToCart(Qty: "\(qtyCount)", nCartType: "0")
    }
    @objc func onClickPlus() {
        if Int(qtyCount) < stockQnty {
            isUpdated = true
            qtyCount = qtyCount + 1
            tblProductDetails.reloadData()
        }
        else
        {
            AppHelper.showMessage(view: self.view, message: "lbl_ProductDetail_Out_Of_Stock".setlocalized())
            
        }
    }
    
    @objc func onClickMinus() {
        if qtyCount > 1 {
            isUpdated = true
            qtyCount = qtyCount - 1
            tblProductDetails.reloadData()
        }
    }
    
    @objc func back() {
         appDelegate.tabBarController1.tabBar.isHidden = false
        if isDeeplink == true
        {
            appDelegate.loginSuccess()
        }
        else   if isFromOrders == true
        {
            appDelegate.SetTabBarItem(0)
        }
        else
        {
            sideMenuManager?.hideSideMenuView()
                   self.navigationController?.popViewController(animated: true)
        }
       
    }
    @objc func addWishlist () {
        if buttonWishlist.currentImage == UIImage.init(named: "love-and-romance")
        {
            AddWishlist(iswish: "1")
        }
        else
        {
            AddWishlist(iswish: "0")
        }
        
        
       }
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
   
    
     @objc func shareproduct() {
        
  
        let someText:String = "lbl_ShareMessageText".setlocalized()
           let objectsToShare:URL = URL(string: "https://khaam.page.link/?link=https://khaam.me/product?productid=\(productId)&apn=com.Khaam.fashion.app&ibi=com.khaamApp.AppleStore")!
           let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
           let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view

           activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]

           self.present(activityViewController, animated: true, completion: nil)
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
    
    @objc func gotoCart() {
//        totalCartCount = 0
//        var dicCart:NSMutableArray = NSMutableArray()
//        var newDictProductDetails:NSMutableDictionary = NSMutableDictionary()
//        if userDefaults.object(forKey: kCartData) != nil {
//            dicCart = (AppHelper.convertToDictionary(text: userDefaults.object(forKey: kCartData) as! String) as! NSArray).mutableCopy() as! NSMutableArray
//            print(dicCart)
//            
//            let currentProductId = dicProductDetials.object(forKey: "nProductId") as! NSNumber
//            var cartCount = 0
//            var selectctedIndex = 0
//            for index in 0..<dicCart.count {
//                let dictProductCart = dicCart.object(at: index) as! NSDictionary
//                
//                let oldProductId = dictProductCart.object(forKey: "nProductId") as! NSNumber
//                if currentProductId == oldProductId {
//                    if let productCount = dictProductCart.object(forKey: "nQty") as? String {
//                        newDictProductDetails = dictProductCart.mutableCopy() as! NSMutableDictionary
//                        cartCount = Int(productCount)!
//                        selectctedIndex = index
//                    }
//                }
//                
//                if let productCount = dictProductCart.object(forKey: "nQty") as? String {
////                    totalCartCount = totalCartCount + Int(productCount)!
//                }
//                
//            }
//            if cartCount != 0 {
//                newDictProductDetails.setValue("\(qtyCount)", forKey: "nQty")
////                totalCartCount = (totalCartCount - cartCount) + qtyCount
//                dicCart.replaceObject(at: selectctedIndex, with: newDictProductDetails)
//            }
//            else {
//                newDictProductDetails = dicProductDetials.mutableCopy() as! NSMutableDictionary
//                newDictProductDetails["nQty"] = "\(qtyCount)"
////                totalCartCount = totalCartCount + qtyCount
//                dicCart.add(newDictProductDetails)
//            }
//        }
//        else {
//            newDictProductDetails = dicProductDetials.mutableCopy() as! NSMutableDictionary
//            newDictProductDetails["nQty"] = "\(qtyCount)"
////            totalCartCount = qtyCount
//            dicCart.add(newDictProductDetails)
//        }
//        print(dicCart)
//        totalCartCount = dicCart.count
//        userDefaults.set("\(totalCartCount)", forKey: kGlobalCartCount)
//        let tabCart = self.tabBarController!.tabBar.items?[3]
//        
//        tabCart?.badgeValue = "\(totalCartCount)"
//        if #available(iOS 10.0, *) {
//            tabCart?.badgeColor = .white
//            tabCart?.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#D8131B"),], for: .normal)
//        }
//        iscart = false
//        if qtyCount > 0
//        {
//            AddToCart(Qty: "\(qtyCount)", nCartType: "1")
//        }
        
       iscart = false
       if qtyCount > 0
       {
           AddToCart(Qty: "\(qtyCount)", nCartType: "1")
       }
       else
       {
           AppHelper.showMessage(view: self.view, message: "lbl_ProductDetail_Select_qty".setlocalized())
       }
        
        
    }
   
    // MARK: - Custom Methods
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getProductDetails()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func getProductDetails() {
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
            let nProductId = self.productId
            let cToken = userDefaults.value(forKey: kcToken) as! String
            var nCustomerId = "0"
              var deviceid = ""
                         if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                             nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                         }
              else
                         {
                       deviceid = "\(appDelegate.DeviceId)"
              }
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nProductId=%@&cToken=%@&nCustomerId=%@&cDeviceId=%@", kProductDetials,"\(nUserId)","\(nLanguageId)","\(nProductId)","\(cToken)",nCustomerId,deviceid)
            
            tblProductDetails.alpha = 0
            AppHelper.showLoadingView()
            self.objProductDetails = HttpWrapper.init()
            self.objProductDetails.delegate = self
            self.objProductDetails.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func AddToCart(Qty:String,nCartType:String) {
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
            let nProductId = self.productId
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
                URLQueryItem(name: "cDeviceToken", value: deviceid),
                URLQueryItem(name: "nCartId", value: "0"),
                URLQueryItem(name: "nCartType", value: nCartType)
            ]
            
            AppHelper.showLoadingView()
            self.objAddToCart = HttpWrapper.init()
            self.objAddToCart.delegate = self
            self.objAddToCart.requestWithparamdictParamPostMethodwithHeaderGet(url: "\(url)", headers: nil)
        }
    }
    
 func AddWishlist(iswish:String) {
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
            let nProductId = self.productId
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
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
       // lbNavTitle.text = productName //"lbl_home_title".setlocalized()
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
        
        let buttonCart = UIButton.init(type: .custom)
               buttonCart.setImage(UIImage.init(named: "shopping-cart (1)")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
               buttonCart.tintColor = UIColor.black
               buttonCart.addTarget(self, action:#selector(GoInCart), for: UIControlEvents.touchUpInside)
               buttonCart.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 20, height: 20)
        
        let buttonSearch = UIButton.init(type: .custom)
        buttonSearch.setImage(UIImage.init(named: "icShare")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        buttonSearch.tintColor = UIColor.black
        buttonSearch.addTarget(self, action:#selector(shareproduct), for: UIControlEvents.touchUpInside)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 20, height: 20)
        
        
        buttonWishlist.setImage(UIImage.init(named: "Heartremove")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        buttonWishlist.tintColor = Colorblack
        buttonWishlist.addTarget(self, action:#selector(addWishlist), for: UIControlEvents.touchUpInside)
        buttonWishlist.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonWishlist)
         let barButtonCart = UIBarButtonItem.init(customView: buttonCart)
        
        if UserDefaults.standard.object(forKey: knCustomerId) != nil {
            self.navigationItem.rightBarButtonItems = [barButtonSearch,barButtonLanguage,barButtonCart]
        }
        else
        {
            self.navigationItem.rightBarButtonItems = [barButtonSearch,barButtonCart]
        }
        
     
        
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5{
            
            
            if arrProductDetails.count > 0
            {
                return 1
            }
            else
            {
               return 0
            }
        }
        else if section == 6{
                   
                   
                   if arrAssignedProduct.count > 0
                   {
                       return 1
                   }
                   else
                   {
                      return 0
                   }
               }
        else if section == 3 {
            
            if let attribute:NSArray = self.dicProductDetials.object(forKey: "SuggestedProject") as? NSArray {
                if attribute.count > 0
                {
                    return 1
                }
                else
                {
                   return 0
                }
            }
            return 0
        }
        else if section == 2 {
                   
                   if let attribute:NSArray = self.dicProductDetials.object(forKey: "Attribute") as? NSArray {
                       if attribute.count > 0
                       {
                           return 1
                       }
                       else
                       {
                          return 0
                       }
                   }
                   return 0
               }
        else if section == 3 {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsImageCell") as! ProductDetailsImageCell
            cell.backgroundColor = navigationbarColor
            cell.txtCartCounter.layer.borderWidth = 1
            cell.txtCartCounter.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
            cell.delegateUnit = self
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                   if currentLanguage == "en" {
                    cell.txtSelectSize.textAlignment = .left
                    cell.lblProductPrice.textAlignment = .left
                   }
                   else{
                       cell.txtSelectSize.textAlignment = .right
                    cell.lblProductPrice.textAlignment = .right
                   }
            cell.strunit = arrunitName[nUnitType]
            cell.addType = nUnitType
            cell.stockQnty = stockQnty
            cell.minstockQnty = minstockQnty
            
            if let iswish = self.dicProductDetials.value(forKey: "IsBundleProduct") as? NSNumber
                               {
                                   if iswish == 1
                                   {
                                      cell.txtCartCounter.text = "\(Int(qtyCount))"
                                   }
                                   else
                                   {
                                       cell.txtCartCounter.text = "\(qtyCount)"
                                   }
                               }
            
            
            let plusTap = UITapGestureRecognizer(target: self, action: #selector(onClickPlus))
            plusTap.numberOfTapsRequired = 1
            cell.btnPlus.isUserInteractionEnabled = true
            cell.btnPlus.tag = indexPath.row
            cell.btnPlus.addGestureRecognizer(plusTap)
                       
                if nUnitType == 1
                {
                    cell.viewDropDown.isHidden = true
                    cell.viewCartCount.isHidden = false
            }
            else
                {
                    cell.viewDropDown.isHidden = false
                    cell.viewCartCount.isHidden = true
            }
            let minusTap = UITapGestureRecognizer(target: self, action: #selector(onClickMinus))
            minusTap.numberOfTapsRequired = 1
            cell.btnMinus.isUserInteractionEnabled = true
            cell.btnMinus.tag = indexPath.row
            cell.btnMinus.addGestureRecognizer(minusTap)
            cell.arrvalue = arrUnit
            cell.loadData()
            if dicProductDetials.count != 0 {
                           if isUpdated == false {
                               if userDefaults.value(forKey: kCartData) != nil {
                                   var dicCart:NSMutableArray = NSMutableArray()
                                   let currentProductId = dicProductDetials.object(forKey: "nProductId") as! NSNumber
                                   dicCart = (AppHelper.convertToDictionary(text: userDefaults.object(forKey: kCartData) as! String) as! NSArray).mutableCopy() as! NSMutableArray
                                   
                                   
                                   for index in 0..<dicCart.count {
                                       let dictProductCart = dicCart.object(at: index) as! NSDictionary
                                       
                                       let oldProductId = dictProductCart.object(forKey: "nProductId") as! NSNumber
                                       if currentProductId == oldProductId {
                                           if let productCount = dictProductCart.object(forKey: "nQty") as? String {
                                               cell.txtCartCounter.text = productCount
                                               qtyCount = Float(productCount)!
                                           }
                                       }
                                   }
                               }
                           }
                       }
             cell.delegate = self
            
            if self.dicProductDetials != nil {
                if let urlImage:NSArray = self.dicProductDetials.object(forKey: "Images") as? NSArray {
                    
                    cell.imageItems = urlImage
                    
                   // cell.imageItems = urlImage
//                    cell.productImageCollection.frame.size.height = (self.view.bounds.height / 2) - 70
//                    cell.urlImage = urlImage
//                    URLViewImage = urlImage
                    cell.productImageCollection.reloadData()
                }
            }
            
            if self.dicProductDetials != nil {
                
                if let productName = self.dicProductDetials.object(forKey: "cVendorName") as? String {
                                   //lblVendorlabl.text = "lbl_ProductDetail_Vendor".setlocalized()
                        cell.lblVendorName.text = productName //"\("lbl_ProductDetail_Vendor".setlocalized()) - \(productName)"
                    }
                
                if let productName = self.dicProductDetials.object(forKey: "cName") as? String {
                    cell.lblProductName.text = productName
                    let font = UIFont(name: RalewayRegular, size: 16.0)
                    let height = heightForView(text: productName, font: font!, width: self.view.frame.size.width - 20)
                   cell.viewProductNameHeight.constant = height + 0
                    cell.viewTop.layoutIfNeeded()
                   // cell.viewTop.roundedTop(radius: 30)
                    self.view.layoutIfNeeded()
//                    self.firstCellHeight = height
                }
                
               
                
                if let currency = self.dicProductDetials.object(forKey: "Currency") as? String {
                  
                  if let spcialprice1 = dicProductDetials.object(forKey: "fSpecialPrice")  as? NSNumber {
                      
                      if Float(truncating: spcialprice1) > Float(0)
                      {
                          if let price1 = dicProductDetials.object(forKey: "fPrice")  as? NSNumber {
                          let price = Float(truncating: price1)
                              let spcprice = Float(truncating: spcialprice1)
                            
                              let full = "\(currency) \(String(format: "%.3f", price)) \(currency) \(String(format: "%.3f", spcprice))/\(arrunitName[nUnitType])"
                              
                              cell.lblProductPrice.attributedText = appDelegate.setAttributedPrice(Priceone: "\(currency) \(String(format: "%.3f", price))", pricetwo: "\(currency) \(String(format: "%.3f", spcprice))", Fullstring: full, Font: cell.lblProductPrice.font)
                              //cell.lblPrice.text = "\(currency) \(String(format: "%.3f", price))"
                          }
                          
                         
                      }
                      else{
                          if let price1 = dicProductDetials.object(forKey: "fPrice")  as? NSNumber {
                                                       let price = Float(truncating: price1)
                                                         
                                                           cell.lblProductPrice.text = "\(currency) \(String(format: "%.3f", price))/\(arrunitName[nUnitType])"
                                                       }
                      }
                 
                  }
                  
                   
                }
            }
            
            self.firstCellHeight = cell.viewTop.frame.height
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsAddToCartCell") as! ProductDetailsAddToCartCell
            cell.txtCartCounter.layer.borderWidth = 1
            cell.txtCartCounter.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
            cell.btnAddToCart.layer.cornerRadius = 17.5
            cell.btnAddToCart.clipsToBounds = true
            cell.btnAddToCart.setTitle(" \("lbl_ProductDetail_add_To_Cart".setlocalized())", for: .normal)
            
            cell.btnOrderSample.layer.cornerRadius = 17.5
            cell.btnOrderSample.clipsToBounds = true
            cell.btnOrderSample.setTitle(" \("lbl_ProductDetail_add_Sample_Order".setlocalized())", for: .normal)
            

            cell.txtCartCounter.text = "\(qtyCount)"
            
            let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoCart))
            openProductGesture.numberOfTapsRequired = 1
            cell.btnAddToCart.isUserInteractionEnabled = true
            cell.btnAddToCart.tag = indexPath.row
            cell.btnAddToCart.addGestureRecognizer(openProductGesture)
            
            cell.btnAddToCart.backgroundColor = btnBackgroundColor
            cell.btnAddToCart.setTitleColor(btnTitleColor, for: .normal)
            
            cell.btnOrderSample.backgroundColor = btnBackgroundColor
            cell.btnOrderSample.setTitleColor(btnTitleColor, for: .normal)
            var bolCartExists = false
                       if let IsCartExists = self.dicProductDetials.object(forKey: "IsCartExists") as? NSNumber {
                          
                                      if IsCartExists == 1
                                      {
                                          cell.btnOrderSample.setTitle("lbl_ProductDetail_CheckYourCart".setlocalized().uppercased(), for: .normal)
                                           cell.btnOrderSample.addTarget(self, action:#selector(GoInCart), for: UIControl.Event.touchUpInside)
                                       bolCartExists = true
                                       
                                      }
                                      else
                                      {
                                           cell.btnOrderSample.setTitle(" \("lbl_ProductDetail_add_Sample_Order".setlocalized())", for: .normal)
                                          
                                      }
                       }
                      else
                      {
                           cell.btnOrderSample.setTitle(" \("lbl_ProductDetail_add_Sample_Order".setlocalized())", for: .normal)
                          
                      }
            
            let plusTap = UITapGestureRecognizer(target: self, action: #selector(onClickPlus))
            plusTap.numberOfTapsRequired = 1
            cell.btnPlus.isUserInteractionEnabled = true
            cell.btnPlus.tag = indexPath.row
            cell.btnPlus.addGestureRecognizer(plusTap)
            
            
            let minusTap = UITapGestureRecognizer(target: self, action: #selector(onClickMinus))
            minusTap.numberOfTapsRequired = 1
            cell.btnMinus.isUserInteractionEnabled = true
            cell.btnMinus.tag = indexPath.row
            cell.btnMinus.addGestureRecognizer(minusTap)
            
            if bolCartExists == true
                       {
                           cell.btnAddToCart.isHidden = true
                       }
                       else if stockQnty > 0
                       {
                           cell.btnAddToCart.isHidden = false
                        cell.btnOrderSample.addTarget(self, action: #selector(onClickOrderSample(_:)), for: .touchUpInside)
                       }
                       else
                       {
                          cell.btnAddToCart.isHidden = true
                         cell.btnOrderSample.setTitle(" \("lbl_ProductDetail_Out_Of_Stock".setlocalized())", for: .normal)
                       }
            
            if dicProductDetials.count != 0 {
                if isUpdated == false {
                    if userDefaults.value(forKey: kCartData) != nil {
                        var dicCart:NSMutableArray = NSMutableArray()
                        let currentProductId = dicProductDetials.object(forKey: "nProductId") as! NSNumber
                        dicCart = (AppHelper.convertToDictionary(text: userDefaults.object(forKey: kCartData) as! String) as! NSArray).mutableCopy() as! NSMutableArray
                        
                        
                        for index in 0..<dicCart.count {
                            let dictProductCart = dicCart.object(at: index) as! NSDictionary
                            
                            let oldProductId = dictProductCart.object(forKey: "nProductId") as! NSNumber
                            if currentProductId == oldProductId {
                                if let productCount = dictProductCart.object(forKey: "nQty") as? String {
                                    cell.txtCartCounter.text = productCount
                                    qtyCount = Float(productCount)!
                                }
                            }
                        }
                    }
                }
            }
            return cell
        }
        else if indexPath.section == 3
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedProjectTable_Cell") as! SuggestedProjectTable_Cell
                cell.lblTitle.text = "lbl_ProductDetail_SuggestedProduct".setlocalized()
                
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                                  if currentLanguage == "en" {
                                   cell.lblTitle.textAlignment = .left
                                   
                                  }
                                  else{
                                      cell.lblTitle.textAlignment = .right
                                   
                                  }
                if let attribute:NSArray = self.dicProductDetials.object(forKey: "SuggestedProject") as? NSArray {
                    cell.arrimagelist = attribute
                }
                cell.CollectionProject.reloadData()
                return cell
        }
        else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDescCell") as! ProductDetailsDescCell
            
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
             cell.lblVendorlabl.textAlignment = .left
                cell.txtDescription.textAlignment = .left
            }
            else{
                cell.lblVendorlabl.textAlignment = .right
                cell.txtDescription.textAlignment = .right
            }
            
            cell.txtDescription.makeTextWritingDirectionLeftToRight(true)
            if self.dicProductDetials != nil {
                if let decription = self.dicProductDetials.object(forKey: "cDescription") as? String {
                    
                  //  let htmlString = "<html><body> Some <b>html</b> string </body></html>"
                    // works even without <html><body> </body></html> tags, BTW
                    
                    let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'Dubai-Regular'; font-size: \(15)\">%@</span>", decription)

//                    let attrStr = try! NSAttributedString(
//                        data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
//                        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
//                        documentAttributes: nil)
//
//                    let data = decription.data(using: String.Encoding.unicode)! // mind "!"
                    
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .center

                   
                    
                    let attrStr = try? NSAttributedString( // do catch
                        data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                        options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil)
                    // suppose we have an UILabel, but any element with NSAttributedString will do
                   // let attr = try? NSAttributedString(htmlString: decription, font: UIFont(name: RalewayRegular, size: 33))

                  //  cell.txtDescription.text = atributedText
                    cell.txtDescription.attributedText = modifiedFont.atributedText//decription.htmlToAttributedString
                    
                   // cell.lblProductDesc.text = decription
                    
//                    let font = UIFont(name: RalewayRegular, size: 17.0)
//
//                    let height = heightForView(text: decription, font: font!, width: self.view.frame.size.width - 30)
//                    self.descCellHeight = height
                }
                
               
            }
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailAttribute_Cell") as! ProductDetailAttribute_Cell
            
            if let attribute:NSArray = self.dicProductDetials.object(forKey: "Attribute") as? NSArray {
                cell.ArrAttribute = attribute
            }
            cell.delegate = self
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                       if currentLanguage == "en" {
                        cell.lblName.textAlignment = .left
                           
                       }
                       else{
                           cell.lblName.textAlignment = .right
                           
                       }
            
            cell.lblName.text = "lbl_details_product".setlocalized()
            cell.TblAttribute.reloadData()
            cell.TblAttribute.layoutIfNeeded()
            tblProductDetails.layoutIfNeeded()
            return cell
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsRelatedProductCell") as! ProductDetailsRelatedProductCell
            cell.delegate = self
            cell.isZigzagOn = isZigzagOn
            cell.lblTitle.text = "lbl_ProductDetail_Relatedproduct".setlocalized()
            cell.isassignProduct = false
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                                            if currentLanguage == "en" {
                                             cell.lblTitle.textAlignment = .left
                                             
                                            }
                                            else{
                                                cell.lblTitle.textAlignment = .right
                                             
                                            }
            cell.CollectionviewheghtConstant.constant = 210
            cell.arrProductDetails = NSArray()
            cell.layoutIfNeeded()
            cell.relatedProductCollection.reloadData()
            let layout = UICollectionViewFlowLayout()
                                      layout.scrollDirection = .horizontal
                                      cell.relatedProductCollection.setCollectionViewLayout(layout, animated: true)
             cell.layoutIfNeeded()
            cell.arrProductDetails = arrProductDetails
            cell.relatedProductCollection.reloadData()
            return cell
        }
        else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsRelatedProductCell") as! ProductDetailsRelatedProductCell
            cell.delegate = self
            cell.isZigzagOn = isZigzagOn
            cell.lblTitle.text = "lbl_assigned_product_Name".setlocalized()
            cell.isassignProduct = true
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                                            if currentLanguage == "en" {
                                             cell.lblTitle.textAlignment = .left
                                             
                                            }
                                            else{
                                                cell.lblTitle.textAlignment = .right
                                             
                                            }
            
            let layout = UICollectionViewFlowLayout()
                           layout.scrollDirection = .vertical
                           cell.relatedProductCollection.setCollectionViewLayout(layout, animated: true)
            
           
            
            cell.arrProductDetails = arrAssignedProduct
             cell.layoutIfNeeded()
            cell.relatedProductCollection.reloadData()
            cell.layoutIfNeeded()
            cell.CollectionviewheghtConstant.constant = cell.relatedProductCollection.collectionViewLayout.collectionViewContentSize.height;
            
            
            return cell
        }
        else if indexPath.section == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsRateCell") as! ProductDetailsRateCell
            cell.viewProductRate.layer.borderWidth = 1
            cell.viewProductRate.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
            cell.viewRate.isUserInteractionEnabled = false
            cell.lblRateThisProduct.text = "product_details_rate_this_product".setlocalized()
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
             cell.lblRateThisProduct.textAlignment = .left
             
            }
            else{
                cell.lblRateThisProduct.textAlignment = .right
             
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsReviewCell") as! ProductDetailsReviewCell
            cell.viewReview.layer.borderWidth = 1
            cell.viewReview.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
            cell.imgUser.image = UIImage(named: "img_user")
            cell.lblUserName.text = "John Smith"
            cell.viewRate.value = 3
            cell.viewRate.isUserInteractionEnabled = false
            cell.lblUserReview.text = "Olist voluptatem accusantium dolore"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           // let size = (self.view.bounds.height/1.7) + (self.firstCellHeight - 21)
             let size = (self.view.bounds.width) + (self.firstCellHeight)
            return size
        }
        if indexPath.section == 1 {
            return 0
        }
        if indexPath.section == 2 {
           return UITableViewAutomaticDimension
//            if self.dicProductDetials != nil {
//                if let decription = self.dicProductDetials.object(forKey: "cDescription") as? String {
//                    if decription != "" {
//                        return self.descCellHeight + 20
//                    }
//                    else {
//                        return 0
//                    }
//                }
//                else {
//                    return 0
//                }
//            }
//            else {
//                return 0
//            }
        }
        if indexPath.section == 3 {
             return 110
        }
        
        if indexPath.section == 5 {
             return 240
        }
        
        if indexPath.section == 6 {
            
           return UITableViewAutomaticDimension
            
                   
        }
        
        if indexPath.section == 4 {
            
             if let decription = self.dicProductDetials.object(forKey: "cDescription") as? String
             {
                if decription.count > 0
                {
                    return UITableViewAutomaticDimension
                }
                else
                {
                   return 0
                }
            }
            else
             {
                return 0
            }
            
        }
        else {
            return 101
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1 || section == 2 || section == 4 {
            return nil
        }
        else {
            let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblProductDetails.frame.size.width, height: 35))
            headerView.backgroundColor = UIColor.white
            let lblHeaderName:UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: headerView.frame.size.height))
            
            if section == 3 {
                lblHeaderName.text = "product_details_related_products".setlocalized()
            }
            else {
                lblHeaderName.text = "product_details_review".setlocalized()
            }
            
            lblHeaderName.font = UIFont(name: RalewayRegular, size: 18)
            
            headerView.addSubview(lblHeaderName)
            
            return headerView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 || section == 2 || section == 4 {
            return 0
        }
        else {
            return 0 // 35
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 4 {
//            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "WriteReview") as! WriteReview
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//        }
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objProductDetails {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let arrProduct = dicsResponse.value(forKey: "result") as? NSArray {
                    self.dicProductDetials = arrProduct.object(at: 0) as! NSDictionary
                    
                    
                    
                    
                    arrProductDetails = NSArray()
                     arrAssignedProduct = NSArray()
                    self.tblProductDetails.reloadData()
                    if let iswish = self.dicProductDetials.value(forKey: "ProductVeriant") as? NSArray
                    {
                        arrProductDetails = iswish
                    }
                    
                    
                    if let nCategoryId = self.dicProductDetials.value(forKey: "IsAccessories") as? NSNumber
                      {
                         if nCategoryId == 1
                         {
                          isZigzagOn = true
                          }
                          else
                         {
                          isZigzagOn = false
                          }
                      }
                      else if let nCategoryId = self.dicProductDetials.value(forKey: "IsAccessories") as? String
                      {
                         if nCategoryId == "1"
                         {
                       isZigzagOn = true
                          }
                          else
                         {
                          isZigzagOn = false
                          }
                      }
                    
                    if let iswish = self.dicProductDetials.value(forKey: "ProductVeriant") as? NSArray
                    {
                        arrProductDetails = iswish
                    }
                    
                    
                    if let iswish = self.dicProductDetials.value(forKey: "AssignedProduct") as? NSArray
                    {
                        arrAssignedProduct = iswish
                    }
                    if let iswish = self.dicProductDetials.value(forKey: "IswishList") as? NSNumber
                    {
                        if iswish == 1
                        {
                            buttonWishlist.setImage(UIImage.init(named: "love-and-romance")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
                            buttonWishlist.tintColor = UIColor.red
                        }
                        else
                        {
                             buttonWishlist.setImage(UIImage.init(named: "Heartremove")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
                            buttonWishlist.tintColor = UIColor.black
                        }
                    }
                    
                   
                    
                    
                    
                     if let currency = self.dicProductDetials.object(forKey: "Currency") as? String {
                        if let price1 = dicProductDetials.object(forKey: "fSamplePrice")  as? NSNumber {
                        let price = Float(truncating: price1)
                           
                            btnFeelit.setTitle(" \("lbl_btn_feel_it_for".setlocalized()) \(String(format: "\(currency) %.3f", price))", for: .normal)
                        }
                        
                    }
                    
                    
                    
                    if let stock = dicProductDetials.value(forKey: "fStock") as? NSNumber
                                       {
                                           stockQnty = Int(stock)
                                       }
                                       else if let stock = dicProductDetials.value(forKey: "fStock") as? String
                                       {
                                           stockQnty = Int(stock)!
                                       }
                    if let stock = dicProductDetials.value(forKey: "MinimumOrderQuantity") as? NSNumber
                    {
                        minstockQnty = Int(stock)
                    }
                    else if let stock = dicProductDetials.value(forKey: "MinimumOrderQuantity") as? String
                    {
                        minstockQnty = Int(stock)!
                    }
                    
                    if let stock = dicProductDetials.value(forKey: "fFeelItStock") as? NSNumber
                                       {
                                           fFeelItStock = Int(stock)
                                       }
                                       else if let stock = dicProductDetials.value(forKey: "MinimumOrderQuantity") as? String
                                       {
                                           fFeelItStock = Int(stock)!
                                       }
                    
                    
                    if fFeelItStock > 0
                    {
                        btnFeelit.backgroundColor = btnBackgroundColor
                        btnFeelit.setTitleColor(btnTitleColor, for: .normal)
                    }
                    else
                    {
                        btnFeelit.backgroundColor = UIColor.lightGray
                        btnFeelit.setTitleColor(btnTitleColor, for: .normal)
                    }
                    if let stock = dicProductDetials.value(forKey: "nUnitType") as? NSNumber
                    {
                        nUnitType = Int(stock)
                    }
                    else if let stock = dicProductDetials.value(forKey: "nUnitType") as? String
                    {
                        nUnitType = Int(stock)!
                    }
                    
                   
                    
                    if let iswish = self.dicProductDetials.value(forKey: "IsBundleProduct") as? NSNumber
                                       {
                                           if iswish == 1
                                           {
                                               qtyCount = 1
                                               btnFeelit.isHidden = true
                                           }
                                           else
                                           {
                                               qtyCount = 0
                                              // btnFeelit.isHidden = false
                                           }
                                       }
                                       
                    
                    arrUnit.removeAll()
                    if stockQnty > 0
                    {
                        for index in 1...stockQnty {
                                            
                                           arrUnit.append("\(index) \(arrunitName[nUnitType])")
                                           }
                    }
                  
                    print(self.dicProductDetials)
                    //qtyCount = 1
                    tblProductDetails.alpha = 0
                     self.tblProductDetails.reloadData()
                   
                    self.viewBottom.isHidden = true
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        let indexPath = NSIndexPath(row: 0, section: 0)
                        self.tblProductDetails.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                       
                        self.viewBottom.isHidden = true
                    }) { (true) in
                        self.viewBottom.isHidden = false
                         self.tblProductDetails.alpha = 1
                    }
                    self.tblProductDetails.reloadData()
                    self.tblProductDetails.reloadData()
                    self.view.layoutIfNeeded()
                    self.tblProductDetails.layoutIfNeeded()
                    
                    if let IsCartExists = self.dicProductDetials.object(forKey: "IsCartExists") as? NSNumber {
                                                             
                                           if IsCartExists == 1
                                           {
                                              btnFeelit.isHidden = true
                                          //btnAddCart.setTitle("lbl_ProductDetail_CheckYourCart".setlocalized().uppercased(), for: .normal)
                                           }
                                           else
                                           {
                                               btnFeelit.isHidden = false
                                            //   btnAddCart.setTitle(" \("lbl_ProductDetail_add_To_Cart".setlocalized())", for: .normal)
                                                                       
                                           }
                                       }
                    
                    
                                       
                }
            }
        }
        else if wrapper == objAddToCart {
            AppHelper.hideLoadingView()
             appDelegate.getCount()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                if iscart == false
                {
                    let logoutAlert = UIAlertController(title: "lbl_cartdialog_title".setlocalized(), message: "lbl_cartdialog_description".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                                                     
                    logoutAlert.addAction(UIAlertAction(title: "lbl_cartdialog_continue_shopping".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
                        self.back()
                    }))
                                                     
                    logoutAlert.addAction(UIAlertAction(title: "lbl_cartdialog_viewcart".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                                                         print("Handle Cancel Logic here")
                        self.GoInCart()
                                                     }))
                                                     
                    present(logoutAlert, animated: true, completion: nil)
                    
                    //AppHelper.showMessage(view: self.view, message:  "Lbl_message_add_tocart_successfully".setlocalized())
                }
                else
                {
                    
                    if UserDefaults.standard.object(forKey: "feelitPopup") == nil {
                                      UserDefaults.standard.set("en", forKey: "feelitPopup")
                        let modalViewController = FeelitPopup(nibName:"FeelitPopup",bundle: nil)
                                                          modalViewController.modalPresentationStyle = .overCurrentContext
                                                        modalViewController.delegate = self
                                           //               modalViewController.celltbl = cell
                                           //               modalViewController.isFromAppointMent = true
                                                          present(modalViewController, animated: true, completion: nil)
                    }
                    else
                    {
                        let logoutAlert = UIAlertController(title: "lbl_free_cartdialog_title".setlocalized(), message: "lbl_free_cartdialog_description".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                                                         
                        logoutAlert.addAction(UIAlertAction(title: "lbl_free_cartdialog_continue_shopping".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
                            self.back()
                        }))
                                                         
                        logoutAlert.addAction(UIAlertAction(title: "lbl_cartdialog_viewcart".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                                                             print("Handle Cancel Logic here")
                         self.GoInCart()
                                                         }))
                                                         
                        present(logoutAlert, animated: true, completion: nil)
                    }
                     
                    
                     
                }
               
                getProductDetails()
//                 self.viewBlack.isHidden = false
//                 self.view.addSubview(self.viewPopUp)
//                 self.lblAddedToCartTitle.text = "product_details_added_to_cart".setlocalized()
//                 self.lblAddedToCartDesc.text = "\(self.productName) \("product_details_was_added_to_your_shopping_cart".setlocalized())"
//                 self.btnOk.setTitle("btn_title_ViewCart".setlocalized(), for: .normal)
//                 
//                 self.btnShop.setTitle("btn_title_Shop".setlocalized(), for: .normal)
//                 
//                
//                 self.tblProductDetails.reloadData()
            }
        }
        else if wrapper == objAddWishlist {
                   AppHelper.hideLoadingView()
                   if dicsResponse.value(forKey: "Success") as! String == "1" {
                        getProductDetails()
                   }
               }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        AppHelper.hideLoadingView()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            appDelegate.SetTabBarItem(0)
        }
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

extension NSAttributedString {

    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptorSymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptorSymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }

        self.init(attributedString: attr)
    }

}
