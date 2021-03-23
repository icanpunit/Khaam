//
//  AddNewAddress.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 31/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddNewAddress: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate,CLLocationManagerDelegate , UITextFieldDelegate, GovernetsSelectDelegate,ProjectList_VCDelegate{
    func SelectGoverenate(_ dics: NSDictionary, cell: AddNewAddressCell) {
        
        cell.txtSelectArea.text = ""
        if let value = dics.value(forKey: "cCityName") as? String
        {
            cell.txtSelectGovernate.text = value
        }
        
        if let value = dics.value(forKey: "nCityId") as? NSNumber
        {
            nCityId = "\(value)"
        }
        
        
        
    }
    
    func SelectArea(_ dics: NSDictionary, cell: AddNewAddressCell) {
        
        if let value = dics.value(forKey: "cAreaName") as? String
        {
            cell.txtSelectArea.text = value
        }
        
        if let value = dics.value(forKey: "nAreaId") as? NSNumber
        {
            nAreaId = "\(value)"
        }
        
        
    }
    
   
    
    func onclickselectGovernate(cell:AddNewAddressCell) {
        
        self.view.endEditing(true)
        let modalViewController = ProjectList_VC(nibName:"ProjectList_VC",bundle: nil)
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.delegates = self
        modalViewController.celltbl = cell
        modalViewController.isFromAppointMent = true
        present(modalViewController, animated: true, completion: nil)
    }
    
    func onclickselectArea(cell:AddNewAddressCell) {
        self.view.endEditing(true)
        let modalViewController = ProjectList_VC(nibName:"ProjectList_VC",bundle: nil)
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.delegates = self
        modalViewController.celltbl = cell
        modalViewController.nCityId =  nCityId
        modalViewController.isFromAppointMent = false
        present(modalViewController, animated: true, completion: nil)
    }
    

    // MARK: - IBOutlets
    
   
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAddNewAddress: UITableView!
    
    @IBOutlet weak var segHeader: UISegmentedControl!
    // MARK: - Variables
    var nCityId:String = String()
    var nAreaId:String = String()
    var AddressType = 0
    var strName:String = ""
    var strMobileNo:String = ""
    var strAlternateNo:String = ""
    var strSelectArea:String = ""
    var strBlock:String = ""
    var strStreet:String = ""
    var strAvenue:String = ""
    var strHouse:String = ""
    var strFloor:String = ""
    var strSelectgovernet:String = ""
    var strBuldingNo:String = ""
    var strAddress:String = ""
    var strSpecialInstruction:String = ""
    var strLandmark:String = ""
    var wantToSave:String = "0"
    var dicAddressDetails:NSDictionary = NSDictionary()
    var isEdit:Bool!
    var nAddressId = ""
    var nCustomerId = "0"
    var objAddNewAddress = HttpWrapper()
    var objEditAddress = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    private var locationManager: CLLocationManager!
    var subaddress = ""
    var subLocality = ""
    var subAdministrativeArea = ""
    var administrativeArea = ""
    var postalCode = ""
    var country = ""
    var addressCell = AddNewAddressCell()
    var completeAddress:NSMutableString = NSMutableString()
    var cellHeight:CGFloat = 0
    var isVerify = false
    var selectedIndexPath = IndexPath()
    
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segHeader.setTitle("lbl_new_address_Home".setlocalized(), forSegmentAt: 0)
        segHeader.setTitle("lbl_new_address_Office".setlocalized(), forSegmentAt: 1)
        segHeader.setTitle("lbl_new_address_Aparment".setlocalized(), forSegmentAt: 2)
        segHeader.setTitle("lbl_new_address_teller".setlocalized(), forSegmentAt: 3)
        tblAddNewAddress.tableHeaderView = viewHeader
      
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()

        if isEdit == true {
            self.getAddressDetails()
            isEdit = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    
    // MARK: - @objc Actions
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        
        AddressType = sender.selectedSegmentIndex
        tblAddNewAddress.reloadData()
    }
    @objc func currentLocation(sender:MyAddressTap){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        addressCell = sender.cell
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveNewAddress(sender:MyAddressTap) {
        let cell = sender.cell
        self.completeAddress = ""
        self.strSelectgovernet = cell.txtSelectGovernate.text!
        self.strName = cell.txtName.text!
        self.strMobileNo = cell.txtMobileNo.text!
        self.strAlternateNo = cell.txtAlternateNo.text!
        self.strSelectArea = cell.txtSelectArea.text!
        self.strBlock = cell.txtBlock.text!
        self.strStreet = cell.txtStreet.text!
        self.strAvenue = cell.txtAvenue.text!
        self.strHouse = cell.txtHouse.text!
        self.strFloor = cell.txtFloor.text!
        self.strBuldingNo = cell.txtBildingNo.text!
        self.strSpecialInstruction = cell.txtviewSpecialInstruction.text!
        self.strLandmark = cell.txtLandmark.text!
        var flag = true
        var fieldCount = 0
        var Type = "Home"
        
        
        if AddressType == 0
        {
          Type = "Home"
                    
        }
        else if AddressType == 1
        {
            Type = "Office"
        }
        else if AddressType == 2
        {
            Type = "Apartment"
        }
        else
        {
           Type = "tailor"
        }
        
        
        if AppHelper.isNull(self.strName) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredName.isHidden = false
            cell.lblRequiredName.text = "required".setlocalized()
            cell.bottomSpaceName.constant = 30
            cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strName, 20) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredName.isHidden = false
            cell.lblRequiredName.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.bottomSpaceName.constant = 30
            cell.viewName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredName.isHidden = true
            cell.bottomSpaceName.constant = 10
            cell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
        if AppHelper.isNull(self.strMobileNo) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredMobileNo.isHidden = false
            cell.lblRequiredMobileNo.text = "required".setlocalized()
            cell.bottomSpaceMobileNo.constant = 30
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidMobileNumber(self.strMobileNo) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredMobileNo.isHidden = false
            cell.lblRequiredMobileNo.text = "lbl_signup_only_digits_allowed".setlocalized()
            cell.bottomSpaceMobileNo.constant = 30
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredMobileNo.isHidden = true
            cell.bottomSpaceMobileNo.constant = 10
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }

        
        if AppHelper.isNull(self.strAlternateNo) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredAltMobileNo.isHidden = false
            cell.lblRequiredAltMobileNo.text = "required".setlocalized()
            cell.bottomSpaceAltMobileNo.constant = 30
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidMobileNumber(self.strAlternateNo) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredAltMobileNo.isHidden = false
            cell.lblRequiredAltMobileNo.text = "lbl_signup_only_digits_allowed".setlocalized()
            cell.bottomSpaceAltMobileNo.constant = 30
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredAltMobileNo.isHidden = true
            cell.bottomSpaceAltMobileNo.constant = 10
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }

         if AppHelper.isNull(self.strSelectgovernet) == true {
                         fieldCount = fieldCount + 1
                         cell.lblRequiredSelectGovernate.isHidden = false
                         cell.bottomSpaceGovernate.constant = 30
                         cell.lblRequiredSelectGovernate.text = "required".setlocalized()
                         cell.viewSelectGovernate.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                         flag = false
                     }
                     
                     else {
                         cell.lblRequiredSelectGovernate.isHidden = true
                         cell.bottomSpaceGovernate.constant = 10
                         cell.viewSelectGovernate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                     }
              
              if AppHelper.isNull(self.strSelectArea) == true {
                  fieldCount = fieldCount + 1
                  cell.lblRequiredSelectArea.isHidden = false
                  cell.bottomSpaceSelectArea.constant = 30
                  cell.lblRequiredSelectArea.text = "required".setlocalized()
                  cell.viewSelectArea.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                  flag = false
              }
              
              else {
                  cell.lblRequiredSelectArea.isHidden = true
                  cell.bottomSpaceSelectArea.constant = 10
                  cell.viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
              }
        if AppHelper.isNull(self.strBlock) == true{
            fieldCount = fieldCount + 1
            cell.lblRequiredBlock.isHidden = false
            cell.bottomSpaceBlock.constant = 30
            cell.lblRequiredBlock.text = "required".setlocalized()
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strBlock, 20) == false{
            fieldCount = fieldCount + 1
            cell.lblRequiredBlock.isHidden = false
            cell.bottomSpaceBlock.constant = 30
            cell.lblRequiredBlock.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredBlock.isHidden = true
            cell.bottomSpaceBlock.constant = 10
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        
        if AppHelper.isNull(self.strStreet) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredStreet.isHidden = false
            cell.bottomSpaceStreet.constant = 30
            cell.lblRequiredStreet.text = "required".setlocalized()
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strStreet, 100) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredStreet.isHidden = false
            cell.bottomSpaceStreet.constant = 30
            cell.lblRequiredStreet.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredStreet.isHidden = true
            cell.bottomSpaceStreet.constant = 10
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }

//        if AppHelper.isNull(self.strAvenue) == true {
//            fieldCount = fieldCount + 1
//            cell.lblRequiredAvenue.isHidden = false
//            cell.bottomSpaceAvenue.constant = 30
//            cell.lblRequiredAvenue.text = "required".setlocalized()
//            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else if AppHelper.maxLength(self.strAvenue, 100) == false{
//            fieldCount = fieldCount + 1
//            cell.lblRequiredAvenue.isHidden = false
//            cell.bottomSpaceAvenue.constant = 30
//            cell.lblRequiredAvenue.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
//            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else {
//            cell.lblRequiredAvenue.isHidden = true
//            cell.bottomSpaceAvenue.constant = 10
//            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
//        }

        if AppHelper.isNull(self.strHouse) == true {
            fieldCount = fieldCount + 1
            cell.lblRequiredHouse.isHidden = false
            cell.lblRequiredHouse.text = "required".setlocalized()
            cell.bottomSpaceHouse.constant = 30
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(self.strHouse, 20) == false {
            fieldCount = fieldCount + 1
            cell.lblRequiredHouse.isHidden = false
            cell.lblRequiredHouse.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.bottomSpaceHouse.constant = 30
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.lblRequiredHouse.isHidden = true
            cell.bottomSpaceHouse.constant = 10
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }

        var isFlootCount = false

        if AddressType == 0
              {
                
              
        }
        else
        {
            if AppHelper.isNull(self.strFloor) == true {
                if isFlootCount == false {
                    fieldCount = fieldCount + 1
                    isFlootCount = true
                }
                cell.lblRequiredFloor.isHidden = false
                cell.lblRequiredFloor.text = "required".setlocalized()
                cell.viewFloor.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else if AppHelper.maxLength(self.strFloor, 20) == false {
                if isFlootCount == false {
                    fieldCount = fieldCount + 1
                    isFlootCount = true
                }
                cell.lblRequiredFloor.isHidden = false
                cell.lblRequiredFloor.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
                cell.viewFloor.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else {
                cell.lblRequiredFloor.isHidden = true
                cell.viewFloor.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            }

            if AppHelper.isNull(self.strBuldingNo) == true {
                if isFlootCount == false {
                    fieldCount = fieldCount + 1
                    isFlootCount = true
                }
                cell.lblRequiredBildingNo.isHidden = false
                cell.lblRequiredBildingNo.text = "required".setlocalized()
                cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else if AppHelper.maxLength(self.strBuldingNo, 20) == false {
                if isFlootCount == false {
                    fieldCount = fieldCount + 1
                    isFlootCount = true
                }
                cell.lblRequiredBildingNo.isHidden = false
                cell.lblRequiredBildingNo.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
                cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
                flag = false
            }
            else {
                cell.lblRequiredBildingNo.isHidden = true
                cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            }
        }
        
//
//        if AppHelper.isNull(self.strLandmark) == true {
//                                 fieldCount = fieldCount + 1
//                                 cell.lblRequiredLandmark.isHidden = false
//                                 cell.lblRequiredLandmark.text = "required".setlocalized()
//                                // cell.bottomSpaceHouse.constant = 30
//                                 cell.viewLandMark.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//                                 flag = false
//                             }
//                             else if AppHelper.maxLength(self.strLandmark, 20) == false {
//                                 fieldCount = fieldCount + 1
//                                 cell.lblRequiredLandmark.isHidden = false
//                                 cell.lblRequiredLandmark.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
//                                // cell.bottomSpaceHouse.constant = 30
//                                 cell.viewLandMark.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//                                 flag = false
//                             }
//                             else {
//                                 cell.lblRequiredLandmark.isHidden = true
//                               //  cell.bottomSpaceHouse.constant = 10
//                                 cell.viewLandMark.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
//                             }
        
        print(fieldCount)
        
        if flag == false {
            cellHeight = CGFloat(fieldCount * 20)
            self.tblAddNewAddress.reloadData()
            self.tblAddNewAddress.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        else {
            var param = ""
            
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let cLanguageId = "1"
            let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String

            if strBlock != "" {
                self.completeAddress.append("\(strBlock)")
            }
            
            if strBuldingNo != "" {
                self.completeAddress.append("-\(strBuldingNo)")
            }
            
            if strFloor != "" {
                if self.completeAddress != "" {
                    self.completeAddress.append(", \(strFloor)")
                }
                else {
                    self.completeAddress.append("\(strFloor)")
                }
            }
            
            if strHouse != "" {
                if self.completeAddress != "" {
                    self.completeAddress.append(", \(strHouse)")
                }
                else {
                    self.completeAddress.append("\(strHouse)")
                }
            }
            
            if strStreet != "" {
                if self.completeAddress != "" {
                    self.completeAddress.append(", \(strStreet)")
                }
                else {
                    self.completeAddress.append("\(strStreet)")
                }
            }
            
            if strAvenue != "" {
                if self.completeAddress != "" {
                    self.completeAddress.append(", \(strAvenue)")
                }
                else {
                    self.completeAddress.append("\(strAvenue)")
                }
            }
            
            if net.isReachable == false {
                let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                

                if AddressType == 0 
                {
                    if nAddressId != "" {
                        param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&nAddressId=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kUpdateAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strHouse,self.strFloor,self.strBuldingNo,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.nAddressId,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,"","",Type)
                    }
                    else {
                        param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strHouse,self.strFloor,self.strBuldingNo,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,"","",Type)
                    }
                                   
            }
            else if AddressType == 1 || AddressType == 3
               {
                   if nAddressId != "" {
                       param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&nAddressId=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kUpdateAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,"",self.strFloor,"",self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.nAddressId,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,self.strHouse,self.strBuldingNo,Type)
                   }
                   else {
                       param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,"",self.strFloor,"",self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,self.strHouse,self.strBuldingNo,Type)
                   }
               }
               else
               {
                 if nAddressId != "" {
                      param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&nAddressId=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kUpdateAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strBuldingNo,self.strFloor,self.strHouse,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.nAddressId,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,"","",Type)
                  }
                  else {
                      param = String(format: "%@?cName=%@&cBlock=%@&cStreet=%@&cAvenue=%@&cHouse=%@&cFloor=%@&cBuildingNuber=%@&cAddress=%@&cMobileNo=%@&nCustomerId=%@&nUserId=%@&nLanguageId=%@&cToken=%@&cAlternateMobileNo=%@&Governorate=%@&Area=%@&cSpecialInstruction=%@&cLandmark=%@&cBuildingName=%@&cOfficeName=%@&cAddressType=%@", kAddNewAddress,self.strName,self.strBlock,self.strStreet,self.strAvenue,self.strBuldingNo,self.strFloor,self.strHouse,self.completeAddress,"\(self.strMobileNo)","\(nCustomerId)","\(nUserId)",cLanguageId,cToken,self.strAlternateNo,strSelectgovernet,nAreaId,strSpecialInstruction,self.strLandmark,"","",Type)
                  }
               }
                
                
              
                
                print(param)
                
                let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                
                AppHelper.showLoadingView()
                self.objAddNewAddress = HttpWrapper.init()
                self.objAddNewAddress.delegate = self
                self.objAddNewAddress.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
            }
            
        }
    }
    
    // MARK: - Custom Method
    
    func getAddressDetails() {
        var param:String = ""
        
        let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
        let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
        
        param = String(format: "%@?nUserId=%@&cToken=%@&nAddressId=%@", kGetAddressDetail,"\(nUserId)",cToken,nAddressId)
        
        print(param)
        
        let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        AppHelper.showLoadingView()
        self.objEditAddress = HttpWrapper.init()
        self.objEditAddress.delegate = self
        self.objEditAddress.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        if isEdit == true {
            lblTitle.text = "lbl_edit_address_title".setlocalized()
        }
        else {
            lblTitle.text = "lbl_new_address_title".setlocalized()
        }
        
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
    
    
   
    // MARK: - UITableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewAddressCell") as! AddNewAddressCell
        
//        cell.viewName.layer.cornerRadius = 20
//        cell.viewName.layer.borderWidth = 1
        cell.delegate = self
        if isVerify == false {
            cell.viewSelectGovernate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewAlternateNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewMobileNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewBlock.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewHouse.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewFloor.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewBildingNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            cell.viewLandMark.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            isVerify = true
        }
        
        if AddressType == 0
        {
            cell.ViewFloorHeight.constant = 0
            cell.viewBuildingNoHeight.constant = 0
            cell.viewFloor.isHidden = true
            cell.viewBildingNo.isHidden = true
            
            cell.viewHouse.clipsToBounds = true
            cell.txtHouse.placeholder = "lbl_new_address_placeholder_HouseNumber".setlocalized()
            cell.viewBildingNo.clipsToBounds = true
                   cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_bulding_no".setlocalized()
        }
        else if AddressType == 1 || AddressType == 3
        {
            cell.ViewFloorHeight.constant = 40
            cell.viewBuildingNoHeight.constant = 40
            cell.viewFloor.isHidden = false
            cell.viewBildingNo.isHidden = false
                   
            cell.viewHouse.clipsToBounds = true
            cell.txtHouse.placeholder = "lbl_new_address_placeholder_BuildingName".setlocalized()
            cell.viewBildingNo.clipsToBounds = true
            cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_OfficeName".setlocalized()
        }
        else
        {
            cell.ViewFloorHeight.constant = 40
            cell.viewBuildingNoHeight.constant = 40
            cell.viewFloor.isHidden = false
            cell.viewBildingNo.isHidden = false
            
            cell.viewHouse.clipsToBounds = true
            cell.txtHouse.placeholder = "lbl_new_address_placeholder_BuildingNumber".setlocalized()
            cell.viewBildingNo.clipsToBounds = true
            cell.txtBildingNo.placeholder = "lbl_new_address_placeholder_AparmentNumber".setlocalized()
           
        }
        
        
        
        cell.viewLandMark.clipsToBounds = true
        cell.txtLandmark.placeholder = "lbl_new_address_placeholder_Landmark".setlocalized()
        
        cell.viewName.clipsToBounds = true
        cell.txtName.placeholder = "lbl_new_address_placeholder_name".setlocalized()

//        cell.viewAlternateNo.layer.cornerRadius = 20
//        cell.viewAlternateNo.layer.borderWidth = 1
//
//        cell.viewSelectGovernate.layer.cornerRadius = 20
//        cell.viewSelectGovernate.layer.borderWidth = 1
        
        cell.viewSelectGovernate.clipsToBounds = true
        cell.txtSelectGovernate.placeholder = "lbl_new_address_placeholder_select_governorate".setlocalized()
        
        cell.viewAlternateNo.clipsToBounds = true
        cell.txtAlternateNo.placeholder = "lbl_new_address_placeholder_alertnate_no".setlocalized()
        
//        cell.viewSelectArea.layer.cornerRadius = 20
//        cell.viewSelectArea.layer.borderWidth = 1
        
        cell.viewSelectArea.clipsToBounds = true
        cell.txtSelectArea.placeholder = "lbl_new_address_placeholder_select_area".setlocalized()

//        cell.viewMobileNo.layer.cornerRadius = 20
//        cell.viewMobileNo.layer.borderWidth = 1
        
        cell.viewMobileNo.clipsToBounds = true
        cell.txtMobileNo.placeholder = "lbl_new_address_placeholder_mobile_no".setlocalized()
        
//        cell.viewBlock.layer.cornerRadius = 20
//        cell.viewBlock.layer.borderWidth = 1
        
        cell.viewBlock.clipsToBounds = true
        cell.txtBlock.placeholder = "lbl_new_address_placeholder_block".setlocalized()
        
        cell.viewSpecialInstruction.layer.cornerRadius = 20
        cell.viewSpecialInstruction.layer.borderWidth = 1
         cell.viewSpecialInstruction.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        
//        cell.viewStreet.layer.cornerRadius = 20
//        cell.viewStreet.layer.borderWidth = 1
        
        cell.viewStreet.clipsToBounds = true
        cell.txtStreet.placeholder = "lbl_new_address_placeholder_street".setlocalized()
        
//        cell.viewAvenue.layer.cornerRadius = 20
//        cell.viewAvenue.layer.borderWidth = 1
        
        cell.viewAvenue.clipsToBounds = true
        cell.txtAvenue.placeholder = "lbl_new_address_placeholder_avenue".setlocalized()
        
//        cell.viewHouse.layer.cornerRadius = 20
//        cell.viewHouse.layer.borderWidth = 1
        
        
        
//        cell.viewFloor.layer.cornerRadius = 20
//        cell.viewFloor.layer.borderWidth = 1
        
        cell.viewFloor.clipsToBounds = true
        cell.txtFloor.placeholder = "lbl_new_address_placeholder_floor".setlocalized()
        
//        cell.viewBildingNo.layer.cornerRadius = 20
//        cell.viewBildingNo.layer.borderWidth = 1
        
       
        cell.btnAddAddressNext.backgroundColor = btnBackgroundColor
        cell.btnAddAddressNext.setTitleColor(btnTitleColor, for: .normal)
        cell.btnAddAddressNext.layer.cornerRadius = btnRadius
        cell.btnAddAddressNext.clipsToBounds = true
        cell.btnAddAddressNext.setTitle("lbl_save".setlocalized(), for: .normal)
        
        let addNewAddressTap = MyAddressTap(target: self, action: #selector(saveNewAddress))
        cell.btnAddAddressNext.isUserInteractionEnabled = true
        addNewAddressTap.numberOfTapsRequired = 1
        addNewAddressTap.cell = cell
        cell.btnAddAddressNext.addGestureRecognizer(addNewAddressTap)
        
        let currentLocationTap = MyAddressTap(target: self, action: #selector(currentLocation))
        cell.btnLocation.isUserInteractionEnabled = true
        currentLocationTap.numberOfTapsRequired = 1
        currentLocationTap.cell = cell
        cell.btnLocation.addGestureRecognizer(currentLocationTap)
        
        var cAddress = ""
        if let fullAddress = dicAddressDetails.object(forKey: "cAddress") as? String {
            cAddress = fullAddress
        }
        
        if let cAvenue = dicAddressDetails.object(forKey: "cAvenue") as? String {
            cell.txtAvenue.text = cAvenue
        }
        
    
        if AddressType == 0
        {
//            if let cFloor = dicAddressDetails.object(forKey: "cFloor") as? String {
//                cell.txtFloor.text = cFloor
//            }
    
            if let cHouse = dicAddressDetails.object(forKey: "cHouse") as? String {
                cell.txtHouse.text = cHouse
            }
//            if let cBuildingNumber = dicAddressDetails.object(forKey: "cBuildingNumber") as? String {
//               cell.txtBildingNo.text = cBuildingNumber
//           }
           
        }
        else if AddressType == 1 || AddressType == 3
        {
            if let cHouse = dicAddressDetails.object(forKey: "cBuildingName") as? String {
                cell.txtHouse.text = cHouse
            }
            if let cBuildingNumber = dicAddressDetails.object(forKey: "cOfficeName") as? String {
                cell.txtBildingNo.text = cBuildingNumber
            }
            if let cFloor = dicAddressDetails.object(forKey: "cFloor") as? String {
                           cell.txtFloor.text = cFloor
                       }
        }
        else
        {
            if let cFloor = dicAddressDetails.object(forKey: "cFloor") as? String {
                cell.txtFloor.text = cFloor
            }
       
            if let cHouse = dicAddressDetails.object(forKey: "cHouse") as? String {
                cell.txtBildingNo.text = cHouse
            }
            if let cBuildingNumber = dicAddressDetails.object(forKey: "cBuildingNumber") as? String
            {
                  cell.txtHouse.text = cBuildingNumber
              }
        }
    
        if let cBlock = dicAddressDetails.object(forKey: "cBlock") as? String {
            cell.txtBlock.text = cBlock
        }
        
       if let cBlock = dicAddressDetails.object(forKey: "cLandmark") as? String {
                  cell.txtLandmark.text = cBlock
              }
              
       
        
        if let cSpecialInstruction = dicAddressDetails.object(forKey: "cSpecialInstruction") as? String {
            cell.txtviewSpecialInstruction.text = cSpecialInstruction
        }
        
        
        
        if let cStreet = dicAddressDetails.object(forKey: "cStreet") as? String {
            cell.txtStreet.text = cStreet
        }
        
        if let cName = dicAddressDetails.object(forKey: "cName") as? String {
            cell.txtName.text = cName
        }
        
        if let cName = dicAddressDetails.object(forKey: "cAreaName") as? String {
                   cell.txtSelectArea.text = cName
               }
        
        
        if let cName = dicAddressDetails.object(forKey: "cCityName") as? String {
                   cell.txtSelectGovernate.text = cName
               }
        
        if let cMobileNo = dicAddressDetails.object(forKey: "cMobileNo") as? String {
            cell.txtMobileNo.text = cMobileNo
        }
        
        if let cAlternateMobileNo = dicAddressDetails.object(forKey: "cAlternateMobileNo") as? String {
            cell.txtAlternateNo.text = cAlternateMobileNo
        }
        selectedIndexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(cellHeight)
        return 750 + cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objAddNewAddress {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                UserDefaults.standard.set(dicsResponse.object(forKey: "Message") as! String, forKey: kisMessage)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                AppHelper.showMessage(view:self.view, message: dicsResponse.object(forKey: "Message") as! String)
            }
        }
        else {
            print(dicsResponse)
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1"  {
                self.dicAddressDetails = (dicsResponse.object(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                
                if let type = dicAddressDetails.object(forKey: "cAddressType") as? String
                {
                    if type.uppercased() == "Home".uppercased()
                    {
                        segHeader.selectedSegmentIndex = 0
                        AddressType = 0
                    }
                    else if type.uppercased() == "Office".uppercased()
                    {
                        segHeader.selectedSegmentIndex = 1
                        AddressType = 1
                    }
                        else if type.uppercased() == "tailor".uppercased()
                        {
                            segHeader.selectedSegmentIndex = 3
                            AddressType = 3
                        }
                    else
                    {
                        segHeader.selectedSegmentIndex = 2
                        AddressType = 2
                    }
                    
                }
                if let value = dicAddressDetails.object(forKey: "nAreaId") as? NSNumber {
                                        nAreaId = "\(value)"
                                    }
                      
                      
                      if let value = dicAddressDetails.object(forKey: "nCityId") as? NSNumber {
                                       nCityId = "\(value)"
                                    }
                self.tblAddNewAddress.reloadData()
            }
            else {
                AppHelper.showMessage(view:self.view, message: dicsResponse.object(forKey: "Message") as! String)
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        AppHelper.hideLoadingView()
        AppHelper.showAlert("Error", message: error.localizedDescription)
    }
    
    // MARK:- Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getAddressFromLatLon(pdblLatitude:"\(locValue.latitude)" , withLongitude: "\(locValue.longitude)")
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var sub_address:String = ""
                    
                    if pm.subThoroughfare != nil {
                        sub_address += pm.subThoroughfare!
                        print(pm.subThoroughfare!)
                    }
                    if pm.thoroughfare != nil {
                        sub_address += pm.thoroughfare!
                        print(pm.thoroughfare!)
                    }
                    
                    self.subaddress = sub_address
                    

                    if pm.subLocality != nil {
                        self.subLocality = pm.subLocality!
                        print(pm.subLocality!)
                    }

                    if pm.subAdministrativeArea != nil {
                        self.subAdministrativeArea = pm.subAdministrativeArea!
                        print(pm.subAdministrativeArea!)
                    }

                    if pm.administrativeArea != nil {
                        self.administrativeArea = pm.administrativeArea!
                        print(pm.administrativeArea!)
                    }

                    if pm.postalCode != nil {
                        self.postalCode = pm.postalCode!
                        print(pm.postalCode!)
                    }

                    if pm.country != nil {
                        self.country = pm.country!
                        print(pm.country!)
                    }
                    
                    self.addressCell.txtStreet.text = self.subaddress
                    if self.subaddress != "" {
                        self.addressCell.lblRequiredAvenue.isHidden = true
                        self.addressCell.bottomSpaceAvenue.constant = 10
                        self.addressCell.viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                    }
                    
                    self.addressCell.txtAvenue.text = " \(self.administrativeArea), \(self.country)"
                    if self.administrativeArea != "" || self.country != "" {
                        self.addressCell.lblRequiredStreet.isHidden = true
                        self.addressCell.bottomSpaceStreet.constant = 10
                        self.addressCell.viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                    }
                }
        })
        
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
class MyAddressTap: UITapGestureRecognizer {
    var cell = AddNewAddressCell()
}
