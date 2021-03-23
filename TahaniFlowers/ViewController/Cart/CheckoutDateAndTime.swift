//
//  CheckoutDateAndTime.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckoutDateAndTime: UIViewController,UISearchBarDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,HttpWrapperDelegate,UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var viewDateAndTimeTitle: UIView!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var viewRoundCircle: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewSelectDate: UIView!
    @IBOutlet weak var txtSelectDate: UITextField!
    @IBOutlet weak var viewSelectTime: UIView!
    @IBOutlet weak var txtSelectTime: UITextField!
    @IBOutlet weak var lblSelectPaymentMethod: UILabel!
    @IBOutlet weak var viewMakeOnlinePayment: UIView!
    @IBOutlet weak var imgOnlinePayment: UIImageView!
    @IBOutlet weak var lblOnlinePayment: UILabel!
    @IBOutlet weak var btnOnlinePayment: UIButton!
    @IBOutlet weak var viewCashOnDelivery: UIView!
    @IBOutlet weak var imgCashOnDelivery: UIImageView!
    @IBOutlet weak var lblCashOnDelivery: UILabel!
    @IBOutlet weak var btnCashOnDelivery: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnAddCardMessage: UIButton!
    @IBOutlet weak var viewCardMessage: UIView!
    @IBOutlet weak var txtCardMessage: UITextView!
    @IBOutlet weak var topMarginSelectPaymentMethod: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredCardMessage: UILabel!
    @IBOutlet weak var lblCardMessagePlaceholder: UILabel!
    
    // MARK: - Variables
    
    var searchBar = UISearchBar()
    var timePicker: UIPickerView!
    var arrRelatedTimeSlots:NSMutableArray = NSMutableArray()
    var paymentMethod = ""
    var selectedDate:Date = Date()
    var selectedWeekDay = ""
    var arrAllTimeSlot:NSArray = NSArray()
    var objTimeSlots = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    let weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var selectedTimeIndex = 0
    var lastIndex = -1
    var selecedTime = ""
    var isCardMessage:Bool = false
    var strCardMessage = ""
    // MARK: - Viewcontroller Method
    
    override func viewDidLoad() {
        
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
        self.btnNext.setTitle("Pay", for: .normal)
        self.paymentMethod = "ONLINE"
        
        timePicker = UIPickerView()
        
        timePicker.dataSource = self
        timePicker.delegate = self
        
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtCardMessage.textAlignment = .left
        }
        else {
            self.txtCardMessage.textAlignment = .right
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTimeSlots()
        self.addNavigationBar()
        
        if self.paymentMethod == "ONLINE" {
            self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
        }
        else {
            self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
        }
        
        print(selectedDate)
        print(selecedTime)
        
        self.viewRoundCircle.layer.cornerRadius = 7.5
        self.viewRoundCircle.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewRoundCircle.clipsToBounds = true
        self.viewRoundCircle.layer.borderWidth = 1
        self.viewRoundCircle.backgroundColor = UIColor.white
        self.lblDateAndTime.text = "step_two_date_and_time".setlocalized()
        
        self.viewLine.backgroundColor = UIColor(hexString: "#B0B1B3")
        
        self.btnNext.layer.cornerRadius = btnRadius
        self.btnNext.clipsToBounds = true
//        self.btnNext.setTitle("step_two_next".setlocalized(), for: .normal)
        
        self.viewSelectDate.layer.cornerRadius = 20
        self.viewSelectDate.layer.borderWidth = 1
        self.viewSelectDate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewSelectDate.clipsToBounds = true
        self.txtSelectDate.placeholder = "step_two_select_date".setlocalized()
        
        self.viewSelectTime.layer.cornerRadius = 20
        self.viewSelectTime.layer.borderWidth = 1
        self.viewSelectTime.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewSelectTime.clipsToBounds = true
        self.txtSelectTime.placeholder = "step_two_select_time".setlocalized()
        
        self.viewMakeOnlinePayment.layer.cornerRadius = 2
        self.viewMakeOnlinePayment.layer.borderWidth = 1
        self.viewMakeOnlinePayment.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewMakeOnlinePayment.clipsToBounds = true
        self.lblOnlinePayment.text = "step_two_make_online_payment".setlocalized()
        
        self.viewCashOnDelivery.layer.cornerRadius = 2
        self.viewCashOnDelivery.layer.borderWidth = 1
        self.viewCashOnDelivery.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewCashOnDelivery.clipsToBounds = true
        self.lblCashOnDelivery.text = "step_two_make_cash_on_delivey".setlocalized()
        
        self.lblSelectPaymentMethod.text = "step_two_select_payment_method".setlocalized()
        let tapCODTap = UITapGestureRecognizer(target: self, action: #selector(onTapCOD))
        tapCODTap.numberOfTapsRequired = 1
        self.viewCashOnDelivery.isUserInteractionEnabled = true
        self.viewCashOnDelivery.addGestureRecognizer(tapCODTap)
        
        let tapMOPTap = UITapGestureRecognizer(target: self, action: #selector(onTapMOP))
        tapMOPTap.numberOfTapsRequired = 1
        self.viewMakeOnlinePayment.isUserInteractionEnabled = true
        self.viewMakeOnlinePayment.addGestureRecognizer(tapMOPTap)
        
        self.viewCardMessage.layer.cornerRadius = 2
        self.viewCardMessage.layer.borderWidth = 1
        self.viewCardMessage.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        self.viewCardMessage.clipsToBounds = true
        
    }
    
    // MARK: - IBActions
    
    
    @IBAction func onClickAddCardMessage(_ sender: Any) {
        if isCardMessage == false {
            self.btnAddCardMessage.setImage(UIImage(named: "ic_cart_message_checked"), for: .normal)
            topMarginSelectPaymentMethod.constant = 70
            self.viewCardMessage.isHidden = false
            isCardMessage = true
        }
        else {
            self.btnAddCardMessage.setImage(UIImage(named: "ic_cart_message_unchecked"), for: .normal)
            topMarginSelectPaymentMethod.constant = 10
            self.viewCardMessage.isHidden = true
            self.lblRequiredCardMessage.isHidden = true
            self.txtCardMessage.text = ""
            self.lblCardMessagePlaceholder.isHidden = false
            self.viewCardMessage.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            isCardMessage = false
        }
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        
//        if self.txtSelectDate.text == "" {
//            AppHelper.showMessage(view: self.view, message: "Please select date")
//        }
//        else if self.txtSelectTime.text == "" {
//            AppHelper.showMessage(view: self.view, message: "Please select time")
//        }
//        else if
        self.strCardMessage = self.txtCardMessage.text!
        if isCardMessage == true && AppHelper.isNull(self.strCardMessage) == true {
            self.lblRequiredCardMessage.isHidden = false
            self.topMarginSelectPaymentMethod.constant = 90
            self.viewCardMessage.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.lblRequiredCardMessage.text = "required".setlocalized()
        }
        else if isCardMessage == true && AppHelper.maxLength(self.strCardMessage, 200) == false {
            self.lblRequiredCardMessage.isHidden = false
            self.topMarginSelectPaymentMethod.constant = 90
            self.viewCardMessage.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.lblRequiredCardMessage.text = "signup_max_one_zero_zero_characters_allowed".setlocalized()
        }
        else if self.paymentMethod == "" {
            AppHelper.showMessage(view: self.view, message: "Please select payment method")
        }
        else {
            
            if paymentMethod == "COD" {
                let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                nextViewController.paymentMethod = self.paymentMethod
                nextViewController.selectedDate = self.txtSelectDate.text!
                nextViewController.selecedTime = selecedTime
                nextViewController.date = self.selectedDate
                nextViewController.cardMessage = self.strCardMessage
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
            else {
                let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                nextViewController.paymentMethod = self.paymentMethod
                nextViewController.selectedDate = self.txtSelectDate.text!
                nextViewController.selecedTime = selecedTime
                nextViewController.date = self.selectedDate
                nextViewController.cardMessage = self.strCardMessage
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
    

    @IBAction func onClickMOP(_ sender: UIButton) {
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
        self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
        self.paymentMethod = "ONLINE"
    }
    
    @IBAction func onClickCOD(_ sender: UIButton) {
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
        self.paymentMethod = "COD"
        self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
    }
    
    // MARK: - @objc Actions
    
    @objc func onTapMOP() {
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
        self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        self.btnNext.setTitle("step_two_pay".setlocalized(), for: .normal)
        self.paymentMethod = "ONLINE"
    }
    
    @objc func onTapCOD() {
        self.btnOnlinePayment.setBackgroundImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        self.btnCashOnDelivery.setBackgroundImage(UIImage(named: "ic_radio_checked"), for: .normal)
        self.btnNext.setTitle("step_two_confirm_order".setlocalized(), for: .normal)
        self.paymentMethod = "COD"
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        self.selectedDate = sender.date
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.txtSelectDate.text = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dayNo = AppHelper.getDayOfWeek(today: dateFormatter.string(from: sender.date))
        
        self.selectedWeekDay = self.weekdays[dayNo! - 1]
        print(selectedWeekDay)
        
        self.arrRelatedTimeSlots.removeAllObjects()
        
        for day in 0..<self.arrAllTimeSlot.count {
            let dicTime = self.arrAllTimeSlot.object(at: day) as! NSDictionary
            if dicTime.object(forKey: "cDay") as! String == selectedWeekDay {
                self.arrRelatedTimeSlots.add(dicTime)
            }
        }
        self.selectedTimeIndex = 0
        self.txtSelectTime.text = ""
    }
    
    @objc func handleTimePicker(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.txtSelectTime.text = formatter.string(from: sender.date)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Custom Methods
    
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
        print(Date())
        print(dateSt)
        print(currentStamp)
        
        if Int(currentStamp) < dateSt {
            return true
        }
        else {
            return false
        }
    }
    
    func getTimeSlots() {
        
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
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "step_two_title".setlocalized()
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
    
    // MARK: - Textfiled Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtSelectDate {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            
            // Today Date
            
            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "dd MMM yyyy"
            var date = Date()
            datePickerView.minimumDate = date
            if selectedDate != nil {
                date = selectedDate
                datePickerView.date = selectedDate
            }
            self.selectedDate = date
            self.txtSelectDate.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let dayNo = AppHelper.getDayOfWeek(today: dateFormatter.string(from: date))
            self.selectedWeekDay = self.weekdays[dayNo! - 1]
            print(selectedWeekDay)
            
            self.arrRelatedTimeSlots.removeAllObjects()
            
            for day in 0..<self.arrAllTimeSlot.count {
                let dicTime = self.arrAllTimeSlot.object(at: day) as! NSDictionary
                if dicTime.object(forKey: "cDay") as! String == selectedWeekDay {
                    self.arrRelatedTimeSlots.add(dicTime)
                }
            }

            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        }
        if textField == self.txtSelectTime {
            if self.arrRelatedTimeSlots.count != 0 {
                self.txtSelectTime.inputView = timePicker
                let dicTime = self.arrRelatedTimeSlots[selectedTimeIndex ] as! NSDictionary
                self.txtSelectTime.text = "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
            }
            else {
                AppHelper.showMessage(view: self.view, message: "Please select another date")
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    // MARK: - Textview Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text! + text)
        if textView.text == "" {
            self.lblCardMessagePlaceholder.isHidden = false
        }
        else {
            self.lblCardMessagePlaceholder.isHidden = true
        }
        
        if textView == self.txtCardMessage{
            if str.count >= 0 && str.count <= 200 {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.viewCardMessage.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        self.topMarginSelectPaymentMethod.constant = 70
        self.lblRequiredCardMessage.isHidden = true
    }
    
    // MARK: - Pickerview Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dicTime = self.arrRelatedTimeSlots[row] as! NSDictionary
        
        let strDate = AppHelper.dateToString(date: self.selectedDate, strFormate: "yyyy-MM-dd")
        
        let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
        
        if isFutureDate(strTimeStamp: strTimeStamp) == true {
            pickerView.selectRow(row, inComponent: component, animated: true)
            if lastIndex == -1 {
                lastIndex = row
                self.txtSelectTime.text = "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
            }
        }
        else {
            print(lastIndex)
            pickerView.selectRow(lastIndex, inComponent: component, animated: true)
        }
        
        if row == self.arrRelatedTimeSlots.count - 1{
            if lastIndex == -1 {
                self.txtSelectTime.text = ""
                self.txtSelectTime.resignFirstResponder()
                AppHelper.showMessage(view: self.view, message: "Select another date")
                return ""
            }
            else {
                return "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
            }
        }
        else {
            return "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrRelatedTimeSlots.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if lastIndex != -1 {
            let dicTime = self.arrRelatedTimeSlots[row] as! NSDictionary
            self.selectedTimeIndex = row
            
            
            let strDate = AppHelper.dateToString(date: self.selectedDate, strFormate: "yyyy-MM-dd")
            
            let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
            
            if self.isFutureDate(strTimeStamp: strTimeStamp) == true {
                pickerView.selectRow(row, inComponent: component, animated: true)
            }
            else {
                pickerView.selectRow(self.lastIndex, inComponent: component, animated: true)
            }
            
            if row == self.arrRelatedTimeSlots.count - 1{
                if self.lastIndex == -1 {
                    self.txtSelectTime.resignFirstResponder()
                }
                else {
                    self.txtSelectTime.text = "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
                }
            }
            else {
                self.txtSelectTime.text = "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
            }
        }
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objTimeSlots {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrAllTimeSlot = dicsResponse.object(forKey: "Result") as! NSArray
                self.timePicker.reloadAllComponents()
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
