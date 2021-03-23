//
//  Address.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Address: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HttpWrapperDelegate {

    @IBOutlet weak var btnAdd: UIButtonX!
    // MARK: - IBOutlets
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddnodata: UIButtonX!
    var isfromprofile = false
    // MARK: - Variables
     @IBOutlet weak var lblNoDataFound: UILabel!
       @IBOutlet weak var lblNODataDetail: UILabel!
    // MARK: - Variables
    @IBOutlet var viewNoDataFound: UIView!
    var searchBar = UISearchBar()
    var arrAddress:NSArray = NSArray()
    var objAddress = HttpWrapper()
    var objDeleteAddress = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var cellHeight:CGFloat = 0
    @IBOutlet weak var imgNoData: UIImageView!
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScrren = "Addresses"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        
        btnAdd.tintColor = btnBackgroundColor
        self.viewNoDataFound.frame.size.width = self.view.frame.size.width
               self.viewNoDataFound.frame.size.height = self.view.frame.size.height
               self.viewNoDataFound.isHidden = false
        // @IBOutlet weak var imgNoData: UIImageView!
          if let url = "lbl_NoData_address".setlocalized() as? String {
             imgNoData.cacheImage(urlString: url)
          }
        
        self.lblNoDataFound.text = "lbl_addresslist_nodata_title".setlocalized()
        self.lblNODataDetail.text = "lbl_addresslist_nodata_detail".setlocalized()
        self.btnAddnodata.setTitle("lbl_Address_add_address".setlocalized(), for: .normal)
        btnAddnodata.backgroundColor = btnBackgroundColor
        btnAddnodata.setTitleColor(btnTitleColor, for: .normal)
         self.view.addSubview(self.viewNoDataFound)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.viewNoDataFound.frame.size.width = self.view.frame.size.width
//        self.viewNoDataFound.frame.size.height = self.view.frame.size.height
//        self.lblNoDataFound.text = "home_no_data_found".setlocalized()
        //self.view.addSubview()
        self.addNavigationBar()
        self.getAllAddress()
        if UserDefaults.standard.value(forKey: kisMessage) != nil {
            AppHelper.showMessage(view: self.view, message: UserDefaults.standard.value(forKey: kisMessage) as! String)
            UserDefaults.standard.removeObject(forKey: kisMessage)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @objc func editAddress(sender: UITapGestureRecognizer) {
        let index = sender.view?.tag
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddress
        nextViewController.isEdit = true
        nextViewController.nAddressId = "\(index!)"
        nextViewController.nCustomerId = ""
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func delAddress(sender: UITapGestureRecognizer) {
        
        let index = sender.view?.tag
        
        let deleteAlert = UIAlertController(title: "App_name".setlocalized(), message: "lbl_Address_Delete_Detail".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAddress(id: "\(index!)")
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc func addNewAddress() {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddress
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func back()
    {
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
    
    
    @IBAction func onClickbtnAdd(_ sender: UIButton) {
         let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddress
          self.navigationController?.pushViewController(nextViewController, animated: true)
       }
    
    // MARK: - Custom Method
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getAllAddress()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteAddress(id:String) {
        let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
        let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
        
        let param = String(format: "%@?nAddressId=%@&nUserId=%@&cToken=%@", kDeleteAddress,id,"\(nUserId)",cToken)
        
        print(param)
        
        let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        AppHelper.showLoadingView()
        self.objDeleteAddress = HttpWrapper.init()
        self.objDeleteAddress.delegate = self
        self.objDeleteAddress.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
    }
    
    func getAllAddress () {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            let param = String(format: "%@?nCustomerId=%@&nUserId=%@&cToken=%@", kAllAddress,"\(nCustomerId)","\(nUserId)",cToken)
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objAddress = HttpWrapper.init()
            self.objAddress.delegate = self
            self.objAddress.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lblTitle.text = "lbl_Address_Titel".setlocalized()
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
        if section == 1 {
            if arrAddress.count == 0 {
                return 0
            }
            else {
                return arrAddress.count
            }
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
            cell.viewAddress.layer.cornerRadius = 10
            cell.viewAddress.layer.borderWidth = 0.5
            cell.viewAddress.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
            cell.viewAddress.clipsToBounds = true
            
            cell.btnEdit.layer.cornerRadius = cell.btnEdit.frame.size.height/2
            cell.btnEdit.clipsToBounds = true
            cell.btnEdit.setTitle("lbl_Address_edit".setlocalized(), for: .normal)
            cell.btnEdit.isHidden = true
            cell.btnDelete.layer.cornerRadius = 15
            cell.btnDelete.layer.borderWidth = 1
            cell.btnDelete.clipsToBounds = true
            cell.btnDelete.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
            if arrAddress.count == 0 {
                cell.viewAddress.isHidden = true
                cell.viewNoAddressFound.isHidden = false
                cell.lblNoAddressFound.text = "lbl_Address_no_address_found".setlocalized()
            }
            else {
                cell.viewAddress.isHidden = false
                cell.viewNoAddressFound.isHidden = true
                let dicAddress = arrAddress.object(at: indexPath.row) as! NSDictionary
                
                let editAddressTap = UITapGestureRecognizer(target: self, action: #selector(editAddress))
                editAddressTap.numberOfTapsRequired = 1
                cell.btnEdit.isUserInteractionEnabled = true
                
                let deleteAddressTap = UITapGestureRecognizer(target: self, action: #selector(delAddress))
                
                deleteAddressTap.numberOfTapsRequired = 1
                cell.btnDelete.isUserInteractionEnabled = true
                
                if let addressId = dicAddress.object(forKey: "nAddressId") as? NSNumber {
                    cell.btnEdit.tag = Int(truncating: addressId)
                    cell.btnDelete.tag = Int(truncating: addressId)
                }
                cell.btnDelete.addGestureRecognizer(deleteAddressTap)
                cell.btnEdit.addGestureRecognizer(editAddressTap)
                if let address = dicAddress.object(forKey: "cName") as? String {
                    
                    cell.lbltitle.text = address
                }
                
                if let address = dicAddress.object(forKey: "cAddressType") as? String {
                    
                    cell.lblType.text = address.uppercased()
                }
                else
                {
                    cell.lblType.text = ""
                }
                
                if let address = dicAddress.object(forKey: "cMobileNo") as? String {
                    
                    cell.lblMobile.text = address
                }

                let city = String(format:"%@ : %@","lbl_Address_City".setlocalized(), dicAddress.object(forKey: "cCityName") as! String)
                let area = String(format:"%@ : %@","lbl_Address_Area".setlocalized(), dicAddress.object(forKey: "cAreaName") as! String)
                let block = String(format:"%@ : %@","lbl_Address_block".setlocalized(), dicAddress.object(forKey: "cBlock") as! String)
                let street = String(format:"%@ : %@","lbl_Address_Street".setlocalized(), dicAddress.object(forKey: "cStreet") as! String)
                let BuildingNum = String(format:"%@ : %@","lbl_Address_BuildingNo".setlocalized(), dicAddress.object(forKey: "cBuildingNumber") as! String)
               
               let fulladdress = String(format:"%@ ,%@ ,%@ ,%@ ,%@",city,area,block,street,BuildingNum)
                cell.lblAddressDetails.text = fulladdress
//                if let address = dicAddress.object(forKey: "cAddress") as? String {
//                    let font = UIFont(name: RalewayRegular, size: 14)
//
//                    let height = AppHelper.heightForView(text: address, font: font!, width: self.view.frame.size.width)
//                    self.cellHeight = height
//                    cell.lblAddressDetails.text = address
//                }
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressNewAddressCell") as! AddressNewAddressCell
//            cell.btnAddAddress.layer.cornerRadius = cell.btnAddAddress.frame.size.height/2
//            cell.btnAddAddress.clipsToBounds = true
            cell.btnAddAddress.setTitle("lbl_Address_add_address".setlocalized(), for: .normal)
            cell.viewBack.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
            cell.viewBack.layer.cornerRadius = 10
            cell.viewBack.layer.borderWidth = 0.5
            
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                       if currentLanguage == "en" {
                        cell.btnAddAddress.titleLabel?.textAlignment = .left
                        
                      //  cell.btnAddAddress.setImage(#imageLiteral(resourceName: "ic_arrow_right_disabled"), for: .normal)
                       }
                       else{
                            cell.btnAddAddress.titleLabel?.textAlignment = .left
                         //  cell.btnAddAddress.setImage(#imageLiteral(resourceName: "ic_arrow_left_disabled"), for: .normal)
                       }
            
           // cell.btnAddAddress.backgroundColor = btnBackgroundColor
            let addNewAddressTap = UITapGestureRecognizer(target: self, action: #selector(addNewAddress))
            addNewAddressTap.numberOfTapsRequired = 1
            cell.btnAddAddress.isUserInteractionEnabled = true
            cell.btnAddAddress.tag = indexPath.row
            cell.btnAddAddress.addGestureRecognizer(addNewAddressTap)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicAddress = arrAddress.object(at: indexPath.row) as! NSDictionary
        if let addressId = dicAddress.object(forKey: "nAddressId") as? NSNumber {
           
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddress
            nextViewController.isEdit = true
            nextViewController.nAddressId = "\(addressId)"
            nextViewController.nCustomerId = ""
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
       
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objAddress {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrAddress = dicsResponse.value(forKey: "Result") as! NSArray
                self.tblAddress.reloadData()
                viewNoDataFound.isHidden = true
            }
            else{
                self.arrAddress = []
                self.tblAddress.reloadData()
                viewNoDataFound.isHidden = false
            }
        }
        else if wrapper == objDeleteAddress {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
                self.getAllAddress()
            }
            else{
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
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
