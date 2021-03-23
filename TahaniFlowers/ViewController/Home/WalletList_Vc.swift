//
//  WalletList_Vc.swift
//  TahaniFlowers
//
//  Created by baps on 31/08/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class WalletList_Vc: UIViewController ,HttpWrapperDelegate{

    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var imgWallet: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    var objOrders = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var arrWalletList:NSArray = NSArray()
    var currency = ""
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet weak var lblNoDataFound: UILabel!
      @IBOutlet weak var lblNODataDetail: UILabel!
      @IBOutlet weak var imgNoData: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationBar()
        tblView.delegate = self
        tblView.dataSource = self
        getWallet()
        self.viewNoDataFound.frame.size.width = self.view.frame.size.width
               self.viewNoDataFound.frame.size.height = self.view.frame.size.height
               self.lblNoDataFound.text = "lbl_wallet_emptywallet_title".setlocalized()
               self.lblNODataDetail.text = "lbl_wallet_emptywallet_description".setlocalized()
        if let url = "img_wallet_walleticon_walletscreen".setlocalized() as? String {
            imgWallet.cacheImage(urlString: url)
        }
        
        if let url = "img_wallet_emptyimage".setlocalized() as? String {
            imgNoData.cacheImage(urlString: url)
        }
        
         self.view.addSubview(self.viewNoDataFound)
        viewNoDataFound.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.addNavigationBar()
           
       }
       
    @objc func back() {
           self.navigationController?.popViewController(animated: true)
           
       }
     func addNavigationBar(){
            self.navigationController?.isNavigationBarHidden = false
            let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
            lbNavTitle.textAlignment = .center
            lbNavTitle.text = "lbl_wallet_mywalletscreen".setlocalized()
            lbNavTitle.textColor = UIColor.black
            
            lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
            self.navigationItem.titleView = lbNavTitle
            self.navigationController?.navigationBar.isTranslucent = false
             navigationController?.navigationBar.barTintColor = navigationbarColor
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
           
            self.view.backgroundColor  = navigationbarColor
            viewHeader.backgroundColor  = navigationbarColor
         viewNoDataFound.backgroundColor  = navigationbarColor
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
    
    
     func getWallet() {
            
            if net.isReachable == false {
                let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
                let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
                let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
               var nLanguageId = ""
                          
                          if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                              nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                          }
                let param:NSMutableString = NSMutableString()
                
                param.append(String(format:"%@?", kSelectCustomerWalletDetail))
                param.append(String(format:"nUserId=%@&", "\(nUserId)"))
                param.append(String(format:"nCustomerId=%@&", "\(nCustomerId)"))
                param.append(String(format:"nLanguageId=%@&", "\(nLanguageId)"))
                param.append(String(format:"cToken=%@", cToken))
                 let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                
    //            param = String(format: "%@?nUserId=%@&nCustomerId=%@&cToken=%@", kGetOrders,"\(nUserId)","\(nCustomerId)","C14PwvwO4jjejXPcphTF")
                
                AppHelper.showLoadingView()
                self.objOrders = HttpWrapper.init()
                self.objOrders.delegate = self
                self.objOrders.requestWithparamdictParamPostMethodwithHeaderGet(url: NSMutableString(string: updatedUrl!) as String, headers: nil)
            }
        }
    
    // MARK: - HttpWrapper Delegate
       
       func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
           if wrapper == objOrders {
               print(dicsResponse)
               AppHelper.hideLoadingView()
               if dicsResponse.value(forKey: "Success") as! String == "1" {
                   self.arrWalletList = dicsResponse.value(forKey: "result") as! NSArray
                   self.tblView.reloadData()
                   if let value =  dicsResponse.value(forKey: "cCurrency") as? String
                {
                    currency = value
                }
                viewNoDataFound.isHidden = true
                if let price1 = dicsResponse.value(forKey: "fTotalWalletAmount") as? NSNumber
                {
                    let fPrice = Float(truncating: price1)
                    
                    lblTotalPrice.text = "\(currency) \(String(format: "%.3f", fPrice))"
                }
                
                if arrWalletList.count > 0
                {
                    tblView.tableHeaderView = viewHeader
                    viewNoDataFound.isHidden = true
                }
                else
                {
                    tblView.tableHeaderView = nil
                    viewNoDataFound.isHidden = false
                }
                
               // viewNoDataFound.isHidden = false
               }
               else{
                   //tblOrders.tableFooterView = viewNoDataFound
                   //viewNoDataFound.isHidden = true
                   self.arrWalletList = NSArray()
                    self.tblView.reloadData()
                if arrWalletList.count > 0
                {
                    tblView.tableHeaderView = viewHeader
                    viewNoDataFound.isHidden = true
                }
                else
                {
                    tblView.tableHeaderView = nil
                    viewNoDataFound.isHidden = false
                }
                  // viewNoDataFound.isHidden = false
                   //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WalletList_Vc:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWalletList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletListTable_Cell", for: indexPath) as! WalletListTable_Cell
        
        if let strDate = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "dtCreditedDate") as? String {
            
            let dateArr = strDate.components(separatedBy: "T")
            let gDate = dateArr[0]
            
            let dtDate = AppHelper.stringToDate(strDate: gDate, strFormate: "yyyy-MM-dd")
            cell.lblDate.text = "\(AppHelper.dateToString(date: dtDate, strFormate: "dd/MM/yyyy"))"
        }
        
         if let value = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "cReasons") as? String {
            cell.lblOrderNo.text = value
        }
        
        if let value = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "fCreditedAmount") as? String
        {
            
            if Int(value)! > 0
            {
                cell.lblCredit.text = "imge_wallet_credit".setlocalized()
                if let url = "lbl_NoData_order".setlocalized() as? String {
                    cell.imgArrow.cacheImage(urlString: url)
                                }
                if let price1 = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "fCreditedAmount") as? String
                {
                   
                    let fPrice = Float(price1)
                      
                    cell.lblPrice.text = "\(currency) \(String(format: "%.3f", fPrice!))"
                    

                }
            }
            else
            {
                if let url = "img_wallet_debit".setlocalized() as? String {
                                   cell.imgArrow.cacheImage(urlString: url)
                                               }
                cell.lblCredit.text = "lbl_wallet_debit_mywallletscreen".setlocalized()
                
                if let price1 = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "fDebitedAmount") as? String
                               {
                                  
                                   let fPrice = Float(price1)
                                      
                                   cell.lblPrice.text = "\(currency) \(String(format: "%.3f", fPrice!))"
                                   

                               }
            }
        }
        else if let value = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "fCreditedAmount") as? NSNumber
        {
             if Int(value) > 0
            {
                if let url = "imge_wallet_credit".setlocalized() as? String {
                                   cell.imgArrow.cacheImage(urlString: url)
                                               }
                cell.lblCredit.text = "lbl_wallet_credit_mywallletscreen".setlocalized()
                if let price1 = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "fCreditedAmount") as? NSNumber
                                              {
                                                 
                                                let fPrice = Float(truncating: price1)
                                                      
                                                  cell.lblPrice.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                                  

                                              }
            }
            else
            {
                if let url = "img_wallet_debit".setlocalized() as? String {
                                   cell.imgArrow.cacheImage(urlString: url)
                                               }
                cell.lblCredit.text = "lbl_wallet_debit_mywallletscreen".setlocalized()
                
                if let price1 = (arrWalletList.object(at: indexPath.row) as! NSDictionary).value(forKey: "fDebitedAmount") as? NSNumber
                                              {
                                                 
                                                let fPrice = Float(truncating: price1)
                                                     
                                                  cell.lblPrice.text = "\(currency) \(String(format: "%.3f", fPrice))"
                                                  

                                              }
            }
        }
        return cell
    }
}
