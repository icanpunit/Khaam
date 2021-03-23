//
//  ProductDetailsImageCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import iOSDropDown
enum ImageItem {
    case bitmap(UIImage)
    case url(URL, placeholder: UIImage?)
}


protocol ShowimageDelegate {
    func OnclickShowImage(cell:ProducDetailsImageCollectionCell)
}


protocol UnitSelectDelegate {
    func onSelectUnit(value:Float)
    
}
class ProductDetailsImageCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate ,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
   var timer:Timer = Timer()
    var index = 0
    var isLoadFirstTime:Bool = true
    var isScroll = false
    let view1 = UIView()
    @IBOutlet weak var viewDropDown: UIView!
    @IBOutlet weak var txtSelectSize: UITextField!
    // MARK: - IBOutlets
     var delegate:ShowimageDelegate?
    var selectedstock = 0
    var delegateUnit:UnitSelectDelegate?
    var strunit = String()
    var addType:Int = Int()
     var stockQnty = 0
    var minstockQnty = 0
    @IBOutlet weak var lblVendorName: UILabel!
    var FinelFloatValue = Float()
    var arrunitName = ["","checkout_quantity".setlocalized(),"lbl_select_kg_placeholcer".setlocalized(),"lbl_seelct_meter_placeholder".setlocalized()]
     var arrunitName1 = ["","checkout_quantity".setlocalized(),"lbl_kilograms".setlocalized(),"lbl_Meter".setlocalized()]
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var productImageCollection: UICollectionView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var viewProductNameHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCartCount: UIView!
       @IBOutlet weak var btnPlus: UIButton!
       @IBOutlet weak var btnMinus: UIButton!
       @IBOutlet weak var txtCartCounter: UITextField!
    // MARK: - Variables
   
    var spinFuelAmount: UIPickerView = UIPickerView()
       var mileageToPass: String!

       var fuelAmount: Double = 0.00

       var pickerData = [[String]]()
    var urlImage:String = ""
    
    var imageItems:NSArray = NSArray()
     var arrvalue:[String] = [String]()
    
    // MARK: - TableviewCell Methods
    func loadData()
    {
        
      txtSelectSize.placeholder = arrunitName[addType]
         spinFuelAmount = UIPickerView(frame: CGRect(x: 0, y: 200, width: UIScreen().bounds.size.width, height: 300))
                spinFuelAmount.backgroundColor = .white

                spinFuelAmount.showsSelectionIndicator = true
                spinFuelAmount.delegate = self
                spinFuelAmount.dataSource = self

                // Toolbar
                         // let btnDone = UIBarButtonItem(barButtonSystemItem: "lbl_ProductDetail_Spinner_Select".setlocalized(), target: self, action: #selector(self.donePicker))
                          let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let btnDone = UIBarButtonItem(title: "lbl_ProductDetail_Spinner_Select".setlocalized(), style: .plain, target: self, action: #selector(self.donePicker))
        let cancelButton = UIBarButtonItem(title: "lbl_ProductDetail_Spinner_Cencel".setlocalized(), style: .plain, target: self, action: #selector(self.Cancel))

                          let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: spinFuelAmount.frame.width, height: 44))
                          barAccessory.barStyle = .default
                          barAccessory.isTranslucent = false
                          barAccessory.items = [cancelButton, spaceButton, btnDone]
                         // spinFuelAmount.addSubview(barAccessory)
                 txtSelectSize.inputAccessoryView = barAccessory
                
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
        if addType == 2
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
            
//            for indexP in 0...100
//            {
//                  penceValues.append("\(indexP)")
//                 // penceValues.append(indexP)
//              }
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
            
//            for indexP in 0...100
//            {
//                let value = String(format: "%02d", indexP)
//
//                  penceValues.append(value)
//                 // penceValues.append(indexP)
//              }
        }
                    

                self.pickerData = [poundValues, penceValues]

                       spinFuelAmount.delegate = self
                       spinFuelAmount.dataSource = self
                txtSelectSize.inputView = spinFuelAmount
        
       // self.txtSelectSize.optionArray = arrvalue
        
//        if arrvalue.count > 0
//        {
//             self.txtSelectSize.text = arrvalue[0]
//        }
       
    }
    
    func setupTap() {
        let touchDown = UILongPressGestureRecognizer(target:self, action: #selector(didTouchDown))
        touchDown.minimumPressDuration = 2
        view1.addGestureRecognizer(touchDown)
    }

    @objc func didTouchDown(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            print("end")
           
            
            timer.invalidate()
            print("start")
        }
       else if gesture.state == .ended {
            print("end")
            self.addTimer()
        }
        else
        {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
       view1.frame = UIScreen.main.bounds
              view1.backgroundColor = UIColor.clear
              contentView.addSubview(view1)
        contentView.bringSubview(toFront: viewTop)
             self.addTimer()
              self.productImageCollection.delegate = self
              self.productImageCollection.dataSource = self
              setupTap()
              //------------right  swipe gestures in collectionView--------------//
              
              let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
              if currentLanguage == "en" {
                  let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwiped))
                  swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                  view1.addGestureRecognizer(swipeRight)
                  
                  //-----------left swipe gestures in collectionView--------------//
                  let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwiped))
                  swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                  view1.addGestureRecognizer(swipeLeft)
              }
              else
              {
                  let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwiped))
                  swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                  view1.addGestureRecognizer(swipeRight)
                  
                  //-----------left swipe gestures in collectionView--------------//
                  let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwiped))
                  swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                  view1.addGestureRecognizer(swipeLeft)
              }
              
              view1.tag = 10
              let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductCategory))
              openProductGesture.numberOfTapsRequired = 1
              view1.isUserInteractionEnabled = true
             
              view1.addGestureRecognizer(openProductGesture)
        
    }

  @objc func donePicker() {

           txtSelectSize.resignFirstResponder()
    
    if (txtSelectSize.text!.count > 0)
    {
        
    }
    else
    {
         var fuelAmount =  "1.00"
        if minstockQnty > 0
        {
            fuelAmount =  "\(minstockQnty).00"
        }
        else
        {
            
        }
       
               txtSelectSize.text = fuelAmount + " \(arrunitName1[addType])"
               FinelFloatValue = Float(fuelAmount) as! Float
    }
      // self.delegateUnit?.onSelectUnit(value: Int(FinelFloatValue), index: self.indexpath)

    self.delegateUnit?.onSelectUnit(value: FinelFloatValue)
       }
   @objc func Cancel() {

              txtSelectSize.resignFirstResponder()
         // self.delegateUnit?.onSelectUnit(value: Int(FinelFloatValue), index: self.indexpath)

          }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let dotString = "."

          if let text = textField.text {
              let isDeleteKey = string.isEmpty

              if !isDeleteKey {
                  if text.contains(dotString) {
                      if text.components(separatedBy: dotString)[1].count == 2 {

                                  return false

                      }

                  }

              }
          }
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onClickunit(_ sender: Any) {
        txtSelectSize.resignFirstResponder()
       // txtSelectSize.showList()
    }
    func roundCorners(cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    // MARK: - Collectionview Datasource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProducDetailsImageCollectionCell", for: indexPath) as! ProducDetailsImageCollectionCell
        
        
        if let url = (imageItems.object(at: indexPath.row) as! NSDictionary).value(forKey: "Image") as? String
        {
            if url != "" {
                cell.imgProduct.cacheImage(urlString: url)
                //cell.imgProduct.contentMode = .scaleAspectFit
            }
            else {
                cell.imgProduct.image = UIImage(named: "ic_product_image")
            }
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
               
               let cell:ProducDetailsImageCollectionCell = collectionView.cellForItem(at: indexPath) as! ProducDetailsImageCollectionCell
               
               delegate?.OnclickShowImage(cell: cell)
           }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
      
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
            if indexPath.row == 0
            {
                 view1.isHidden = false
                
            }
            else if indexPath.row == imageItems.count-1
            {
                view1.isHidden = false
            }
            else
            {
                view1.isHidden = true
            }
            print(indexPath.row)
        }
        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            print(indexPath.row)
            
           
            if isScroll == false
            {
                
           
    //        if indexPath.row == self.imageItems.count{
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0),at: .left, animated: false)
    //
    //                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
    //                if currentLanguage == "en" {
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0),at: .left, animated: false)
    //                }
    //                else{
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0),at: .right, animated: false)
    //                }
    //
    //            }
    //        }
            }
            else
            {
                isScroll = false
                
            }
        }
     @objc func rightSwiped()
        {
            timer.invalidate()
            addTimer()
            print("right swiped ")
            let index = productImageCollection.indexPathsForVisibleItems.last
            
            print("left",index?.row)
            if index?.row == 0
            {
                print(imageItems.count-1)
                // productImageCollection.reloadData()
                
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                if currentLanguage == "en" {
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: imageItems.count-1, section: 0), at: .left, animated: false)
                    
                }
                else{
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: imageItems.count-1, section: 0), at: .right, animated: false)
                }
            }
            else if index?.row == imageItems.count-1
            {
                
                productImageCollection.reloadData()
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                if currentLanguage == "en" {
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: imageItems.count-2, section: 0), at: .right, animated: true)
                }
                else{
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: imageItems.count-2, section: 0), at: .right, animated: true)
                }
            }
        }
        
        @objc func leftSwiped()
        {
            timer.invalidate()
            addTimer()
            print("left swiped ")
            let index = productImageCollection.indexPathsForVisibleItems.last
            print("right",index?.row)

            if index?.row == imageItems.count-1
            {

                productImageCollection.reloadData()
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                if currentLanguage == "en" {
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
                }
                else{
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
                }
            }
            else if index?.row == 0
            {
                print(imageItems.count-1)
                // productImageCollection.reloadData()
                
                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                if currentLanguage == "en" {
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 1, section: 0), at: .left, animated: true)
                    
                }
                else{
                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: true)
                }
            }
            
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            
    //        isScroll = true
    //       // productImageCollection.collectionViewLayout.invalidateLayout()
    //
    //        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
    //
    //           let index = productImageCollection.indexPathsForVisibleItems.last
    //            // productImageCollection.reloadData()
    //
    //            print("left",index?.row)
    //            if index?.row == 0
    //            {
    //                print(imageItems.count-1)
    //                productImageCollection.reloadData()
    //
    //                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
    //                if currentLanguage == "en" {
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: imageItems.count, section: 0), at: .left, animated: false)
    //
    //                }
    //                else{
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: imageItems.count, section: 0), at: .right, animated: false)
    //                }
    //            }
    //
    //        } else {
    //            let index = productImageCollection.indexPathsForVisibleItems.last
    //            print("right",index?.row)
    //
    //            if index?.row == imageItems.count-1
    //            {
    //
    //                productImageCollection.reloadData()
    //                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
    //                if currentLanguage == "en" {
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
    //                }
    //                else{
    //                    self.productImageCollection?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
    //                }
    //            }
    //        }
    //        let current = productImageCollection.indexPathsForVisibleItems
        }
        
        func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
            // Cancel any in-flight requests for data for the specified index paths.
            
        }
    func addTimer(){
          // timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
       }
       
       @objc func nextPage(){
           let current = productImageCollection.indexPathsForVisibleItems
           
           if current.count > 0
           {
              
               if imageItems.count + 1 > 0 {
                   
                   index = ((current.last)?.row)!
                   
                   if index == self.imageItems.count {
                       index = ((current.last)?.row)! - 1
                   }
                   
                   if index == imageItems.count - 1 {
                       index = 0
                       let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                       if currentLanguage == "en" {
                           self.productImageCollection?.scrollToItem(at:IndexPath(item: index, section: 0), at: .left, animated: false)
                       }
                       else{
                           self.productImageCollection?.scrollToItem(at:IndexPath(item: index, section: 0), at: .right, animated: false)
                       }
                       
                   }
                   else {
                       index = index + 1
                       let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                       if currentLanguage == "en" {
                           self.productImageCollection?.scrollToItem(at:IndexPath(item: index, section: 0), at: .left, animated: true)
                       }
                       else{
                           self.productImageCollection?.scrollToItem(at:IndexPath(item: index, section: 0), at: .right, animated: true)
                       }
                   }
               }
           }
       }
    
    
     @objc func gotoProductCategory(sender:UITapGestureRecognizer){
            
            
          //  let index = sender.view?.tag
            let index = productImageCollection.indexPathsForVisibleItems.last
        let cell:ProducDetailsImageCollectionCell = productImageCollection.cellForItem(at: index!) as! ProducDetailsImageCollectionCell
        
        delegate?.OnclickShowImage(cell: cell)
    //        if index == 10
    //        {
    //
    //        }
    //        else
    //        {
    //
    //        }
           
           
        }
    // MARK: - @objc Methods
    
    // MARK: - Custom Methods

}
extension ProductDetailsImageCell
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
        
       
        txtSelectSize.text = fuelAmount + " \(arrunitName1[addType])"
        FinelFloatValue = Float(fuelAmount) as! Float
        spinFuelAmount.reloadComponent(1)
        self.delegateUnit?.onSelectUnit(value: FinelFloatValue)

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
