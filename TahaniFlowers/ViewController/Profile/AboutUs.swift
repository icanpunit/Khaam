//
//  AboutUs.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 24/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit



class AboutUs: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tblAboutUs: UITableView!
    // MARK: - Variables
    
  
    @IBOutlet var viewHeader: UIView!
    var objAboutUs  = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var cellHeight:CGFloat = 0
    var dicAboutUs:NSDictionary = NSDictionary()
    var dicFacebook:NSDictionary = NSDictionary()
    var dicInstagram:NSDictionary = NSDictionary()
    var dicWhatsApp:NSDictionary = NSDictionary()
    var dicSnapChat:NSDictionary = NSDictionary()
    var strHTML:String = String()
    var strType:String = String()
    var isback = false
    // MARK: - Viewcontroller Methods
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAboutUs.tableHeaderView = viewHeader
        currentScrren = "AboutUs"
        
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
        self.getAboutUsDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @objc func gotoCotactUs() {
        let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func back() {
//        if isback == true
//        {
//
//        }
//        else
//        {
//            appDelegate.SetTabBarItem(0)
//        }
         self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func onTapFacebook() {
        if let facebookLink = dicFacebook.object(forKey: "cPageContent") as? String {
////            fb://page?id=%@
//            let appURL = URL(string: "fb://page/tahaniflowerskw")!
//
//            if UIApplication.shared.canOpenURL(appURL as URL) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
//                }
//                else {
//                    UIApplication.shared.openURL(appURL as URL)
//                }
//            }
//            else {
                if let url = URL(string: facebookLink) {
                    UIApplication.shared.open(url, options: [:])
                }
//            }
        }
    }
    
    @objc func onTapInstagram() {
        if let instagramLink = dicInstagram.object(forKey: "cPageContent") as? String {
            if let url = URL(string: instagramLink) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    @objc func onTapWhatsApp() {
        print(dicWhatsApp)
        if let whatsappNumber = dicWhatsApp.object(forKey: "cPageContent") as? String {
            let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(whatsappNumber)")!
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
    
    @objc func onTapSnapChat() {
        if let snapChatUserName = dicSnapChat.object(forKey: "cPageContent") as? String {
            let appURL = NSURL(string: "https://www.snapchat.com/add/\(snapChatUserName)")!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
            else {
                // snapchat is not installed
            }
        }
    }
    
    // MARK: - Custom Method
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getAboutUsDetails()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getAboutUsDetails () {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            var nLanguageId = ""
                           
           if UserDefaults.standard.object(forKey: kLanguageId) != nil {
               nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
           }
            
            var url = URLComponents(string: kSelectCMSPagesDetails)!

            url.queryItems = [
                URLQueryItem(name: "nUserId", value: "\(nUserId)"),
                URLQueryItem(name: "nLanguageId", value: nLanguageId),
               URLQueryItem(name: "cPageName", value: strType),
                URLQueryItem(name: "cToken", value: "\(cToken)")
            ]
            
            
//            var param:String = ""
//
//            param = String(format: "%@?nUserId=%@&cPageName=%@&cToken=%@", kSelectCMSPagesDetails,"\(nUserId)","About us","\(cToken)")
            
       //     print(param)
            
            let updatedUrl = "\(url)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objAboutUs = HttpWrapper.init()
            self.objAboutUs.delegate = self
            self.objAboutUs.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        //        1=(AboutUs)
        //        2=(ContactUs)
        //        3=(TermsandCondition)
        //        4=(ReturnPolicy)
        //        5=(PrivacyPolicy)

                if strType == "1"
                {
                   lblTitle.text = "lbl_aboutus_Title".setlocalized()
                }
                else if strType == "2"
                {
                   lblTitle.text = "lbl_ContactUs_Title".setlocalized()
                }
                else if strType == "3"
                {
                    lblTitle.text = "lbl_TermsandCondition_Title".setlocalized()
                }
                else if strType == "4"
                {
                    lblTitle.text = "lbl_ReturnPolicy_Title".setlocalized()
                }
                else if strType == "5"
                {
                     lblTitle.text = "lbl_PrivacyPolicy_Title".setlocalized()
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
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // MARK: - Tableview Delegate And Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell") as! AboutUsCell
        
        cell.txtview.attributedText = strHTML.htmlToAttributedString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 500
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objAboutUs {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
//                cPageContent
                let arrResult = dicsResponse.object(forKey: "result") as! NSArray
                let dicResult = arrResult.object(at: 0) as! NSDictionary
                 if let cPageTitle = dicResult.object(forKey: "cPageContent") as? String
                 {
                    strHTML = cPageTitle
                }
//                for resultIndex in 0..<arrResult.count {
//
//                    let dicResult = arrResult.object(at: resultIndex) as! NSDictionary
//
//                    if let cPageTitle = dicResult.object(forKey: "cPageTitle") as? String
//                    {
//                        if cPageTitle == "About Company" {
//                            self.dicAboutUs = dicResult
//                        }
//                        else if cPageTitle == "Facebook" {
//                            self.dicFacebook = dicResult
//                        }
//                        else if cPageTitle == "Instagram" {
//                            self.dicInstagram = dicResult
//                        }
//                        else if cPageTitle == "WhatsApp" {
//                            self.dicWhatsApp = dicResult
//                        }
//                        else {
//                            self.dicSnapChat = dicResult
//                        }
//                    }
//                }
                self.tblAboutUs.reloadData()
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        AppHelper.hideLoadingView()
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
