//
//  ResetPassword.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 14/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResetPassword: UIViewController,UITextFieldDelegate, HttpWrapperDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewCurrentPassword: UIView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var viewNewPassword: UIView!
    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var bottomSpaceCurrentPassword: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceNewPassword: NSLayoutConstraint!
    @IBOutlet weak var lblCurrentPasswordRequired: UILabel!
    @IBOutlet weak var lblNewPasswordRequired: UILabel!
    var isfromprofile = false
    // MARK: - Variables
    
    var strCurrentPassword:String = ""
    var strNewPassword:String = ""
    var objResetPassword = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtCurrentPassword.textAlignment = .left
            self.txtNewPassword.textAlignment = .left
        }
        else {
            self.txtCurrentPassword.textAlignment = .right
            self.txtNewPassword.textAlignment = .right
        }
        btnResetPassword.backgroundColor = btnBackgroundColor
        btnResetPassword.setTitleColor(btnTitleColor, for: .normal)
        btnResetPassword.setTitle("lbl_forgot_Passwor_btn_Resetpassword".setlocalized(), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
        
//        self.viewCurrentPassword.layer.cornerRadius = 20
//        self.viewCurrentPassword.layer.borderWidth = 1
//        self.viewCurrentPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewCurrentPassword.clipsToBounds = true
//        self.viewCurrentPassword.backgroundColor = UIColor.white
//
//        self.viewNewPassword.layer.cornerRadius = 20
//        self.viewNewPassword.layer.borderWidth = 1
//        self.viewNewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewNewPassword.clipsToBounds = true
//        self.viewNewPassword.backgroundColor = UIColor.white
        self.btnResetPassword.layer.cornerRadius = btnRadius
        self.btnResetPassword.clipsToBounds = true
        
        self.staticLoacalizations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func onClickResetPasseword(_ sender: UIButton) {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if isValidate() {
            
            let strUserName = UserDefaults.standard.value(forKey: kcUserName) as! String
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            let nLoginId = UserDefaults.standard.value(forKey: knLoginId) as! Int
            
            
            var param:String = ""
            
            param = String(format: "%@?cUserName=%@&cOldPassword=%@&cNewPassword=%@&nUserId=%@&cToken=%@&nLoginId=%@", kResetPassword,strUserName,self.strCurrentPassword,self.strNewPassword,"\(nUserId)",cToken,"\(nLoginId)")
             let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            AppHelper.showLoadingView()
            self.objResetPassword = HttpWrapper.init()
            self.objResetPassword.delegate = self
            self.objResetPassword.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    
    // MARK: - @objc Actions
    
    @objc func back(){
         if isfromprofile == true
         {
             self.navigationController?.popViewController(animated: true)
         }
         else
         {
             appDelegate.SetTabBarItem(0)
         }
    }
    
    // MARK: - Custom Methods
    
    func addNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "lbl_reset_password_title".setlocalized()
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
        buttonBack.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        buttonBack.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonBack.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonBack = UIBarButtonItem.init(customView: buttonBack)
        self.navigationItem.leftBarButtonItem = barButtonBack
    }
    
    func staticLoacalizations() {

        self.txtCurrentPassword.placeholder = "lbl_reset_password_current_password_placehoder".setlocalized()
        self.txtNewPassword.placeholder = "lbl_reset_password_New_password_placehoder".setlocalized()
        self.btnResetPassword.setTitle("lbl_forgot_Passwor_btn_Resetpassword".setlocalized(), for: .normal)
    }
    
    func isValidate() -> Bool {
        self.strCurrentPassword = self.txtCurrentPassword.text!
        self.strNewPassword = self.txtNewPassword.text!
        
        var flag = true
        
        if AppHelper.isNull(self.strCurrentPassword) == true {
            self.bottomSpaceCurrentPassword.constant = 30
            self.lblCurrentPasswordRequired.isHidden = false
            self.lblCurrentPasswordRequired.text = "required".setlocalized()
          //  self.viewCurrentPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.minLength(self.strCurrentPassword, 6) == false {
            self.bottomSpaceCurrentPassword.constant = 30
            self.lblCurrentPasswordRequired.isHidden = false
            self.lblCurrentPasswordRequired.text = "lbl_signup_password_min_length".setlocalized()
          //  self.viewCurrentPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strCurrentPassword, 8) == false {
            self.bottomSpaceCurrentPassword.constant = 30
            self.lblCurrentPasswordRequired.isHidden = false
            self.lblCurrentPasswordRequired.text = "lbl_signup_password_max_length".setlocalized()
         //   self.viewCurrentPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        
        if AppHelper.isNull(self.strNewPassword) == true {
            self.lblNewPasswordRequired.isHidden = false
            self.lblNewPasswordRequired.text = "required".setlocalized()
           // self.viewNewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.minLength(self.strNewPassword, 6) == false {
            self.lblNewPasswordRequired.isHidden = false
            self.lblNewPasswordRequired.text = "lbl_signup_password_min_length".setlocalized()
          //  self.viewNewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strNewPassword, 8) == false {
            self.lblNewPasswordRequired.isHidden = false
            self.lblNewPasswordRequired.text = "lbl_signup_password_max_length".setlocalized()
           // self.viewNewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        
        if flag == true {
            return true
        }
        else {
            return false
        }
    }
    // MARK: - TextField Delgate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtCurrentPassword {
            self.txtNewPassword.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtCurrentPassword {
            self.bottomSpaceCurrentPassword.constant = 10
            self.lblCurrentPasswordRequired.isHidden = true
            self.viewCurrentPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else {
            self.lblNewPasswordRequired.isHidden = true
            self.viewNewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if textField == self.txtCurrentPassword || textField == self.txtNewPassword {
            if str.count >= 0 && str.count <= 8 {
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
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objResetPassword {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            let userDefaults = UserDefaults.standard
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                UserDefaults.standard.set(dicsResponse.object(forKey: "Message") as! String, forKey: kisMessage)
                appDelegate.SetTabBarItem(0)
            }
            else {
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
