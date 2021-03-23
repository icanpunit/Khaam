//
//  ContactUs.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 24/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class ContactUs: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate,MFMailComposeViewControllerDelegate  {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblContactUs: UITableView!
    
    // MARK: - Variables
    var selectedDate:Date = Date()
     var date:Date = Date()
    var fSubTotal:Float = 0
    var fGrandTotal:Float = 0
     var selecedTime = ""
    var selectedAddressId = ""
       var completeAddress:NSMutableString = NSMutableString()
    var isAppointment:Bool = false
   
    @IBOutlet weak var lblTitle: UILabel!
    var objContactUs  = HttpWrapper()
    var objContactUsDetails  = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var arrContactDetails:NSArray = NSArray()
    var cellHeigt:CGFloat = 0
    var cellMessageHeight:CGFloat = 0.0
    var isVerify:Bool = false
    var dicCompanyAddress:NSDictionary = NSDictionary()
    var dicCompanyEmail:NSDictionary = NSDictionary()
    var dicCompanyContact:NSDictionary = NSDictionary()
    var dicSupportInq:NSDictionary = NSDictionary()
    var dicWhatsApp:NSDictionary = NSDictionary()
    var dicComplains:NSDictionary = NSDictionary()
    var dicOrderTracking:NSDictionary = NSDictionary()
    
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScrren = "ContactUs"
        
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
        self.getContactUsDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @objc func onClickContactUs(_ sender:MyContactusTap) {
        let cell = sender.cell
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let name = cell.txtUserName.text!
            let emailid = cell.txtEmailAddress.text!
            let contactNo = cell.txtContact.text!
            let message = cell.txtMessage.text!

            var flag = true
            var fieldCount = 0
            
            if AppHelper.isNull(name) == true {
                fieldCount = fieldCount + 1
                cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                cell.lblRequiredName.isHidden = false
                cell.lblRequiredName.text = "required".setlocalized()
                cell.bottomSpaceName.constant = 30
                flag = false
            }
//            else if AppHelper.maxLength(name, 20) == false {
//                fieldCount = fieldCount + 1
//                cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//                cell.lblRequiredName.isHidden = false
//                cell.lblRequiredName.text = "signup_max_two_zero_characters_allowed".setlocalized()
//                cell.bottomSpaceName.constant = 30
//                flag = false
//            }
            else {
                cell.lblRequiredName.isHidden = true
                cell.bottomSpaceName.constant = 10
                cell.viewName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            }
            
            if AppHelper.isNull(emailid) == true {
                fieldCount = fieldCount + 1
                cell.bottomSapceEmail.constant = 30
                cell.lblRequiredEmail.isHidden = false
                cell.lblRequiredEmail.text = "required".setlocalized()
                cell.viewEmail.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else if AppHelper.isValidEmail(emailid) == false {
                fieldCount = fieldCount + 1
                cell.bottomSapceEmail.constant = 30
                cell.lblRequiredEmail.isHidden = false
                cell.lblRequiredEmail.text = "EnterValidEmail".setlocalized()
                cell.viewEmail.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else{
                cell.bottomSapceEmail.constant = 10
                cell.lblRequiredEmail.isHidden = true
                cell.viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            }
            
            if AppHelper.isNull(contactNo) == true {
                fieldCount = fieldCount + 1
                cell.bottomSpaceContact.constant = 30
                cell.lblRequiredContact.isHidden = false
                cell.lblRequiredContact.text = "required".setlocalized()
                cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else if AppHelper.isValidMobileNumber(contactNo) == false {
                fieldCount = fieldCount + 1
                cell.bottomSpaceContact.constant = 30
                cell.lblRequiredContact.isHidden = false
                cell.lblRequiredContact.text = "signup_only_digits_allowed".setlocalized()
                cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
//            else if AppHelper.minLength(contactNo, 10) == false {
//                fieldCount = fieldCount + 1
//                cell.bottomSpaceContact.constant = 30
//                cell.lblRequiredContact.isHidden = false
//                cell.lblRequiredContact.text = "signup_enter_valid_mobile_number_allowed".setlocalized()
//                cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//                flag = false
//            }
            else if AppHelper.maxLength(contactNo, 10) == false {
                fieldCount = fieldCount + 1
                cell.bottomSpaceContact.constant = 30
                cell.lblRequiredContact.isHidden = false
                cell.lblRequiredContact.text = "signup_max_one_zero_characters_allowed".setlocalized()
                cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else {
                cell.bottomSpaceContact.constant = 10
                cell.lblRequiredContact.isHidden = true
                cell.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            }
              
            
              if isAppointment == true
                   {
                       
                   }
                   else
                   {
                       if AppHelper.isNull(message) == true {
                                      fieldCount = fieldCount + 1
                                      cell.lblRequiredMessage.isHidden = false
                                      cell.lblRequiredMessage.text = "required".setlocalized()
                                      cell.viewMessage.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                                      flag = false
                                  }
                                  else if AppHelper.maxLength(message, 100) == false {
                                      fieldCount = fieldCount + 1
                                      cell.lblRequiredMessage.isHidden = false
                                      cell.lblRequiredMessage.text = "signup_max_one_zero_zero_characters_allowed".setlocalized()
                                      cell.viewMessage.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                                      flag = false
                                  }
                                  else {
                                      cell.lblRequiredMessage.isHidden = true
                                      cell.viewMessage.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
                                  }
                   }
           
            
            if flag == false {
                self.tblContactUs.reloadData()
                cellMessageHeight = CGFloat(fieldCount * 20)
                self.view.layoutIfNeeded()
            }
            else {
                
                if isAppointment == true
                {
                    let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderCheckout") as! OrderCheckout
                                                            
                                  let dateFormatter = DateFormatter()
                                                            //            dateFormatter.locale = Locale(identifier: "en")
                                  dateFormatter.dateFormat = "dd MMM yyyy"
                                  var date = Date()
                                                                        
                                  if selectedDate != nil {
                                      date = selectedDate
                                      // datePickerView.date = selectedDate
                                  }
                                                                       
                                  nextViewController.isAppointment = true
                                  nextViewController.selectedAddressId = self.selectedAddressId
                                  nextViewController.selectedDate = dateFormatter.string(from: date)
                                  nextViewController.selecedTime = selecedTime
                                  nextViewController.date = date
                    nextViewController.completeAddress = completeAddress
                    nextViewController.ApName = name
                    nextViewController.ApEmail = emailid
                    nextViewController.ApMobile = contactNo
                              nextViewController.fGrandTotal = fGrandTotal
                              nextViewController.fSubTotal = fGrandTotal
                                //nextViewController.cardMessage = self.strCardMessage
                                  self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else
                {
                    var param:String = ""
                    
                    param = String(format: "%@?cName=%@&cEmail=%@&cMobileno=%@&cMessage=%@", kContactUs,name,emailid,contactNo,message)
                    
                    print(param)
                    
                    let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                    
                    AppHelper.showLoadingView()
                    self.objContactUs = HttpWrapper.init()
                    self.objContactUs.delegate = self
                    self.objContactUs.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
                }
                
            }
        }
    }
    
    @objc func onClickEmail(_ sender:MyContactusTap) {
        let cell = sender.cellContact
        let email = cell.lblEmailDesc.text // insert your email here
        let subject = ""
        let bodyText = ""
        
        // https://developer.apple.com/documentation/messageui/mfmailcomposeviewcontroller
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            
            mailComposerVC.setToRecipients([email!])
            mailComposerVC.setSubject(subject)
            mailComposerVC.setMessageBody(bodyText, isHTML: false)
            
            self.present(mailComposerVC, animated: true, completion: nil)
            
        } else {
            print("Device not configured to send emails, trying with share ...")
            
            let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!) {
                if #available(iOS 10.0, *) {
                    if UIApplication.shared.canOpenURL(emailURL) {
                        UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                            if !result {
                                print("Unable to send email.")
                            }
                        })
                    }
                }
                else {
                    UIApplication.shared.openURL(emailURL as URL)
                }
            }
        }
    }
    
    @objc func onClickNumber(_ sender:MyContactusTap) {
        
    }
   
    @objc func back() {
         appDelegate.SetTabBarItem(0)
    }
    
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - Custom Method
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getContactUsDetails()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getContactUsDetails () {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&cPageName=%@&cToken=%@", kContactAbout,"\(nUserId)","Contact us","\(cToken)")
            
            print(param)
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objContactUsDetails = HttpWrapper.init()
            self.objContactUsDetails.delegate = self
            self.objContactUsDetails.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        
        if isAppointment == true
        {
            lblTitle.text = "lbl_Appoinment_UserDetail".setlocalized()
            
        }
        else
        {
            lblTitle.text = "contact_us".setlocalized()
        }
        
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
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
        self.navigationItem.rightBarButtonItems = []
    }
    
    // MARK: - UITableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrContactDetails.count != 0 {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsGetInTouchCell") as! ContactUsGetInTouchCell
            
//            let dicAddress = self.arrContactDetails.object(at: 0) as! NSDictionary
            
//            cell.viewLocation.layer.cornerRadius = 3
//            cell.viewLocation.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
//            cell.viewLocation.layer.borderWidth = 1
//            cell.viewLocation.clipsToBounds = true
            var companyAddress = ""
            if let address = dicCompanyAddress.object(forKey: "cPageContent") as?String {
                companyAddress = address
                cell.lblLocationDesc.text = address
            }
            
            let font = UIFont(name: RalewayRegular, size: 14.0)
            
            let height = AppHelper.heightForView(text: companyAddress, font: font!, width: self.view.frame.width - 50) + 44
            
            cell.viewLocationHeight.constant = height
            
            cellHeigt = height
            
          
            if let strEmail = dicCompanyEmail.object(forKey: "cPageContent") as? String {
                cell.lblEmailDesc.text = strEmail
                
            }
            
            
            if let contactNumber = dicCompanyContact.object(forKey: "cPageContent") as? String {
                cell.lblContactNumberDesc.text = contactNumber
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.OnClickNumberToCall))
                cell.lblContactNumberDesc.isUserInteractionEnabled = true
                cell.lblContactNumberDesc.tag = 5
                cell.lblContactNumberDesc.addGestureRecognizer(tap)
            }
            
//            let contactTap = MyContactusTap(target: self, action: #selector(onClickNumber))
//            contactTap.numberOfTapsRequired = 1
//            contactTap.cellContact = cell
//            cell.lblContactNumberDesc.isUserInteractionEnabled = true
//            cell.lblContactNumberDesc.addGestureRecognizer(contactTap)
            
            let emailTap = MyContactusTap(target: self, action: #selector(onClickEmail))
            emailTap.numberOfTapsRequired = 1
            emailTap.cellContact = cell
            cell.lblEmailDesc.isUserInteractionEnabled = true
            cell.lblEmailDesc.addGestureRecognizer(emailTap)
        
            cell.lblForSupportAndInq.text = "contact_us_for_support_and_order_inquires".setlocalized()
            cell.lblForComplains.text = "contact_us_for_complains".setlocalized()
            cell.lblForOrderTrackingDelivery.text = "contact_us_for_order_tracking_and_delivery".setlocalized()
            cell.lblForWhatsapp.text = "contact_us_for_whatsApp".setlocalized()
            
            cell.lblLoationTitle.text = "contact_us_location".setlocalized()
            cell.lblEmailTitle.text = "contact_us_email_address_placeholder".setlocalized()
            cell.lblContactNumber.text = "contact_us_contact_number_placeholder".setlocalized()
            cell.lblForSupportAndInq.text = "contact_us_for_support_and_order_inquires".setlocalized()
            cell.lblForComplains.text = "contact_us_for_complains".setlocalized()
            cell.lblForOrderTrackingDelivery.text = "contact_us_for_order_tracking_and_delivery".setlocalized()
            cell.lblForWhatsapp.text = "contact_us_for_whatsApp".setlocalized()
            
            if let forSupport = dicSupportInq.object(forKey: "cPageContent") as? String {
                cell.lblSupportAndInqContact.text = forSupport
                 let tap = UITapGestureRecognizer(target: self, action: #selector(self.OnClickNumberToCall))
                cell.lblSupportAndInqContact.isUserInteractionEnabled = true
                 cell.lblSupportAndInqContact.tag = 1
                cell.lblSupportAndInqContact.addGestureRecognizer(tap)
            }
            
            if let forComplains = dicComplains.object(forKey: "cPageContent") as? String {
                cell.lblForComplainsContact.text = forComplains
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.OnClickNumberToCall))
                cell.lblForComplainsContact.isUserInteractionEnabled = true
                cell.lblForComplainsContact.tag = 2
                cell.lblForComplainsContact.addGestureRecognizer(tap)
            }
            
            if let forOrder = dicOrderTracking.object(forKey: "cPageContent") as? String {
                cell.lblForOrderTrackingDeliveryContact.text = forOrder
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.OnClickNumberToCall))
                cell.lblForOrderTrackingDeliveryContact.isUserInteractionEnabled = true
                cell.lblForOrderTrackingDeliveryContact.tag = 3
                cell.lblForOrderTrackingDeliveryContact.addGestureRecognizer(tap)
            }
            
            if let forWhatsapp = dicWhatsApp.object(forKey: "cPageContent") as? String {
                cell.lblForWhatsappContact.text = forWhatsapp
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.OnClickNumberToCall))
                cell.lblForWhatsappContact.isUserInteractionEnabled = true
                cell.lblForWhatsappContact.tag = 4
                cell.lblForWhatsappContact.addGestureRecognizer(tap)
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsSendMessageCell") as! ContactUsSendMessageCell
            if isVerify == false {
                cell.viewName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
                cell.viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
                cell.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
                cell.viewMessage.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
                isVerify = true
            }
            
            if isAppointment == true
            {
                cell.viewMessage.isHidden = true
                cell.viewMsgHeightConstant.constant = 0
                cell.txtUserName.text = appDelegate.bookingName
                cell.txtContact.text = appDelegate.BookingNumber
                
                if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                               if UserDefaults.standard.object(forKey: kcEmail) != nil {
                                   let editProfileEmailID = UserDefaults.standard.object(forKey: kcEmail) as! String
                                   if AppHelper.isValidEmail(editProfileEmailID) {
                                       cell.txtEmailAddress.text = editProfileEmailID
                                   }
                                   else {
                                      
                                   }
                               }
                               else {
                                  
                               }
                           }
                else
                {
                   cell.txtEmailAddress.text = appDelegate.BookingEmail
                }
                
                
                 
            }
            
            cell.txtUserName.placeholder = "contact_us_name_placeholder".setlocalized()
            cell.txtContact.placeholder = "contact_us_contact_number_placeholder".setlocalized()
            cell.txtMessage.placeholder = "contact_us_message_placeholder".setlocalized()
            cell.txtEmailAddress.placeholder = "contact_us_email_address_placeholder".setlocalized()
            
//            cell.viewName.layer.cornerRadius = 20
//            cell.viewName.layer.borderWidth = 1
//            cell.viewName.clipsToBounds = true
//            
//            cell.viewEmail.layer.cornerRadius = 20
//            cell.viewEmail.layer.borderWidth = 1
//            cell.viewEmail.clipsToBounds = true
//            
//            cell.viewContact.layer.cornerRadius = 20
//            cell.viewContact.layer.borderWidth = 1
//            cell.viewContact.clipsToBounds = true
//            
//            cell.viewMessage.layer.cornerRadius = 20
//            cell.viewMessage.layer.borderWidth = 1
//            cell.viewMessage.clipsToBounds = true
            
            cell.btnSend.layer.cornerRadius = btnRadius
            cell.btnSend.clipsToBounds = true
            
            let sendTap = MyContactusTap(target: self, action: #selector(onClickContactUs))
            sendTap.numberOfTapsRequired = 1
            sendTap.cell = cell
            cell.btnSend.isUserInteractionEnabled = true
            cell.btnSend.addGestureRecognizer(sendTap)
            cell.btnSend.setTitle("contact_us_send".setlocalized(), for: .normal)
            cell.btnSend.backgroundColor = btnBackgroundColor
            cell.btnSend.setTitleColor(btnTitleColor, for: .normal)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30 , height: 30))
        headerView.backgroundColor = UIColor.clear
        
        let headerName = UILabel(frame: CGRect(x: 20, y: 10, width: self.view.frame.size.width-20, height: 20))
        headerName.textColor = UIColor(hexString: "#000000")
        headerName.font = UIFont(name: RalewayRegular, size: 18)
        if section == 0 {
            headerName.text = "get_in_touch".setlocalized()
        }
        else {
            headerName.text = "send_us_message".setlocalized()
        }
        
        headerView.addSubview(headerName)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            return 0//295 + cellHeigt
        }
        else {
            return 290 + cellMessageHeight
        }
    }
    
    
    @objc
    func OnClickNumberToCall(sender:UITapGestureRecognizer) {
        print("tap working")
        if sender.view?.tag == 1
        {
            if let forSupport = dicSupportInq.object(forKey: "cPageContent") as? String {
                if let url = NSURL(string: "tel://\(forSupport)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        else if sender.view?.tag == 2
        {
            if let forComplains = dicComplains.object(forKey: "cPageContent") as? String {
                if let url = NSURL(string: "tel://\(forComplains)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        else if sender.view?.tag == 3
        {
            if let forOrder = dicOrderTracking.object(forKey: "cPageContent") as? String {
                if let url = NSURL(string: "tel://\(forOrder)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        else if sender.view?.tag == 4
        {
            if let forWhatsapp = dicWhatsApp.object(forKey: "cPageContent") as? String {
                let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(forWhatsapp)")!
                if UIApplication.shared.canOpenURL(appURL as URL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                    }
                    else {
                        UIApplication.shared.openURL(appURL as URL)
                    }
                }
                else {
                    // Whatsapp is not installed
                }
            }
            
        }
        else if sender.view?.tag == 5
        {
             if let contactNumber = dicCompanyContact.object(forKey: "cPageContent") as? String {
                if let url = NSURL(string: "tel://\(contactNumber)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
        }
        
       

    }
    // MARK:- HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objContactUs {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                if let message = dicsResponse.object(forKey: "Message") as? String {
                    UserDefaults.standard.set(message, forKey: kisMessage)
                    appDelegate.SetTabBarItem(0)
                }
            }
        }
        else if wrapper == objContactUsDetails {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                self.arrContactDetails = dicsResponse.object(forKey: "Result") as! NSArray
                
                for index in 0..<self.arrContactDetails.count {
                    let dicResult = self.arrContactDetails.object(at: index) as! NSDictionary
                    if let cPageTitle = dicResult.object(forKey: "cPageTitle") as? String {
                        
                        if cPageTitle == "Company Address1" {
                            self.dicCompanyAddress = dicResult
                        }
                        else if cPageTitle == "Company Email" {
                            self.dicCompanyEmail = dicResult
                        }
                        else if cPageTitle == "Company Phone Number" {
                            self.dicCompanyContact = dicResult
                        }
                        else if cPageTitle == "Support & Order Inquires" {
                            self.dicSupportInq = dicResult
                        }
                        else if cPageTitle == "WhatsApp" {
                            self.dicWhatsApp = dicResult
                        }
                        else if cPageTitle == "Complains" {
                            self.dicComplains = dicResult
                        }
                        else if cPageTitle == "Order Tracking & Delivery" {
                            self.dicOrderTracking = dicResult
                        }
                    }
                }
                
                self.tblContactUs.reloadData()
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class MyContactusTap: UITapGestureRecognizer {
    var cell = ContactUsSendMessageCell()
    var cellContact = ContactUsGetInTouchCell()
}
