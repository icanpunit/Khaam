//
//  VendorProductlist.swift
//  TahaniFlowers
//
//  Created by baps on 16/06/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VendorProductlist: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,HttpWrapperDelegate,UITabBarControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var productListCollection: UICollectionView!
    @IBOutlet var viewNoDataFound: UIView!
     @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
    @IBOutlet weak var btnBackToShop: UIButtonX!
    private let footerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.white)

    @IBOutlet weak var lblTotalProducts: UILabel!
    
    @IBOutlet weak var subcategoryHeightCostant: NSLayoutConstraint!
    @IBOutlet weak var CollectionSubCat: UICollectionView!
    // MARK: - Variables
    var arrProducts :NSMutableArray = NSMutableArray()
    var searchBar = UISearchBar()
    var api = ""
    var nCategoryId = "0"
    var nvendorid = ""
    var cCategoryName = ""
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
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListCollection.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
               (productListCollection.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: productListCollection.bounds.width, height: 50)

        if IsSubCategory == false
        {
            subcategoryHeightCostant.constant = 0
        }
        CollectionSubCat.delegate = self
        CollectionSubCat.dataSource = self
        CollectionSubCat.reloadData()
        // Do any additional setup after loading the view.
        self.tabBarController?.delegate = self
        self.viewNoDataFound.frame.size.width = self.view.frame.size.width
        self.viewNoDataFound.frame.size.height = self.view.frame.size.height
        self.lblNoDataFound.text = "lbl_Productlist_NoData_Title".setlocalized()
        self.lblNODataDetail.text = "lbl_Productlist_NoDataDetail".setlocalized()
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
        else if searchText != "" {
            self.searchProducts()
        }
        else {
            self.productsByCategory(ispaging: false)
            getSubCategory()
        }

    }

     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionElementKindSectionFooter {
               let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
               footer.addSubview(footerView)
               footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
               return footer
           }
           return UICollectionReusableView()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - @objc Actions
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
        appDelegate.SetTabBarItem(0)
    }
    
    @IBAction func onClickBtnFilter(_ sender: UIButton) {
        
      
        
//        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Filter_Vc") as! Filter_Vc
//        self.navigationController?.pushViewController(nextViewController, animated: true)
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
                    self.searchProducts()
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
               
               param = String(format: "%@?nUserId=%@&nLanguageId=%@&nVendorId=%@&cToken=%@", kGetVendorProductWiseCategoryList,"\(nUserId)","\(nLanguageId)","\(nvendorid)","\(cToken)")
               
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
    
    func searchProducts() {
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
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&cSearchString=%@&cToken=%@", kSearchProduct,"\(nUserId)","\(nLanguageId)","\(searchText)","\(cToken)")
            
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
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nVendorId=%@&nCategoryId=%@&cToken=%@&cFilterType=%@&nFromId=%@&nToId=%@", kSelectAllVendorProduct,"\(nUserId)","\(nLanguageId)","\(nvendorid)","\(categoryId)","\(cToken)","\(appDelegate.Filtertype)","\(pageTo)","\(pageFrom)")
            
            AppHelper.showLoadingView()
            self.objProductsByCategory = HttpWrapper.init()
            self.objProductsByCategory.delegate = self
            self.objProductsByCategory.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
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
        buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
      // self.navigationItem.rightBarButtonItems = [barButtonSearch]
        if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                            self.navigationItem.rightBarButtonItems = [barButtonLanguage,barButtonSearch]
                      }
               else
               {
                    self.navigationItem.rightBarButtonItems = [barButtonSearch]
               }
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - Collectionview Delegates

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == CollectionSubCat
        {
            return arrCategoryList.count
        }
        else
        {
            return self.arrProducts.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CollectionSubCat
              {
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCollection_Cell", for: indexPath) as! SubcategoryCollection_Cell
                cell.viewBack.layer.cornerRadius = cell.viewBack.frame.height/2
                let dicProduct = self.arrCategoryList.object(at: indexPath.row) as! NSDictionary
                
                if let url = dicProduct.object(forKey: "cCategoryIcon") as? String {
                    cell.imgIcon.cacheImage(urlString: url)
                }
                                         
                 if let productName = dicProduct.object(forKey: "cCategoryName") as? String {
                     cell.lblTitle.text = productName
                 }
                 cell.imgIcon.image = cell.imgIcon.image?.withRenderingMode(.alwaysTemplate)
                
                if let url = dicProduct.object(forKey: "cCategoryIcon") as? String {
                    cell.imgIcon.cacheImage(urlString: url)
                }
                
                if let id = dicProduct.object(forKey: "nCategoryId") as? NSNumber {
                    
                    if "\(id)" == nCategoryId
                                   {
                                       cell.viewBack.backgroundColor = UIColor.white
                                       cell.imgIcon.tintColor = .black
                                       cell.lblTitle.isHidden = false
                                       cell.imgHeight.constant = 30
                                       cell.imgWidth.constant = 30
                                       cell.imgCenterConstant.constant = -10
                                   }
                                   else
                                   {
                                       cell.imgHeight.constant = 40
                                       cell.imgWidth.constant = 40
                                       cell.viewBack.backgroundColor = UIColor.clear
                                        cell.imgIcon.tintColor = .lightGray
                                       cell.lblTitle.isHidden = true
                                       cell.imgCenterConstant.constant = 0
                                   }
                                  
                }
                
                
               
                        return cell
              }
              else
              {
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionCell", for: indexPath) as! ProductListCollectionCell
                          let dicProduct = self.arrProducts.object(at: indexPath.row) as! NSDictionary
                          
                  //        cell.contentView.layer.borderWidth = 0.5
                  //        cell.contentView.layer.borderColor = UIColor.black.cgColor
                          if let url = dicProduct.object(forKey: "cImage") as? String {
                              cell.imgProduct.cacheImage(urlString: url)
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
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == CollectionSubCat
                    {
                        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        }
        else
        {
            return CGSize(width: (collectionView.frame.size.width)/2, height: collectionView.frame.size.width/1.5)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CollectionSubCat
        {
            let dicProduct = self.arrCategoryList.object(at: indexPath.row) as! NSDictionary
            
            if let productName = dicProduct.object(forKey: "cCategoryName") as? String
            {
                self.lblTitle.text = productName
            }
            
            if let id = dicProduct.object(forKey: "nCategoryId") as? NSNumber
            {
                nCategoryId = "\(id)"
            }
            TotalRecord = 0
            CollectionSubCat.reloadData()
            productsByCategory(ispaging: false)
        }
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
                           productsByCategory(ispaging: true)
                        }
                        else
                        {
                            
                        }
                        
                        
                    }
        }
       
        
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
                
                lblTotalProducts.text = "\(TotalRecord) \("lbl_Productlist_CountText".setlocalized())"
                if let products = dicsResponse.value(forKey: "result") as? NSArray {
                 //   self.arrProducts = products
                    
                     self.arrProducts.addObjects(from: products as [AnyObject])
                    self.productListCollection.reloadData()
                }
            }
            else {
                
                
                if TotalRecord == 0
                {
                    lblTotalProducts.text = "lbl_Productlist_NoProducts".setlocalized()
                    self.arrProducts = NSMutableArray()
                                   self.productListCollection.reloadData()
                }
               
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
                self.CollectionSubCat.reloadData()
            }
            else {
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
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        
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


