//
//  CartCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import iOSDropDown

protocol UnitSelectInCartDelegate {
    func onSelectUnit(value:Float,index:IndexPath)
    
}
class CartDetailsCell: UITableViewCell ,UIPickerViewDelegate,UIPickerViewDataSource{

    // MARK: - IBOutlets
    
    @IBOutlet weak var imgFeelit2: UIImageView!
    @IBOutlet weak var imgFeelit: UIImageView!
    @IBOutlet weak var viewDropDown: UIView!
    var delegateUnit:UnitSelectInCartDelegate?
   @IBOutlet weak var lblOutofStock: UILabel!
       @IBOutlet weak var txtSelectSize: UITextField!
    @IBOutlet weak var viewProductDetails: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var viewCartCount: UIView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var txtCounter: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstant: NSLayoutConstraint!
    var isSampel = false
    var iswish = false
    var selectedstock = 0
    var strunit = String()
    var stockQnty = 0
    var nCartType = 0
    
    
    var arrvalue:[String] = [String]()
    var nUnitType = 1
    var minstockQnty = 0
    var indexpath = IndexPath()
    var selectedqty:Float = 1.00
    var FinelFloatValue = Float()
    var spinFuelAmount: UIPickerView = UIPickerView()
         var mileageToPass: String!

         var fuelAmount: Double = 0.00

         var pickerData = [[String]]()
   var arrunitName = ["","checkout_quantity".setlocalized(),"lbl_select_kg_placeholcer".setlocalized(),"lbl_seelct_meter_placeholder".setlocalized()]
     var arrunitName1 = ["","checkout_quantity".setlocalized(),"lbl_kilograms".setlocalized(),"lbl_Meter".setlocalized()]
      // MARK: - TableviewCell Methods
      func loadData()
      {
        if minstockQnty > 0
        {
            FinelFloatValue = Float(minstockQnty)
        }
txtSelectSize.placeholder = arrunitName[nUnitType]
        spinFuelAmount = UIPickerView(frame: CGRect(x: 0, y: 200, width: UIScreen().bounds.size.width, height: 300))
               spinFuelAmount.backgroundColor = .white

               spinFuelAmount.showsSelectionIndicator = true
               spinFuelAmount.delegate = self
               spinFuelAmount.dataSource = self

        
        // Toolbar
          // let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePicker))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let btnDone = UIBarButtonItem(title: "lbl_ProductDetail_Spinner_Select".setlocalized(), style: .plain, target: self, action: #selector(self.donePicker))
           let cancelButton = UIBarButtonItem(title: "lbl_ProductDetail_Spinner_Cencel".setlocalized(), style: .plain, target: self, action: #selector(self.Cancel))

           let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: spinFuelAmount.frame.width, height: 44))
           barAccessory.barStyle = .default
           barAccessory.isTranslucent = false
           barAccessory.items = [cancelButton, spaceButton, btnDone]
        txtSelectSize.inputAccessoryView = barAccessory
          // spinFuelAmount.addSubview(barAccessory)
        
              
               
               
               // Image Array its optional
               // txtExpenceType.ImageArray = [👩🏻‍🦳,🙊,🥞]
               // The the Closure returns Selected Index and String
       //        txtSelectSize.placeholder = "Select \(strunit)"
       //        txtSelectSize.selectedRowColor = ColorLightgray
       //        txtSelectSize.font = UIFont(name: RalewayRegular, size: 15)
       //        txtSelectSize.selectedIndex = 0
       //        self.txtSelectSize.delegate = self
       //        txtSelectSize.didSelect{(selectedText , index ,id) in
       //
       //            print(index)
       //            self.txtCartCounter.text = "\(index + 1)"
       //            self.delegateUnit?.onSelectUnit(value: index+1)
       //          //  self.endTimeselectedIndex = index
       //
       //            //            if let id = (self.arrExpensetypeList.object(at: index) as! NSDictionary).value(forKey: "nExpenceTypeId") as? String
       //            //            {
       //            //                self.strexpenseTypeID = id
       //            //            }
       //            //            else if let id = (self.arrExpensetypeList.object(at: index) as! NSDictionary).value(forKey: "nExpenceTypeId") as? NSNumber
       //            //            {
       //            //                self.strexpenseTypeID = "\(id)"
       //            //            }
       //            //
       //            //            print(self.strexpenseTypeID,selectedText)
       //            // self.txtExpenceType.text = "Selected String: \(selectedText) \n index: \(index)"
       //        }
             
               // Initialization code
               var poundValues = [String]()
                      var penceValues = [String]()
       
         penceValues = ["00","25","50","75"]
       if nUnitType == 2
       {
           for indexP in 0...stockQnty
           {
               
                if indexP > 0
                 {
                      if indexP >= minstockQnty
                                          {
                                              poundValues.append("\(indexP)")
                                          }
                 }
             }
           
//           for indexP in 0...100
//           {
//                 penceValues.append("\(indexP)")
//                // penceValues.append(indexP)
//             }
       }
       else
       {
           for indexP in 0...stockQnty
           {
                // poundValues.append(indexP)
                 if indexP > 0
                 {
                      if indexP >= minstockQnty
                                          {
                                              poundValues.append("\(indexP)")
                                          }
                 }
             }
           
//           for indexP in 0...100
//           {
//               let value = String(format: "%02d", indexP)
//
//                 penceValues.append(value)
//                // penceValues.append(indexP)
//             }
       }
                   

               self.pickerData = [poundValues, penceValues]

                      spinFuelAmount.delegate = self
                      spinFuelAmount.dataSource = self
               txtSelectSize.inputView = spinFuelAmount
               
        
         
      }
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        
//               txtSelectSize.selectedRowColor = ColorLightgray
//               txtSelectSize.font = UIFont(name: RalewayRegular, size: 15)
//              // txtSelectSize.selectedIndex = 0
//               txtSelectSize.didSelect{(selectedText , index ,id) in
//
//                   print(index)
//                 //  self.txtCartCounter.text = "\(index + 1)"
//                self.delegateUnit?.onSelectUnit(value: index+1, index: self.indexpath)
//                 //  self.endTimeselectedIndex = index
//
//                   //            if let id = (self.arrExpensetypeList.object(at: index) as! NSDictionary).value(forKey: "nExpenceTypeId") as? String
//                   //            {
//                   //                self.strexpenseTypeID = id
//                   //            }
//                   //            else if let id = (self.arrExpensetypeList.object(at: index) as! NSDictionary).value(forKey: "nExpenceTypeId") as? NSNumber
//                   //            {
//                   //                self.strexpenseTypeID = "\(id)"
//                   //            }
//                   //
//                   //            print(self.strexpenseTypeID,selectedText)
//                   // self.txtExpenceType.text = "Selected String: \(selectedText) \n index: \(index)"
//               }
    }

    
   @objc func donePicker() {

    
            txtSelectSize.resignFirstResponder()
        self.delegateUnit?.onSelectUnit(value: FinelFloatValue, index: self.indexpath)

        }
    @objc func Cancel() {

               txtSelectSize.resignFirstResponder()
          // self.delegateUnit?.onSelectUnit(value: Int(FinelFloatValue), index: self.indexpath)

           }
    
    @IBAction func onClickunit(_ sender: Any) {
           //txtSelectSize.showList()
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension CartDetailsCell
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0
        {
            return pickerData[component].count
        }
        else
        {
            if selectedstock == stockQnty
            {
                 return 1
            }
            else
            {
                 return pickerData[component].count
            }
          
        }
         
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return "\(pickerData[component][row])"
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let firstComponent = pickerData[0][spinFuelAmount.selectedRow(inComponent: 0)]
        let secondComponent = pickerData[1][spinFuelAmount.selectedRow(inComponent: 1)]

        
        selectedstock = Int(firstComponent)!
               
               var fuelAmount =  "\(firstComponent).\(secondComponent)"
               
               if selectedstock == stockQnty
               {
                    fuelAmount =  "\(firstComponent).00"
               }
               else
               {
                    fuelAmount =  "\(firstComponent).\(secondComponent)"
               }
        
      // let fuelAmount =  "\(firstComponent).\(secondComponent)"
        txtSelectSize.text = fuelAmount + " \(arrunitName1[nUnitType])"
        FinelFloatValue = Float(fuelAmount) as! Float
        spinFuelAmount.reloadComponent(1)
      //  self.delegateUnit?.onSelectUnit(value: Int(FinelFloatValue), index: self.indexpath)
        
//         if let firstValue = Int(firstComponent), let secondValue = Int(secondComponent) {
//
//         }
    }
        
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     

            let titleData = pickerData[component][row] //this is bad, you'll have to compute what to do about this, but you get the point
            var myString1 = NSMutableAttributedString(string:"\(titleData)")
            let myString1Font1 = UIFont(name:"AvenirNext-Regular", size:24.0)
            let myString1Color1 = UIColor(red: 0.292745, green: 0.461693, blue: 0.998524, alpha: 1.000000)
            let originalNSString = myString1.string as NSString
            let myString1Range1 = originalNSString.range(of: "\(titleData)")
            var myString1ParaStyle1 = NSMutableParagraphStyle()
            myString1ParaStyle1.baseWritingDirection = NSWritingDirection.natural
            myString1ParaStyle1.lineBreakMode = NSLineBreakMode.byWordWrapping
            myString1.addAttribute(NSAttributedStringKey.underlineColor, value:myString1Color1, range:myString1Range1)
            myString1.addAttribute(NSAttributedStringKey.paragraphStyle, value:myString1ParaStyle1, range:myString1Range1)
            myString1.addAttribute(NSAttributedStringKey.font, value:myString1Font1!, range:myString1Range1)

            if component == 0 {
                myString1ParaStyle1.alignment = NSTextAlignment.center
            } else if component == 1 {
                myString1ParaStyle1.alignment = NSTextAlignment.center
            }

            return myString1
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {

            var pickerLabel = view as! UILabel!
            if view == nil {
                pickerLabel = UILabel()
                let hue = CGFloat(row)/CGFloat(pickerData.count)
                pickerLabel!.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
            }
            let titleData = pickerData[component][row]
            var myString1 = NSMutableAttributedString(string:"\(titleData)")
            let myString1Font1 = UIFont(name:"AvenirNext-Regular", size:24.0)
            let myString1Color1 = UIColor(red: 0.292745, green: 0.461693, blue: 0.998524, alpha: 1.000000)
            let originalNSString = myString1.string as NSString
            let myString1Range1 = originalNSString.range(of: "\(titleData)")
            let myString1ParaStyle1 = NSMutableParagraphStyle()
            myString1ParaStyle1.baseWritingDirection = NSWritingDirection.natural
            myString1ParaStyle1.lineBreakMode = NSLineBreakMode.byWordWrapping
            myString1.addAttribute(NSAttributedStringKey.underlineColor, value:myString1Color1, range:myString1Range1)
            myString1.addAttribute(NSAttributedStringKey.paragraphStyle, value:myString1ParaStyle1, range:myString1Range1)
            myString1.addAttribute(NSAttributedStringKey.font, value:myString1Font1!, range:myString1Range1)
            pickerLabel!.attributedText = myString1

            if component == 0 {
                myString1ParaStyle1.alignment = NSTextAlignment.center
            } else if component == 1 {
                myString1ParaStyle1.alignment = NSTextAlignment.center
            }


            return pickerLabel!
        }
    
}
