//
//  Profile.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 19/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class Profile: UIViewController,UITableViewDelegate,UITableViewDataSource{

    // MARK: - IBOutlets
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet var viewPleaseLogin: UIView!
    @IBOutlet var viewFooter: UIView!
    
    @IBOutlet weak var imgSignOutUser: UIImageView!
    @IBOutlet weak var lblSignOutDetail: UILabel!
    @IBOutlet weak var lblSignOutTitle: UILabel!
    @IBOutlet weak var viewSignOut: UIView!
    @IBOutlet var viewHeaderSignOUt: UIView!
    @IBOutlet weak var lblAvailble: UILabel!
     var isBackRequired:Bool = false
    var arrFirst = ["menu_my_account".setlocalized(),"menu_my_orders".setlocalized(),"menu_my_Booking".setlocalized(),"lbl_wallet_myprofile_screen".setlocalized(),"menu_my_address".setlocalized(),"menu_my_Wishlist".setlocalized(),"menu_Edit_Profile".setlocalized()]
   
     var arrGuestFirst = ["menu_my_account".setlocalized(),"menu_my_Booking".setlocalized()]//,"menu_Call_us".setlocalized(),"menu_Chat_With_Us".setlocalized(),"menu_logout".setlocalized()
  //  var arrFirst = ["lbl_Profile_menu_Location".setlocalized(),"lbl_Profile_menu_Changepassword".setlocalized(),"lbl_Profile_menu_Shipping".setlocalized(),"lbl_Profile_menu_Payment".setlocalized()]
    var arrTwo = ["lbl_Profile_menu_AppNotifications".setlocalized(),"lbl_Language_Choose".setlocalized()]
     var arrthree = ["menu_Faq".setlocalized(),"menu_Aboutus".setlocalized(),"menu_TermsCondition".setlocalized(),"menu_Return_Policy".setlocalized(),"menu_Privacy_Policy".setlocalized(),"menu_Rate_us".setlocalized()]
    var arrHeader = ["","lbl_Profile_menu_Header_Account".setlocalized(),"lbl_Profile_menu_Header_My_setting".setlocalized(),"lbl_Profile_menu_Header_My_support".setlocalized(),"lbl_Profile_menu_Header_My_contact_us".setlocalized()]
    // MARK: - Variables
    var cellHeight:CGFloat = 0
    var isBackButton:Bool = false
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var lblTitle: UILabel!
    // MARK: - Viewcontroller Methods
    
    @IBOutlet weak var btnLogOut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblProfile.isHidden = true
        tblProfile.tableFooterView = viewFooter
        viewFooter.backgroundColor = navigationbarColor
        viewSignOut.layer.cornerRadius = btnRadius
        viewHeaderSignOUt.backgroundColor = navigationbarColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                          if currentLanguage == "en" {
                           lblSignOutTitle.textAlignment = .left
                           lblSignOutDetail.textAlignment = .left
                          }
                          else{
                              lblSignOutTitle.textAlignment = .right
                           lblSignOutDetail.textAlignment = .right
                          }
        
        var username = ""
        if UserDefaults.standard.object(forKey: kcCustomerName) != nil {
            lblTitle.text = UserDefaults.standard.object(forKey: kcCustomerName) as! String
            username = UserDefaults.standard.object(forKey: kcCustomerName) as! String
        }
        else
        {
           lblTitle.text = "lbl_Profile_Title".setlocalized()
        }
        lblAvailble.text = "lbl_Profile_AvailableTimeing".setlocalized()
        lblSignOutTitle.text = "lbl_profile_not_login_title".setlocalized()
        lblSignOutDetail.text = "lbl_profile_not_login_description".setlocalized()
//        let strlogout = "\("lbl_profile_sign_out_btn_Not_text".setlocalized())\(username)?\("lbl_profile_sign_out_text".setlocalized())"
//
//        btnLogOut.setTitle(strlogout, for: .normal)
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
               .font: UIFont(name: RalewayRegular, size: 15),
               .foregroundColor: UIColor.black]
               
               let main_string = "\("lbl_profile_sign_out_btn_Not_text".setlocalized()) \(username) ? \("lbl_profile_sign_out_text".setlocalized())"
                                 let attributedString = NSMutableAttributedString(string: main_string,attributes:[NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7e7e7e")])
                                 
                                 let string_to_color = "lbl_profile_sign_out_text".setlocalized()
                                 
                                 let range = (main_string as NSString).range(of: string_to_color)
                                 
                                 // Set the 'click here' substring to be the link
                                 attributedString.setAttributes(yourAttributes, range: range)
                                
               btnLogOut.setAttributedTitle(attributedString, for: .normal)
               btnLogOut.tintColor = UIColor.init(hexString: "7e7e7e")
        self.tblProfile.isHidden = false
        self.tblProfile.reloadData()
        
        self.addNavigationBar()
        if UserDefaults.standard.object(forKey: kisLogin) != nil {
            
            
            if UserDefaults.standard.value(forKey: kisMessage) != nil {
                AppHelper.showMessage(view: self.view, message: UserDefaults.standard.value(forKey: kisMessage) as! String)
                UserDefaults.standard.removeObject(forKey: kisMessage)
            }
            btnLogOut.isHidden = false
            tblProfile.tableHeaderView = nil
        }
        else {
            tblProfile.tableHeaderView = viewHeaderSignOUt
            btnLogOut.isHidden = true
//            let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
//            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @IBAction func onClickLoginUser(_ sender: Any) {
                    let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
                    self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func onclickEdit(_ sender: Any) {
        let nextViewController = objProfile.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
               self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @objc func gotoEditProfile() {
       
        let nextViewController = objProfile.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func back() {
        appDelegate.SetTabBarItem(0)
    }
    
    @objc func changeLanguage () {
        
       
        
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    @IBAction func onClickbtnLogOUt(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "lbl_home_title".setlocalized(), message: "menu_do_you_want_to_logout".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                                  
                                  logoutAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
                                      UserDefaults.standard.removeObject(forKey: kisLogin)
                                      UserDefaults.standard.removeObject(forKey: knLoginId)
                                      UserDefaults.standard.removeObject(forKey: kcUserName)
                                      UserDefaults.standard.removeObject(forKey: knCustomerId)
                                      UserDefaults.standard.removeObject(forKey: kcCustomerName)
                                      UserDefaults.standard.removeObject(forKey: kcEmail)
                                      UserDefaults.standard.removeObject(forKey: kcPassword)
                                      UserDefaults.standard.removeObject(forKey: kcContactNo)
                                      UserDefaults.standard.removeObject(forKey: kcGender)
                                      UserDefaults.standard.removeObject(forKey: kcCustomerType)
                                      UserDefaults.standard.removeObject(forKey: kcCustomerImage)
                                     // UserDefaults.standard.removeObject(forKey: kcToken)
                                      UserDefaults.standard.removeObject(forKey: kcBio)
                                      UserDefaults.standard.removeObject(forKey: kcSocialLogin)
                                      self.userDefaults.synchronize()
                                      
                                      UserDefaults.standard.set("menu_logout_successfully".setlocalized(), forKey: kisMessage)
                                      
                                      appDelegate.SetTabBarItem(0)
                                  }))
                                  
                                  logoutAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                                      print("Handle Cancel Logic here")
                                  }))
                                  
                                  present(logoutAlert, animated: true, completion: nil)
    }
    @IBAction func onClickWhatsappChat(_ sender: Any) {
        
        let urlWhats = "https://wa.me/\("whatsapp_Number".setlocalized())"
                                   if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                                       if let whatsappURL = URL(string: urlString) {
                                           if UIApplication.shared.canOpenURL(whatsappURL){
                                               if #available(iOS 10.0, *) {
                                                   UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                                               } else {
                                                   UIApplication.shared.openURL(whatsappURL)
                                               }
                                           }
                                           else {
                                              AppHelper.showMessage(view: self.view, message: "Install Whatsapp")
                                               print("Install Whatsapp")
                                           }
                                       }
                                   }
    }
    @IBAction func onClickMeil(_ sender: Any) {
        let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
                        self.setContentViewController(controller: nextViewController)
    }
    @IBAction func OnClickPhoneCall(_ sender: Any) {
        if let url = URL(string: "telprompt://\("mobcall_number".setlocalized())") {
                                     let application = UIApplication.shared
                                     guard application.canOpenURL(url) else {
                                         return
                                     }
                                     application.open(url, options: [:], completionHandler: nil)
                                 }
    }
    
      @objc func wishlist () {
            
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Wishlist_Vc") as! Wishlist_Vc
                   self.navigationController?.pushViewController(nextViewController, animated: true)
            
    //        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
    //        self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    // MARK: - Custom Method
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
       // lbNavTitle.text = "profile_title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        
        if UserDefaults.standard.object(forKey: kcCustomerName) != nil {
            lbNavTitle.text = UserDefaults.standard.object(forKey: kcCustomerName) as! String
           // username = UserDefaults.standard.object(forKey: kcCustomerName) as! String
        }
        else
        {
           lbNavTitle.text = "lbl_Profile_Title".setlocalized()
        }
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = UIColor.white
        
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
        if isBackRequired == true || isBackButton == true{
            self.navigationItem.leftBarButtonItem = barButtonBack
           // isBackRequired = false
            isBackButton = true
        }
        else {
            isBackButton = false
            self.navigationItem.leftBarButtonItems = []
        }
        
 
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "wishlist"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(wishlist), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
      //  self.navigationItem.rightBarButtonItems = [barButtonLanguage]
       
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        print(text)
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // MARK: - Tableview Delegates and Datasourse
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        else if section == 1 {
            
            if UserDefaults.standard.object(forKey: kisLogin) != nil {
                        
                        
                      return arrFirst.count
            }
            else {
                return arrGuestFirst.count
            }
            
           // return arrFirst.count
        }
        else if section == 2 {
            return arrTwo.count
        }
        else if section == 3 {
            return arrthree.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFirstCell") as! ProfileFirstCell
            cell.imgProfile.backgroundColor = UIColor.white
            if UserDefaults.standard.object(forKey: kcCustomerImage) != nil {
                let strImgURL = UserDefaults.standard.object(forKey: kcCustomerImage) as! String
                cell.imgProfile.cacheImage(urlString: strImgURL)
            }
            
            if UserDefaults.standard.object(forKey: kcCustomerName) != nil {
                cell.lblUserName.text = UserDefaults.standard.object(forKey: kcCustomerName) as! String
            }
            
            let editProfileTap = UITapGestureRecognizer(target: self, action: #selector(gotoEditProfile))
            editProfileTap.numberOfTapsRequired = 1
            cell.btnEdit.isUserInteractionEnabled = true
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addGestureRecognizer(editProfileTap)
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
            cell.imgProfile.clipsToBounds = true
            
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailsCell") as! ProfileDetailsCell

            
            if UserDefaults.standard.object(forKey: kisLogin) != nil {
                                   
                         cell.lblTitle.text = arrFirst[indexPath.row]
                                
                       }
                       else {
                
                
                 cell.lblTitle.text = arrGuestFirst[1]
                          
                       }
            
           
               cell.switchNotificaiton.isHidden = true
            cell.imgArrow.isHidden = false
            cell.imgArrow.image =  cell.imgArrow.image?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection()
            cell.imgArrow.tintColor = cell.lblTitle.textColor
            
            return cell
        }
       else if indexPath.section == 2{
             let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailsCell") as! ProfileDetailsCell
             cell.lblTitle.text = arrTwo[indexPath.row]
            
                    let currentLanguage = UserDefaults.standard.object(forKey: knotificaiton) as! String //Locale.current.languageCode
                    if currentLanguage == "0" {
                        cell.switchNotificaiton.isOn = false
                    }
                    else{
                        cell.switchNotificaiton.isOn = true
                    }
            //
            if indexPath.row == 0
            {
                 cell.switchNotificaiton.isHidden = false
                cell.imgArrow.isHidden = true
            }
            else
            {
                 cell.switchNotificaiton.isHidden = true
                cell.imgArrow.isHidden = false
            }
            cell.imgArrow.image =  cell.imgArrow.image?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection()
                       cell.imgArrow.tintColor = cell.lblTitle.textColor
//             cell.switchNotificaiton.isHidden = false
//             cell.imgArrow.isHidden = true
       
             
             return cell
         }
        else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailsCell") as! ProfileDetailsCell

            cell.lblTitle.text = arrthree[indexPath.row]
               cell.switchNotificaiton.isHidden = true
            cell.imgArrow.isHidden = false
           cell.imgArrow.image =  cell.imgArrow.image?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection()
                       cell.imgArrow.tintColor = cell.lblTitle.textColor
            cell.imgArrow.tintColor = cell.lblTitle.textColor
            return cell
      
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if section == 0 {
               return nil
           }
           else {
               let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblProfile.frame.size.width, height: 35))
               var lblHeaderName:UILabel = UILabel()
               var btnViewMore:UIButton = UIButton()
               
            headerView.backgroundColor = navigationbarColor
            lblHeaderName.backgroundColor = navigationbarColor
               let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
               if currentLanguage == "en" {
                   lblHeaderName = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 100, height: headerView.frame.size.height))
                   btnViewMore = UIButton(frame: CGRect(x: headerView.frame.size.width - 100, y: 0, width: 100, height: headerView.frame.size.height))
               }
               else {
                   lblHeaderName = UILabel(frame: CGRect(x: 100, y: 0, width: self.view.frame.size.width - 115, height: headerView.frame.size.height))
                   btnViewMore = UIButton(frame: CGRect(x: 15, y: 0, width: 100, height: headerView.frame.size.height))
               }
               
               
            
               lblHeaderName.text = arrHeader[section]
               //lblHeaderName.text = (arrProductType.object(at: section - 1) as! String)
               lblHeaderName.font = UIFont(name: RalewaySemiBold, size: 17)
               
               
//               btnViewMore.setTitle("home_view_more".setlocalized(), for: .normal)
//               btnViewMore.titleLabel?.font = UIFont(name: RalewayRegular, size: 14)
//               btnViewMore.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
//               
//              // let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductList))
//               openProductGesture.numberOfTapsRequired = 1
//               btnViewMore.isUserInteractionEnabled = true
//               btnViewMore.tag = section
//               btnViewMore.addGestureRecognizer(openProductGesture)
               
               headerView.addSubview(lblHeaderName)
              // headerView.addSubview(btnViewMore)
               
               return headerView
           }
       }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if section == 0 {
                return 0
            }
            else if section == 1 {
                    if UserDefaults.standard.object(forKey: kisLogin) != nil {
                                               
                                               
                                             return 35
                                   }
                                   else {
                                              return 35
                                   }
            }
            else
            {
                
               
                return 35
            }
   
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        else if indexPath.section == 1{
            if indexPath.row == 0
            {
               return 0
            }
            else
           {
               return UITableViewAutomaticDimension
           }
            
        }
            else if indexPath.section == 2{
                       if indexPath.row == 0
                       {
                          return 0
                       }
                       else
                      {
                          return UITableViewAutomaticDimension
                      }
                       
                   }
        else
                   {
                       return UITableViewAutomaticDimension
                   }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                           let nextViewController = objProfile.instantiateViewController(withIdentifier: "Profile") as! Profile
                           isBackRequired = true
                
                            self.setContentViewController(controller: nextViewController)
                       }
                       else if indexPath.row == 1 {
                
                if UserDefaults.standard.object(forKey: kisLogin) != nil {
                                                             
                                                             
                                                          let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Orders") as! Orders
                                                           nextViewController.isfromprofile = true
                                                                       self.setContentViewController(controller: nextViewController)
                                                 }
                                                 else {
                                                             let nextViewController: MyAppointmentListVC = MyAppointmentListVC(nibName: "MyAppointmentListVC", bundle: nil)
                                                    nextViewController.isfromprofile = true
                                                                                 
                                                                                      // let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "WalletList_Vc") as! WalletList_Vc
                                                                                     //  nextViewController.isfromprofile = true
                                                                                       self.setContentViewController(controller: nextViewController)
                                                 }
                
                           
                       }
                       else if indexPath.row == 2 {
                
                        let nextViewController: MyAppointmentListVC = MyAppointmentListVC(nibName: "MyAppointmentListVC", bundle: nil)
                        nextViewController.isfromprofile = true
                      
                           // let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "WalletList_Vc") as! WalletList_Vc
                          //  nextViewController.isfromprofile = true
                            self.setContentViewController(controller: nextViewController)
                                             }
                else if indexPath.row == 3 {
                                           let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "WalletList_Vc") as! WalletList_Vc
                                         //  nextViewController.isfromprofile = true
                                           self.setContentViewController(controller: nextViewController)
                                                            }
                
                       else if indexPath.row == 4 {
                           let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Address") as! Address
                nextViewController.isfromprofile = true
                            self.setContentViewController(controller: nextViewController)
                       }
                       else if indexPath.row == 5 {
                           let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Wishlist_Vc") as! Wishlist_Vc
                nextViewController.isfromprofile = true
                            self.setContentViewController(controller: nextViewController)
                       }
                       else if indexPath.row == 6{
                            let nextViewController = objProfile.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
                         // nextViewController.isfromprofile = true
                           self.setContentViewController(controller: nextViewController)
                       }
                       else if indexPath.row == 7{
                           let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "SelectLanguage") as! SelectLanguage
                                                       // nextViewController.isfromprofile = true
                            self.setContentViewController(controller: nextViewController)
                       }
                      else if indexPath.row == 8//Rate us
                        {
                            let YOURAPPID = "1522466977"
                            let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id\(YOURAPPID)?mt=8&action=write-review")!
                            UIApplication.shared.openURL(url)
                        }
                      else if indexPath.row == 9//call us
                        {
                            
                            if let url = URL(string: "telprompt://\("mobcall_number".setlocalized())") {
                              let application = UIApplication.shared
                              guard application.canOpenURL(url) else {
                                  return
                              }
                              application.open(url, options: [:], completionHandler: nil)
                          }
                        }
                else if indexPath.row == 10//chat with us
                       {
                        //https://wa.me/15551234567
                        let urlWhats = "https://wa.me/\("whatsapp_Number".setlocalized())"
                             if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                                 if let whatsappURL = URL(string: urlString) {
                                     if UIApplication.shared.canOpenURL(whatsappURL){
                                         if #available(iOS 10.0, *) {
                                             UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                                         } else {
                                             UIApplication.shared.openURL(whatsappURL)
                                         }
                                     }
                                     else {
                                        AppHelper.showMessage(view: self.view, message: "Install Whatsapp")
                                         print("Install Whatsapp")
                                     }
                                 }
                             }
                       }
                       else {
                           
                          
                       }
                   
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
                      {
                                   
                                 }
                                 else if indexPath.row == 1 {
                                      let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "SelectLanguage") as! SelectLanguage
                                                                                           // nextViewController.isfromprofile = true
                                                                self.setContentViewController(controller: nextViewController)
                                 }
        }
        else
        {
            if indexPath.row == 0//about Us
            {
                 let nextViewController = objProfile.instantiateViewController(withIdentifier: "FaqVc") as! FaqVc
                //               nextViewController.strType = "Name"
                //               nextViewController.isback = true
                              self.setContentViewController(controller: nextViewController)
            }
            else if indexPath.row == 1//about Us
                {
                    let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                    nextViewController.strType = "1"
                
                    self.setContentViewController(controller: nextViewController)
            }
            else if indexPath.row == 2//Terms & condition s
            {
               let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                nextViewController.strType = "3"
                nextViewController.isback = true
                self.setContentViewController(controller: nextViewController)
            }
            else if indexPath.row == 3 {//Return policy
               let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                nextViewController.strType = "4"
                nextViewController.isback = true
                self.setContentViewController(controller: nextViewController)
            }
            else if indexPath.row == 4 {//Privacy Policy //
               let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                nextViewController.strType = "5"
                nextViewController.isback = true
                self.setContentViewController(controller: nextViewController)
            }
            else if indexPath.row == 5{//Rate us
                let YOURAPPID = "1522466977"
                                          let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id\(YOURAPPID)?mt=8&action=write-review")!
                                          UIApplication.shared.openURL(url)
            }
            else if indexPath.row == 6{//Contact Us
                 let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
                 self.setContentViewController(controller: nextViewController)
            }
        }
           
        
    }
    func setContentViewController(controller:UIViewController)
    {
        self.navigationController?.pushViewController(controller, animated: true)
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
