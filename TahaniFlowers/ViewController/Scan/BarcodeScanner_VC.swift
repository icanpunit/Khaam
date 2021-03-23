//
//  BarcodeScanner_VC.swift
//  Browzly
//
//  Created by Nikunj on 21/04/17.
//  Copyright © 2017 I Can Infotech. All rights reserved.
//

import UIKit
import AVFoundation


protocol BarcodeScanner_VCDelegate {
    func SetISBNNumber(number: String)
}

class BarcodeScanner_VC: UIViewController, RMScannerViewDelegate  {
    
    @IBOutlet var scannerView: RMScannerView!
    @IBOutlet var lblScanCode:UILabel!
    
    var delegate: BarcodeScanner_VCDelegate?
    var tag:String = "0"
    
   var isbreck = false
    var isEndBreck = false
    var cBreakTypeName:String = String()
    var nBreakTypeId:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set verbose logging to YES so we can see exactly what's going on
        scannerView.verboseLogging = true
        
        // Set animations to YES for some nice effects
        scannerView.animateScanner = true
        
        // Set code outline to YES for a box around the scanned code
        scannerView.displayCodeOutline = true
        
        // Start the capture session when the view loads - this will also start a scan session
        scannerView.startCaptureSession()
        //        scannerView.startScanSession()
        
        
        // Do any additional setup after loading the view.
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "menu_ScanProduct".setlocalized()
       
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
        
//        let buttonLanguage = UIButton.init(type: .custom)
//        buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
//        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
//        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
//
//        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
//        self.navigationItem.rightBarButtonItems = []
    }
    
    @objc func back() {
//           if isback == true
//           {
//               self.navigationController?.popViewController(animated: true)
//           }
//           else
//           {
//
//           }
            appDelegate.SetTabBarItem(0)
       }
    override func viewWillAppear(_ animated: Bool) {
        addNavigationBar()
        
    }
    
    
    
   @objc func BackClick(){
        dismiss(animated: true, completion: nil)
    }
    
    public func didScanCode(_ scannedCode: String!, onCodeType codeType: String!) {
        print(scannedCode)
        self.lblScanCode.text = scannedCode
        
        scannerView.stopScanSession()
        let params = URL(string: scannedCode)?.parameters
        if let name = params?["link"] {
            
            let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetails
            let newURL = URL(string: name)!

            if ((Int(name)) != nil)
            {
                nextViewController.productId = "\(name)"
            }
            else
            {
                print(newURL.valueOf("productid"))
                                   
                                   nextViewController.productId = newURL.valueOf("productid")!
            }
           
            
                   nextViewController.isDeeplink = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
                        
            print(name)
        }
//        if(delegate != nil){
//            CheckQRCode(CodeString: scannedCode)
//
//        }
//        else
//        {
//            if self.isbreck == true
//            {
//                CheckQRCode(CodeString: scannedCode)
//            }
//        }
        
        
    }
    
    
   
    
    public func errorGeneratingCaptureSession(_ error: Error!) {
        scannerView.stopCaptureSession()
     //   appDelegate.AlertMessage(title: "Unsupported Device", message: "This device does not have a camera. Run this app on an iOS device that has a camera.")
    }
    
    func errorAcquiringDeviceHardwareLock(_ error: Error!) {
       // appDelegate.AlertMessage(title: "Focus Unavailable", message: "Tap to focus is currently unavailable. Try again in a little while.")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
