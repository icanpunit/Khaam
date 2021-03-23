//
//  ProductCategory.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 15/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LNSideMenu

class ProductCategory: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,HttpWrapperDelegate,UITabBarDelegate,UITabBarControllerDelegate {
   
    // MARK: - IBOutlets
    
 
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var productCategoryCollection: UICollectionView!
    @IBOutlet var viewNodataFound: UIView!
     @IBOutlet weak var lblNoDataFound: UILabel!
     
       @IBOutlet weak var lblNODataDetail: UILabel!
    @IBOutlet weak var btnBackToShop: UIButtonX!
    @IBOutlet weak var imgNoData: UIImageView!
    
    // MARK: - Variables
    var searchBar = UISearchBar()
    let userDefaults = UserDefaults.standard
    var api = ""
    var nCategoryId = ""
    var nParentCateogyId = ""
    var cCategoryName = ""
    var isCategory:Bool!
    var isSubCategory:Bool = false
    var arrProducts:NSArray = NSArray()
    var arrCategoryList:NSArray = NSArray()
    var objProductCategory = HttpWrapper()
    var objSubCategory = HttpWrapper()
    var objCategoryList = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var isFromTab = false
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScrren = "ProductCategory"
        self.tabBarController?.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar()
        if isCategory == true {
            self.getCategoryList()
        }

        if isSubCategory == true {
            self.getSubCategory()
//            isSubCategory = false
        }
        
        self.view.addSubview(self.viewNodataFound)
        self.viewNodataFound.frame.size.width = self.view.frame.size.width
        self.viewNodataFound.frame.size.height = self.view.frame.size.height
        self.viewNodataFound.isHidden = true
        self.lblNoDataFound.text = "lbl_categorylist_nodata_title".setlocalized()
        self.lblNODataDetail.text = "lbl_categorylist_nodata_detail".setlocalized()
        self.btnBackToShop.setTitle("placed_order_go_back".setlocalized(), for: .normal)
        // @IBOutlet weak var imgNoData: UIImageView!
               if let url = "lbl_NoData_Category".setlocalized() as? String {
                  imgNoData.cacheImage(urlString: url)
               }
        
//
//        var viewControllers = navigationController?.viewControllers
//        
//        viewControllers?.remove(at: 1) //here 2 views to pop index numbers of views
//        
//        navigationController?.setViewControllers(viewControllers!, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - @objc Actions
    
    @objc func back() {
        appDelegate.SetTabBarItem(0)
    }
    
    
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
        appDelegate.SetTabBarItem(0)
    }
    
    @objc func changeLanguage () {
        
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
    
    @objc func gotoProductListing(sender:UITapGestureRecognizer) {
        let index = sender.view?.tag
        if let dictProduct = self.arrCategoryList.object(at: index!) as? NSDictionary {
            var isSubCategory = ""

            if let nSubCategoryId = dictProduct.object(forKey: "IsSubCategory") as? String
            {
                isSubCategory = nSubCategoryId
            }
            
            
            if isSubCategory == "1" {
                if let nCategoryId = dictProduct.object(forKey: "nCategoryId") as? NSNumber {
                    let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                    nextViewController.nCategoryId = "\(nCategoryId)"
                    if let cCategoryName = dictProduct.object(forKey: "cCategoryName") as? String {
                        nextViewController.cCategoryName = cCategoryName
                    }
                    nextViewController.IsSubCategory = true
                    nextViewController.api = kProductByCategory
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
            else
            {
                if let nCategoryId = dictProduct.object(forKey: "nCategoryId") as? NSNumber {
                    let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
                    nextViewController.nCategoryId = "\(nCategoryId)"
                    if let cCategoryName = dictProduct.object(forKey: "cCategoryName") as? String {
                        nextViewController.cCategoryName = cCategoryName
                    }
                    nextViewController.IsSubCategory = false
                    nextViewController.api = kProductByCategory
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
             
        }
    }
    
    // MARK: - Custom Methods
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                if self.isCategory == true {
                    self.getCategoryList()
                }
                
                if self.isSubCategory == true {
                    self.getSubCategory()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getCategoryList() {
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
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&cToken=%@", kCategoryList,"\(nUserId)","\(nLanguageId)","\(cToken)")
            
            AppHelper.showLoadingView()
            self.objCategoryList = HttpWrapper.init()
            self.objCategoryList.delegate = self
            self.objCategoryList.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
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
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nParentCategoryId=%@&cToken=%@", kSubCategory,"\(nUserId)","\(nLanguageId)","\(parentCateogyId)","\(cToken)")
            
            AppHelper.showLoadingView()
            self.objSubCategory = HttpWrapper.init()
            self.objSubCategory.delegate = self
            self.objSubCategory.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func getProductCategory(){
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
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&nCategoryId=%@&cToken=%@", kProductByCategory,"\(nUserId)","\(nLanguageId)","\(categoryId)","\(cToken)")
            
            AppHelper.showLoadingView()
            self.objProductCategory = HttpWrapper.init()
            self.objProductCategory.delegate = self
            self.objProductCategory.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lblTitle.text = "lbl_Category_Title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        
        viewNodataFound.backgroundColor  = navigationbarColor
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
        
        
        let buttonSearch = UIButton.init(type: .custom)
        buttonSearch.setImage(UIImage.init(named: "ic_tab_cart"), for: UIControlState.normal)
        buttonSearch.addTarget(self, action:#selector(addSarchBar), for: UIControlEvents.touchUpInside)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 30, height: 30)
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "ic_menu"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 30, height: 30)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
       // self.navigationItem.rightBarButtonItems = [barButtonLanguage,barButtonSearch]
        
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCollectionCell", for: indexPath) as! ProductCategoryCollectionCell
        
        cell.btnNext.image = UIImage(named: "ic_back_ar")?.withRenderingMode(.alwaysTemplate)
               cell.btnNext.tintColor = UIColor.white
        if let dicProduct = arrCategoryList.object(at: indexPath.row) as? NSDictionary {
            if let nameProduct = dicProduct.object(forKey: "cCategoryName") as? String {
                cell.lblProductCategoryName.text = nameProduct
            }
            

            if let descProduct = dicProduct.object(forKey: "cCategoryDesc") as? String {
                cell.lblProductCategoryDesc.text = descProduct
            }
            
            if let urlImage = dicProduct.object(forKey: "cCategoryImage") as? String {
                cell.imgProductCategory.cacheImage(urlString: urlImage)
            }

            let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductListing))
            openProductGesture.numberOfTapsRequired = 1
            cell.viewProductCategory.isUserInteractionEnabled = true
            cell.viewProductCategory.tag = indexPath.row
            cell.viewProductCategory.addGestureRecognizer(openProductGesture)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0 )
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objProductCategory {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let products = dicsResponse.value(forKey: "result") as? NSArray {
                    self.arrProducts = products
                    self.productCategoryCollection.reloadData()
                }
            }
            else {
                self.productCategoryCollection.isHidden = true
                self.viewNodataFound.isHidden = false
            }
        }
        else if wrapper == objCategoryList {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let categoryList = dicsResponse.object(forKey: "result") as? NSArray {
                    self.arrCategoryList = categoryList
                }
                self.productCategoryCollection.reloadData()
                self.productCategoryCollection.isHidden = false
                self.viewNodataFound.isHidden = true
            }
            else {
                self.productCategoryCollection.isHidden = true
                self.viewNodataFound.isHidden = false
            }
        }
        
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
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
