//
//  ForgotPassword.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 14/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPassword: UIViewController,UITextFieldDelegate, HttpWrapperDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewEmailId: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSendInstruction: UIButton!
    @IBOutlet weak var lblEmailIdRequired: UILabel!
    
    
    // MARK: - Variables
    
    var strEmail:String = ""
    var objForgotPassword  = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtEmail.textAlignment = .left
        }
        else {
            self.txtEmail.textAlignment = .right
        }
        
        btnSendInstruction.backgroundColor = btnBackgroundColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()

//        self.viewEmailId.layer.cornerRadius = 20
//        self.viewEmailId.layer.borderWidth = 1
//        self.viewEmailId.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewEmailId.clipsToBounds = true
//        self.viewEmailId.backgroundColor = UIColor.white
        self.btnSendInstruction.layer.cornerRadius = btnRadius
        self.btnSendInstruction.clipsToBounds = true
        self.tabBarController?.tabBar.isHidden = true
        self.staticLoacalizations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - IBActions
    @IBAction func onClickSendInstructions(_ sender: UIButton) {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if isValidate() {
            var param:String = ""
            
            param = String(format: "%@?cEmail=%@", kForgotPassword,self.strEmail)
            
            AppHelper.showLoadingView()
            self.objForgotPassword = HttpWrapper.init()
            self.objForgotPassword.delegate = self
            self.objForgotPassword.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    // MARK: - @objc Actions
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Custom Methods
    
    func addNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "lbl_forgot_password_title".setlocalized()
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
    }
    
    func staticLoacalizations() {
        self.txtEmail.placeholder = "lbl_forgot_password_emailid_placeholder".setlocalized()
        self.btnSendInstruction.setTitle("lbl_forgot_password_send_instructions".setlocalized(), for: .normal)
    }
    
    func isValidate() -> Bool {
        self.strEmail = self.txtEmail.text!
        var flag = true
        if AppHelper.isNull(self.strEmail) == true {
           // self.viewEmailId.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.lblEmailIdRequired.isHidden = false
            self.lblEmailIdRequired.text = "required".setlocalized()
//            AppHelper.showMessage(view: self.view, message: "forgot_password_email_required".setlocalized())
            flag = false
        }
        else if AppHelper.isValidEmail(self.strEmail) == false {
            print(self.strEmail)
          //  self.viewEmailId.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.lblEmailIdRequired.isHidden = false
            self.lblEmailIdRequired.text = "lbl_forgot_Passwor_EnterValidEmail".setlocalized()
//            AppHelper.showMessage(view: self.view, message: "forgot_password_valid_email".setlocalized())
            flag = false
        }
        else {
           // self.viewEmailId.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            self.lblEmailIdRequired.isHidden = true
        }
        if flag == true {
            return true
        }
        else {
            return false
        }
    }
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewEmailId.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        self.lblEmailIdRequired.isHidden = true
        self.lblEmailIdRequired.text = "lbl_forgot_Passwor_EnterValidEmail".setlocalized()
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objForgotPassword {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            let userDefaults = UserDefaults.standard
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                userDefaults.set(dicsResponse.value(forKey: "Message") as! String, forKey: kisMessage)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                AppHelper.hideLoadingView()
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
