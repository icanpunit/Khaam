//
//  Filter_Vc.swift
//  TahaniFlowers
//
//  Created by baps on 10/04/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol filterApplyDelegate {
    func FilterApply()
    
}
class Filter_Vc: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate,CallApiFilterDelegate {
    
    func FilterReloadData() {
       callWebserviceForCategoryFilter()
    }
    
    
    
let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
    @IBOutlet weak var tblMain: UITableView!
    var objFilterlist = HttpWrapper()
       var net:NetworkReachabilityManager = NetworkReachabilityManager()!
     let userDefaults = UserDefaults.standard
    var arrForcategoryFilter:NSMutableArray = NSMutableArray()
    var nCategoryId:String = ""
  
    var delegate:filterApplyDelegate?
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnApply.backgroundColor = btnBackgroundColor
        self.btnApply.setTitleColor(btnTitleColor, for: .normal)
        self.btnApply.layer.cornerRadius = btnRadius
        self.view.backgroundColor = UIColor.white
        self.btnClear.backgroundColor = btnBackgroundColor
        self.btnClear.setTitleColor(btnTitleColor, for: .normal)
        self.btnClear.layer.cornerRadius = btnRadius
        let nibName = UINib(nibName: "Filtertable_Cell", bundle: nil)
        tblMain.register(nibName, forCellReuseIdentifier: "Filtertable_Cell")
        btnApply.setTitle("lbl_filter_Btn_Apply".setlocalized(), for: .normal)
        btnClear.setTitle("lbl_Filter_btn_Clear".setlocalized(), for: .normal)
        let nibName2 = UINib(nibName: "FilterSlider_Cell", bundle: nil)
        tblMain.register(nibName2, forCellReuseIdentifier: "FilterSlider_Cell")
       addNavigationBar()
        tblMain.tableFooterView = UIView()
        tblMain.delegate = self
        tblMain.dataSource = self
        callWebserviceForCategoryFilter()
//        appDelegate.FilterDataArray.removeAllObjects()
//        appDelegate.FilterDataArrayName.removeAllObjects()
        // Do any additional setup after loading the view.
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "lbl_Filter_Title".setlocalized()
//        if searchText != "" {
//            lbNavTitle.text = self.searchText
//        }
//        else {
//            lbNavTitle.text = cCategoryName //"lbl_home_title".setlocalized()
//        }
        
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
      //  self.view.backgroundColor  = navigationbarColor
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let buttonBack = UIButton.init(type: .custom)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.addNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func back() {
        
        if appDelegate.isFilterApply == false
        {
            appDelegate.FilterDataArray.removeAllObjects()
            appDelegate.FilterDataArrayName.removeAllObjects()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBackToShop(_ sender: UIButtonX) {
        appDelegate.SetTabBarItem(0)
    }
    
    @IBAction func onClickbtnClear(_ sender: Any) {
        appDelegate.FilterDataArray.removeAllObjects()
        appDelegate.FilterDataArrayName.removeAllObjects()
        tblMain.reloadData()
        appDelegate.isFilterApply = false
        callWebserviceForCategoryFilter()
         delegate?.FilterApply()
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickbtnApply(_ sender: Any) {
        appDelegate.isFilterApply = true
        delegate?.FilterApply()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func callWebserviceForCategoryFilter() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = userDefaults.value(forKey: knUserId) as! Int
            var nLanguageId = ""
            
            if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
            }
            
            let cToken = userDefaults.value(forKey: kcToken) as! String
            
            var param:String = ""

            var strfilter = ""
            if appDelegate.FilterDataArray.count > 0
            {
             
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: appDelegate.FilterDataArray)
                let jsonString = String(data: jsonData!, encoding: .utf8)
                strfilter = jsonString!
            }
            
            
//nCategoryId
            param = String(format: "%@?nUserId=%@&nLanguageId=%@&cToken=%@&nCategoryId=%@&cAttributeJsonData=%@", kSelectSmartFilterByAttributeJsonData,"\(nUserId)","\(nLanguageId)","\(cToken)",nCategoryId,strfilter)
            
            print("Catlog: \(param)")
            let escapedString = param.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            AppHelper.showLoadingView()
            self.objFilterlist = HttpWrapper.init()
            self.objFilterlist.delegate = self
            self.objFilterlist.requestWithparamdictParamPostMethodwithHeaderGet(url: escapedString, headers: nil)
        }
    }
    
    
    
     // MARK: - HttpWrapper Delegate
        
        func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        //    self.refreshControl.endRefreshing()
           // self.activityIndicatorView.stopAnimating()
            if wrapper == objFilterlist {
                AppHelper.hideLoadingView()
                if dicsResponse.value(forKey: "Success") as! String == "1" {
                    if let bannerImages = dicsResponse.object(forKey: "result") as? NSArray {
                        self.arrForcategoryFilter = bannerImages.mutableCopy() as! NSMutableArray
                    }
                    
                    self.tblMain.reloadData()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.tblMain.reloadData()
                    }) { (true) in
                        self.tblMain.reloadData()
                    }
                }
                else
                {
                    self.arrForcategoryFilter.removeAllObjects()
                     self.tblMain.reloadData()
                }
            }
          
        }
        
        func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
            AppHelper.hideLoadingView()
        }
    // MARK: - tableview Methods
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrForcategoryFilter.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeType") as! String == "Numeric" || (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeType") as! String == "Price"
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSlider_Cell", for: indexPath) as! FilterSlider_Cell
        
         cell.Data = arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary
        cell.delegate = self
         cell.index = indexPath;
        
        var min:Float = Float()
        
        if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "MinValue") as? String
        {
            min = Float(value)!
        }
        else if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "MinValue") as? Float
        {
            min = Float(value)
        }
        else if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "MinValue") as? NSNumber
        {
            min = Float(truncating: value)
        }
        
        var max:Float = Float()
               
       if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "MaxValue") as? String
       {
           max = Float(value)!
       }
       else if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "MaxValue") as? Float
       {
           max = Float(value)
       }
       else if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "MaxValue") as? NSNumber
       {
        max = Float(truncating: value)
       }
        
        
        var nAttributeId:Int = Int()
                      
              if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributeId") as? String
              {
                nAttributeId = Int(value)!
              }
              else if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributeId") as? Float
              {
                nAttributeId = Int(value)
              }
              else if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributeId") as? NSNumber
              {
               nAttributeId = Int(truncating: value)
              }
                //NSDictionary * minmaxvalue = [[arrForcategoryFilter objectAtIndex:indexPath.row] valueForKey:@"filter_value"];
             
        var istrue = false;
        var dataindex = 0;
        
        if appDelegate.FilterDataArray.count > 0
        {
            for index in 0...appDelegate.FilterDataArray.count-1 {
               let inData:NSDictionary = appDelegate.FilterDataArray.object(at: index) as! NSDictionary
             if let id = inData.value(forKey: "nAttributeId") as? String
               {
                              if "\(id)" == "\(nAttributeId)"
                              {
                              istrue = true
                               dataindex = index
                   }
                           }
                           else if let id = inData.value(forKey: "nAttributeId") as? NSNumber
                           {
                               if "\(id)" == "\(nAttributeId)"
                                          {
                                        istrue = true
                                           dataindex = index
                               }
                           }
            }
        }
        
        
        if istrue == true
        {
            let inData:NSDictionary = appDelegate.FilterDataArray.object(at: dataindex) as! NSDictionary
            if let values = inData.value(forKey: "cAttributeValue") as? String
            {
                let minmax = values.split(separator: ",")
                let testmin = String(minmax[0])
                let testmax = String(minmax[1]) 
                cell.min = min;
                cell.max = max;
                cell.Smin = NSString(string: testmin).floatValue
                cell.Smax = NSString(string: testmax).floatValue
            }
            
        }
        else
        {
            cell.min = min;
            cell.max = max;
            cell.Smin = min;
            cell.Smax = max;
        }
        
        
               
        if currentLanguage == "en" {
            
            if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeName") as? String
                         {
                            cell.lblTitle.text = value
                         }
            
        }
        else{
             if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeNameAr") as? String
                                    {
                                       cell.lblTitle.text = value
                                    }
        }
                
        cell.setupslider()
        
        cell.layoutIfNeeded()
        cell.RangeSliderCurrency.layoutIfNeeded()
        return cell
    }
    else
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Filtertable_Cell", for: indexPath) as! Filtertable_Cell
        
        if let value:NSArray = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "AttributeValue") as? NSArray
        {
            cell.myArray = value.mutableCopy() as! NSMutableArray
        }
        cell.SelectedArray.removeAllObjects()
        cell.delegate = self
        cell.Data = arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary
         
        if let id = cell.Data.value(forKey: "nAttributeId") as? String
                     {
                        cell.nAttributeId = "\(id)"
                     }
                     else if let id = cell.Data.value(forKey: "nAttributeId") as? NSNumber
                     {
                         cell.nAttributeId = "\(id)"
                     }
                     
                     if let id = cell.Data.value(forKey: "cAttributeType") as? String
                     {
                        cell.cAttributeType = "\(id)"
                     }
                     else if let id = cell.Data.value(forKey: "cAttributeType") as? NSNumber
                     {
                         cell.cAttributeType = "\(id)"
                     }
        
         if(cell.myArray.count%2 == 0)
         {
            cell.collectionHeightConstant.constant = CGFloat(cell.myArray.count/2 * 60)
         }
         else
         {
            var value:Int = cell.myArray.count + 1;
            cell.collectionHeightConstant.constant = CGFloat(value/2 * 60)
         }
        // cell.collectionHeightConstant.constant = 100
        
        if currentLanguage == "en" {
                   
                   if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeName") as? String
                                {
                                   cell.lblTitle.text = value
                                }
                   
               }
               else{
                    if let value = (arrForcategoryFilter.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeNameAr") as? String
                                           {
                                              cell.lblTitle.text = value
                                           }
               }
        
        
        
        
        
         cell.index = indexPath
        cell.CollectionFilter.reloadData()
        return cell
    }
    
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
