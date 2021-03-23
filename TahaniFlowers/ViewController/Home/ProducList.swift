//
//  ProducList.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 15/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIView {
    @IBInspectable var dropShadow: Bool {
        set{
            if newValue {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.4
                layer.shadowRadius = 1
                layer.shadowOffset = CGSize.zero
            } else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0
                layer.shadowRadius = 0
                layer.shadowOffset = CGSize.zero
            }
        }
        get {
            return layer.shadowOpacity > 0
        }
    }
}
public class CollectionViewFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ProducList: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,HttpWrapperDelegate,UITabBarControllerDelegate,SubcategoryDelegate,filterApplyDelegate {
    
    
    func FilterApply() {
        if isFeatureProducts == true {
            self.getFeatureProducts()
        }
        else if isFeelit == true
        {
            self.productsByCategory(ispaging: false)
        }
        else if searchText != "" {
           
            self.searchProducts(ispaging: false)
            if let url = "lbl_NoData_Search".setlocalized() as? String {
                      imgNoData.cacheImage(urlString: url)
                   }
        }
        else {
           if let url = "lbl_NoData_Productlist".setlocalized() as? String {
                                imgNoData.cacheImage(urlString: url)
                             }
            self.productsByCategory(ispaging: false)
            getSubCategory()
        }
    }
    
    func onselectSubcategory(nCategoryId: String, productName: String) {
        
        self.lblTitle.text = productName
        TotalRecord = 0
        self.nCategoryId = nCategoryId
        productsByCategory(ispaging: false)
    }
    
    func onselectSort()
    {
        let myAlert = objHomeSB.instantiateViewController(withIdentifier: "Sort_Vc")
               myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
               myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
               self.tabBarController?.tabBar.isHidden = true
               
               self.present(myAlert, animated: true, completion: nil)
    }

   // @IBOutlet weak var btnSort: UIButton!
    // MARK: - IBOutlets
    @IBOutlet weak var productListCollection: UICollectionView!
    @IBOutlet var viewNoDataFound: UIView!
     @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
    @IBOutlet weak var btnBackToShop: UIButtonX!
    private let footerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.white)

  //  @IBOutlet weak var lblTotalProducts: UILabel!
    
    @IBOutlet weak var imgNoData: UIImageView!
    
   // @IBOutlet weak var CollectionSubCat: UICollectionView!
    // MARK: - Variables
    var arrProducts :NSMutableArray = NSMutableArray()
    var searchBar = UISearchBar()
    var api = ""
    var isFromOrders:Bool = false
    var nCategoryId = ""
    var cCategoryName = ""
    var isFromTab:Bool = Bool()
    var isFeatureProducts:Bool!
    var objProductsByCategory = HttpWrapper()
    var objSearch = HttpWrapper()
    var objFeatureProducts = HttpWrapper()
    var userDefaults = UserDefaults.standard
    var searchText = ""
    var nParentCateogyId = ""
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var objSubCategory = HttpWrapper()
    var arrCategoryList:NSArray = NSArray()
    var IsSubCategory = false
    var pageTo = 1
    var pageFrom = 10
    var TotalRecord = 0
    var isFeelit = false
    @IBOutlet weak var lblTitle: UILabel!
    var isCheckFistTime : Bool = false
    //var isFirstTime:Bool!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListCollection.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
               (productListCollection.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: productListCollection.bounds.width, height: 50)

       
//        CollectionSubCat.delegate = self
//        CollectionSubCat.dataSource = self
//        CollectionSubCat.reloadData()
        // Do any additional setup after loading the view.
        self.tabBarController?.delegate = self
        self.viewNoDataFound.frame.size.width = self.view.frame.size.width
        self.viewNoDataFound.frame.size.height = self.view.frame.size.height
        self.lblNoDataFound.text = "lbl_prodcutlist_nodata_title".setlocalized()
        self.lblNODataDetail.text = "lbl_productlist_nodata_detail".setlocalized()
        self.btnBackToShop.setTitle("placed_order_go_back".setlocalized(), for: .normal)
        
        self.btnBackToShop.backgroundColor = btnBackgroundColor
        self.btnBackToShop.setTitleColor(btnTitleColor, for: .normal)
       
        currentScrren = "ProductList"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleModalDismissed),
                                               name: NSNotification.Name(rawValue: "modalIsDimissed"),
                                               object: nil)
        if isFeatureProducts == true {
            self.getFeatureProducts()
        }
        else if isFeelit == true
        {
            self.productsByCategory(ispaging: false)
        }
        else if searchText != "" {
           
            self.searchProducts(ispaging: false)
            if let url = "lbl_NoData_Search".setlocalized() as? String {
                      imgNoData.cacheImage(urlString: url)
                   }
        }
        else {
           if let url = "lbl_NoData_Productlist".setlocalized() as? String {
                                imgNoData.cacheImage(urlString: url)
                             }
            self.productsByCategory(ispaging: false)
            getSubCategory()
        }

    }

    @objc func handleModalDismissed() {
         self.tabBarController?.tabBar.isHidden = false
        productsByCategory(ispaging: false)
        // Do something
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.addNavigationBar()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [unowned self] in
//            //self.functionToCall()
//            DispatchQueue.main.async() {
//                // your UI update code
//                let obj = ProductListHeaderCollection_Cell()
//                obj.CollectionSubCat.scrollToItem(at:IndexPath(item: 1, section: 0), at: .left, animated: false)
////                UIView.animate(withDuration: 0.8) {
////                    obj.CollectionSubCat.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: true)
////                }
//            }
//        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - @objc Actions
    
    @objc func back() {
        if isFromOrders == true
        {
            appDelegate.SetTabBarItem(0)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
        appDelegate.SetTabBarItem(0)
    }
    
    @IBAction func onClickBtnFilter(_ sender: UIButton) {
                
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Filter_Vc") as! Filter_Vc
        nextViewController.delegate = self
        nextViewController.nCategoryId = self.nCategoryId
      self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func onClickBtnSort(_ sender: UIButton) {
        let myAlert = objHomeSB.instantiateViewController(withIdentifier: "Sort_Vc")  
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.tabBarController?.tabBar.isHidden = true
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Wishlist_Vc") as! Wishlist_Vc
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
    
    @objc func gotoProductDetails(sender:UITapGestureRecognizer) {
        let index = sender.view?.tag
        let productDetails = arrProducts.object(at: index!) as! NSDictionary
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
    
    // MARK: - Custom Methods
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                if self.isFeatureProducts == true {
                    self.getFeatureProducts()
                }
                else if self.searchText != "" {
                    self.searchProducts(ispaging: false)
                }
                else {
                    self.productsByCategory(ispaging: false)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getSubCategory() {
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
               let parentCateogyId = self.nParentCateogyId
               let cToken = userDefaults.value(forKey: kcToken) as! String
               
               var param:String = ""
               
               param = String(format: "%@?nUserId=%@&nLanguageId=%@&nParentCategoryId=%@&cToken=%@", kSubCategory,"\(nUserId)","\(nLanguageId)","\(nCategoryId)","\(cToken)")
               
               AppHelper.showLoadingView()
               self.objSubCategory = HttpWrapper.init()
               self.objSubCategory.delegate = self
               self.objSubCategory.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
           }
       }
    func getFeatureProducts() {
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
            
            AppHelper.showLoadingView()
            self.objFeatureProducts = HttpWrapper.init()
            self.objFeatureProducts.delegate = self
            self.objFeatureProducts.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
        
    }
    
    func searchProducts(ispaging:Bool) {
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
            
             if ispaging == true
                               {
                                   
                               }
                               else
                               {
                                   
                                   self.arrProducts = NSMutableArray()
            //                       self.arrdata = NSMutableArray()
                                   pageTo = 1
                                   pageFrom = 10
                               }
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&cSearchString=%@&cToken=%@&nFromId=%@&nToId=%@", kSearchProduct,"\(nUserId)","\(nLanguageId)","\(searchText)","\(cToken)","\(pageTo)","\(pageFrom)")
            
            AppHelper.showLoadingView()
            self.objSearch = HttpWrapper.init()
            self.objSearch.delegate = self
            self.objSearch.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func productsByCategory(ispaging:Bool){
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
            let categoryId = self.nCategoryId
            let cToken = userDefaults.value(forKey: kcToken) as! String
            
            if ispaging == true
            {
                
            }
            else
            {
                
                self.arrProducts = NSMutableArray()
                //                       self.arrdata = NSMutableArray()
                pageTo = 1
                pageFrom = 10
            }
            
            var strfilter = ""
            if appDelegate.FilterDataArray.count > 0
            {
                
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: appDelegate.FilterDataArray)
                let jsonString = String(data: jsonData!, encoding: .utf8)
                strfilter = jsonString!
            }
            
            var param:String = ""
            
            if isFeelit == true
            {
                param = String(format: "%@?nUserId=%@&nLanguageId=%@&nCategoryId=%@&cToken=%@&cFilterType=%@&nFromId=%@&nToId=%@", kGetFeelItMostSellerProduct,"\(nUserId)","\(nLanguageId)","\(categoryId)","\(cToken)","\(appDelegate.Filtertype)","\(pageTo)","\(pageFrom)")
            }
            else
            {
                param = String(format: "%@?nUserId=%@&nLanguageId=%@&nCategoryId=%@&cToken=%@&nFilterType=%@&nFromId=%@&nToId=%@&cAttributeJsonData=%@", kProductByCategory,"\(nUserId)","\(nLanguageId)","\(categoryId)","\(cToken)","\(appDelegate.Filtertype)","\(pageTo)","\(pageFrom)",strfilter)
            }
            
            let escapedString = param.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            AppHelper.showLoadingView()
            self.objProductsByCategory = HttpWrapper.init()
            self.objProductsByCategory.delegate = self
        self.objProductsByCategory.requestWithparamdictParamPostMethodwithHeaderGet(url: escapedString, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        if searchText != "" {
            lblTitle.text = self.searchText
        }
        else {
            lblTitle.text = cCategoryName //"lbl_home_title".setlocalized()
        }
        
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = UIColor.white
         viewNoDataFound.backgroundColor  = UIColor.white//navigationbarColor
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
        
        if isFromTab == true
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        else
        {
            self.navigationItem.leftBarButtonItem = barButtonBack
        }
        
        
        let buttonSearch = UIButton.init(type: .custom)
        buttonSearch.setImage(UIImage.init(named: "ic_search"), for: UIControlState.normal)
        buttonSearch.addTarget(self, action:#selector(addSarchBar), for: UIControlEvents.touchUpInside)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 20, height: 20)
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
      // self.navigationItem.rightBarButtonItems = [barButtonSearch]
        if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                          //  self.navigationItem.rightBarButtonItems = [barButtonLanguage]
                      }
               else
               {
                    //self.navigationItem.rightBarButtonItems = [barButtonSearch]
               }
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
       // searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - Collectionview Delegates

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return self.arrProducts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionCell", for: indexPath) as! ProductListCollectionCell
        let dicProduct = self.arrProducts.object(at: indexPath.row) as! NSDictionary
        cell.lblProductName.text = ""
        cell.lblPrice.text = ""
        //        cell.contentView.layer.borderWidth = 0.5
        //        cell.contentView.layer.borderColor = UIColor.black.cgColor
        if let url = dicProduct.object(forKey: "cImage") as? String {
            cell.imgProduct.cacheImage(urlString: url)
        }
        else
        {
            cell.imgProduct.image = UIImage(named:"productlistPlaceholder")
        }
        
        if let productName = dicProduct.object(forKey: "cName") as? String {
            cell.lblProductName.text = productName
        }
        
        if let productDesc = dicProduct.object(forKey: "cShortDescription") as? String {
            cell.lblProductDesc.text = productDesc
        }
        
        if let currency = dicProduct.object(forKey: "Currency") as? String {
            
            if let spcialprice1 = dicProduct.object(forKey: "fSpecialPrice")  as? NSNumber {
                
                if Float(truncating: spcialprice1) > Float(0)
                {
                    if let price1 = dicProduct.object(forKey: "fPrice")  as? NSNumber {
                        let price = Float(truncating: price1)
                        let spcprice = Float(truncating: spcialprice1)
                        
                        let full = "\(currency) \(String(format: "%.3f", price)) \(currency) \(String(format: "%.3f", spcprice))"
                        
                        cell.lblPrice.attributedText = appDelegate.setAttributedPrice(Priceone: "\(currency) \(String(format: "%.3f", price))", pricetwo: "\(currency) \(String(format: "%.3f", spcprice))", Fullstring: full, Font: cell.lblPrice.font)
                        //cell.lblPrice.text = "\(currency) \(String(format: "%.3f", price))"
                    }
                    
                    
                }
                else{
                    if let price1 = dicProduct.object(forKey: "fPrice")  as? NSNumber {
                        let price = Float(truncating: price1)
                        
                        cell.lblPrice.text = "\(currency) \(String(format: "%.3f", price))"
                    }
                }
                
            }
            
            
        }
        
        let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductDetails))
        openProductGesture.numberOfTapsRequired = 1
        cell.viewProduct.isUserInteractionEnabled = true
        cell.viewProduct.tag = indexPath.row
        
        
        
        
        cell.viewProduct.addGestureRecognizer(openProductGesture)
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         return CGSize(width: (collectionView.frame.size.width)/2, height: collectionView.frame.size.width/2+80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == CollectionSubCat
//        {
//            let dicProduct = self.arrCategoryList.object(at: indexPath.row) as! NSDictionary
//            
//            if let productName = dicProduct.object(forKey: "cCategoryName") as? String
//            {
//                self.lblTitle.text = productName
//            }
//            
//            if let id = dicProduct.object(forKey: "nCategoryId") as? NSNumber
//            {
//                nCategoryId = "\(id)"
//            }
//            TotalRecord = 0
//            CollectionSubCat.reloadData()
//            productsByCategory(ispaging: false)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
        if collectionView == productListCollection
        {
             if !(indexPath.row + 1 < self.arrProducts.count) {
                        
                        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                        spinner.startAnimating()
            //            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            //
            //            self.tableview.tableFooterView = spinner
            //            self.tableview.tableFooterView?.isHidden = false
                        
                        // self.isLoading = true;
                        pageTo = pageFrom + 1
                        
                        pageFrom += 10
                        
                        if arrProducts.count < TotalRecord
                        {
                            
                            if searchText != ""
                            {
                                self.searchProducts(ispaging: true)
                            }
                            else
                            {
                                productsByCategory(ispaging: true)
                            }
                            
                           
                        }
                        else
                        {
                            
                        }
                        
                        
                    }
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
         if searchText != "" {
            return CGSize(width: collectionView.frame.size.width, height: 0)
         }
        else if IsSubCategory == false
        {
             return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width, height: 180)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
              if kind == UICollectionElementKindSectionFooter {
                  let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
                  footer.addSubview(footerView)
                  footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
                  return footer
              }
              else if kind == UICollectionElementKindSectionHeader
              {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductListHeaderCollection_Cell", for: indexPath) as? ProductListHeaderCollection_Cell else {
                                   fatalError("Invalid view type")
                           }
                
                headerView.delegate = self
                if IsSubCategory == false
                {
                    headerView.subcategoryHeightCostant.constant = 0
                }
                headerView.nCategoryId = nCategoryId
                headerView.lblTotalProducts.text = "\(TotalRecord) \("lbl_Productlist_CountText".setlocalized())"
                headerView.arrCategoryList = arrCategoryList
                headerView.CollectionSubCat.reloadData()
                
                print("Category count..\(arrCategoryList.count)")
                if arrCategoryList.count != 0 {
                
                    if isCheckFistTime == false {
                        UIView.animate(withDuration: 0.3, animations: {
                            
                        }) { (true) in
                            
                            DispatchQueue.main.async() {
                               headerView.CollectionSubCat.scrollToItem(at:IndexPath(item: 1, section: 0), at: .left, animated: true)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in

                                UIView.animate(withDuration: 0.3) {
                                    DispatchQueue.main.async() {
                                       headerView.CollectionSubCat.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: true)
                                        self.isCheckFistTime = true
                                    }
                                }
                            }
                        }
                    }
                    
                }
                return headerView
              }
              return UICollectionReusableView()
    }
    
    // MARK: - Searchbar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //    self.searchText = searchBar.text!
        self.searchText = searchBar.text!
//        self.searchProducts()
        
    }
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objProductsByCategory {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                if let StrTemp = dicsResponse.value(forKey: "nTotalRecords") as? String {
                    self.TotalRecord =  Int(StrTemp)!
                }
                else if let StrTemp = dicsResponse.value(forKey: "nTotalRecords") as? NSNumber {
                    self.TotalRecord =  Int(truncating: StrTemp)
                }
                
                
                if let products = dicsResponse.value(forKey: "result") as? NSArray {
                    //   self.arrProducts = products
                    
                    self.arrProducts.addObjects(from: products as [AnyObject])
                    self.productListCollection.reloadData()
                }
            }
            else {
                //if TotalRecord < 0
                //{
                    // lblTotalProducts.text = "lbl_Productlist_NoProducts".setlocalized()
                    self.arrProducts = NSMutableArray()
                    self.productListCollection.reloadData()
                //}
                
                //                self.viewNoDataFound.isHidden = false
                //                self.view.addSubview(self.viewNoDataFound)
                //                self.productListCollection.isHidden = true
            }
        }
        else if wrapper == objSubCategory {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let categoryList = dicsResponse.object(forKey: "result") as? NSArray {
                    self.arrCategoryList = categoryList
                }
                self.productListCollection.reloadData()
                // self.CollectionSubCat.reloadData()
            }
            else {
                self.productListCollection.reloadData()
                //                self.collectionSubcategory.isHidden = true
                //                self.viewNoDataFound.isHidden = false
            }
        }
        else if wrapper == objFeatureProducts {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let products = dicsResponse.value(forKey: "result") as? NSArray {
                    self.arrProducts.addObjects(from: products as [AnyObject])
                    self.productListCollection.reloadData()
                }
            }
            else {
                self.viewNoDataFound.isHidden = false
                self.view.addSubview(self.viewNoDataFound)
                self.productListCollection.isHidden = true
            }
        }
        else if wrapper == objSearch {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                if let StrTemp = dicsResponse.value(forKey: "nTotalRecords") as? String {
                    self.TotalRecord =  Int(StrTemp)!
                }
                else if let StrTemp = dicsResponse.value(forKey: "nTotalRecords") as? NSNumber {
                    self.TotalRecord =  Int(truncating: StrTemp)
                }
                
                //  lblTotalProducts.text = "\(TotalRecord) \("lbl_Productlist_CountText".setlocalized())"
                
                if let products = dicsResponse.value(forKey: "result") as? NSArray {
                    self.arrProducts.addObjects(from: products as [AnyObject])
                    self.productListCollection.reloadData()
                }
            }
            else {
                if TotalRecord < 0
                {
                    // lblTotalProducts.text = "lbl_Productlist_NoProducts".setlocalized()
                    self.arrProducts = NSMutableArray()
                    self.productListCollection.reloadData()
                }
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


