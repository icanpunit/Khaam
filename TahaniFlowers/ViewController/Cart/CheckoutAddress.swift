//
//  CheckoutAddress.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckoutAddress: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HttpWrapperDelegate,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, GovernetsSelectCartDelegate,ProjectList_VCCartDelegate {
    
    
 func SelectGoverenate(_ dics: NSDictionary, cell: CheckoutAddNewAddress) {
     
     cell.txtSelectArea.text = ""
     if let value = dics.value(forKey: "cCityName") as? String
     {
         cell.txtSelectGovernate.text = value
     }
     
     if let value = dics.value(forKey: "nCityId") as? NSNumber
     {
         nCityId = "\(value)"
     }
     
     
     
 }
 
 func SelectArea(_ dics: NSDictionary, cell: CheckoutAddNewAddress) {
     
     if let value = dics.value(forKey: "cAreaName") as? String
     {
         cell.txtSelectArea.text = value
     }
     
     if let value = dics.value(forKey: "nAreaId") as? NSNumber
     {
         nAreaId = "\(value)"
     }
     
     
 }
 

 
 func onclickselectGovernate(cell:CheckoutAddNewAddress) {
     let modalViewController = ProjectList_VC(nibName:"ProjectList_VC",bundle: nil)
     modalViewController.modalPresentationStyle = .overCurrentContext
     modalViewController.delegates2 = self
    modalViewController.isCart = true
     modalViewController.celltbl = cell
     modalViewController.isFromAppointMent = true
     present(modalViewController, animated: true, completion: nil)
 }
 
 func onclickselectArea(cell:CheckoutAddNewAddress) {
     let modalViewController = ProjectList_VC(nibName:"ProjectList_VC",bundle: nil)
     modalViewController.modalPresentationStyle = .overCurrentContext
     modalViewController.delegates2 = self
    modalViewController.isCart = true

     modalViewController.celltbl = cell
     modalViewController.nCityId =  nCityId
     modalViewController.isFromAppointMent = false
     present(modalViewController, animated: true, completion: nil)
 }
    
    @IBOutlet weak var lblBookingSavedAddress: UILabel!
    @IBOutlet weak var btnBookingAddAddress: UIButton!
    @IBOutlet weak var viewBookingHeader: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var segHeader: UISegmentedControl!
     @IBOutlet weak var lblShippingAddress: UILabel!
     var AddressType = 0
    var isfirstTime = false
    // MARK: - IBOUtltes
    var nCityId:String = String()
       var nAreaId:String = String()
    @IBOutlet weak var tblCheckoutAddress: UITableView!
    @IBOutlet var tblAddNewAddress: UITableView!
    @IBOutlet weak var viewNewAddress: UIView!
    @IBOutlet weak var viewNewAddressBottomMargin: NSLayoutConstraint!
    @IBOutlet var viewSubDateTime: UIView!
    @IBOutlet weak var collectionDateTime: UICollectionView!
    @IBOutlet weak var viewDateTimePicker: UIView!
    @IBOutlet weak var viewHeightDateTimePicker: NSLayoutConstraint!
    @IBOutlet weak var bottomMarginDateTimePicker: NSLayoutConstraint!
    @IBOutlet weak var viewBlackShadow: UIView!
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblbottomspaceconstant: NSLayoutConstraint!
    @IBOutlet weak var lblSelectTime: UILabel!
    @IBOutlet weak var collectionTime: UICollectionView!
    @IBOutlet weak var btnSubmit: UIButton!
    var nCartType = "1"
    @IBOutlet weak var lblDeliveryOptions: UILabel!
    @IBOutlet weak var lblDeliveryTimeMessage: UILabel!
     var objSignup  = HttpWrapper()
    var isGuest = false
     @IBOutlet weak var lblTitle: UILabel!
    // MARK: - Variables
    var searchBar = UISearchBar()
    var strName:String = ""
     var strEmail:String = ""
    var strMobileNo:String = ""
    var strAlternateNo:String = ""
    var strSelectArea:String = ""
    var strBlock:String = ""
    var strStreet:String = ""
    var strAvenue:String = ""
    var strHouse:String = ""
    var strFloor:String = ""
     var strSelectgovernet:String = ""
    var strSpecialInstruction:String = ""
     var strLandmark:String = ""
    var strGuestEmail:String = ""
    @IBOutlet var viewAddressHeader: UIView!
    var strBuldingNo:String = ""
    var strAddress:String = ""
    var wantToSave:String = "0"
    var cellHeight:CGFloat = 0.0
    var isAppointment:Bool = false
    var cellNewAddressHeight:CGFloat = 0.0
    var arrAddress:NSArray = NSArray()
    var objAddress = HttpWrapper()
    var objCheckEmail = HttpWrapper()
    var objAddNewAddress = HttpWrapper()
    var objTimeSlots = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var selectedAddressIndex = -1
    var selectedAddressId = ""
    var completeAddress:NSMutableString = NSMutableString()
    var isChecked:Bool = false
    var addressCell = CheckoutAddNewAddress()
    private var locationManager: CLLocationManager!
    var subaddress = ""
    var subLocality = ""
    var subAdministrativeArea = ""
    var administrativeArea = ""
    var postalCode = ""
    var country = ""
    let weekdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var dayCounter = -1
    var timeSlots = 0
    var arrAllTimeSlot:NSArray = NSArray()
    var arrRelatedTimeSlots:NSMutableArray = NSMutableArray()
    var listOfDays:NSMutableArray = NSMutableArray()
    var selectedDateIndex = -1
    var selectedDate:Date = Date()
    var selectedTimeSlotIndex = -1
    var selectedTimeSlot = ""
    var isFirstTime:Bool = true
    var arrDate:NSMutableArray = NSMutableArray()
    var isNotSaved:Bool = false
    var notSavedAddress = ""
    var firstCellHeight:CGFloat = 5
    var isVerify:Bool = false
    var isNewAddress:Bool = false
    @IBOutlet weak var lblNoDataFound: UILabel!
          @IBOutlet weak var lblNODataDetail: UILabel!
       // MARK: - Variables
       @IBOutlet var viewNoDataFound: UIView!
    // For Address
     @IBOutlet weak var btnAddnodata: UIButtonX!
    var isDateTimeSelected:Bool = false
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBookingAddAddress.tintColor = btnBackgroundColor
        let tabbarHeight = self.tabBarController?.tabBar.frame.size.height
        self.viewNewAddressBottomMargin.constant = tabbarHeight!
        segHeader.setTitle("lbl_new_address_Home".setlocalized(), forSegmentAt: 0)
        segHeader.setTitle("lbl_new_address_Office".setlocalized(), forSegmentAt: 1)
        segHeader.setTitle("lbl_new_address_Aparment".setlocalized(), forSegmentAt: 2)
        segHeader.setTitle("lbl_new_address_teller".setlocalized(), forSegmentAt: 3)
        currentScrren = "CheckoutAddress"
        tblAddNewAddress.tableHeaderView = viewAddressHeader
        
        viewDateTimePicker.layer.cornerRadius = 25
        viewDateTimePicker.clipsToBounds = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        
        btnNext.layer.cornerRadius = btnRadius
        btnNext.setTitle("lbl_DeliveryAddress_step_one_next".setlocalized(), for: .normal)
        btnNext.clipsToBounds = true
        btnNext.layoutIfNeeded()
        let value = appDelegate.tabBarController1.tabBar.frame.height + 45
        tblbottomspaceconstant.constant = -value
        
          if let url = "lbl_NoData_address".setlocalized() as? String {
                   imgNoData.cacheImage(urlString: url)
                }
              
              self.lblNoDataFound.text = "lbl_addresslist_nodata_title".setlocalized()
              self.lblNODataDetail.text = "lbl_addresslist_nodata_detail".setlocalized()
              self.btnAddnodata.setTitle("lbl_Address_add_address".setlocalized(), for: .normal)
        btnAddnodata.backgroundColor = btnBackgroundColor
               btnAddnodata.setTitleColor(btnTitleColor, for: .normal)
        viewNoDataFound.backgroundColor = navigationbarColor
         btnAddnodata.backgroundColor = btnBackgroundColor
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: kisMessage) != nil {
            AppHelper.showMessage(view: self.view, message: UserDefaults.standard.value(forKey: kisMessage) as! String)
            UserDefaults.standard.removeObject(forKey: kisMessage)
        }
        btnNext.layoutIfNeeded()
        self.arrDate.removeAllObjects()
        self.getDays()
        
        
        if UserDefaults.standard.object(forKey: knCustomerId) != nil
        {
            
        }
        self.getAllAddress()
        self.addNavigationBar()
        self.getTimeSlots()
        let onBlackTap = UITapGestureRecognizer(target: self, action: #selector(onTapBlack))
        onBlackTap.numberOfTapsRequired = 1
        self.viewBlackShadow.isUserInteractionEnabled = true
        self.viewBlackShadow.addGestureRecognizer(onBlackTap)
        
        
        self.lblDeliveryOptions.text = "lbl_DeliveryAddress_delivery_options".setlocalized()
        self.lblSelectDate.text = "lbl_DeliveryAddress_delivery_date".setlocalized()
        self.lblSelectTime.text = "lbl_DeliveryAddress_delivery_time".setlocalized()
        self.btnSubmit.setTitle("lbl_DeliveryAddress_submit".setlocalized(), for: .normal)
        
        if isAppointment == true
        {
            btnAddnodata.isHidden = true
            tblCheckoutAddress.tableHeaderView = viewBookingHeader
        }
        else
        {
            tblCheckoutAddress.tableHeaderView = nil
             openTimeslot()
            btnAddnodata.isHidden = true
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isAppointment == false
        {
             self.navigationController?.isNavigationBarHidden = true
        }
       
    }
    
    // MARK: - IBActions
    
    
    @IBAction func onClickbtnAdd(_ sender: UIButton) {
      isNewAddress = true
             isNotSaved = true
             self.tblCheckoutAddress.isHidden = true
             self.tblAddNewAddress.isHidden = false
             self.viewNewAddress.isHidden = false
             self.viewNewAddress.addSubview(self.tblAddNewAddress)
             self.tblAddNewAddress.frame.size.width = self.view.frame.size.width
             self.tblAddNewAddress.frame.size.height = self.view.frame.size.height
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
       
      
        
        if self.selectedDateIndex == -1 {
            AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_PleaseSelectDelDate".setlocalized());
        }
        else if  selectedTimeSlotIndex ==  -1{
            AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_PleaseSelectDelTime".setlocalized());
        }
        else
        {
        self.isDateTimeSelected = true
        
        self.tabBarController?.tabBar.isHidden = false
        self.viewSubDateTime.removeFromSuperview()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.viewBlackShadow.isHidden = true
            self.bottomMarginDateTimePicker.constant = -450
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.hidesBottomBarWhenPushed = false
        
        self.tblCheckoutAddress.reloadData()
        }
    }
    
   
    
    @IBAction func onClickClose(_ sender: UIButton) {
//        if selectedDate == nil {
//            self.lblDeliveryTimeMessage.text = "Please select delivery date to view delivery timeslots"
//            self.collectionTime.isHidden = true
//        }
        self.tabBarController?.tabBar.isHidden = false
        self.viewSubDateTime.removeFromSuperview()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.viewBlackShadow.isHidden = true
            self.bottomMarginDateTimePicker.constant = -450
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    // MARK: - @objc Actions
    
    @IBAction func onClickNext(_ sender: Any) {
        //for set appoinment 
        if isAppointment == true
        {
            
            if self.completeAddress == "" {
                AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_step_one_select_address".setlocalized());
            }
            else
            {
                
                appDelegate.BookingEmail = strGuestEmail
                let rootObj: BookAppointMentTimeVc = BookAppointMentTimeVc(nibName: "BookAppointMentTimeVc", bundle: nil)
                 rootObj.selectedAddressId = self.selectedAddressId
                rootObj.completeAddress = completeAddress
                self.navigationController?.pushViewController(rootObj, animated: true)
            }
            
        }
        else
        {
            if  selectedTimeSlot == "" {
                AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_please_select_delivery_options".setlocalized());
            }
            else  if self.completeAddress == "" {
                AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_step_one_select_address".setlocalized());
            }
            else {
                let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                                          
                let dateFormatter = DateFormatter()
                                          //            dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "dd MMM yyyy"
                var date = Date()
                                                      
                if selectedDate != nil {
                    date = selectedDate
                    // datePickerView.date = selectedDate
                }
                                                     
                nextViewController.nCartType = nCartType
                nextViewController.selectedAddressId = self.selectedAddressId
                nextViewController.selectedDate = dateFormatter.string(from: date)
                nextViewController.selecedTime = selectedTimeSlot
                nextViewController.date = self.selectedDate
              //nextViewController.cardMessage = self.strCardMessage
                self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
        
       
    }
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
           
           AddressType = sender.selectedSegmentIndex
           tblAddNewAddress.reloadData()
       }
    
    @objc func currentLocation(sender:MyTapGesture){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        addressCell = sender.cell
    }
    
    @objc func back() {
        
        if isNewAddress == true {
            isNewAddress = false
            self.tblCheckoutAddress.isHidden = false
            self.tblAddNewAddress.isHidden = true
            self.viewNewAddress.isHidden = true
            self.tblAddNewAddress.removeFromSuperview()
            self.addressCell.txtName.text = ""
            self.addressCell.txtMobileNo.text = ""
            self.addressCell.txtAlternateNo.text = ""
            self.addressCell.txtSelectArea.text = ""
            self.addressCell.txtBlock.text = ""
            self.addressCell.txtStreet.text = ""
            self.addressCell.txtAvenue.text = ""
            self.addressCell.txtHouse.text = ""
            self.addressCell.txtFloor.text = ""
            self.addressCell.txtBildingNo.text = ""
            
            isChecked = false
            isNotSaved = false
            self.addressCell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_checkbox_unchecked"), for: .normal)
            
            if isGuest == true
            {
                          self.addressCell.lblRequiredEmail.isHidden = true
                           self.addressCell.BottomSpaceEmail.constant = 10
            }
            else
            {
                self.addressCell.lblRequiredEmail.isHidden = true
                self.addressCell.BottomSpaceEmail.constant = 10
                self.addressCell.viewEmailHeight.constant = 0
            }
           
          //  self.addressCell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            self.addressCell.lblRequiredName.isHidden = true
            self.addressCell.bottomSpaceName.constant = 10
            self.addressCell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
            self.addressCell.lblRequiredBlock.isHidden = true
            self.addressCell.bottomSpaceBlock.constant = 10
            self.addressCell.viewBlock.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
           // self.addressCell.bottomSpaceFlootAndBuilding.constant = 10
            self.addressCell.viewFloor.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            self.addressCell.lblRequiredFloor.isHidden = true
    
            self.addressCell.lblRequiredHouse.isHidden = true
            self.addressCell.bottomSpaceHouse.constant = 10
            self.addressCell.viewHouse.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
            self.addressCell.lblRequiredAvenue.isHidden = true
            self.addressCell.bottomSpaceAvenue.constant = 10
            self.addressCell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
            self.addressCell.lblRequiredStreet.isHidden = true
            self.addressCell.bottomSpaceStreet.constant = 10
            self.addressCell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
            self.addressCell.lblRequiredMobileNo.isHidden = true
            self.addressCell.bottomSpaceMobileNo.constant = 10
            self.addressCell.viewMobileNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
          //  self.addressCell.bottomSpaceFlootAndBuilding.constant = 10
            self.addressCell.viewBildingNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            self.addressCell.lblRequiredBuildingNo.isHidden = true
    
            self.addressCell.lblRequiredSelectArea.isHidden = true
            self.addressCell.bottomSpaceSelectArea.constant = 10
            self.addressCell.viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
    
            self.addressCell.lblRequiredAltMobileNo.isHidden = true
            self.addressCell.bottomSpaceAltMobileNo.constant = 10
            self.addressCell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            self.tblCheckoutAddress.reloadData()
        }
        else {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
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
    
    @objc func saveAddress(_ sender:MyTapGesture) {
        let cell = sender.cell
        
        if isChecked == false {
            isChecked = true
            isNotSaved = false
            cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_checkbox_checked"), for: .normal)
        }
        else {
            isChecked = false
            isNotSaved = true
            cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_checkbox_unchecked"), for: .normal)
        }
    }
    
    @objc func gotoNext(_ sender:MyTapGesture){
        let cell = sender.cell
        self.completeAddress = ""
        self.strName = cell.txtName.text!
        self.strAlternateNo = cell.txtAlternateNo.text!
        self.strSelectArea = cell.txtSelectArea.text!
        self.strMobileNo = cell.txtMobileNo.text!
        self.strBlock = cell.txtBlock.text!
        self.strStreet = cell.txtStreet.text!
        self.strAvenue = cell.txtAvenue.text!
        self.strHouse = cell.txtHouse.text!
        self.strFloor = cell.txtFloor.text!
         self.strEmail = cell.txtEmail.text!
        self.strBuldingNo = cell.txtBildingNo.text!
        self.strLandmark = cell.txtLandmark.text!
        self.strSelectgovernet = cell.txtSelectGovernate.text!
        self.strSpecialInstruction = cell.txtviewSpecialInstruction.text!
        var flag = true
        var isFloor = false
        var fieldCount = 0
        
       
               
        if AppHelper.isNull(self.strName) == true {
//            AppHelper.showMessage(view: self.view, message: "checkout_name_required".setlocalized())
            fieldCount = fieldCount + 1
            cell.lblRequiredName.isHidden = false
            cell.lblRequiredName.text = "required".setlocalized()
            cell.BottomSpaceEmail.constant = 30
            cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strName, 20) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredName.isHidden = false
            cell.lblRequiredName.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.BottomSpaceEmail.constant = 30
            cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredName.isHidden = true
            cell.BottomSpaceEmail.constant = 10
            cell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
        
        if cell.isGuest == true
        {
            if AppHelper.isNull(self.strEmail) == true {
             //            AppHelper.showMessage(view: self.view, message: "checkout_name_required".setlocalized())
                 fieldCount = fieldCount + 1
                 cell.lblRequiredEmail.isHidden = false
                 cell.lblRequiredEmail.text = "required".setlocalized()
                 cell.bottomSpaceName.constant = 30
                 cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                 flag = false
             }
             else if !AppHelper.isValidEmail(self.strEmail)
             {
                 cell.lblRequiredEmail.isHidden = false
                 cell.lblRequiredEmail.text = "lbl_login_valid_email".setlocalized()
                 cell.bottomSpaceName.constant = 30
                 cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                 flag = false
             }
            
             else {
                 cell.lblRequiredEmail.isHidden = true
                 cell.bottomSpaceName.constant = 10
                 cell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
             }
             
        }
        
         
        
        if AppHelper.isNull(self.strMobileNo) == true {
//            AppHelper.showMessage(view: self.view, message: "checkout_mobile_no_required".setlocalized())
            fieldCount = fieldCount + 1
            cell.lblRequiredMobileNo.isHidden = false
            cell.lblRequiredMobileNo.text = "required".setlocalized()
            cell.bottomSpaceMobileNo.constant = 30
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidMobileNumber(self.strMobileNo) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredMobileNo.isHidden = false
            cell.lblRequiredMobileNo.text = "lbl_signup_only_digits_allowed".setlocalized()
            cell.bottomSpaceMobileNo.constant = 30
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredMobileNo.isHidden = true
            cell.bottomSpaceMobileNo.constant = 10
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
        if AppHelper.isNull(self.strAlternateNo) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredAltMobileNo.isHidden = false
            cell.lblRequiredAltMobileNo.text = "required".setlocalized()
            cell.bottomSpaceAltMobileNo.constant = 30
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidMobileNumber(self.strAlternateNo) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredAltMobileNo.isHidden = false
            cell.lblRequiredAltMobileNo.text = "lbl_signup_only_digits_allowed".setlocalized()
            cell.bottomSpaceAltMobileNo.constant = 30
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredAltMobileNo.isHidden = true
            cell.bottomSpaceAltMobileNo.constant = 10
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
         if AppHelper.isNull(self.strSelectgovernet) == true {
                               fieldCount = fieldCount + 1
                               cell.lblRequiredSelectGovernate.isHidden = false
                               cell.bottomSpaceGovernate.constant = 30
                               cell.lblRequiredSelectGovernate.text = "required".setlocalized()
                               cell.viewSelectGovernate.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                               flag = false
                           }
                           
                           else {
                               cell.lblRequiredSelectGovernate.isHidden = true
                               cell.bottomSpaceGovernate.constant = 10
                               cell.viewSelectGovernate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           }
              
              if AppHelper.isNull(self.strSelectArea) == true {
                  fieldCount = fieldCount + 1
                  cell.lblRequiredSelectArea.isHidden = false
                  cell.lblRequiredSelectArea.text = "required".setlocalized()
                  cell.bottomSpaceSelectArea.constant = 30
                  cell.viewSelectArea.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                  flag = false
              }
              
              else {
                  cell.lblRequiredSelectArea.isHidden = true
                  cell.bottomSpaceSelectArea.constant = 10
                  cell.viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
              }
        
        if AppHelper.isNull(self.strBlock) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredBlock.isHidden = false
            cell.lblRequiredBlock.text = "required".setlocalized()
            cell.bottomSpaceBlock.constant = 30
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strBlock, 20) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredBlock.isHidden = false
            cell.lblRequiredBlock.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.bottomSpaceBlock.constant = 30
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredBlock.isHidden = true
            cell.bottomSpaceBlock.constant = 10
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
        if AppHelper.isNull(self.strStreet) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredStreet.isHidden = false
            cell.lblRequiredStreet.text = "required".setlocalized()
            cell.bottomSpaceStreet.constant = 30
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strStreet, 100) == false{
            fieldCount = fieldCount + 1
            cell.lblRequiredStreet.isHidden = false
            cell.lblRequiredStreet.text = "lbl_signup_max_one_zero_zero_characters_allowed".setlocalized()
            cell.bottomSpaceStreet.constant = 30
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredStreet.isHidden = true
            cell.bottomSpaceStreet.constant = 10
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
//        if AppHelper.isNull(self.strAvenue) == true {
//            fieldCount = fieldCount + 1
//            cell.lblRequiredAvenue.isHidden = false
//            cell.lblRequiredAvenue.text = "required".setlocalized()
//            cell.bottomSpaceAvenue.constant = 30
//            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else if AppHelper.maxLength(self.strAvenue, 100) == false {
//            fieldCount = fieldCount + 1
//            cell.lblRequiredAvenue.isHidden = false
//            cell.lblRequiredAvenue.text = "lbl_signup_max_one_zero_zero_characters_allowed".setlocalized()
//            cell.bottomSpaceAvenue.constant = 30
//            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else {
//            cell.lblRequiredAvenue.isHidden = true
//            cell.bottomSpaceAvenue.constant = 10
//            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
//        }
        
        if AppHelper.isNull(self.strHouse) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredHouse.isHidden = false
            cell.lblRequiredHouse.text = "required".setlocalized()
            cell.bottomSpaceHouse.constant = 30
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strHouse, 20) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredHouse.isHidden = false
            cell.lblRequiredHouse.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.bottomSpaceHouse.constant = 30
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredHouse.isHidden = true
            cell.bottomSpaceHouse.constant = 10
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
        
        if AddressType == 0
                    {
                      
                    
              }
              else
              {
                 if AppHelper.isNull(self.strFloor) == true {
                      if isFloor == false {
                          fieldCount = fieldCount + 1
                        //  cell.bottomSpaceFlootAndBuilding.constant = 20
                          isFloor = true
                      }
                      cell.viewFloor.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                      cell.lblRequiredFloor.isHidden = false
                      cell.lblRequiredFloor.text = "required".setlocalized()
                      flag = false
                    cell.bottomSpaceFloar.constant = 20
                  }
                  else if AppHelper.maxLength(self.strFloor, 20) == false {
                      if isFloor == false {
                          fieldCount = fieldCount + 1
                       cell.bottomSpaceFloar.constant = 20
                          isFloor = true
                      }
                      cell.viewFloor.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                      cell.lblRequiredFloor.isHidden = false
                      cell.lblRequiredFloor.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
                      flag = false
                  }
                  else {
                      cell.bottomSpaceFloar.constant = 10
                      cell.viewFloor.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                      cell.lblRequiredFloor.isHidden = true
                  }
                  
                  if AppHelper.isNull(self.strBuldingNo) == true {
                      if isFloor == false {
                          fieldCount = fieldCount + 1
                         // cell.bottomSpaceFlootAndBuilding.constant = 10
                          isFloor = true
                      }
                    cell.bottomSpaceFloar.constant = 20
                      cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                      cell.lblRequiredBuildingNo.isHidden = false
                      cell.lblRequiredBuildingNo.text = "required".setlocalized()
                      flag = false
                  }
                  else if AppHelper.maxLength(self.strBuldingNo, 20) == false {
                      if isFloor == false {
                          fieldCount = fieldCount + 1
                        //  cell.bottomSpaceFlootAndBuilding.constant = 10
                          isFloor = true
                      }
                    cell.bottomSpaceFloar.constant = 20
                      cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                      cell.lblRequiredBuildingNo.isHidden = false
                      cell.lblRequiredBuildingNo.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
                      flag = false
                  }
                  else {
                    cell.bottomSpaceFloar.constant = 10
                     // cell.bottomSpaceFlootAndBuilding.constant = 10
                      cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                      cell.lblRequiredBuildingNo.isHidden = true
                  }
              }
              
              
//              if AppHelper.isNull(self.strLandmark) == true {
//                                       fieldCount = fieldCount + 1
//                                       cell.lblRequiredLandmark.isHidden = false
//                                       cell.lblRequiredLandmark.text = "required".setlocalized()
//                                      // cell.bottomSpaceHouse.constant = 30
//                                       cell.viewLandMark.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//                                       flag = false
//                                   }
//                                   else if AppHelper.maxLength(self.strLandmark, 20) == false {
//                                       fieldCount = fieldCount + 1
//                                       cell.lblRequiredLandmark.isHidden = false
//                                       cell.lblRequiredLandmark.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
//                                      // cell.bottomSpaceHouse.constant = 30
//                                       cell.viewLandMark.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//                                       flag = false
//                                   }
//                                   else {
//                                       cell.lblRequiredLandmark.isHidden = true
//                                     //  cell.bottomSpaceHouse.constant = 10
//                                       cell.viewLandMark.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
//                                   }
              
        
       
        
            
        if flag == false {
            self.tblAddNewAddress.reloadData()
            cellNewAddressHeight = CGFloat(fieldCount * 20)
             self.view.layoutIfNeeded()
            tblAddNewAddress.setContentOffset(.zero, animated:false)
        }
        else
        {
            isChecked = true
            if cell.isGuest == true
            {
                 isChecked = true
               CheckEmailValid(Email: strEmail)
            }
            else
            {
                AddressAdd()
            }
           
        }
    }
    
    @IBAction func onClickbtnBookingAddAddress(_ sender: Any) {
        isNewAddress = true
        isNotSaved = true
        self.tblCheckoutAddress.isHidden = true
        self.tblAddNewAddress.isHidden = false
        self.viewNewAddress.isHidden = false
        self.viewNewAddress.addSubview(self.tblAddNewAddress)
        self.tblAddNewAddress.frame.size.width = self.view.frame.size.width
        self.tblAddNewAddress.frame.size.height = self.view.frame.size.height
    }
    @objc func onClickAddNewAddress() {
        isNewAddress = true
        isNotSaved = true
        self.tblCheckoutAddress.isHidden = true
        self.tblAddNewAddress.isHidden = false
        self.viewNewAddress.isHidden = false
        self.viewNewAddress.addSubview(self.tblAddNewAddress)
        self.tblAddNewAddress.frame.size.width = self.view.frame.size.width
        self.tblAddNewAddress.frame.size.height = self.view.frame.size.height
    }
    
    
    func AddressAdd()
    {
                var param:String = ""
                 self.tblCheckoutAddress.reloadData()
                let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
                let cLanguageId = "1"
             var nCustomerId = ""
            if UserDefaults.standard.object(forKey: knCustomerId) != nil
               {
                    nCustomerId = "\(UserDefaults.standard.value(forKey: knCustomerId) as! Int)"
               }
        else
            {
                nCustomerId = appDelegate.GuestCustomerId
        }
        
               
                let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
                
                
                if strBlock != "" {
                    self.completeAddress.append("\(strBlock)")
                }
                
                if strBuldingNo != "" {
                    self.completeAddress.append("-\(strBuldingNo)")
                }
                
                if strFloor != "" {
                    if self.completeAddress != "" {
                        self.completeAddress.append(", \(strFloor)")
                    }
                    else {
                        self.completeAddress.append("\(strFloor)")
                    }
                }
                
                if strHouse != "" {
                    if self.completeAddress != "" {
                        self.completeAddress.append(", \(strHouse)")
                    }
                    else {
                        self.completeAddress.append("\(strHouse)")
                    }
                }
                
                if strStreet != "" {
                    if self.completeAddress != "" {
                        self.completeAddress.append(", \(strStreet)")
                    }
                    else {
                        self.completeAddress.append("\(strStreet)")
                    }
                }
                
                if strAvenue != "" {
                    if self.completeAddress != "" {
                        self.completeAddress.append(", \(strAvenue)")
                    }
                    else {
                        self.completeAddress.append("\(strAvenue)")
                    }
                }

                UserDefaults.standard.set(self.completeAddress, forKey: kcBillingAddress)
                
        var Type = "Home"
                      
                      
                      if AddressType == 0
                      {
                        Type = "Home"
                                  
                      }
                      else if AddressType == 1
                      {
                          Type = "Office"
                      }
                        else if AddressType == 3
                                             {
                                                 Type = "tailor"
                                             }
                      else
                      {
                         Type = "Apartment"
                      }
        if AddressType == 0
                      {
                         param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strHouse,self.strFloor,self.strBuldingNo,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,"","",Type)
                  }
                  else if AddressType == 1 || AddressType == 3
                     {
                         param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,"",self.strFloor,"",self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,self.strHouse,self.strBuldingNo,Type)
                     }
                     else
                     {
                        param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strBuldingNo,self.strFloor,self.strHouse,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,"","",Type)
                     }
                      
//                param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strHouse,self.strFloor,self.strBuldingNo,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction)
                
    //                param = String(format: "%@?cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@", kAddNewAddress,self.strBlock,self.strStreet,self.strAvenue,self.strHouse,self.strFloor,self.strBuldingNo,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken)
                
                print(param)
                
                let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                if isChecked == true {
                    AppHelper.showLoadingView()
                    self.objAddNewAddress = HttpWrapper.init()
                    self.objAddNewAddress.delegate = self
                    self.objAddNewAddress.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
                }
                else {
                    
                    if isDateTimeSelected == true {
                        let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                        
                         let dateFormatter = DateFormatter()
                        //            dateFormatter.locale = Locale(identifier: "en")
                                    dateFormatter.dateFormat = "dd MMM yyyy"
                                    var date = Date()
                                    
                                    if selectedDate != nil {
                                        date = selectedDate
                                       // datePickerView.date = selectedDate
                                    }
                                   
                        nextViewController.nCartType = nCartType
                        nextViewController.isGuest = isGuest
                   nextViewController.selectedAddressId = self.selectedAddressId
                   nextViewController.selectedDate = dateFormatter.string(from: date)
                   nextViewController.selecedTime = selectedTimeSlot
                   nextViewController.date = self.selectedDate
                    //nextViewController.cardMessage = self.strCardMessage
                   self.navigationController?.pushViewController(nextViewController, animated: true)
    //                    let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutDateAndTime") as! CheckoutDateAndTime
    //                    nextViewController.selectedDate = selectedDate
    //                    nextViewController.selecedTime = selectedTimeSlot
    //                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                    else {
                        AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_please_select_delivery_options".setlocalized())
                        self.tblCheckoutAddress.isHidden = false
                        self.tblAddNewAddress.isHidden = true
                        self.viewNewAddress.isHidden = true
                        self.tblAddNewAddress.reloadData()
                       // self.selectedAddressIndex = self.arrAddress.count
                        self.notSavedAddress = self.completeAddress as String
                        self.getAllAddress()
                    }
                }
    }
    @objc func onClickOpen(_ sender:MyTapGesture) {
        
       openTimeslot()
        
//        self.hidesBottomBarWhenPushed = true
    }
    
    
    
    func openTimeslot()
    {
          // self.tabBarController?.tabBar.isHidden = true
                self.lblDeliveryTimeMessage.text = "lbl_DeliveryAddress_please_select_delivery_date_to_view_delivery_timeslots".setlocalized()
                self.viewDateTimePicker.addSubview(self.viewSubDateTime)
                self.viewSubDateTime.frame.size.width = self.view.frame.size.width
                self.viewSubDateTime.frame.size.height = 450
                self.collectionTime.reloadData()
                self.collectionDateTime.reloadData()
        //        self.viewBlackShadow.addGestureRecognizer(outerViewClose)
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.viewBlackShadow.isHidden = false
                    self.bottomMarginDateTimePicker.constant = 0
                    self.view.layoutIfNeeded()
                    self.collectionTime.reloadData()
                    self.collectionDateTime.reloadData()
                }, completion: nil)
    }
    @objc func onTapBlack() {
        self.tabBarController?.tabBar.isHidden = false
        self.viewSubDateTime.removeFromSuperview()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.viewBlackShadow.isHidden = true
            self.bottomMarginDateTimePicker.constant = -450
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.hidesBottomBarWhenPushed = false
    }
    
    // MARK: - Custom Methods
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getAllAddress()
                self.getTimeSlots()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getDays() {
        let date = Date()
        self.arrDate.add(date)
        for nDate in 1..<7 {
            let newDate =  Calendar.current.date(byAdding: .day, value: nDate, to: date)!
            arrDate.add(newDate)
        }
        print(self.arrDate)
    }
    
    func getOnlyDate(date:Date) -> String {
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day], from: date)
        let day = components.day
        return "\(day as! Int)"
    }
    
    func getWeekDay(date:Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        return self.weekdays[weekday - 1]
    }
    
    func isFutureDate(strTimeStamp:String) -> Bool {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let currentSystemDate = AppHelper.dateToString(date: date, strFormate: "yyyy-MM-dd")
        let strSystemDate = "\(currentSystemDate) \(hour):\(minutes):00"
        
        let timeDate = AppHelper.stringToDate(strDate: strTimeStamp, strFormate: "yyyy-MM-dd HH:mm:ss")
        let systemDate = AppHelper.stringToDate(strDate: strSystemDate, strFormate: "yyyy-MM-dd HH:mm:ss")
        
        let dateStamp:TimeInterval = timeDate.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        
        let currentStamp:TimeInterval = systemDate.timeIntervalSince1970
//        print(Date())
//        print(dateSt)
//        print(currentStamp)
//        
        if Int(currentStamp) < dateSt {
            return true
        }
        else {
            return false
        }
    }
    
    func getTimeSlots() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            let param:NSMutableString = NSMutableString()
            
            param.append(String(format:"%@?", kTimeSlots))
            param.append(String(format:"nUserId=%@&", "\(nUserId)"))
            param.append(String(format:"cToken=%@", cToken))
            
            AppHelper.showLoadingView()
            self.objTimeSlots = HttpWrapper.init()
            self.objTimeSlots.delegate = self
            self.objTimeSlots.requestWithparamdictParamPostMethodwithHeaderGet(url: NSMutableString(string: param) as String, headers: nil)
        }
    }
    
    func getAllAddress () {
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
            
            let param = String(format: "%@?nCustomerId=%@&nUserId=%@&cToken=%@", kAllAddress,"\(nCustomerId)","\(nUserId)",cToken)
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objAddress = HttpWrapper.init()
            self.objAddress.delegate = self
            self.objAddress.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func CreateGuestUser()
    {
        if net.isReachable == false {
                   let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
                   alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
               else {
                   var param:String = ""

                   


                   

            param = String(format: "%@?cCustomerFirstName=%@&cCustomerLastName=%@&cCustomerContactNo=%@&cCustomerEmailId=%@&nUserId=%@&cPassword=%@&cGender=%@&cCustomerType=%@&cToken=%@&cIPAddress=%@&cMType=%@&cDeviceToken=%@", kSignup,self.strName,self.strName,self.strMobileNo,self.strEmail,"1","GuestUser","Male","guestuser",KbasecToken,appDelegate.StrFirebaseToken,"1","\(appDelegate.DeviceId)")
                   
                    let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                   
                   AppHelper.showLoadingView()
                   self.objSignup = HttpWrapper.init()
                   self.objSignup.delegate = self
                   self.objSignup.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
               }
    }
    func CheckEmailValid (Email:String) {
           if net.isReachable == false {
               let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
               alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
           else {
               let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
             //  let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
               let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
               
               let param = String(format: "%@?cUserName=%@&nUserId=%@&cToken=%@", kgetguestuserdetails,"\(Email)","\(nUserId)",cToken)
               
               print(param)
               
               let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
               
               AppHelper.showLoadingView()
               self.objCheckEmail = HttpWrapper.init()
               self.objCheckEmail.delegate = self
               self.objCheckEmail.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
           }
       }
       
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
       // lbNavTitle.text = "step_one_title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        lblTitle.text = "step_one_title".setlocalized()//appDelegate.setLocalizationstring(string: "lbl_cart")
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        tblAddNewAddress.backgroundColor  = navigationbarColor
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
        self.navigationItem.rightBarButtonItems = []
        
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    // MARK: - Tableview Delegates and Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCheckoutAddress {
            if section == 1 {
                
                if isAppointment == true
                {
                    
                    return self.arrAddress.count
                }
                else
                {
                    if isNotSaved == true {
                        return self.arrAddress.count + 1
                    }
                    else {
                        return self.arrAddress.count
                    }
                }
                
            }
            else {
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblCheckoutAddress {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutAddNewAddressCell") as! CheckoutAddNewAddressCell
                cell.viewRoundCircle.layer.cornerRadius = 7.5
                cell.viewRoundCircle.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                cell.viewRoundCircle.clipsToBounds = true
                cell.viewRoundCircle.layer.borderWidth = 1
                cell.viewLine.backgroundColor = UIColor(hexString: "#B0B1B3")
                
                cell.lblShippingMethod.text = "lbl_DeliveryAddress_step_one_shipping_address".setlocalized()
                cell.lblSavedAddress.text = "lbl_DeliveryAddress_step_one_saved_address".setlocalized()
                //cell.btnAddAddress.setTitle("lbl_DeliveryAddress_step_one_add_address".setlocalized() , for: .normal)
                cell.btnAddAddress.tintColor = btnBackgroundColor
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                
                
                
                let addNewAddress = UITapGestureRecognizer(target: self, action: #selector(onClickAddNewAddress))
                cell.btnAddAddress.isUserInteractionEnabled = true
                addNewAddress.numberOfTapsRequired = 1
                cell.btnAddAddress.addGestureRecognizer(addNewAddress)
                
                
                if selectedDate != nil && selectedTimeSlot != "" {
                    cell.heightDatTimeSelected.constant = 30
                    self.firstCellHeight = 30
                    cell.lblDateDesc.text = "\(AppHelper.dateToString(date: selectedDate, strFormate: "dd MMM yyyy"))"
                    cell.lblBetweenDesc.text = selectedTimeSlot
                    cell.viewUnderLine.isHidden = true
                    cell.lblBetweenDesc.isHidden = false
                    cell.lblDateDesc.isHidden = false
                    cell.lblBetweenTitle.isHidden = false
                    cell.lblDateTitle.isHidden = false
                    cell.lblDeliveryOption.isHidden = false
                    cell.btnOpen.isHidden = true
                    cell.btnOpen.setTitle("lbl_DeliveryAddress__choose_another_option".setlocalized(), for: .normal)
                }
                else
                {
                    cell.btnOpen.isHidden = false
                }
                
                let openTap = MyTapGesture(target: self, action: #selector(onClickOpen))
                cell.btnOpen.isUserInteractionEnabled = true
                openTap.numberOfTapsRequired = 1
                openTap.checkoutCell = cell
                cell.btnOpen.addGestureRecognizer(openTap)
                
                let openTap2 = MyTapGesture(target: self, action: #selector(onClickOpen))
                cell.btnOpen.isUserInteractionEnabled = true
                openTap2.numberOfTapsRequired = 1
                openTap2.checkoutCell = cell
               
                
                 cell.btnOpen2.addGestureRecognizer(openTap2)
                cell.btnOpen.setTitle("lbl_DeliveryAddress_choose_delivery_options".setlocalized(), for: .normal)
                return cell
            }
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutBillingAddressCell") as! CheckoutBillingAddressCell

                if indexPath.row < self.arrAddress.count {
                    let dicAddress = self.arrAddress.object(at: indexPath.row) as! NSDictionary
                    
                    if let address = dicAddress.object(forKey: "cAddressType") as? String {
                        
                        cell.lblType.text = address.uppercased()
                    }
                    else
                    {
                        cell.lblType.text = ""
                    }
                    
                    if let address = dicAddress.object(forKey: "cName") as? String {
                                       
                                       cell.lbltitle.text = address
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
                    
//                    if let address = dicAddress.object(forKey: "cAddress") as? String {
//                        let font = UIFont(name: RalewayRegular, size: 14.0)
//                        let height = AppHelper.heightForView(text: address, font: font!, width: self.view.frame.size.width - 55)
//                        self.cellHeight = height
//                        cell.lblAddressDetails.text = address
//                    }
                    
                    if let nAddressId = dicAddress.object(forKey: "nAddressId") as? NSNumber {
                        if selectedAddressId == "\(nAddressId)" {
                            if let cAddress = dicAddress.object(forKey: "cAddress") as? String {
                                self.completeAddress = NSMutableString(string: cAddress)
                                UserDefaults.standard.set(self.completeAddress, forKey: kcBillingAddress)
                            }
                            self.selectedAddressIndex = indexPath.row
                        }
                    }
                    
                    if self.selectedAddressIndex == indexPath.row {
                        cell.btnAddressRadio.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                    }
                    else {
                        cell.btnAddressRadio.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                    }
                }
                else {
                    print(self.selectedAddressIndex)
                    if self.selectedAddressIndex == indexPath.row {
                        cell.btnAddressRadio.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
                    }
                    else {
                        cell.btnAddressRadio.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
                    }
                    
                    cell.lblAddressDetails.text = self.notSavedAddress
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutBillingNextCell") as! CheckoutBillingNextCell
                cell.btnBillingNext.layer.cornerRadius = btnRadius
                cell.btnBillingNext.setTitle("lbl_DeliveryAddress_step_one_next".setlocalized(), for: .normal)
                cell.btnBillingNext.clipsToBounds = true

                return cell
            }
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutAddNewAddress") as! CheckoutAddNewAddress
            self.addressCell = cell
            cell.delegate = self
            cell.isGuest = isGuest
            cell.btnAddAddressNext.backgroundColor = btnBackgroundColor
            cell.btnAddAddressNext.setTitleColor(btnTitleColor, for: .normal)
            if isGuest == false
            {
                cell.viewEmailHeight.constant = 0
                cell.viewEmail.isHidden = true
                
            }
            else
            {
                cell.btnCheckBox.isHidden = true
                cell.txtEmail.text = strGuestEmail
                cell.lblSaveAddressForFutureUse.isHidden = true
            }
           if isVerify == false {
                           cell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                            cell.viewSelectGovernate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewBlock.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewHouse.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewFloor.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewLandMark.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                           isVerify = true
                       }
            
            if AddressType == 0
                   {
                       cell.ViewFloorHeight.constant = 0
                       cell.viewBuildingNoHeight.constant = 0
                       cell.viewFloor.isHidden = true
                       cell.viewBildingNo.isHidden = true
                       
                       cell.viewHouse.clipsToBounds = true
                       cell.txtHouse.placeholder = "lbl_new_address_placeholder_HouseNumber".setlocalized()
                       cell.viewBildingNo.clipsToBounds = true
                              cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_bulding_no".setlocalized()
                   }
                   else if AddressType == 1 || AddressType == 3
                   {
                       cell.ViewFloorHeight.constant = 40
                       cell.viewBuildingNoHeight.constant = 40
                       cell.viewFloor.isHidden = false
                       cell.viewBildingNo.isHidden = false
                              
                       cell.viewHouse.clipsToBounds = true
                       cell.txtHouse.placeholder = "lbl_new_address_placeholder_BuildingName".setlocalized()
                       cell.viewBildingNo.clipsToBounds = true
                       cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_OfficeName".setlocalized()
                   }
                   else
                   {
                       cell.ViewFloorHeight.constant = 40
                       cell.viewBuildingNoHeight.constant = 40
                       cell.viewFloor.isHidden = false
                       cell.viewBildingNo.isHidden = false
                       
                       cell.viewHouse.clipsToBounds = true
                       cell.txtHouse.placeholder = "lbl_new_address_placeholder_BuildingNumber".setlocalized()
                       cell.viewBildingNo.clipsToBounds = true
                       cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_AparmentNumber".setlocalized()
                      
                   }
            
                     //  cell.arrAreaList = self.arrArealist
                       cell.viewRoundCircle.layer.cornerRadius = 7.5
                       cell.viewRoundCircle.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                       cell.viewRoundCircle.clipsToBounds = true
                       cell.viewRoundCircle.layer.borderWidth = 1
                       cell.viewLine.backgroundColor = UIColor(hexString: "#B0B1B3")
            
//                       cell.viewName.layer.cornerRadius = 20
//                       cell.viewName.layer.borderWidth = 1
                       cell.viewName.clipsToBounds = true
                       cell.txtName.placeholder = "lbl_new_address_placeholder_name".setlocalized()
                       
//                       cell.viewAlternateNo.layer.cornerRadius = 20
//                       cell.viewAlternateNo.layer.borderWidth = 1
                       cell.viewAlternateNo.clipsToBounds = true
                       cell.txtAlternateNo.placeholder = "lbl_new_address_placeholder_alertnate_no".setlocalized()
                       
//                       cell.viewSelectArea.layer.cornerRadius = 20
//                       cell.viewSelectArea.layer.borderWidth = 1
                       cell.viewSelectArea.clipsToBounds = true
                       cell.txtSelectArea.placeholder = "lbl_new_address_placeholder_select_area".setlocalized()
                       
//                       cell.viewSelectGovernate.layer.cornerRadius = 20
//                       cell.viewSelectGovernate.layer.borderWidth = 1
                       cell.viewSelectGovernate.clipsToBounds = true
                       cell.txtSelectGovernate.placeholder = "lbl_new_address_placeholder_select_governorate".setlocalized()
                       
//                       cell.viewMobileNo.layer.cornerRadius = 20
//                       cell.viewMobileNo.layer.borderWidth = 1
                       cell.viewMobileNo.clipsToBounds = true
                       cell.txtMobileNo.placeholder = "lbl_new_address_placeholder_mobile_no".setlocalized()
                       
                       
//                       cell.viewBlock.layer.cornerRadius = 20
//                       cell.viewBlock.layer.borderWidth = 1
                       cell.viewBlock.clipsToBounds = true
                       cell.txtBlock.placeholder = "lbl_new_address_placeholder_block".setlocalized()
                       
//                       cell.viewStreet.layer.cornerRadius = 20
//                       cell.viewStreet.layer.borderWidth = 1
                       cell.viewStreet.clipsToBounds = true
                       cell.txtStreet.placeholder = "lbl_new_address_placeholder_street".setlocalized()
                       
//                       cell.viewAvenue.layer.cornerRadius = 20
//                       cell.viewAvenue.layer.borderWidth = 1
                       cell.viewAvenue.clipsToBounds = true
                       cell.txtAvenue.placeholder = "lbl_new_address_placeholder_avenue".setlocalized()
                       
                       cell.viewSpecialInstruction.layer.cornerRadius = 20
                       cell.viewSpecialInstruction.layer.borderWidth = 1
                       cell.viewSpecialInstruction.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
//                       cell.viewHouse.layer.cornerRadius = 20
//                       cell.viewHouse.layer.borderWidth = 1
//                       cell.viewHouse.clipsToBounds = true
//                       cell.txtHouse.placeholder = "lbl_new_address_placeholder_house".setlocalized()
                       
//                       cell.viewFloor.layer.cornerRadius = 20
//                       cell.viewFloor.layer.borderWidth = 1
                       cell.viewFloor.clipsToBounds = true
                       cell.txtFloor.placeholder = "lbl_new_address_placeholder_floor".setlocalized()
                       
//                       cell.viewBildingNo.layer.cornerRadius = 20
//                       cell.viewBildingNo.layer.borderWidth = 1
//                       cell.viewBildingNo.clipsToBounds = true
//                       cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_bulding_no".setlocalized()
                       
                       let saveAddressTap = MyTapGesture(target: self, action: #selector(saveAddress))
                       saveAddressTap.numberOfTapsRequired = 1
                       saveAddressTap.cell = cell
                       cell.btnCheckBox.isUserInteractionEnabled = true
                       cell.btnCheckBox.addGestureRecognizer(saveAddressTap)
                       
                       let saveLabelAddressTap = MyTapGesture(target: self, action: #selector(saveAddress))
                       saveLabelAddressTap.numberOfTapsRequired = 1
                       saveLabelAddressTap.cell = cell
                       cell.lblSaveAddressForFutureUse.isUserInteractionEnabled = true
                       cell.lblSaveAddressForFutureUse.addGestureRecognizer(saveLabelAddressTap)
                       
                       cell.btnAddAddressNext.layer.cornerRadius = btnRadius
                       cell.btnAddAddressNext.clipsToBounds = true
                       
                       let addNewAddressTap = MyTapGesture(target: self, action: #selector(gotoNext))
                       cell.btnAddAddressNext.isUserInteractionEnabled = true
                       addNewAddressTap.numberOfTapsRequired = 1
                       addNewAddressTap.cell = cell
                       cell.btnAddAddressNext.addGestureRecognizer(addNewAddressTap)
                       
                       let currentLocationTap = MyTapGesture(target: self, action: #selector(currentLocation))
                       cell.btnCurrentLocation.isUserInteractionEnabled = true
                       currentLocationTap.numberOfTapsRequired = 1
                       currentLocationTap.cell = cell
                       cell.btnCurrentLocation.addGestureRecognizer(currentLocationTap)

            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblCheckoutAddress {
            return 3
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblCheckoutAddress {
            if indexPath.section == 0 {
                if isAppointment == true
                {
                     return 0
                }
                else
                {
                     return 181 + firstCellHeight  //229
                }
               
            }
            else if indexPath.section == 1{
                return UITableViewAutomaticDimension
            }
            else {
                return 0
                
            }
        }
        else {
            return 970 + cellNewAddressHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblCheckoutAddress {
            if section == 0 {
                return nil
            }
            else if section == 1 {
                let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblCheckoutAddress.frame.size.width, height: 35))
                headerView.backgroundColor = UIColor.white
                let lblHeaderName:UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: headerView.frame.size.height))
                lblHeaderName.font = UIFont(name: RalewayLight, size: 16)
                
                let bootomLine = UIView(frame: CGRect(x: 10, y: 35, width: self.tblCheckoutAddress.frame.size.width - 20, height: 1))
                bootomLine.backgroundColor = UIColor(hexString: "#B0B1B3")
                
                if self.arrAddress.count != 0 {
                    lblHeaderName.text = "lbl_DeliveryAddress_step_one_billing_address".setlocalized()
                    headerView.addSubview(bootomLine)
                }
                else {
                    lblHeaderName.text = "lbl_DeliveryAddress_step_one_no_address_found".setlocalized()
                }
                
                headerView.backgroundColor = navigationbarColor
                headerView.addSubview(lblHeaderName)
                
                return headerView
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblCheckoutAddress {
            if section == 1{
                return 0
            }
            else {
                return 0
            }
            
        }
        else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCheckoutAddress {
            if indexPath.section == 0 {
//                self.tblCheckoutAddress.isHidden = true
//                self.viewNewAddress.isHidden = false
//                self.viewNewAddress.addSubview(self.tblAddNewAddress)
//                self.tblAddNewAddress.frame.size.width = self.view.frame.size.width
//                self.tblAddNewAddress.frame.size.height = self.view.frame.size.height
            }
            else if indexPath.section == 1 {
                self.selectedAddressIndex = -1
                self.selectedAddressIndex = indexPath.row
                
                if indexPath.row < self.arrAddress.count {
                    let dicAddress = self.arrAddress.object(at: indexPath.row) as! NSDictionary
                    if let nAddressId = dicAddress.object(forKey: "nAddressId") as? NSNumber {
                        self.selectedAddressId = "\(nAddressId)"
                    }
                    
                     if let cAddress = dicAddress.object(forKey: "cName") as? String {
                        appDelegate.bookingName = cAddress
                    }
                    
                    if let cAddress = dicAddress.object(forKey: "cMobileNo") as? String {
                        appDelegate.BookingNumber = cAddress
                    }
                    
                    if let cAddress = dicAddress.object(forKey: "cMobileNo") as? String {
                                           appDelegate.BookingNumber = cAddress
                                       }
                                       
                    
                    
                    
                    if let cAddress = dicAddress.object(forKey: "cAddress") as? String {
                        self.completeAddress = NSMutableString(string: cAddress)
                        UserDefaults.standard.set(self.completeAddress, forKey: kcBillingAddress)
                    }
                }
                else {
                    selectedAddressId = ""
                    self.completeAddress = self.notSavedAddress as! NSMutableString
                }
                
                self.tblCheckoutAddress.reloadData()
            }
            else if indexPath.section == 2 {
                if  selectedTimeSlot == "" {
                    AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_please_select_delivery_options".setlocalized());
                }
                else  if self.completeAddress == "" {
                    AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_step_one_select_address".setlocalized());
                }
                else {
                     let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                                      
                                       let dateFormatter = DateFormatter()
                                      //            dateFormatter.locale = Locale(identifier: "en")
                                                  dateFormatter.dateFormat = "dd MMM yyyy"
                                                  var date = Date()
                                                  
                                                  if selectedDate != nil {
                                                      date = selectedDate
                                                     // datePickerView.date = selectedDate
                                                  }
                                                 
                               nextViewController.nCartType = nCartType
                              nextViewController.selectedAddressId = self.selectedAddressId
                                 nextViewController.selectedDate = dateFormatter.string(from: date)
                                 nextViewController.selecedTime = selectedTimeSlot
                                 nextViewController.date = self.selectedDate
                                  //nextViewController.cardMessage = self.strCardMessage
                                 self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
        }
    }
    
    // MARK:- Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getAddressFromLatLon(pdblLatitude:"\(locValue.latitude)" , withLongitude: "\(locValue.longitude)")
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if placemarks == nil
                {
                    return
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var sub_address:String = ""
                    
                    if pm.subThoroughfare != nil {
                        sub_address += pm.subThoroughfare!
                    }
                    if pm.thoroughfare != nil {
                        sub_address += pm.thoroughfare!
                    }
                    
                    self.subaddress = sub_address
                    
                    
                    if pm.subLocality != nil {
                        self.subLocality = pm.subLocality!
                    }
                    
                    if pm.subAdministrativeArea != nil {
                        self.subAdministrativeArea = pm.subAdministrativeArea!
                    }
                    
                    if pm.administrativeArea != nil {
                        self.administrativeArea = pm.administrativeArea!
                    }
                    
                    if pm.postalCode != nil {
                        self.postalCode = pm.postalCode!
                    }
                    
                    if pm.country != nil {
                        self.country = pm.country!
                    }
                    
                    self.addressCell.txtStreet.text = self.subaddress
                    if self.subaddress != "" {
                        self.addressCell.lblRequiredAvenue.isHidden = true
                        self.addressCell.bottomSpaceAvenue.constant = 10
                        self.addressCell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                    }
                    self.addressCell.txtAvenue.text = " \(self.administrativeArea), \(self.country)"
                    
                    if self.administrativeArea != "" || self.country != "" {
                        self.addressCell.lblRequiredStreet.isHidden = true
                        self.addressCell.bottomSpaceStreet.constant = 10
                        self.addressCell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                    }
                }
        })
        
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objAddress {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrAddress = dicsResponse.value(forKey: "Result") as! NSArray
                 self.viewNewAddress.isHidden = true
                self.view.layoutIfNeeded()
                self.tblCheckoutAddress.reloadData()
                
                tblCheckoutAddress.tableFooterView = nil
                
                if arrAddress.count > 0 && isfirstTime == false
                {
                    if UserDefaults.standard.object(forKey: kisLogin) != nil {
                                                  
                                                }
                                              else if appDelegate.GuestCustomerId != "0"
                                          {
                                           let dicAddress = self.arrAddress.object(at: 0) as! NSDictionary
                                           if let nAddressId = dicAddress.object(forKey: "nAddressId") as? NSNumber {
                                                                  self.selectedAddressId = "\(nAddressId)"
                                                              }
                                                              
                                                               if let cAddress = dicAddress.object(forKey: "cName") as? String {
                                                                  appDelegate.bookingName = cAddress
                                                              }
                                                              
                                                              if let cAddress = dicAddress.object(forKey: "cMobileNo") as? String {
                                                                  appDelegate.BookingNumber = cAddress
                                                              }
                                                              
                                                              if let cAddress = dicAddress.object(forKey: "cMobileNo") as? String {
                                                                                     appDelegate.BookingNumber = cAddress
                                                                                 }
                                                                                 
                                                              
                                                              
                                                              
                                                              if let cAddress = dicAddress.object(forKey: "cAddress") as? String {
                                                                  self.completeAddress = NSMutableString(string: cAddress)
                                                                  UserDefaults.standard.set(self.completeAddress, forKey: kcBillingAddress)
                                                              }
                                           
                                              if self.completeAddress == "" {
                                                  AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_step_one_select_address".setlocalized());
                                              }
                                              else
                                              {
                                                  
                                                  appDelegate.BookingEmail = strGuestEmail
                                                  let rootObj: BookAppointMentTimeVc = BookAppointMentTimeVc(nibName: "BookAppointMentTimeVc", bundle: nil)
                                                   rootObj.selectedAddressId = self.selectedAddressId
                                                  rootObj.completeAddress = completeAddress
                                                  self.navigationController?.pushViewController(rootObj, animated: true)
                                              }
                                          }
                                   else {
                                       
                                   }
                }
               
            }
            else{
                 self.tblCheckoutAddress.reloadData()
                tblCheckoutAddress.tableFooterView = viewNoDataFound
//                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else  if wrapper == objSignup {
                        print(dicsResponse)
                        AppHelper.hideLoadingView()
                        let userDefaults = UserDefaults.standard
                        if dicsResponse.value(forKey: "Success") as! String == "1" {
                            
                            let customerDetails = (dicsResponse.value(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                            
//                            if let nUserId = customerDetails.value(forKey: "nLoginId") as? NSNumber {
//                                userDefaults.set(nUserId, forKey: knLoginId)
//                            }
//
//                            if let nUserId = customerDetails.value(forKey: "nUserId") as? NSNumber {
//                                userDefaults.set(nUserId, forKey: knUserId)
//                            }
//
                            if let nCustomerId = customerDetails.value(forKey: "nCustomerId") as? NSNumber {
                                appDelegate.GuestCustomerId = "\(nCustomerId)"
                            }
                            
                            AddressAdd()
                            
//
//                            if let cCustomerName = customerDetails.value(forKey: "cCustomerName") as? String {
//                                userDefaults.set(cCustomerName, forKey: kcCustomerName)
//                            }
//
//                            if let cEmail = customerDetails.value(forKey: "cEmail") as? String {
//                                userDefaults.set(cEmail, forKey: kcEmail)
//                            }
//
//                            if let cContactNo = customerDetails.value(forKey: "cContactNo") as? String {
//                                userDefaults.set(cContactNo, forKey: kcContactNo)
//                            }
//
//                            if let cGender = customerDetails.value(forKey: "cGender") as? String {
//                                userDefaults.set(cGender, forKey: kcGender)
//                            }
//
//                            if let cCustomerType = customerDetails.value(forKey: "cCustomerType") as? String {
//                                userDefaults.set(cCustomerType, forKey: kcCustomerType)
//                            }
//
//                            if let cCustomerImage = customerDetails.value(forKey: "cCustomerImage") as? String {
//                                userDefaults.set(cCustomerImage, forKey: kcCustomerImage)
//                            }
//
//                            if let cToken = customerDetails.value(forKey: "cToken") as? String {
//                                userDefaults.set(cToken, forKey: kcToken)
//                            }
//
//                            userDefaults.set("1", forKey: kisLogin)
//
//                            if self.isSocialLogin == true {
//                                userDefaults.set("1", forKey: kcSocialLogin)
//                            }
//
//                            userDefaults.set("register_successfully".setlocalized(), forKey: kisMessage)
                            
                           
                        }
                        else {
                            AppHelper.hideLoadingView()
                            AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
                        }
                    }
        else if wrapper == objAddNewAddress {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
                
                
                if isDateTimeSelected == true {
                     let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                                      
                                       let dateFormatter = DateFormatter()
                                      //            dateFormatter.locale = Locale(identifier: "en")
                                                  dateFormatter.dateFormat = "dd MMM yyyy"
                                                  var date = Date()
                                                  
                                                  if selectedDate != nil {
                                                      date = selectedDate
                                                     // datePickerView.date = selectedDate
                                                  }
                                                 
                                  nextViewController.nCartType = nCartType
                                 nextViewController.isGuest = isGuest
                                 nextViewController.selectedAddressId = dicsResponse.value(forKey: "ID") as! String
                                 nextViewController.selectedDate = dateFormatter.string(from: date)
                                 nextViewController.selecedTime = selectedTimeSlot
                                 nextViewController.date = self.selectedDate
                                  //nextViewController.cardMessage = self.strCardMessage
                                 self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else {
                    AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_please_select_delivery_options".setlocalized())
                    self.tblCheckoutAddress.isHidden = false
                    self.tblAddNewAddress.isHidden = true
                    self.selectedAddressId = dicsResponse.value(forKey: "ID") as! String
                    self.getAllAddress()
                }
            }
            else {
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
        else if wrapper == objTimeSlots {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrAllTimeSlot = dicsResponse.object(forKey: "Result") as! NSArray
                
                print(arrAllTimeSlot)
            }
        }
        else if wrapper == objCheckEmail {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                let logoutAlert = UIAlertController(title: "lbl_home_title".setlocalized(), message: "lbl_DeliveryAddress_your_Email_AlreadyUse".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                                         
                                         logoutAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
                                          
                                         }))
                                         
                                         logoutAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                                             print("Handle Cancel Logic here")
                                         }))
                                         
                                         present(logoutAlert, animated: true, completion: nil)
//                self.arrAllTimeSlot = dicsResponse.object(forKey: "Result") as! NSArray
//
//                print(arrAllTimeSlot)
            }
            else
            {
                CreateGuestUser()
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        
    }
    override func viewWillLayoutSubviews() {
        
    }
    // MARK: - Collectionview Delegate and datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionDateTime {
            var daysLimit:Int=0
            if UserDefaults.standard.object(forKey: kDaysLimit) != nil {
                daysLimit = Int(UserDefaults.standard.object(forKey: kDaysLimit) as! String)!
            }
            
            return daysLimit
        }
        else {
            return self.arrRelatedTimeSlots.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionDateTime {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckoutAddressDateTimeCollectionCell", for: indexPath) as! CheckoutAddressDateTimeCollectionCell
            cell.viewBack.layer.cornerRadius = 10
            cell.viewBack.layer.borderWidth = 0.5
            cell.viewBack.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
            let strDate = self.getOnlyDate(date: self.arrDate.object(at: indexPath.row) as! Date)
            cell.lblDate.text = strDate
            
            cell.lblDay.text = self.getWeekDay(date: self.arrDate.object(at: indexPath.row) as! Date)
            
            if selectedDateIndex == indexPath.row {
                selectedDate = self.arrDate.object(at: selectedDateIndex) as! Date
                cell.lblDay.backgroundColor = btnBackgroundColor
                cell.lblDate.backgroundColor = btnBackgroundColor
                cell.lblDay.textColor = UIColor.white
                cell.lblDate.textColor = UIColor.white
            }
            else {
                cell.lblDay.backgroundColor = UIColor.white
                cell.lblDate.backgroundColor = UIColor.white
                cell.lblDay.textColor = UIColor.darkGray
                cell.lblDate.textColor = UIColor.darkGray
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckoutAddressTimeCell", for: indexPath) as! CheckoutAddressTimeCell
            let dicTime = self.arrRelatedTimeSlots[indexPath.row] as! NSDictionary
            cell.viewTimeSlot.layer.cornerRadius = 10
            cell.viewTimeSlot.layer.borderWidth = 0.5
            cell.viewTimeSlot.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
           
            if selectedDateIndex != -1 {
                
                let strDate = AppHelper.dateToString(date: selectedDate, strFormate: "yyyy-MM-dd")
                print(strDate)
                let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
                
                cell.lblTime.text =  "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
                
                if isFutureDate(strTimeStamp: strTimeStamp) == true {
                    if selectedTimeSlotIndex == indexPath.row {
                        cell.viewTimeSlot.backgroundColor = btnBackgroundColor
                        cell.lblTime.backgroundColor = btnBackgroundColor
                        cell.viewSubTimeSlot.backgroundColor = btnBackgroundColor
                        cell.lblTime.textColor = UIColor.white
                    }
                    else {
                        cell.lblTime.backgroundColor = UIColor.white
                        cell.lblTime.textColor = UIColor.darkGray
                        cell.viewSubTimeSlot.backgroundColor = UIColor.white
                        cell.viewTimeSlot.backgroundColor = UIColor.white
                    }
                }
                else {
                    cell.lblTime.backgroundColor = UIColor.white
                    cell.viewTimeSlot.backgroundColor = UIColor.white
                    cell.viewSubTimeSlot.backgroundColor = UIColor.white
                    cell.lblTime.textColor = UIColor.gray
                }

            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionDateTime {
            return CGSize(width: 72, height: 72)
        }
        else {
            
           //  return CGSize(width: self.view.frame.size.width/2 - 20, height: 90)
            if AppHelper.isEven(number: timeSlots) == true {
                return CGSize(width: self.view.frame.size.width/2 - 20, height: 30)
            }
            else {

                if indexPath.row < timeSlots - 1 {
                    return CGSize(width: self.view.frame.size.width/2 - 20, height: 30)
                }
                else {
                    return CGSize(width: self.view.frame.size.width - 30, height: 30)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionDateTime {
            self.selectedDateIndex = indexPath.row
            selectedDate = self.arrDate.object(at: indexPath.row) as! Date
            print(selectedDate)
            let selectedWeekDay = self.getWeekDay(date: self.arrDate.object(at: indexPath.row) as! Date)
            print(selectedWeekDay)
            self.arrRelatedTimeSlots.removeAllObjects()
            
            for day in 0..<self.arrAllTimeSlot.count {
                let dicTime = self.arrAllTimeSlot.object(at: day) as! NSDictionary
                print(dicTime.object(forKey: "cDay") as! String)
                if (dicTime.object(forKey: "cDay") as! String).contains(selectedWeekDay) {
                    let strDate = AppHelper.dateToString(date: selectedDate, strFormate: "yyyy-MM-dd")
                    print(strDate)
                    let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
                    if isFutureDate(strTimeStamp: strTimeStamp) == true {
                        self.arrRelatedTimeSlots.add(dicTime)
                    }
                }
            }
            print(self.arrRelatedTimeSlots)
            self.timeSlots = self.arrRelatedTimeSlots.count
            self.selectedTimeSlotIndex = -1
            self.collectionDateTime.reloadData()
            if timeSlots > 0 {
                self.collectionTime.isHidden = false
                self.collectionTime.reloadData()
            }
            else {
                self.collectionTime.isHidden = true
                self.lblDeliveryTimeMessage.text = "lbl_DeliveryAddress_no_delivery_time_available".setlocalized()
            }
        }
        else {
            let dicTime = self.arrRelatedTimeSlots[indexPath.row] as! NSDictionary
            let strDate = AppHelper.dateToString(date: selectedDate, strFormate: "yyyy-MM-dd")
            let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
            self.selectedTimeSlot = "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
            print(self.selectedTimeSlot)
            self.selectedTimeSlotIndex = indexPath.row
            if isFutureDate(strTimeStamp: strTimeStamp) == true {
                self.collectionTime.reloadData()
            }
            
            self.isDateTimeSelected = true
                   
                   self.tabBarController?.tabBar.isHidden = false
                   self.viewSubDateTime.removeFromSuperview()
                   UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                       self.viewBlackShadow.isHidden = true
                       self.bottomMarginDateTimePicker.constant = -450
                       self.view.layoutIfNeeded()
                   }, completion: nil)
                   self.hidesBottomBarWhenPushed = false
                   
                   self.tblCheckoutAddress.reloadData()
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

class MyTapGesture: UITapGestureRecognizer {
    var cell = CheckoutAddNewAddress()
    var checkoutCell = CheckoutAddNewAddressCell()
}
