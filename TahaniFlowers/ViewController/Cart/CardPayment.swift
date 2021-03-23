//
//  CardPayment.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 05/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit
import WebKit
import goSellSDK
class CardPayment: UIViewController,UIScrollViewDelegate,WKNavigationDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var wkKnet: WKWebView!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    internal var selectedPaymentItems: [PaymentItem]?
        internal var plainAmount: Decimal?
    var isAppointment:Bool = false
     // MARK: - Variables
     let session:Session = Session()
    // MARK: - Variables
    var fGrandTotal:Float = 0
    var kentUrl:String = ""
    var orderId:String = ""
    var zoomscale:CGFloat = -1
    // MARK: - Viewcontroller Methods
     let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        GoSellSDK.mode = .production
               session.delegate = self
               session.dataSource = self
        
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading?.mode = MBProgressHUDModeIndeterminate
        loading?.show(true)
     //  AppHelper.showLoadingView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
        session.start()
//        print(self.kentUrl)
//        wkKnet.navigationDelegate = self
//
//        let url = URL(string: kentUrl)!
//        leftMargin.constant = -(self.view.bounds.width / 2)
//        rightMargin.constant =  -(self.view.bounds.width / 2)
//        
//        wkKnet.load(URLRequest(url:url ))
//        wkKnet.scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Custom Method
    
    func addNavigationBar(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "payment_title".setlocalized()
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
    
    func updateZoomToAspectToFit(webView: WKWebView) {
        let contentSize: CGSize = webView.scrollView.contentSize //PDF size
        let viewSize:CGSize = webView.bounds.size
        let extraLength = contentSize.height - viewSize.height
        let extraWidth = contentSize.width - viewSize.width
        let shouldScaleToFitHeight = extraLength > extraWidth
        let zoomRangeFactor:CGFloat = 4
        if shouldScaleToFitHeight {
            let ratio:CGFloat = (viewSize.height / contentSize.height)
            webView.scrollView.minimumZoomScale = ratio / zoomRangeFactor
            webView.scrollView.maximumZoomScale = ratio * zoomRangeFactor
            webView.scrollView.zoomScale = ratio
        }
    }
    
    // MARK: - Webkit view delegate
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if let url = navigationAction.request.url?.absoluteString {
//            print(url)
//
//            if url.contains("knetpayment/checkout") {
//                AppHelper.showLoadingView()
//            }
//            else {
//                AppHelper.hideLoadingView()
//            }
//
//            if url.contains("KNetPayment/SuccessPayment") {
//                AppHelper.hideLoadingView()
//
//                let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
//                nextViewController.orderId = self.orderId
//                self.navigationController?.pushViewController(nextViewController, animated: true)
//            }
//            else if url.contains("KNetPayment/FailurePayment") {
//                AppHelper.hideLoadingView()
//                let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPaymentFailed") as! CardPaymentFailed
//                self.navigationController?.pushViewController(nextViewController, animated: true)
//            }
//            else if url.contains("login") {
//                AppHelper.hideLoadingView()
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//
//
//        if (navigationAction.navigationType == .linkActivated){
//            decisionHandler(.cancel)
//        } else {
//            decisionHandler(.allow)
//        }
//
//    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        AppHelper.hideLoadingView()
        self.updateZoomToAspectToFit(webView: webView)

    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(scrollView.zoomScale)
        if zoomscale == -1 {
            self.zoomscale = scrollView.zoomScale
        }
        wkKnet.scrollView.setZoomScale(zoomscale, animated: true)
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
// MARK: - SessionDataSource
extension CardPayment: SessionDataSource {
   
    internal var currency: Currency? {
        
        return .with(isoCode: "KWD")
    }
    
    internal var applePayMerchantID: String
    {
        return "merchant.tap.gosell"
    }
    
//    internal var merchantID: String?
//    {
//        return "599424"
//    }
    
    var customer: Customer? {
            
       return self.newCustomer
    }

    /// Creating a customer with known identifier received from Tap before.
    var identifiedCustomer: Customer? {
            
        return try? Customer(identifier: "cus_to_mer")
    }

    /// Creating a customer with raw information.
    var newCustomer: Customer? {
       
        var Email = ""
        var Name = ""
        if userDefaults.value(forKey: kcCustomerName) != nil {
                       Name = userDefaults.value(forKey: kcCustomerName) as! String
                   }
                   else {
                       Name = "Guest"
                   }
                   
                   if userDefaults.value(forKey: kcEmail) != nil {
                       let emailId = userDefaults.value(forKey: kcEmail) as! String
                       if AppHelper.isValidEmail(emailId){
                           Email = emailId
                           
                       }
                       else {
                           Email = "Guest@Khaam.com"
                           
                       }
                   }
                   else {
                       Email = "Guest@Khaam.com"
                   }
        
        let emailAddress = try! EmailAddress(emailAddressString: Email)
        let phoneNumber = try! PhoneNumber(isdNumber: "965", phoneNumber: "96512345")
            
        return try? Customer(emailAddress:  emailAddress,
                             phoneNumber:   phoneNumber,
                             firstName:     Name,
                             middleName:    nil,
                             lastName:      Name)
    }
    
    internal var amount: Decimal {
        
        let value = Double(fGrandTotal)
        return self.plainAmount ?? Decimal(value)
    }
    
    internal var items: [PaymentItem]? {

        return self.selectedPaymentItems
    }
    
    
    
    internal var mode: TransactionMode {
        
        return .purchase
    }
    
   
    
    /*var allowedCadTypes: [CardType]? {
        
        return [CardType(cardType: .Debit)]
    }*/
    
   
    
}


// MARK: - SessionDelegate
extension CardPayment: SessionDelegate {
    
    internal func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
        
        // payment succeed, saving the customer for reuse.
         AppHelper.hideLoadingView()
     
        if let customerID = charge.customer.identifier {
            
            let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
            nextViewController.isAppointment = isAppointment
                 nextViewController.orderId = self.orderId
            nextViewController.cTransactionId = customerID
                 self.navigationController?.pushViewController(nextViewController, animated: true)
          
        }
    }
    
    
    internal func applePaymentTokenizationFailed(_ error: String, on session: SessionProtocol) {
        
    }
    internal func applePaymentTokenizationSucceeded(_ token: Token, on session: SessionProtocol) {
        
    }
    
    internal func applePaymentSucceed(_ charge: String, on session: SessionProtocol) {
        //print(charge)
        let alert = UIAlertController(title: "Message from SDK delegate", message: charge, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.session.stop {
            self.present(alert, animated: true)
        }
    }
    
    internal func applePaymentCanceled(on session: SessionProtocol)
    {
        let alert = UIAlertController(title: "Message from SDK delegate", message: "User Canceled", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        //self.session.stop {
          //  self.present(alert, animated: true)
        //}
    }
    
    
    internal func applePaymen(_ charge: String, on session: SessionProtocol) {
        //print(charge)
        let alert = UIAlertController(title: "Message from SDK delegate", message: charge, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.session.stop {
            self.present(alert, animated: true)
        }
    }
    
    internal func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
        
        // authorization succeed, saving the customer for reuse.
        
        if let customerID = authorize.customer.identifier {
            
            
        }
    }
    
    // payment failed, payment screen closed.
    func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
        
        let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPaymentFailed") as! CardPaymentFailed
        nextViewController.isAppointment = isAppointment
        nextViewController.orderId = self.orderId
        self.navigationController?.pushViewController(nextViewController, animated: true)
//        if let error = error {
//            let errorMessage:String = "\(error) \n \(error.description)"
//            let alert:UIAlertController  = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
//            let copyAction:UIAlertAction = UIAlertAction(title: "Copy", style: .destructive) { (_) in
//                UIPasteboard.general.string = errorMessage
//            }
//            alert.addAction(copyAction)
//            present(alert, animated: true, completion: nil)
//        }
    }
    
    internal func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
        
        // authorization failed, payment screen closed.
    }
    
    internal func sessionCancelled(_ session: SessionProtocol) {
        
        let nextViewController = objCart.instantiateViewController(withIdentifier: "CardPaymentFailed") as! CardPaymentFailed
        nextViewController.orderId = self.orderId
        nextViewController.isAppointment = isAppointment
        self.navigationController?.pushViewController(nextViewController, animated: true)
        // payment cancelled (user manually closed the payment screen).
    }
    
   
    
    internal func sessionIsStarting(_ session: SessionProtocol) {
        
        // session is about to start, but UI is not yet shown.
       //  AppHelper.showLoadingView()
      
    }
    
    internal func sessionHasStarted(_ session: SessionProtocol) {
        
        // session has started, UI is shown (or showing)
        AppHelper.hideLoadingView()
       
    }
    
    internal func sessionHasFailedToStart(_ session: SessionProtocol) {
        
        // session has failed to start.
        
         AppHelper.hideLoadingView()
    }
}
