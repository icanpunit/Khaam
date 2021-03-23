//
//  SideMenu_Vc.swift
//  Staycurity
//
//  Created by Mandip Kanjiya on 15/08/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

import Alamofire
import SDWebImage
import MessageUI

class SideMenu_Vc: UIViewController ,UITableViewDataSource , UITableViewDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tblMain: UITableView!
    
    var emailId = ""
    
    var arrDefaultMenu = ["menu_home".setlocalized(),"menu_category".setlocalized(),"menu_ScanProduct".setlocalized(),"lbl_Language_Choose".setlocalized(),"menu_about_us".setlocalized(),"menu_contact_us".setlocalized(),"menu_login".setlocalized()]
    var arrDefaultMenuIcons = ["ic_menu_home","ic_menu_category","qr-code","language (1)","about-us","ic_menu_contact_us","ic_menu_login"]
    var arrLoginMenu = ["menu_home".setlocalized(),"menu_category".setlocalized(),"menu_ScanProduct".setlocalized(),"menu_about_us".setlocalized(),"menu_contact_us".setlocalized()]
    var arrLoginMenuIcons = ["ic_menu_home","ic_menu_category","qr-code","ic_menu_about_us","ic_menu_contact_us"]
    var arrLoginMenu_account = ["menu_my_account".setlocalized(),"menu_my_orders".setlocalized(),"menu_my_address".setlocalized(),"lbl_menu_wishlist".setlocalized(),"menu_reset_password".setlocalized(),"menu_logout".setlocalized()]
    var arrLoginMenuIcons_account = ["ic_menu_account","ic_menu_orders","ic_menu_address","is_Menu_Wishlist","ic_menu_reset_password","ic_menu_logout"]
    
    let userDefaults = UserDefaults.standard
     weak var delegate: LeftMenuDelegate?
    func setFontAndColor(){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFontAndColor()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadData),
                                               name: NSNotification.Name(rawValue: "reloadMenu"),
                                               object: nil)
        
        tblMain.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblMain.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tblMain.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        tblMain.reloadData()
    }
    
    @objc func reloadData() {
        tblMain.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        else if indexPath.section == 1 {
              if userDefaults.object(forKey: kisLogin) == nil {
                           if indexPath.row == 2 {
                               return 50
                           }
                           else {
                               return 50
                           }
                       }
                       else {
                           if indexPath.row == 2 {
                               return 50
                           }
                           else {
                               return 50
                           }
                       }
        }
        else {
            if userDefaults.object(forKey: kcSocialLogin) != nil {
                if indexPath.row == 3 {
                    return 0
                }
                else {
                    return 50
                }
            }
            else {
                return 50
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if userDefaults.string(forKey: kisLogin) != nil {
            return 3
        }
        else {

            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            if userDefaults.string(forKey: kisLogin) != nil {
                return arrLoginMenu.count
            }
            else{
                return arrDefaultMenu.count
            }
        }
        else {
            return arrLoginMenu_account.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuProfile_Cell", for: indexPath) as! SideMenuProfile_Cell
            if userDefaults.value(forKey: kcCustomerName) != nil {
                cell.lblName.text = userDefaults.value(forKey: kcCustomerName) as! String
            }
            else {
                cell.lblName.text = "lbl_home_title".setlocalized()
            }
            
            if userDefaults.value(forKey: kcEmail) != nil {
                emailId = userDefaults.value(forKey: kcEmail) as! String
                if AppHelper.isValidEmail(emailId){
                    cell.lblEmail.text = emailId
                    cell.lblEmail.isUserInteractionEnabled = true
                }
                else {
                    cell.lblEmail.text = ""
                    cell.lblEmail.isUserInteractionEnabled = false
                }
            }
            else {
                if UserDefaults.standard.object(forKey: kSupportEmail) != nil {
                    if let supportEmail = UserDefaults.standard.object(forKey: kSupportEmail) as? String {
                        emailId = supportEmail
                        cell.lblEmail.text = emailId
                        cell.lblEmail.isUserInteractionEnabled = true
                    }
                }
            }
            
            if UserDefaults.standard.object(forKey: kcCustomerImage) != nil{
                print(UserDefaults.standard.object(forKey: kcCustomerImage) as! String)
                cell.imgProfile.cacheImage(urlString: UserDefaults.standard.object(forKey: kcCustomerImage) as! String)
            }
            else {
                cell.imgProfile.image = UIImage(named: "ic_logo")
            }
            cell.imgProfile.backgroundColor = UIColor.white
            cell.imgProfile.isUserInteractionEnabled = true
            let openContactUs = UITapGestureRecognizer(target: self, action: #selector(onTapImgProfile))
            openContactUs.numberOfTapsRequired = 1
            cell.imgProfile.addGestureRecognizer(openContactUs)
            
            let openEmail = UITapGestureRecognizer(target: self, action: #selector(onTapEmail))
            openEmail.numberOfTapsRequired = 1
//            cell.lblEmail.isUserInteractionEnabled = true
            cell.lblEmail.addGestureRecognizer(openEmail)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuButton_Cell", for: indexPath) as! sideMenuButton_Cell
            
            var currentLanguage = ""
            
            if UserDefaults.standard.object(forKey: kLanguageCode) == nil {
                currentLanguage = "en"
            }
            else {
                currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            }
                
            if currentLanguage == "en" {
                cell.btnActions.contentHorizontalAlignment = .left
            }
            else {
                cell.btnActions.contentHorizontalAlignment = .right
            }
            
            if userDefaults.object(forKey: kisLogin) != nil {
                if indexPath.section == 1 {
                    cell.btnActions.setTitle(self.arrLoginMenu[indexPath.row], for: .normal)
                    cell.imgICon.image = UIImage.init(named: self.arrLoginMenuIcons[indexPath.row] as! String)
                }
                else {
                    cell.btnActions.setTitle(self.arrLoginMenu_account[indexPath.row], for: .normal)
                    cell.imgICon.image = UIImage.init(named: self.arrLoginMenuIcons_account[indexPath.row] as! String)
                }
            }
            else {
                cell.btnActions.setTitle(arrDefaultMenu[indexPath.row], for: .normal)
                
                
                cell.imgICon.image = UIImage.init(named: arrDefaultMenuIcons[indexPath.row] as! String)
            }

            let templateImage = cell.imgICon.image?.withRenderingMode(.alwaysTemplate)
            cell.imgICon.image = templateImage
            cell.imgICon.tintColor = UIColor.black
            
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let delegate = delegate {
            delegate.didSelectItemAtIndex(indexPath: indexPath)
           }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView:UIView;
        var headerTitle:UILabel;
        
        let languageCode = UserDefaults.standard.object(forKey: kLanguageCode) as! String

        if  languageCode == "en" {
            headerView = UIView(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: 50))
            headerTitle = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: 50))
        }
        else {
            headerView = UIView(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: 50))
            headerTitle = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: 50))
        }
        
        headerTitle.text = "menu_account".setlocalized()
        headerTitle.font = UIFont(name: RalewaySemiBold, size: 18)
        headerTitle.textColor = UIColor.black
        headerView.addSubview(headerTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 50
        }
        else {
            return 0
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

    // MARK: - @objc action methods
    
    @objc func onTapImgProfile() {
       // SJSwiftSideMenuController.hideLeftMenu()
        if userDefaults.object(forKey: kisLogin) != nil {
            
            let nextViewController = objProfile.instantiateViewController(withIdentifier: "Profile") as! Profile
            nextViewController.isBackRequired = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else {
            let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @objc func onTapEmail() {
       // SJSwiftSideMenuController.hideLeftMenu()
        
        let email = emailId // insert your email here
        let subject = ""
        let bodyText = ""
        
        // https://developer.apple.com/documentation/messageui/mfmailcomposeviewcontroller
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            
            mailComposerVC.setToRecipients([email])
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
