//
//  FaqVc.swift
//  TahaniFlowers
//
//  Created by baps on 27/06/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import WebKit
class FaqVc: UIViewController ,WKNavigationDelegate ,UIScrollViewDelegate{

    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
       @IBOutlet weak var leftMargin: NSLayoutConstraint!
       @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBar()
        
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                  if currentLanguage == "en" {
                    webview.load(URLRequest(url: URL(string: "http://www.khaam.me/admin/FAQManagementEn.aspx?nUserId=1")!))
                  }
                  else{
                       webview.load(URLRequest(url: URL(string: "http://www.khaam.me/admin/FAQManagementAr.aspx?nUserId=1")!))
                  }
//        
//        print(self.kentUrl)
//        webview.navigationDelegate = self

//        let url = URL(string: "http://www.khaam.me/admin/FAQManagementEn.aspx?nUserId=1")!
//        leftMargin.constant = -(self.view.bounds.width / 2)
//        rightMargin.constant =  -(self.view.bounds.width / 2)
//
//        webview.load(URLRequest(url:url ))
//        webview.scrollView.delegate = self
        // Do any additional setup after loading the view.
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
          //  self.updateZoomToAspectToFit(webView: webView)

        }
        
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
           
        }
    
    override func viewWillAppear(_ animated: Bool) {
         addNavigationBar()
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
       }
    func addNavigationBar(){
           self.navigationController?.isNavigationBarHidden = false
           let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
           lbNavTitle.textAlignment = .center
           lbNavTitle.text = "menu_Faq".setlocalized()
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
           
//           let buttonLanguage = UIButton.init(type: .custom)
//           buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
//           buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
//           buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
//
//           let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
//           self.navigationItem.rightBarButtonItems = []
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
