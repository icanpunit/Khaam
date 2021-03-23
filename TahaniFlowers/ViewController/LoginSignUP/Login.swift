//
//  ViewController.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 13/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices

@available(iOS 13.0, *)
extension Login: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
           if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
               // Create an account in your system.
               let userIdentifier = appleIDCredential.user
            var FirstName = ""
             var lastName = ""
            var email = ""
               if let userFirstName = appleIDCredential.fullName?.givenName
               {
                 FirstName = userFirstName
               }
            else
               {
                FirstName = "Apple"
              }
            
              if  let userLastName = appleIDCredential.fullName?.familyName
              {
                lastName = userLastName
              }
            else
              {
                 lastName = "Login"
              }
            if  let userEmail = appleIDCredential.email
            {
                email = userEmail
            }
            else
            {
                email = "\(userIdentifier)@khaam.com"
            }
               
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                 switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                        break
                    case .revoked:
                        // The Apple ID credential is revoked.
                        break
                 case .notFound: break
                        // No credential was found, so show the sign-in UI.
                    default:
                        break
                 }
            }
            
            print(appleIDCredential.fullName)
             print(appleIDCredential.email)
             print(appleIDCredential)
            self.SocialLogin(type: "Apple", strUserName: FirstName, strLastName: lastName, strContactNumber: "", strEmailId: email, strPassword: userIdentifier)
               //Navigate to other view controller
           } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
               // Sign in using an existing iCloud Keychain credential.
               let username = passwordCredential.user
               let password = passwordCredential.password
               
               //Navigate to other view controller
           }
       }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
}


extension Login: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


class Login: UIViewController,UITextFieldDelegate, HttpWrapperDelegate  {
   
    
    @IBOutlet weak var btnloginTopSpaceConstant: NSLayoutConstraint!
    @IBOutlet weak var stackviewRadioButtons: UIStackView!
    @IBOutlet weak var viewradioHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var viewPasswordHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnGuestUser: UIButton!
    @IBOutlet weak var btnExistingUser: UIButton!
    @IBOutlet weak var viewAppleLogin: UIView!
    // MARK: - IBOutlets
    @IBOutlet weak var swtchRemember: UISwitch!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceUserName: NSLayoutConstraint!
    @IBOutlet weak var bottomSpacePassword: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredUserName: UILabel!
    @IBOutlet weak var lblRequiredPassword: UILabel!
    @IBOutlet weak var lblRememeber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblSocialTitle: UILabel!
    var LoginType = 0
    // MARK: - Variables
    var strUserName:String = ""
    var strPassword:String = ""
    var objLogin  = HttpWrapper()
    var objSocial  = HttpWrapper()
    var fbName = ""
    var fbFirstName = ""
    var fbLastName = ""
    var fbId = ""
    var fbPicture = ""
    var fbEmail = ""
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var isFromCart:Bool = false
    var isAppointment:Bool = false
    var isFromCartsample:Bool = false
    var objCheckEmail = HttpWrapper()
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if isFromCart
        {
            
        }
        else if isAppointment
        {
            
        }
        else if isFromCartsample
        {
            
        }
        else
        {
            stackviewRadioButtons.isHidden = true
            viewradioHeightConstant.constant = 0
        }
        btnExistingUser.setImage(UIImage(named: "ic_radio_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
                     btnExistingUser.tintColor = Colorblack
                     btnGuestUser.setImage(UIImage(named: "ic_radio_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
                     btnGuestUser.tintColor = ColorLightGray
        
        swtchRemember.onTintColor = UIColor.orange
       
        viewAppleLogin.backgroundColor = UIColor.clear
        if let data = UserDefaults.standard.object(forKey: "Remeber") as? Data {
                   if let dics = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
                       
                       if let strTemp = dics.object(forKey: "Email") as? String {
                           txtUserName.text = strTemp
                       }
                       if let strTemp = dics.object(forKey: "password") as? String {
                           txtPassword.text = strTemp
                       }
                       
                       if let strTemp = dics.object(forKey: "RememberMe") as? String {
                           appDelegate.RememberMe = strTemp
                           
                           
                           if (appDelegate.RememberMe == "true") {
                            swtchRemember.isOn = true
                           }
                           else{
                               swtchRemember.isOn = false
                           }
                           
                       }
                   }
               }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Login.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)

        
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtUserName.textAlignment = .left
            self.txtPassword.textAlignment = .left
        }
        else {
            self.txtUserName.textAlignment = .right
            self.txtPassword.textAlignment = .right
        }
        
        if #available(iOS 13.0, *) {
                   self.setupSignInButton()
               } else {
                   // Fallback on earlier versions
               }
        
        btnLogin.backgroundColor = btnBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
//        self.viewUserName.layer.cornerRadius = 20
//        self.viewUserName.layer.borderWidth = 1
//        self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewUserName.clipsToBounds = true
//        self.viewUserName.backgroundColor = UIColor.white
//
//
//        self.viewPassword.layer.cornerRadius = 20
//        self.viewPassword.layer.borderWidth = 1
//        self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewPassword.clipsToBounds = true
//        self.viewPassword.backgroundColor = UIColor.white
        self.btnLogin.layer.cornerRadius = btnRadius
        self.btnLogin.clipsToBounds = true
        
        self.viewFacebook.layer.cornerRadius = 3
        self.viewFacebook.clipsToBounds = true
        
        self.viewGoogle.layer.cornerRadius = 3
        self.viewGoogle.layer.borderWidth = 1
        self.viewGoogle.layer.borderColor = UIColor(hexString: "#9A9A9A").cgColor
        self.viewGoogle.clipsToBounds = true
        self.btnGoogle.setTitleColor(UIColor(hexString: "#5D5D5D"), for: .normal)

        self.staticLoacalizations()
        
        if UserDefaults.standard.value(forKey: kisMessage) != nil {
            AppHelper.showMessage(view: self.view, message: UserDefaults.standard.value(forKey: kisMessage) as! String)
            UserDefaults.standard.removeObject(forKey: kisMessage)
        }
        
        self.mainViewHeight.constant = 800 - self.view.frame.size.height
        
        
       
                          
        let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: RalewayRegular, size: 15),
        .foregroundColor: btnBackgroundColor]
        
        let main_string = "\("lbl_login_do_not_have_an_acc".setlocalized()) \("lbl_signup_btn_signup".setlocalized())"
                          let attributedString = NSMutableAttributedString(string: main_string,attributes:[NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7e7e7e")])
                          
                          let string_to_color = "lbl_signup_btn_signup".setlocalized()
                          
                          let range = (main_string as NSString).range(of: string_to_color)
                          
                          // Set the 'click here' substring to be the link
                          attributedString.setAttributes(yourAttributes, range: range)
                         
        btnSignup.setAttributedTitle(attributedString, for: .normal)
        btnSignup.tintColor = UIColor.init(hexString: "7e7e7e")
//                          self.txtViewTerms.delegate = self
//                          txtViewTerms.isSelectable = true
//                          txtViewTerms.isEditable = false
//                          self.txtViewTerms.attributedText = attributedString
        
    }
    
      @available(iOS 13.0, *)
        private func setupSignInButton() {
             
            
             let signInButton = ASAuthorizationAppleIDButton()
             signInButton.addTarget(self, action: #selector(self.signInButtonTapped), for: .touchDown)
             
             signInButton.translatesAutoresizingMaskIntoConstraints = false
             self.viewAppleLogin.addSubview(signInButton)
             
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
             NSLayoutConstraint.activate([
                signInButton.centerXAnchor.constraintEqualToSystemSpacingAfter(view.centerXAnchor, multiplier: 1),
    //            signInButton.centerYAnchor.constraintEqualToSystemSpacingBelow(view.centerYAnchor, multiplier: 1),
                 signInButton.heightAnchor.constraint(equalToConstant: 40),
                 signInButton.widthAnchor.constraint(equalToConstant: screenWidth - 60)
             ])
         }
         @available(iOS 13.0, *)
         @objc private func signInButtonTapped() {
             let authorizationProvider = ASAuthorizationAppleIDProvider()
             let request = authorizationProvider.createRequest()
            request.requestedScopes = [.email , .fullName]
             
             let authorizationController = ASAuthorizationController(authorizationRequests: [request])
             authorizationController.delegate = self
             authorizationController.presentationContextProvider = self
             authorizationController.performRequests()
         }
      
    @IBAction func onClickbtnapplelogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            self.signInButtonTapped()
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        
      //  self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        self.bottomSpaceUserName.constant = 10
        self.lblRequiredUserName.isHidden = true
        
       // self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        self.bottomSpacePassword.constant = 10
        self.lblRequiredPassword.isHidden = true
    }
    
    // MARK: - IBActions
    
    @IBAction func onClickForgotPassword(_ sender: UIButton) {
        let nextViewController = objMain.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPassword
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        
        
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if LoginType == 1
        {
           if isValidateForguest() {
            
                CheckEmailValid(Email: txtUserName.text!)
            }
        }
        else if isValidate() {
            
            var param:String = ""


            param = String(format: "%@?cUserName=%@&cPassword=%@&nUserId=%@&cToken=%@&cIPAddress=%@&cMType=%@&cDeviceToken=%@", kLogin,self.strUserName,self.strPassword,"1",KbasecToken,appDelegate.StrFirebaseToken,"1","\(appDelegate.DeviceId)")
            print(param)
            
              let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            AppHelper.showLoadingView()
            self.objLogin = HttpWrapper.init()
            self.objLogin.delegate = self
            self.objLogin.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
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
    
    
    func SocialLogin(type:String,strUserName:String,strLastName:String,strContactNumber:String,strEmailId:String,strPassword:String)
    {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            var param:String = ""
            
             param = String(format: "%@?cCustomerFirstName=%@&cCustomerLastName=%@&cCustomerContactNo=%@&cCustomerEmailId=%@&nUserId=%@&cPassword=%@&cGender=%@&cCustomerType=%@&cToken=%@&cIPAddress=%@&cMType=%@&cDeviceToken=%@", kSignup,strUserName,strLastName,strContactNumber,strEmailId,"1",strPassword,"NA",type,KbasecToken,"","1","\(appDelegate.DeviceId)")
            print(param)
            let urlString = param.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            AppHelper.showLoadingView()
            self.objSocial = HttpWrapper.init()
            self.objSocial.delegate = self
            self.objSocial.requestWithparamdictParamPostMethodwithHeaderGet(url: urlString!, headers: nil)
        }
    }
    @IBAction func onClickSignup(_ sender: UIButton) {
        let nextViewController = objMain.instantiateViewController(withIdentifier: "Signup") as! Signup
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func onClickFacebook(_ sender: UIButton) {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.fbLoginInitiate()
        }
    }

    @IBAction func onClickGoogle(_ sender: UIButton) {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            appDelegate.isLoginScreen = true
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
       // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
     // MARK: - Google Api Calling 
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            //self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
               
                SocialLogin(type: "Google", strUserName: appDelegate.fullName, strLastName: appDelegate.familyName, strContactNumber: "", strEmailId: appDelegate.email, strPassword: appDelegate.userId)
            }
        }
    }
    
    func fbLoginInitiate() {
        
        if (AccessToken.current != nil) {
            print(" Login  Success==>")
        }
        let loginManager = LoginManager()
        loginManager.loginBehavior = .browser
        
        //Grannt Permission
        loginManager.logIn(permissions:  ["public_profile", "email"], from: self) { (result, error1) in
            if (error1 == nil){
                
                self.fetchFacebookProfile()
            }
            
        }
        func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
            
        }
        
    }
    func removeFbData() {
        
        let fbManager = LoginManager()
        fbManager.logOut()
       // AccessToken.se
    }
    func fetchFacebookProfile()
    {
        if AccessToken.current != nil {
            
            let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,email,picture.type(large)"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                print("FacebookResponse :===>\(result)")
                let json = JSON(result)
                
                self.fbName = json["name"].stringValue
                self.fbFirstName = json["first_name"].stringValue
                self.fbLastName = json["last_name"].stringValue
                self.fbId = json["id"].stringValue
                if json["email"].exists() {
                    self.fbEmail = json["email"].stringValue
                }
                else {
                    self.fbEmail = self.fbId
                }
                self.fbPicture = json["picture"]["data"]["url"].stringValue
                self.SocialLogin(type: "Facebook", strUserName: self.fbFirstName, strLastName: self.fbLastName, strContactNumber: "", strEmailId: self.fbEmail, strPassword: self.fbId)
                //self.facebookLogin()
            })
        }
    }
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        
    }
    // MARK: - @objc Actions
    
    @IBAction func onClickbtnGuestUser(_ sender: Any) {
        btnGuestUser.setImage(UIImage(named: "ic_radio_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnGuestUser.tintColor = Colorblack
        btnExistingUser.setImage(UIImage(named: "ic_radio_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnExistingUser.tintColor = ColorLightGray
         self.btnLogin.setTitle("lbl_login_Proceed".setlocalized(), for: .normal)
        swtchRemember.isHidden = true
        btnForgotPassword.isHidden = true
        viewPasswordHeightConstant.constant = 0
        btnloginTopSpaceConstant.constant = -15
        lblRememeber.isHidden = true
        txtPassword.text = ""
        txtUserName.text = ""
        LoginType = 1
    }
    @IBAction func OnclickbtnExistingUser(_ sender: Any) {
        btnExistingUser.setImage(UIImage(named: "ic_radio_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnExistingUser.tintColor = Colorblack
        btnGuestUser.setImage(UIImage(named: "ic_radio_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnGuestUser.tintColor = ColorLightGray
         self.btnLogin.setTitle("lbl_login_btn_login".setlocalized(), for: .normal)
        viewPasswordHeightConstant.constant = 40
        btnloginTopSpaceConstant.constant = 20
        swtchRemember.isHidden = false
        btnForgotPassword.isHidden = false
        lblRememeber.isHidden = false
        LoginType = 0
        
        if let data = UserDefaults.standard.object(forKey: "Remeber") as? Data {
                    if let dics = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
                        
                        if let strTemp = dics.object(forKey: "Email") as? String {
                            txtUserName.text = strTemp
                        }
                        if let strTemp = dics.object(forKey: "password") as? String {
                            txtPassword.text = strTemp
                        }
                        
                        if let strTemp = dics.object(forKey: "RememberMe") as? String {
                            appDelegate.RememberMe = strTemp
                            
                            
                            if (appDelegate.RememberMe == "true") {
                             swtchRemember.isOn = true
                            }
                            else{
                                swtchRemember.isOn = false
                            }
                            
                        }
                    }
                }
        
    }
    @objc func back() {
        appDelegate.SetTabBarItem(0)
    }
    @IBAction func onChangeRemember(_ sender: Any) {
        if (appDelegate.RememberMe == "false") {
            
          //  btnRember.set(image: #imageLiteral(resourceName: "check"), title: strBtnRememberMe as NSString, titlePosition: .right, additionalSpacing: 10, state: .normal)
            
            
            appDelegate.RememberMe = "true"
            
            let DicSave:NSDictionary = [
                "Email":txtUserName.text!,
                "password":txtPassword.text!,
                "RememberMe":appDelegate.RememberMe
            ]
            
            let data = NSKeyedArchiver.archivedData(withRootObject: DicSave)
            UserDefaults.standard.set(data, forKey: "Remeber")
            
        }
        else{
          //  btnRember.set(image: #imageLiteral(resourceName: "uncheck"), title: strBtnRememberMe as NSString, titlePosition: .right, additionalSpacing: 15, state: .normal)
            appDelegate.RememberMe = "false"
            
            let DicSave:NSDictionary = [
                "Email":"",
                "password":"",
                "RememberMe":appDelegate.RememberMe
            ]
            
            let data = NSKeyedArchiver.archivedData(withRootObject: DicSave)
            UserDefaults.standard.set(data, forKey: "Remeber")
        }
    }
    
    // MARK: - Custom Methods
    
    func matches(regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func facebookLogin() {
        
    }
    
    func staticLoacalizations() {
        lblTitle.text = "lbl_login_WelcomeBack".setlocalized()
        lblSocialTitle.text = "lbl_login_SocialTitle".setlocalized()
        lblDetail.text = "lbl_login_LogBack".setlocalized()
        lblRememeber.text = "lbl_login_Rememeber".setlocalized()
        
        self.txtUserName.placeholder = "lbl_login_email".setlocalized()
        self.txtPassword.placeholder = "lbl_login_password".setlocalized()
        self.btnForgotPassword.setTitle("lbl_login_forgot_password".setlocalized(), for: .normal)
        self.btnLogin.setTitle("lbl_login_btn_login".setlocalized(), for: .normal)
       // self.btnSignup.setTitle("lbl_login_do_not_have_an_acc".setlocalized(), for: .normal)
        self.btnFacebook.setTitle("login_with_facebook".setlocalized(), for: .normal)
        self.btnGoogle.setTitle("login_with_google".setlocalized(), for: .normal)
        
         self.btnGuestUser.setTitle("lbl_login_Guest_User".setlocalized(), for: .normal)
        
         self.btnExistingUser.setTitle("lbl_login_Existing_User".setlocalized(), for: .normal)
    }
    
     func isValidateForguest() -> Bool {
            self.strUserName = self.txtUserName.text!
            self.strPassword = self.txtPassword.text!
            
            var flag = true
            
    //        if AppHelper.isNull(self.strUserName) == true {
    //            self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
    //            self.bottomSpaceUserName.constant = 30
    //            self.lblRequiredUserName.isHidden = false
    //            self.lblRequiredUserName.text = "required".setlocalized()
    ////            AppHelper.showMessage(view: self.view, message: "login_username_required".setlocalized())
    //            flag = false
    //        }
    //        else {
    //            self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
    //            self.bottomSpaceUserName.constant = 10
    //            self.lblRequiredUserName.isHidden = true
    //        }
            
            if AppHelper.isNull(self.strUserName) == true {
              //  self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                self.bottomSpaceUserName.constant = 30
                self.lblRequiredUserName.isHidden = false
                self.lblRequiredUserName.text = "required".setlocalized()
                //            AppHelper.showMessage(view: self.view, message: "login_valid_email".setlocalized())
                flag = false
            }
            else if AppHelper.isValidEmail(self.strUserName) == false {
               // self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                self.bottomSpaceUserName.constant = 30
                self.lblRequiredUserName.isHidden = false
                self.lblRequiredUserName.text = "lbl_Login_EnterValidEmail".setlocalized()
    //            AppHelper.showMessage(view: self.view, message: "login_valid_email".setlocalized())
                flag = false
            }
            else {
               // self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
                self.bottomSpaceUserName.constant = 10
                self.lblRequiredUserName.isHidden = true
            }
            
            
                
            if flag == true {
                return true
            }
            else {
                return false
            }
        }
    
    func isValidate() -> Bool {
        self.strUserName = self.txtUserName.text!
        self.strPassword = self.txtPassword.text!
        
        var flag = true
        
//        if AppHelper.isNull(self.strUserName) == true {
//            self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            self.bottomSpaceUserName.constant = 30
//            self.lblRequiredUserName.isHidden = false
//            self.lblRequiredUserName.text = "required".setlocalized()
////            AppHelper.showMessage(view: self.view, message: "login_username_required".setlocalized())
//            flag = false
//        }
//        else {
//            self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//            self.bottomSpaceUserName.constant = 10
//            self.lblRequiredUserName.isHidden = true
//        }
        
        if AppHelper.isNull(self.strUserName) == true {
          //  self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.bottomSpaceUserName.constant = 30
            self.lblRequiredUserName.isHidden = false
            self.lblRequiredUserName.text = "required".setlocalized()
            //            AppHelper.showMessage(view: self.view, message: "login_valid_email".setlocalized())
            flag = false
        }
        else if AppHelper.isValidEmail(self.strUserName) == false {
           // self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.bottomSpaceUserName.constant = 30
            self.lblRequiredUserName.isHidden = false
            self.lblRequiredUserName.text = "lbl_Login_EnterValidEmail".setlocalized()
//            AppHelper.showMessage(view: self.view, message: "login_valid_email".setlocalized())
            flag = false
        }
        else {
           // self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            self.bottomSpaceUserName.constant = 10
            self.lblRequiredUserName.isHidden = true
        }
        
        if AppHelper.isNull(self.strPassword) == true {
          //  self.viewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            self.bottomSpacePassword.constant = 30
            self.lblRequiredPassword.isHidden = false
            self.lblRequiredPassword.text = "required".setlocalized()
//            AppHelper.showMessage(view: self.view, message: "login_password_required".setlocalized())
            flag = false
        }
        else {
           // self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            self.bottomSpacePassword.constant = 10
            self.lblRequiredPassword.isHidden = true
        }
            
        if flag == true {
            return true
        }
        else {
            return false
        }
    }
    
    func addNavigationBar(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "lbl_login_title".setlocalized()
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
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String //Locale.current.languageCode
        if currentLanguage == "en" {
            buttonMenu.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            buttonMenu.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        buttonMenu.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonMenu.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonMenu = UIBarButtonItem.init(customView: buttonMenu)
      //  self.navigationItem.leftBarButtonItem = barButtonMenu

    }
    
    // MARK: - TextFiled Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtUserName {
            self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            self.bottomSpaceUserName.constant = 10
            self.lblRequiredUserName.isHidden = true
        }
        else {
            self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            self.bottomSpacePassword.constant = 10
            self.lblRequiredPassword.isHidden = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtUserName {
            self.txtPassword.becomeFirstResponder()
        }
        else {
          textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - HttpWraper Delegates
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objLogin {
            AppHelper.hideLoadingView()
            print(dicsResponse)
            AppHelper.hideLoadingView()
            let userDefaults = UserDefaults.standard
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                let customerDetails = (dicsResponse.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary
                
                if let nUserId = customerDetails.value(forKey: "nLoginId") as? NSNumber {
                    userDefaults.set(nUserId, forKey: knLoginId)
                }
                
                if let nUserId = customerDetails.value(forKey: "nUserId") as? NSNumber {
                    userDefaults.set(nUserId, forKey: knUserId)
                }

                if let nCustomerId = customerDetails.value(forKey: "nCustomerId") as? NSNumber {
                    userDefaults.set(nCustomerId, forKey: knCustomerId)
                }

                if let cToken = customerDetails.value(forKey: "cToken") as? String {
                    userDefaults.set(cToken, forKey: kcToken)
                }
                
                UserDefaults.standard.set("login_login_successfully".setlocalized(), forKey: kisMessage)
                
                userDefaults.set("1", forKey: kisLogin)
                userDefaults.synchronize()
                
                if isFromCart == true {
                    
                    appDelegate.SetTabBarItem(3)
//                    let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else  if isAppointment == true
               {
                   let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                   
                   nextViewController.isAppointment = true
                   self.navigationController?.pushViewController(nextViewController, animated: true)
               }
                    else if isFromCartsample == true
                {
                    appDelegate.SetTabBarItem(2)
                }
                else {
                    appDelegate.SetTabBarItem(0)
                }
            }
            else {
                AppHelper.hideLoadingView()
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
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
                            appDelegate.GuestCustomerId = "0"
                            if isAppointment == true
                            {
                                let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                                nextViewController.isGuest = true
                                nextViewController.strGuestEmail = txtUserName.text!
                                nextViewController.isAppointment = true
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                            }
                             else if isFromCartsample == false
                             {
                                 let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                                 nextViewController.isGuest = true
                                 nextViewController.strGuestEmail = txtUserName.text!
                                 self.navigationController?.pushViewController(nextViewController, animated: true)
                             }
                            else
                            {
                                let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                                      nextViewController.nCartType = "0"
                                      nextViewController.isGuest = true
                                
                                     nextViewController.strGuestEmail = txtUserName.text!
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                            }
                            
                        }
                    }
        else  if wrapper == objSocial {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            let userDefaults = UserDefaults.standard
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                
                let customerDetails = (dicsResponse.value(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                
                if let nUserId = customerDetails.value(forKey: "nLoginId") as? NSNumber {
                    userDefaults.set(nUserId, forKey: knLoginId)
                }
                
                if let nUserId = customerDetails.value(forKey: "nUserId") as? NSNumber {
                    userDefaults.set(nUserId, forKey: knUserId)
                }
                
                if let nCustomerId = customerDetails.value(forKey: "nCustomerId") as? NSNumber {
                    userDefaults.set(nCustomerId, forKey: knCustomerId)
                }
                
                if let cCustomerName = customerDetails.value(forKey: "cCustomerName") as? String {
                    userDefaults.set(cCustomerName, forKey: kcCustomerName)
                }
                
                if let cEmail = customerDetails.value(forKey: "cEmail") as? String {
                    userDefaults.set(cEmail, forKey: kcEmail)
                }
                
                if let cContactNo = customerDetails.value(forKey: "cContactNo") as? String {
                    userDefaults.set(cContactNo, forKey: kcContactNo)
                }
                
                if let cGender = customerDetails.value(forKey: "cGender") as? String {
                    userDefaults.set(cGender, forKey: kcGender)
                }
                
                if let cCustomerType = customerDetails.value(forKey: "cCustomerType") as? String {
                    userDefaults.set(cCustomerType, forKey: kcCustomerType)
                }
                
                if let cCustomerImage = customerDetails.value(forKey: "cCustomerImage") as? String {
                    userDefaults.set(cCustomerImage, forKey: kcCustomerImage)
                }
                
                if let cToken = customerDetails.value(forKey: "cToken") as? String {
                    userDefaults.set(cToken, forKey: kcToken)
                }
                
                userDefaults.set("1", forKey: kisLogin)
                
                if userDefaults.object(forKey: kisMessage) == nil {
                    userDefaults.set("login_login_successfully".setlocalized(), forKey: kisMessage)
                }
                
                userDefaults.set("1", forKey: kcSocialLogin)
                
                if isFromCart == true {
                    let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                    else  if isAppointment == true
                    {
                        let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
                        
                        nextViewController.isAppointment = true
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                else {
                    appDelegate.SetTabBarItem(0)
                }
            }
            else {
                AppHelper.hideLoadingView()
                let tost = MBProgressHUD.showAdded(to: view, animated: true)
                tost?.mode = MBProgressHUDModeText
                tost?.detailsLabelText = dicsResponse.value(forKey: "Message") as! String
                tost?.margin = 10;
                
                //        tost?.yOffset = 200;
                let height = view.frame.size.height
                if height < 600 {
                    tost?.yOffset = 150
                }
                else if height > 600 {
                    tost?.yOffset = 200
                }
                //Float(view.frame.size.height - 150);
                tost?.isUserInteractionEnabled = false
                tost?.hide(true, afterDelay: 3)
               //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        
        
        
    }
    
}

