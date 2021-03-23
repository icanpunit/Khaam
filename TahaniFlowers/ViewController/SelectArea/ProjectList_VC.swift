//
//  ProjectList_VC.swift
//  ViteHR
//
//  Created by i can infotech on 28/12/17.
//  Copyright © 2017 i can infotech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ProjectList_VCDelegate{
    func SelectGoverenate(_ dics: NSDictionary,cell:AddNewAddressCell)
    func SelectArea(_ dics: NSDictionary,cell:AddNewAddressCell)
}

protocol ProjectList_VCCartDelegate{
    func SelectGoverenate(_ dics: NSDictionary,cell:CheckoutAddNewAddress)
    func SelectArea(_ dics: NSDictionary,cell:CheckoutAddNewAddress)
}


class ProjectList_VC: UIViewController,UITableViewDelegate,UITableViewDataSource ,HttpWrapperDelegate,UISearchBarDelegate{
    //Reload Data
    func ContectAddSuccess() {
       // SelectAllProject()
    }
    

    @IBOutlet weak var SearchViewConstantTrilling: NSLayoutConstraint!
    var delegates: ProjectList_VCDelegate?
    var delegates2: ProjectList_VCCartDelegate?
    var celltbl:UITableViewCell = UITableViewCell()
    @IBOutlet weak var btnadd: UIButton!
    @IBOutlet var viewSearch: UIView!
    var arrdata: NSMutableArray = NSMutableArray()
    var NoOfCell: NSMutableArray = NSMutableArray()
    @IBOutlet var tableview: UITableView!
    var isFromAppointMent = false
    var nCityId:String = String()
    @IBOutlet var searchbar: UISearchBar!
    var tableData: NSMutableArray = NSMutableArray()
    var searchActive: Bool = false
    var isCart = false
    var objGetGovernate = HttpWrapper()
       var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        searchbar.tintColor = .darkGray
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
            .updateValue(UIColor.darkGray, forKey: NSAttributedStringKey.foregroundColor.rawValue)
        
        let nibName = UINib(nibName: "ProjrctList_Cell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ProjrctList_Cell")
        //tableview.tableHeaderView = viewSearch
        
        
        btnadd.setImage(btnadd.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
       // btnadd.tintColor = navTopcolor
        
        if isFromAppointMent == true
        {
            SearchViewConstantTrilling.constant = 10
            btnadd.isHidden = false
            getGoveranatelist()
        }
        else
        {
            SearchViewConstantTrilling.constant = 10
            btnadd.isHidden = true
            getArealist()
        }
        // Do any additional setup after loading the view.
    }


    @IBAction func onclickAddContact(_ sender: Any) {
        
        
      
       
    }
    
   
    @IBAction func BtnCloseClick(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    func CreateCell(){
        
        NoOfCell = NSMutableArray()
        
        var array = NSMutableArray()
        
        if(searchActive == false){
            array = arrdata
        }
        else{
            array = tableData
        }
        for item in array {
            
            if let cell = tableview.dequeueReusableCell(withIdentifier: "ProjrctList_Cell") as? ProjrctList_Cell {
                
                if let dic = item as? NSDictionary {
                    
                    //print(dic)
                    cell.DataDic = dic
                    if isFromAppointMent == true
                    {
                        if let name = dic.object(forKey: "cCityName") as? String {
                            cell.lblname.text = name
                        }
                    }
                    else
                    {
                        if let name = dic.object(forKey: "cAreaName") as? String {
                            cell.lblname.text = name
                        }
                    }
                   
                    
                   // cell.imgRedio.image = UIImage(named: "uncheck")!
                }
                NoOfCell.add(cell)
            }
        }
        tableview.reloadData()
    }
    
    //MARK: TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoOfCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = NoOfCell.object(at: indexPath.row) as? ProjrctList_Cell
        return (cell?.frame.size.height)!
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (NoOfCell.object(at: indexPath.row) as? ProjrctList_Cell)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          DispatchQueue.main.async {
                  let cell = self.NoOfCell.object(at: indexPath.row) as? ProjrctList_Cell
                //  cell?.imgRedio.image = UIImage(named: "check")!
                  self.dismiss(animated: true, completion: nil)
            
            if self.isCart == true
            {
                if self.isFromAppointMent == true
                       {
                           self.delegates2?.SelectGoverenate((cell?.DataDic)!, cell: self.celltbl as! CheckoutAddNewAddress)
                       }
                       else
                       {
                          self.delegates2?.SelectArea((cell?.DataDic)!, cell: self.celltbl as! CheckoutAddNewAddress)
                       }
                
                  }
            
            else
            {
                if self.isFromAppointMent == true
                       {
                           self.delegates?.SelectGoverenate((cell?.DataDic)!, cell: self.celltbl as! AddNewAddressCell)
                       }
                       else
                       {
                          self.delegates?.SelectArea((cell?.DataDic)!, cell: self.celltbl as! AddNewAddressCell)
                       }
                
                  }
            }
            
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        if let cell = NoOfCell.object(at: indexPath.row) as? ProjrctList_Cell {
           // cell.imgRedio.image = UIImage(named: "uncheck")!
        }
    }
    
    
    //MARK: - Search Method
    
    override func viewWillDisappear(_ animated: Bool) {
        searchbar.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard()
    {
        //let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.searchbar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchbar.resignFirstResponder()
    }
    
    
    func getGoveranatelist() {
           
           if net.isReachable == false {
               let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
               alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
           else {
               let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
              // let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
               let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
               var nLanguageId = ""
               
               if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                   nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
               }
               
               let param:NSMutableString = NSMutableString()
               
               param.append(String(format:"%@?", kSelectAllCityByLanguageIdAndCountryId))
               param.append(String(format:"nUserId=%@&", "\(nUserId)"))
               param.append(String(format:"nCountryId=%@&", "1"))
               param.append(String(format:"nLanguageId=%@&", nLanguageId))
               param.append(String(format:"cToken=%@", cToken))
               
               print(param)
               
               let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
               
               AppHelper.showLoadingView()
               self.objGetGovernate = HttpWrapper.init()
               self.objGetGovernate.delegate = self
               self.objGetGovernate.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
           }
       }
    
    
    func getArealist() {
              
              if net.isReachable == false {
                  let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
                  alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
              }
              else {
                  let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
               //   let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
                  let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
                  var nLanguageId = ""
                  
                  if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                      nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                  }
                  
                  let param:NSMutableString = NSMutableString()
                  
                  param.append(String(format:"%@?", kSelectAllAreaByLanguageIdAndCityId))
                  param.append(String(format:"nUserId=%@&", "\(nUserId)"))
                  param.append(String(format:"nCityId=%@&", nCityId))
                  param.append(String(format:"nLanguageId=%@&", nLanguageId))
                  param.append(String(format:"cToken=%@", cToken))
                  
                  print(param)
                  
                  let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                  
                  AppHelper.showLoadingView()
                  self.objGetGovernate = HttpWrapper.init()
                  self.objGetGovernate.delegate = self
                  self.objGetGovernate.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
              }
          }
       
    
    // MARK: - HttpWrapper Delegate
       
       func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
           if wrapper == objGetGovernate {
               print(dicsResponse)
               AppHelper.hideLoadingView()
               if dicsResponse.value(forKey: "Success") as! String == "1" {
                   if let products = dicsResponse.value(forKey: "Result") as? NSArray {
                    self.arrdata = products.mutableCopy() as! NSMutableArray
                    self.NoOfCell.removeAllObjects()
                                     DispatchQueue.main.async(execute: {
                                          self.CreateCell()
                                      })
                    }
                    
               }
               else{
                   
                 //  viewNoDataFound.isHidden = false
                   //AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
               }
           }
         
       }
       
       func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
           AppHelper.hideLoadingView()
       }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text!.isEmpty{
            searchActive = false
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            CreateCell()
            
        } else {
            searchActive = true
            tableData.removeAllObjects()
            
            let predicate=NSPredicate(format: "cCityName CONTAINS[c] %@",searchText)
            let predicate2=NSPredicate(format: "cAreaName CONTAINS[c] %@",searchText)
            //let predicate3=NSPredicate(format: "city CONTAINS[c] %@",searchText)
            
            let andPredicate = NSCompoundPredicate(type: .or , subpredicates: [predicate, predicate2])
            
            let arrSearch = (self.arrdata as NSArray).filtered(using: andPredicate) as! NSArray
            self.tableData = arrSearch.mutableCopy() as! NSMutableArray
            
//            for item in arrdata {
//
//                if let dic = item as? NSDictionary {
//
//                    if isFromAppointMent == true
//                    {
//
//                        if let strTemp = dic.object(forKey: "cCustomerFirstName") as? String {
//                            if strTemp.lowercased().range(of:searchText.lowercased()) != nil {
//                                tableData.add(dic)
//                            }
//                        }
//                    }
//                    else
//                    {
//                        if let strTemp = dic.object(forKey: "cProjectName") as? String {
//                            if strTemp.lowercased().range(of:searchText.lowercased()) != nil {
//                                tableData.add(dic)
//                            }
//                        }
//                    }
//
//
//
//
//                }
//            }
            self.CreateCell()
        }
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
