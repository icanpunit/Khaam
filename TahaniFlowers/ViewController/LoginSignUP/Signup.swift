//
//  Signup.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 14/12/18.
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
extension Signup: ASAuthorizationControllerDelegate {
    
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
               self.SocialSignup(type: "Apple", strUserName: FirstName, strLastName: lastName, strContactNumber: "", strEmailId: email, strPassword: userIdentifier)
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


extension Signup: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

class Signup: UIViewController,UITextFieldDelegate, HttpWrapperDelegate ,UITextViewDelegate{

   
    @IBOutlet weak var lblSocialTitle: UILabel!
    @IBOutlet weak var txtMobileCode: UITextField!
    @IBOutlet weak var btnShowPass: UIButton!
    @IBOutlet weak var viewAppleLogin: UIView!
    // MARK: - Outlets
    @IBOutlet weak var btnFemale: UIButton!
       @IBOutlet weak var btnMale: UIButton!
     var Gender = "Male"
    @IBOutlet weak var txtViewTerms: UITextView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var imgLastName: UIImageView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var imgConfirmPassword: UIImageView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var viewMainHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSpaceFirstName: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredFirstName: UILabel!
    @IBOutlet weak var bottomSpaceLastName: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredLastName: UILabel!
    @IBOutlet weak var bottomSpacePassword: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredPassword: UILabel!
    @IBOutlet weak var bottomSpaceConfirmPassword: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredConfirmPassword: UILabel!
    @IBOutlet weak var bottomSpaceEmailId: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredEmailId: UILabel!
    @IBOutlet weak var lblRequiredContactNumber: UILabel!
    var isFromCartsample:Bool = false
    
    
    // MARK: - Variables
    
    var strUserName:String = ""
    var strLastName:String = ""
    var strPassword:String = ""
    var strConfirmPassword:String = ""
    var strEmailId:String = ""
    var strContactNumber:String = ""
    var fbName = ""
    var fbFirstName = ""
    var fbLastName = ""
    var fbId = ""
    var fbPicture = ""
    var fbEmail = ""
    var objSignup  = HttpWrapper()
    var isSocialLogin:Bool = false
    var isPasswordShow:Bool = false
    var isFromCart:Bool = false
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        btnShowPass.setImage(UIImage.init(named: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnShowPass.tintColor = UIColor.darkGray
        GIDSignIn.sharedInstance().presentingViewController = self
        // Do any additional setup after loading the view, typically from a nib.
        viewAppleLogin.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleSignupAuthUINotification"),
                                               object: nil)
        
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtUserName.textAlignment = .left
            self.txtLastName.textAlignment = .left
            self.txtPassword.textAlignment = .left
            self.txtPassword.textAlignment = .left
            self.txtConfirmPassword.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtContact.textAlignment = .left
        }
        else {
            self.txtUserName.textAlignment = .right
            self.txtLastName.textAlignment = .right
            self.txtPassword.textAlignment = .right
            self.txtPassword.textAlignment = .right
            self.txtConfirmPassword.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtContact.textAlignment = .right
        }
        if #available(iOS 13.0, *) {
                   self.setupSignInButton()
               } else {
                   // Fallback on earlier versions
               }
        btnSignup.backgroundColor = btnBackgroundColor
        btnMale.setImage(UIImage(named: "ic_radio_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
              btnMale.tintColor = Colorblack
              btnFemale.setImage(UIImage(named: "ic_radio_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
              btnFemale.tintColor = ColorLightGray
        
        let linkAttributes = [
                 NSAttributedString.Key.link: URL(string: "https://www.khaam.com/khaam/AppHTML/Customer/khaam-TermsConditions.pdf")!,
                 NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!,
                       NSAttributedString.Key.foregroundColor:colorRed
                 ] as [NSAttributedString.Key : Any]
                   
                   let linkAttributes2 = [
                       NSAttributedString.Key.link: URL(string: "https://www.khaam.com/khaam/AppHTML/Customer/khaam-PrivacyPolicy.pdf")!,
                       NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!,
                       NSAttributedString.Key.foregroundColor: colorRed
                       ] as [NSAttributedString.Key : Any]
                   
                   let linkAttributes3 = [
                       NSAttributedString.Key.link: URL(string: "https://www.khaam.com/khaam/AppHTML/Customer/khaam-CustomerResponsibilities.pdf")!,
                       NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!,
                       NSAttributedString.Key.foregroundColor: colorRed
                       ] as [NSAttributedString.Key : Any]
                   
        let main_string = "\("lbl_signup_byRegister".setlocalized()) \("lbl_signup_termsAndCondition".setlocalized()) \("lbl_Signup_privacy_and1".setlocalized()) \("lbl_Signup_privacyPolicy".setlocalized()) \("lbl_Signup_privacy_and1".setlocalized()) \("lbl_signup_return_policy".setlocalized())"
                   let attributedString = NSMutableAttributedString(string: main_string,attributes:[NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7e7e7e")])
                   
                   let string_to_color = "lbl_signup_termsAndCondition".setlocalized()
                   let string_to_color2 = "lbl_Signup_privacyPolicy".setlocalized()
                   let string_to_color3 = "lbl_signup_return_policy".setlocalized()
                   let range = (main_string as NSString).range(of: string_to_color)
                   let range2 = (main_string as NSString).range(of: string_to_color2)
                   let range3 = (main_string as NSString).range(of: string_to_color3)
                   // Set the 'click here' substring to be the link
                   attributedString.setAttributes(linkAttributes, range: range)
                   attributedString.setAttributes(linkAttributes2, range: range2)
                   attributedString.setAttributes(linkAttributes3, range: range3)
                   self.txtViewTerms.delegate = self
                   txtViewTerms.isSelectable = true
                   txtViewTerms.isEditable = false
                   self.txtViewTerms.attributedText = attributedString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
       
    override func viewWillAppear(_ animated: Bool) {
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
               .font: UIFont(name: RalewayRegular, size: 15),
               .foregroundColor: btnBackgroundColor]
               
               let main_string = "\("lbl_signup_already_have_account".setlocalized()) \("lbl_login_btn_login".setlocalized())"
                                 let attributedString = NSMutableAttributedString(string: main_string,attributes:[NSAttributedString.Key.font: UIFont(name: RalewayRegular, size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7e7e7e")])
                                 
                                 let string_to_color = "lbl_login_btn_login".setlocalized()
                                 
                                 let range = (main_string as NSString).range(of: string_to_color)
                                 
                                 // Set the 'click here' substring to be the link
                                 attributedString.setAttributes(yourAttributes, range: range)
                                
               btnLogin.setAttributedTitle(attributedString, for: .normal)
               btnLogin.tintColor = UIColor.init(hexString: "7e7e7e")
          //self.btnLogin.setTitle("lbl_signup_already_have_account".setlocalized(), for: .normal)
        self.addNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
//        self.viewUserName.layer.cornerRadius = 20
//        self.viewUserName.layer.borderWidth = 1
//        self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewUserName.clipsToBounds = true
//        self.viewUserName.backgroundColor = UIColor.white
//
//        self.viewLastName.layer.cornerRadius = 20
//        self.viewLastName.layer.borderWidth = 1
//        self.viewLastName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewLastName.clipsToBounds = true
//        self.viewLastName.backgroundColor = UIColor.white
//
//        self.viewPassword.layer.cornerRadius = 20
//        self.viewPassword.layer.borderWidth = 1
//        self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewPassword.clipsToBounds = true
        self.txtPassword.keyboardType = .asciiCapable
      //  self.viewPassword.backgroundColor = UIColor.white
        
        
//        self.viewConfirmPassword.layer.cornerRadius = 20
//        self.viewConfirmPassword.layer.borderWidth = 1
//        self.viewConfirmPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewConfirmPassword.clipsToBounds = true
        self.txtConfirmPassword.keyboardType = .asciiCapable
        
//        self.viewEmail.layer.cornerRadius = 20
//        self.viewEmail.layer.borderWidth = 1
//        self.viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewEmail.clipsToBounds = true
        self.txtEmail.keyboardType = .asciiCapable
        // self.viewEmail.backgroundColor = UIColor.white
        
        
//        self.viewContact.layer.cornerRadius = 20
//        self.viewContact.layer.borderWidth = 1
//        self.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        self.viewContact.clipsToBounds = true
        self.txtContact.keyboardType = .asciiCapableNumberPad
      //   self.viewContact.backgroundColor = UIColor.white
        
        
        self.btnSignup.layer.cornerRadius = btnRadius
        self.btnSignup.clipsToBounds = true
        
        self.viewFacebook.layer.cornerRadius = 3
        self.viewFacebook.clipsToBounds = true
        
        self.viewGoogle.layer.cornerRadius = 3
        self.viewGoogle.layer.borderWidth = 1
        self.viewGoogle.layer.borderColor = UIColor(hexString: "#9A9A9A").cgColor
        self.viewGoogle.clipsToBounds = true
        self.btnGoogle.setTitleColor(UIColor(hexString: "#5D5D5D"), for: .normal)
        
        self.viewMainHeight.constant = 900 - self.view.frame.size.height
        
//        self.txtEmail.textInputMode?.primaryLanguage(
        
        self.staticLoacalizations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func onClickSignup(_ sender: UIButton) {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if isValidate() {
            var param:String = ""

            param = String(format: "%@?cCustomerFirstName=%@&cCustomerLastName=%@&cCustomerContactNo=%@&cCustomerEmailId=%@&nUserId=%@&cPassword=%@&cGender=%@&cCustomerType=%@&cToken=%@&cIPAddress=%@&cMType=%@&cDeviceToken=%@", kSignup,self.strUserName,self.strLastName,self.strContactNumber,self.strEmailId,"1",self.strPassword,Gender,"App",KbasecToken,appDelegate.StrFirebaseToken,"1","\(appDelegate.DeviceId)")
            
             let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objSignup = HttpWrapper.init()
            self.objSignup.delegate = self
            self.objSignup.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    @IBAction func onClickLogin(_ sender: UIButton) {
        
         if isFromCart == true {
            let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else
         {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    @IBAction func onClickFacebook(_ sender: UIButton) {
        isSocialLogin = true
        self.fbLoginInitiate()
    }
    @IBAction func onClickGoogle(_ sender: UIButton) {
        appDelegate.isLoginScreen = false
        isSocialLogin = true
        GIDSignIn.sharedInstance().signIn()
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
    // MARK: - @objc Actions
    
    
    @IBAction func onClickbtnMale(_ sender: Any) {
          btnMale.setImage(UIImage(named: "ic_radio_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
          btnMale.tintColor = Colorblack
          btnFemale.setImage(UIImage(named: "ic_radio_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
          btnFemale.tintColor = ColorLightGray
          Gender = "Male"
      }
      @IBAction func onClickbtnFemale(_ sender: Any) {
          btnFemale.setImage(UIImage(named: "ic_radio_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
          btnFemale.tintColor = Colorblack
          btnMale.setImage(UIImage(named: "ic_radio_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
          btnMale.tintColor = ColorLightGray
        
          Gender = "Female"
      }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickbtnapplelogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            self.signInButtonTapped()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func onClickShowPass(_ sender: Any) {
        if isPasswordShow == true
        {
            isPasswordShow = false
            btnShowPass.tintColor = UIColor.darkGray
            txtPassword.isSecureTextEntry = true
        }
        else
        {
            isPasswordShow = true
            btnShowPass.tintColor = Colorblack
            txtPassword.isSecureTextEntry = false
        }
    }
    
    @available(iOS 10.0, *)
         func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
             
             // check for the url string for performing your own custom actions here
             let urlString = URL.absoluteString
             
             var Name = ""
             if urlString == "https://www.khaam.com/khaam/AppHTML/Customer/khaam-PrivacyPolicy.pdf"
             {
                 Name =  "5"
             }
             else if urlString == "https://www.khaam.com/khaam/AppHTML/Customer/khaam-CustomerResponsibilities.pdf"
             {
                 Name = "4"
             }
             else if urlString == "https://www.khaam.com/khaam/AppHTML/Customer/khaam-TermsConditions.pdf"
             {
                 Name =  "3"
             }
             
           
             
             print(urlString)
        let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
        nextViewController.strType = Name
        nextViewController.isback = true
        self.navigationController?.pushViewController(nextViewController, animated: true)

             return false
         }
    
    func SocialSignup(type:String,strUserName:String,strLastName:String,strContactNumber:String,strEmailId:String,strPassword:String)
    {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            var param:String = ""
            
            
            param = String(format: "%@?cCustomerFirstName=%@&cCustomerLastName=%@&cCustomerContactNo=%@&cCustomerEmailId=%@&nUserId=%@&cPassword=%@&cGender=%@&cCustomerType=%@&cToken=%@&cIPAddress=%@&cMType=%@&cDeviceToken=%@", kSignup,strUserName,strLastName,strContactNumber,strEmailId,"1",strPassword,"NA",type,KbasecToken,appDelegate.StrFirebaseToken,"1","\(appDelegate.DeviceId)")
            print(param)
            let urlString = param.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            AppHelper.showLoadingView()
            self.objSignup = HttpWrapper.init()
            self.objSignup.delegate = self
            self.objSignup.requestWithparamdictParamPostMethodwithHeaderGet(url: urlString!, headers: nil)
        }
    }
    // MARK: - Custom Functions

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
   //     AccessToken.setCurrent(nil)
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
                
                 self.SocialSignup(type: "Facebook", strUserName: self.fbFirstName, strLastName: self.fbLastName, strContactNumber: "", strEmailId: self.fbId, strPassword: self.fbId)
            })
        }
    }
    
    func facebookLogin() {
        
    }
    
    
    // MARK: - Google Api Calling
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleSignupAuthUINotification" {
            //self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                
                self.SocialSignup(type: "Google", strUserName: appDelegate.fullName, strLastName: appDelegate.familyName, strContactNumber: "", strEmailId: appDelegate.email, strPassword: appDelegate.userId)
            }
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "lbl_signup_title".setlocalized()
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
        self.txtUserName.placeholder = "lbl_signup_name".setlocalized()
        self.txtLastName.placeholder = "placeholder_signup_lastname".setlocalized()
        self.txtPassword.placeholder = "lbl_signup_password".setlocalized()
        self.txtConfirmPassword.placeholder = "lbl_signup_password".setlocalized()
        self.txtEmail.placeholder = "lbl_signup_email".setlocalized()
        self.txtContact.placeholder = "lbl_signup_contact".setlocalized()
        lblSocialTitle.text = "lbl_signup_socialTitle".setlocalized()
        self.btnSignup.setTitle("lbl_login_signup".setlocalized(), for: .normal)
      
        self.btnFacebook.setTitle("login_with_facebook".setlocalized(), for: .normal)
        self.btnGoogle.setTitle("login_with_google".setlocalized(), for: .normal)
    }
    
    func isValidate() -> Bool {
        self.strUserName = self.txtUserName.text!
        self.strLastName = self.txtLastName.text!
        self.strPassword = self.txtPassword.text!
        self.strConfirmPassword = self.txtConfirmPassword.text!
        self.strEmailId = self.txtEmail.text!
        self.strContactNumber = self.txtContact.text!
 
        self.viewMainHeight.constant = 900 - self.view.frame.size.height
        
        var fieldCount = 0
        var flag = true
        
        if AppHelper.isNull(self.strUserName) == true {
//            AppHelper.showMessage(view: self.view, message: "signup_username_required".setlocalized())
            fieldCount = fieldCount + 1
            self.bottomSpaceFirstName.constant = 30
            self.lblRequiredFirstName.text = "required".setlocalized()
            self.lblRequiredFirstName.isHidden = false
          //  self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strUserName, 20) == false {
            fieldCount = fieldCount + 1
            self.bottomSpaceFirstName.constant = 30
            self.lblRequiredFirstName.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            self.lblRequiredFirstName.isHidden = false
           // self.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            self.bottomSpaceFirstName.constant = 10
            self.lblRequiredFirstName.isHidden = true
            //self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        
//        if AppHelper.isNull(self.strLastName) == true {
////            AppHelper.showMessage(view: self.view, message: "signup_lastname_required".setlocalized())
//            fieldCount = fieldCount + 1
//            self.bottomSpaceLastName.constant = 30
//            self.lblRequiredLastName.text = "required".setlocalized()
//            self.lblRequiredLastName.isHidden = false
//            self.viewLastName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else if AppHelper.maxLength(self.strLastName, 20) == false{
//            fieldCount = fieldCount + 1
//            self.bottomSpaceLastName.constant = 30
//            self.lblRequiredLastName.text = "signup_max_two_zero_characters_allowed".setlocalized()
//            self.lblRequiredLastName.isHidden = false
//            self.viewLastName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else {
//            self.bottomSpaceLastName.constant = 10
//            self.lblRequiredLastName.isHidden = true
//            self.viewLastName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        }
        
        if AppHelper.isNull(self.strPassword) == true {
//            AppHelper.showMessage(view: self.view, message: "signup_password_required".setlocalized())
            fieldCount = fieldCount + 1
           
            self.lblRequiredPassword.text = "required".setlocalized()
            self.lblRequiredPassword.isHidden = false
          // self.viewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.minLength(self.strPassword, 6) == false {
            fieldCount = fieldCount + 1
           
            self.lblRequiredPassword.text = "lbl_signup_password_min_length".setlocalized()
            self.lblRequiredPassword.isHidden = false
          //  self.viewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strPassword, 8) == false{
            fieldCount = fieldCount + 1
           
            self.lblRequiredPassword.text = "lbl_signup_password_max_length".setlocalized()
            self.lblRequiredPassword.isHidden = false
          //  self.viewPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
           
            self.lblRequiredPassword.isHidden = true
           // self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        
//        if AppHelper.isNull(self.strConfirmPassword) == true {
////            AppHelper.showMessage(view: self.view, message: "signup_confirm_password_required".setlocalized())
//            fieldCount = fieldCount + 1
//            self.bottomSpaceConfirmPassword.constant = 30
//            self.lblRequiredConfirmPassword.text = "required".setlocalized()
//            self.lblRequiredConfirmPassword.isHidden = false
//            self.viewConfirmPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        if self.strPassword != strConfirmPassword {
////            AppHelper.showMessage(view: self.view, message: "signup_password_and_confrimpassword_not_matched".setlocalized())
//            fieldCount = fieldCount + 1
//            self.bottomSpaceConfirmPassword.constant = 30
//            self.lblRequiredConfirmPassword.text = "signup_password_and_confrimpassword_not_matched".setlocalized()
//            self.lblRequiredConfirmPassword.isHidden = false
//            self.viewConfirmPassword.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else if strConfirmPassword != "" {
//            self.bottomSpaceConfirmPassword.constant = 10
//            self.lblRequiredConfirmPassword.isHidden = true
//            self.viewConfirmPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        }
        
        if AppHelper.isNull(self.strEmailId) == true {
//            AppHelper.showMessage(view: self.view, message: "signup_email_required".setlocalized())
            fieldCount = fieldCount + 1
           self.bottomSpacePassword.constant = 30
            self.lblRequiredEmailId.text = "required".setlocalized()
            self.lblRequiredEmailId.isHidden = false
          //  self.viewEmail.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidEmail(self.strEmailId) == false {
//            AppHelper.showMessage(view: self.view, message: "signup_valid_email".setlocalized())
            fieldCount = fieldCount + 1
            self.bottomSpacePassword.constant = 30
            self.lblRequiredEmailId.text = "lbl_signup_EnterValidEmail".setlocalized()
            self.lblRequiredEmailId.isHidden = false
        //    self.viewEmail.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
             self.bottomSpacePassword.constant = 30
            self.lblRequiredEmailId.isHidden =  true
          //  self.viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        
        if AppHelper.isNull(self.strContactNumber) == true {
//            AppHelper.showMessage(view: self.view, message: "signup_contact_required".setlocalized())
              self.bottomSpaceEmailId.constant = 30
            self.lblRequiredContactNumber.text = "required".setlocalized()
            self.lblRequiredContactNumber.isHidden = false
           // self.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidMobileNumber(self.strContactNumber) == false {
            self.lblRequiredContactNumber.text = "lbl_signup_only_digits_allowed".setlocalized()
            self.lblRequiredContactNumber.isHidden = false
              self.bottomSpaceEmailId.constant = 30
          //  self.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strContactNumber, 10) == false {
            self.lblRequiredContactNumber.text = "lbl_signup_max_one_zero_characters_allowed".setlocalized()
              self.bottomSpaceEmailId.constant = 30
            self.lblRequiredContactNumber.isHidden = false
          //  self.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            self.lblRequiredContactNumber.isHidden = true
           // self.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        
        self.viewMainHeight.constant = CGFloat(Int(self.viewMainHeight.constant) + (fieldCount * 20))
        self.view.layoutIfNeeded()
        
        if flag == true {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - TextFiled Delegates
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if isValidate()
//        {
//
//        }
//        return true
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtUserName {
            self.bottomSpaceFirstName.constant = 10
            self.lblRequiredFirstName.isHidden = true
            self.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        if textField == self.txtLastName {
            self.bottomSpaceLastName.constant = 10
            self.lblRequiredLastName.isHidden = true
            self.viewLastName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == self.txtPassword {
            
            self.lblRequiredPassword.isHidden = true
            self.viewPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == self.txtConfirmPassword {
           
            self.lblRequiredConfirmPassword.isHidden = true
            self.viewConfirmPassword.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == self.txtEmail {
             
            self.bottomSpacePassword.constant = 10
            self.lblRequiredEmailId.isHidden = true
            self.viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == self.txtContact {
            self.bottomSpaceEmailId.constant = 10
            self.lblRequiredContactNumber.isHidden = true
            self.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtUserName {
            self.txtLastName.becomeFirstResponder()
        }
        if textField == self.txtLastName {
            self.txtPassword.becomeFirstResponder()
        }
        else if textField == self.txtPassword {
            self.txtConfirmPassword.becomeFirstResponder()
        }
        else if textField == self.txtConfirmPassword {
            self.txtEmail.becomeFirstResponder()
        }
        else if textField == self.txtEmail {
            self.txtContact.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if textField == self.txtUserName || textField == self.txtLastName{
            if str.count >= 0 && str.count <= 20 {
                return true
            }
            else {
                return false
            }
        }
        else if textField == self.txtPassword || textField == self.txtConfirmPassword {
            if str.count >= 0 && str.count <= 8 {
                return true
            }
            else {
                return false
            }
        }
        else if textField == self.txtContact{
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
    
    // MARK: - HttpWrapper Delegates
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objSignup {
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
                
                if self.isSocialLogin == true {
                    userDefaults.set("1", forKey: kcSocialLogin)
                }
                
                userDefaults.set("lbl_SignUp_Success_message".setlocalized(), forKey: kisMessage)
                
                if isFromCart == true {
                    appDelegate.SetTabBarItem(2)
//                    let nextViewController = objCart.instantiateViewController(withIdentifier: "CheckoutAddress") as! CheckoutAddress
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
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
class CustomTextField: UITextField {
    
    private func getKeyboardLanguage() -> String? {
        return "en" // here you can choose keyboard any way you need
    }
    
    override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for tim in UITextInputMode.activeInputModes {
                if tim.primaryLanguage!.contains(language) {
                    return tim
                }
            }
        }
        return super.textInputMode
    }
    
}
