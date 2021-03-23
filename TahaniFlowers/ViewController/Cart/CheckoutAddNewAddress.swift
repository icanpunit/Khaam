//
//  CheckoutAddNewAddress.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

protocol GovernetsSelectCartDelegate {
    func onclickselectGovernate(cell:CheckoutAddNewAddress)
    func onclickselectArea(cell:CheckoutAddNewAddress)
}

class CheckoutAddNewAddress: UITableViewCell, UITextFieldDelegate ,UITextViewDelegate{

    // MARK: - IBOutlets

   @IBOutlet weak var viewAddNewAddress: UIView!
    var delegate:GovernetsSelectCartDelegate?
    var myPickerView : UIPickerView!
    var arrAreaList:NSArray = NSArray()
    var pickerData = ["Hitesh Modi" , "Kirit Modi" , "Ganesh Modi" , "Paresh Modi"]
     var arrGovernete = ["Al Asimah Governorate","Hawalli Governorate","Farwaniya Governorate","Mubarak Al-Kabeer Governorate","Ahmadi Governorate","Jahra Governorate"]
    
     @IBOutlet weak var lblRequiredLandmark: UILabel!
    @IBOutlet weak var viewBuildingNoHeight: NSLayoutConstraint!
       @IBOutlet weak var ViewFloorHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceFloar: NSLayoutConstraint!
    @IBOutlet weak var txtLandmark: UITextField!
       @IBOutlet weak var viewLandMark: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewSelectGovernate: UIView!
       @IBOutlet weak var lblRequiredSelectGovernate: UILabel!
       @IBOutlet weak var txtSelectGovernate: UITextField!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewAlternateNo: UIView!
    @IBOutlet weak var txtAlternateNo: UITextField!
    @IBOutlet weak var viewSelectArea: UIView!
    var strSpecialInstruction = "specialInstruction_placeholder".setlocalized()
    @IBOutlet weak var txtviewSpecialInstruction: UITextView!
    @IBOutlet weak var txtSelectArea: UITextField!
    @IBOutlet weak var viewMobileNo: UIView!
    @IBOutlet weak var viewSpecialInstruction: UIView!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var txtBlock: UITextField!
    @IBOutlet weak var viewStreet: UIView!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var viewAvenue: UIView!
    @IBOutlet weak var txtAvenue: UITextField!
    @IBOutlet weak var viewHouse: UIView!
    @IBOutlet weak var txtHouse: UITextField!
    @IBOutlet weak var viewFloor: UIView!
    @IBOutlet weak var txtFloor: UITextField!
    @IBOutlet weak var viewBildingNo: UIView!
    @IBOutlet weak var txtBildingNo: UITextField!
    @IBOutlet weak var lblSaveAddressForFutureUse: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnAddAddressNext: UIButton!
    @IBOutlet weak var viewShippingAddress: UIView!
    @IBOutlet weak var lblShippingAddress: UILabel!
    @IBOutlet weak var viewRoundCircle: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
     var isGuest = false
    @IBOutlet weak var BottomSpaceEmail: NSLayoutConstraint!
    @IBOutlet weak var viewEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceGovernate: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceName: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredName: UILabel!
    @IBOutlet weak var bottomSpaceMobileNo: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredMobileNo: UILabel!
    @IBOutlet weak var bottomSpaceAltMobileNo: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredAltMobileNo: UILabel!
    @IBOutlet weak var bottomSpaceSelectArea: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredSelectArea: UILabel!
    @IBOutlet weak var bottomSpaceBlock: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredBlock: UILabel!
    @IBOutlet weak var bottomSpaceStreet: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredStreet: UILabel!
    @IBOutlet weak var bottomSpaceAvenue: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredAvenue: UILabel!
    @IBOutlet weak var bottomSpaceHouse: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredHouse: UILabel!
    @IBOutlet weak var bottomSpaceFlootAndBuilding: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredFloor: UILabel!
    @IBOutlet weak var lblRequiredBuildingNo: UILabel!
    @IBOutlet weak var lblRequiredEmail: UILabel!
    
    // TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtAlternateNo.delegate = self
        txtSelectArea.delegate = self
        txtSelectGovernate.delegate = self
        txtBildingNo.delegate = self
        txtMobileNo.delegate = self
        txtMobileNo.delegate = self
        txtStreet.delegate = self
        txtAvenue.delegate = self
        txtHouse.delegate = self
        txtFloor.delegate = self
        txtBlock.delegate = self
        txtName.delegate = self
         txtEmail.delegate = self
        txtLandmark.delegate = self
        
        txtviewSpecialInstruction.text = strSpecialInstruction
        txtviewSpecialInstruction.textColor = UIColor.lightGray
        txtviewSpecialInstruction.delegate = self
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtName.textAlignment = .left
            self.txtAlternateNo.textAlignment = .left
            self.txtSelectArea.textAlignment = .left
            self.txtSelectGovernate.textAlignment = .left
            self.txtBildingNo.textAlignment = .left
            self.txtMobileNo.textAlignment = .left
            self.txtStreet.textAlignment = .left
            self.txtAvenue.textAlignment = .left
            self.txtHouse.textAlignment = .left
            self.txtFloor.textAlignment = .left
            self.txtBlock.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtLandmark.textAlignment = .left
        }
        else {
            self.txtName.textAlignment = .right
            self.txtAlternateNo.textAlignment = .right
             self.txtSelectGovernate.textAlignment = .right
            self.txtSelectArea.textAlignment = .right
            self.txtBildingNo.textAlignment = .right
            self.txtMobileNo.textAlignment = .right
            self.txtStreet.textAlignment = .right
            self.txtAvenue.textAlignment = .right
            self.txtHouse.textAlignment = .right
            self.txtFloor.textAlignment = .right
            self.txtBlock.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtLandmark.textAlignment = .right
        }
    }

    
    @IBAction func onClickbtnGovernate(_ sender: Any) {
        
        self.contentView.endEditing(true)
        
        delegate?.onclickselectGovernate(cell: self)
    }
    @IBAction func onClickselectArea(_ sender: Any) {
        
        self.contentView.endEditing(true)
                   if AppHelper.isNull(self.txtSelectGovernate.text!) == true
                              {
                                  AppHelper.showAlert("Error", message: "PleaseSelectGovernet".setlocalized())
                                  }
                              else
                                     {
                                     delegate?.onclickselectArea(cell: self)
                              }
        
    }
    
    // MARK: - textfield Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        if textField == txtName
        {
             lblRequiredName.isHidden = true
             BottomSpaceEmail.constant = 10
             viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        else if textField == txtEmail
        {
            if isGuest == true
            {
             lblRequiredEmail.isHidden = true
             bottomSpaceName.constant = 10
             viewName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            }
          
        }
            
        else if textField == txtBlock
        {
            lblRequiredBlock.isHidden = true
            bottomSpaceBlock.constant = 10
            viewBlock.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
            else if textField == txtSelectGovernate
                   {
                        lblRequiredSelectGovernate.isHidden = true
                        bottomSpaceGovernate.constant = 10
                        viewSelectGovernate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                       textField.endEditing(true)
                       delegate?.onclickselectGovernate(cell: self)
                   }
                   else if textField == txtSelectArea
                      {
                           lblRequiredSelectArea.isHidden = true
                           bottomSpaceSelectArea.constant = 10
                           viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
                          textField.endEditing(true)
                       
                       if AppHelper.isNull(self.txtSelectGovernate.text!) == true
                                  {
                                      AppHelper.showAlert("Error", message: "PleaseSelectGovernet".setlocalized())
                                      }
                                  else
                                         {
                                         delegate?.onclickselectArea(cell: self)
                                  }
                          
                      }
        else if textField == txtFloor
        {
            
            if lblRequiredBuildingNo.isHidden == true {
                bottomSpaceFloar.constant = 10
            }
            bottomSpaceFloar.constant = 10
            viewFloor.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            lblRequiredFloor.isHidden = true
        }
        else if textField == txtHouse
        {
             lblRequiredHouse.isHidden = true
             bottomSpaceHouse.constant = 10
             viewHouse.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        else if textField == txtAvenue
        {
             lblRequiredAvenue.isHidden = true
             bottomSpaceAvenue.constant = 10
             viewAvenue.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }else if textField == txtStreet
        {
             lblRequiredStreet.isHidden = true
             bottomSpaceStreet.constant = 10
             viewStreet.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }else if textField == txtMobileNo
        {
             lblRequiredMobileNo.isHidden = true
             bottomSpaceMobileNo.constant = 10
             viewMobileNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }
        else if textField == txtBildingNo
        {
            if lblRequiredFloor.isHidden == true {
                bottomSpaceFloar.constant = 10
            }
            viewBildingNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
            lblRequiredBuildingNo.isHidden = true
        }
        else if textField == txtSelectArea
        {
             lblRequiredSelectArea.isHidden = true
             bottomSpaceSelectArea.constant = 10
             viewSelectArea.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }else if textField == txtAlternateNo
        {
             lblRequiredAltMobileNo.isHidden = true
             bottomSpaceAltMobileNo.constant = 10
             viewAlternateNo.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }else if textField == txtLandmark
        {
             lblRequiredLandmark.isHidden = true
            // bottomSpaceAltMobileNo.constant = 10
             viewLandMark.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if textField == txtName || textField == txtSelectArea || textField == txtBlock || textField == txtHouse || textField == txtFloor || textField == txtBildingNo  {
            if str.count >= 0 && str.count <= 20 {
                return true
            }
            else {
                return false
            }
        }
        else if  textField == txtStreet || textField == txtAvenue {
            if str.count >= 0 && str.count <= 50 {
                return true
            }
            else {
                return false
            }
        }
        else if textField == txtMobileNo || textField == txtAlternateNo {
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
    
    
    //MARK:- textview Delegate
       func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == UIColor.lightGray {
               textView.text = nil
               textView.textColor = UIColor.black
           }
       }
       
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           let str = (textView.text! + text)
            if textView == txtviewSpecialInstruction  {
               if str.count >= 0 && str.count <= 200 {
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
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = strSpecialInstruction
               textView.textColor = UIColor.lightGray
           }
       }
       
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
