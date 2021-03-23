//
//  SelectLanguage.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 29/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift

class SelectLanguage: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate {
  
    // MARK: - IBOutlets
    @IBOutlet weak var tblLanguage: UITableView!
    @IBOutlet weak var lblChooseLanguageTitle: UILabel!
    
    // MARK: - Variables
    
    var objLanguage = HttpWrapper()
    var arrLanguage:NSArray = NSArray()
    var selectedIndex = 0
    var selectedLanguage = ""
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScrren = "SelectLanguage"
        
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
        self.navigationController?.isNavigationBarHidden = true
        self.lblChooseLanguageTitle.text = "lbl_Language_Choose".setlocalized()
       // self.addNavigationBar()
        self.getAllLanguage()
        appDelegate.tabBarController1.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @IBAction func onClickArabic(_ sender: Any) {
        goNext(index: 1)
    }
    @IBAction func onClickenglish(_ sender: Any) {
        goNext(index: 0)
    }
    
    func goNext(index:Int)
    {
        let dicLanguage = self.arrLanguage.object(at: index) as! NSDictionary
               var languageCode = ""
               if let nLanguageCode = dicLanguage.object(forKey: "cLanguageCssType") as? String {
                   languageCode = nLanguageCode
                   selectedLanguage = languageCode
               }
               
               Localize.setCurrentLanguage(selectedLanguage)
               let newLanguage:Languages!
               if selectedLanguage == "en" {
                   newLanguage = .en
               }
               else {
                   newLanguage = .ar
               }
               // change the language
               UserDefaults.standard.set(selectedLanguage, forKey: kLanguageCode)
               LanguageManager.shared.setLanguage(language: newLanguage)
               
               if UserDefaults.standard.object(forKey: kFirstTime) != nil {
                                 
                  appDelegate.SetTabBarItem(0)
                }
               else
               {
                   UserDefaults.standard.set(false, forKey: kFirstTime)
                appDelegate.SetTabBarItem(0)
//                   let nextViewController = objMain.instantiateViewController(withIdentifier: "StartPage_Vc") as! StartPage_Vc
//                   self.navigationController?.pushViewController(nextViewController, animated: true)
               }
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickApply() {
    }
    
    // MARK: - Custom Method
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getAllLanguage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addNavigationBar(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "select_language_title".setlocalized()
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
        
        let buttonMenu = UIButton.init(type: .custom)
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            buttonMenu.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            buttonMenu.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        buttonMenu.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonMenu.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonMenu = UIBarButtonItem.init(customView: buttonMenu)
        self.navigationItem.leftBarButtonItem = barButtonMenu
        
    }
    
    func getAllLanguage() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&cToken=%@", kLanguages,"\(nUserId)","\(cToken)")
            
            AppHelper.showLoadingView()
            self.objLanguage = HttpWrapper.init()
            self.objLanguage.delegate = self
            self.objLanguage.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    // MARK: - Tableview Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.arrLanguage.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageCell") as! SelectLanguageCell
            let dicLanguage = self.arrLanguage.object(at: indexPath.row) as! NSDictionary
            if let langaugeName = dicLanguage.object(forKey: "cLanguageName") as? String {
                cell.lblLanguageName.text = langaugeName
            }
            if let nLanguageCode = dicLanguage.object(forKey: "cLanguageCssType") as? String {
                if nLanguageCode == "en" {
                    cell.imgLanguage.image = UIImage(named: "ic_language_en")
                }
                else {
                    cell.imgLanguage.image = UIImage(named: "ic_ar")
                }
            }
            
            if UserDefaults.standard.object(forKey: kLanguageCode) != nil {
                let currentLanguageCode = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                if let languageCode = dicLanguage.object(forKey: "cLanguageCssType") as? String {
                    
                    if selectedLanguage != "" {
                        if selectedLanguage == languageCode {
                            cell.imgTick.image = UIImage(named: "ic_tick")
                            selectedLanguage = languageCode
                        }
                        else {
                            cell.imgTick.image = UIImage(named: "")
                        }
                    }
                    else {
                        if currentLanguageCode == languageCode {
                            cell.imgTick.image = UIImage(named: "ic_tick")
                            selectedLanguage = languageCode
                        }
                        else {
                            cell.imgTick.image = UIImage(named: "")
                        }
                    }
                }
            }

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLangaugeApplyCell") as! SelectLangaugeApplyCell
            cell.btnApply.layer.cornerRadius = btnRadius
            cell.btnApply.clipsToBounds = true
            cell.btnApply.setTitle("select_language_apply".setlocalized(), for: .normal)
            
            let applyTap = UITapGestureRecognizer(target: self, action: #selector(onClickApply))
            applyTap.numberOfTapsRequired = 1
            cell.btnApply.addGestureRecognizer(applyTap)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 51
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dicLanguage = self.arrLanguage.object(at: indexPath.row) as! NSDictionary
        var languageCode = ""
        if let nLanguageCode = dicLanguage.object(forKey: "cLanguageCssType") as? String {
            languageCode = nLanguageCode
            selectedLanguage = languageCode
        }
        
        Localize.setCurrentLanguage(selectedLanguage)
        let newLanguage:Languages!
        if selectedLanguage == "en" {
            newLanguage = .en
        }
        else {
            newLanguage = .ar
        }
        // change the language
        UserDefaults.standard.set(selectedLanguage, forKey: kLanguageCode)
        LanguageManager.shared.setLanguage(language: newLanguage)
        
        if UserDefaults.standard.object(forKey: kFirstTime) != nil {
                          
           appDelegate.SetTabBarItem(0)
         }
        else
        {
            UserDefaults.standard.set(false, forKey: kFirstTime)
            appDelegate.SetTabBarItem(0)
//            let nextViewController = objMain.instantiateViewController(withIdentifier: "StartPage_Vc") as! StartPage_Vc
//            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        
//        self.tblLanguage.reloadData()
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objLanguage {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                arrLanguage = dicsResponse.value(forKey: "result") as! NSArray
                self.tblLanguage.reloadData()
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
