//
//  FilterSlider_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 16/08/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

import SwiftRangeSlider
class FilterSlider_Cell: UITableViewCell {

    @IBOutlet weak var lblMinPriceTop: UILabel!
    @IBOutlet weak var lblMaxPriceTop: UILabel!
    @IBOutlet weak var lblMinPrice: UILabel!
    @IBOutlet weak var lblMaxPrice: UILabel!
    
    @IBOutlet weak var sliderWidthConstant: NSLayoutConstraint!
    var min:Float = Float()
     var max:Float = Float()
     var Smin:Float = Float()
     var Smax:Float = Float()
     var Finelmax:Float = Float()
    var selectedmin:Float = Float()
    var selectedmax:Float = Float()
    var isprice:Bool = Bool()
   var isUpdate:Bool = Bool()
    var Data:NSDictionary = NSDictionary()
    var index = IndexPath()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var RangeSliderCurrency: RangeSlider!
     let size = UIScreen().bounds.width
    var nAttributeId = ""
    var cAttributeType = ""
    
    var delegate: CallApiFilterDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        RangeSliderCurrency.layoutSubviews()
         self.RangeSliderCurrency.updateLayerFramesAndPositions()
        
        lblMinPriceTop.text = "lbl_FilterSlider_min".setlocalized()
        lblMaxPriceTop.text = "lbl_FilterSlider_max".setlocalized()
       // RangeSliderCurrency.frame = CGRect(x: RangeSliderCurrency.frame.origin.x, y: RangeSliderCurrency.frame.origin.y, width: size-20, height: RangeSliderCurrency.frame.height)
        // Initialization code
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
         RangeSliderCurrency.layoutIfNeeded()
        self.RangeSliderCurrency.updateLayerFramesAndPositions()
    }
    
    func setupslider()
    {
        //self.RangeSliderCurrency.delegate = self;
        //self.RangeSliderCurrency.setMinAndMaxRange(Int(min), maxRange: Int(max))
        
           //self.RangeSliderCurrency.maxValue = _max;
           
        
        if let id = Data.value(forKey: "nAttributeId") as? String
               {
                  nAttributeId = "\(id)"
               }
               else if let id = Data.value(forKey: "nAttributeId") as? NSNumber
               {
                   nAttributeId = "\(id)"
               }
               
               if let id = Data.value(forKey: "cAttributeType") as? String
               {
                  cAttributeType = "\(id)"
               }
               else if let id = Data.value(forKey: "cAttributeType") as? NSNumber
               {
                   cAttributeType = "\(id)"
               }
        
           if (isUpdate == true)
           {
               lblMinPrice.text =  String(format: "%.2f", Smin)
               lblMaxPrice.text =  String(format: "%.2f", Smax)
            
        }else
           {
            lblMinPrice.text =  String(format: "%.2f", Smin)
            lblMaxPrice.text =  String(format: "%.2f+", Smax)
        }
        
        RangeSliderCurrency.minimumValue = Double(min)
        RangeSliderCurrency.maximumValue = Double(max)
        RangeSliderCurrency.lowerValue = Double(Smin)
        RangeSliderCurrency.upperValue = Double(Smax)
       
      //  self.RangeSliderCurrency.setMinAndMaxValue(Int(Smin), maxValue: Int(Smax))
      
//        self.RangeSliderCurrency.image
//
           self.RangeSliderCurrency.hideLabels = true;
     //  RangeSliderCurrency.frame = CGRect(x: RangeSliderCurrency.frame.origin.x, y: RangeSliderCurrency.frame.origin.y, width: size-20, height: RangeSliderCurrency.frame.height)
//           self.RangeSliderCurrency.handleColor = [UIColor blackColor];
//           self.RangeSliderCurrency.handleDiameter = 30;
//           self.RangeSliderCurrency.handleImage = [UIImage imageNamed:@"ic_option_on"];
//           self.RangeSliderCurrency.selectedHandleDiameterMultiplier = 1.3;
//           NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//           formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//           self.RangeSliderCurrency.numberFormatterOverride = formatter;
    }
    
    
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider) {
      print("\(rangeSlider.lowerValue), \(rangeSlider.upperValue)")
        let selectedMinimum = rangeSlider.lowerValue
        let selectedMaximum = rangeSlider.upperValue
        if (rangeSlider.upperValue >= Double(max))
               {
                
                lblMinPrice.text =  String(format: "%.2f", selectedMinimum)
                lblMaxPrice.text =  String(format: "%.2f+", selectedMaximum)
                   
                   
                   if (isprice == true)
                   {
                       selectedmax = Finelmax;
                    selectedmin = Float(selectedMinimum);
                   }
                   else
                   {
                    selectedmax = Float(selectedMaximum);
                    selectedmin = Float(selectedMinimum);
                   }
                   
               }
               else
               {
                
                lblMinPrice.text =  String(format: "%.2f", selectedMinimum)
                lblMaxPrice.text =  String(format: "%.2f", selectedMaximum)
            
                selectedmax = Float(selectedMaximum);
                selectedmin = Float(selectedMinimum);
               }
        
        createData()
    }
    
    
   func createData()
    {
//       [{"nAttributeId":12,"cAttributeType":"Numeric","cAttributeValue":"1.0,5.0","cAttributeMinValue":"1.0"}]
        var istrue = false;
        var dataindex = 0;
        
        if appDelegate.FilterDataArray.count > 0
        {
            for index in 0...appDelegate.FilterDataArray.count-1 {
               let inData:NSDictionary = appDelegate.FilterDataArray.object(at: index) as! NSDictionary
             if let id = inData.value(forKey: "nAttributeId") as? String
               {
                              if "\(id)" == nAttributeId
                              {
                              istrue = true
                               dataindex = index
                   }
                           }
                           else if let id = inData.value(forKey: "nAttributeId") as? NSNumber
                           {
                               if "\(id)" == nAttributeId
                                          {
                                        istrue = true
                                           dataindex = index
                               }
                           }
            }
        }
        
        
        
       
        let dic:NSMutableDictionary = NSMutableDictionary()
        dic.setValue(nAttributeId, forKey: "nAttributeId")
        dic.setValue(cAttributeType, forKey: "cAttributeType")
         dic.setValue(String(format: "%@,%@", String(format: "%.2f", selectedmin),String(format: "%.2f", selectedmax)), forKey: "cAttributeValue")
         dic.setValue("", forKey: "cAttributeMinValue")
        
        
        if istrue == true
               {
                   appDelegate.FilterDataArray.replaceObject(at: dataindex, with: dic)
               }
               else
               {
                    appDelegate.FilterDataArray.add(dic)
               }
        
       
        
        print(appDelegate.FilterDataArray)
       delegate?.FilterReloadData()
    }

    
    @IBAction func curvaceousnessValueChanged(_ slider: UISlider) {
     
    }
    @IBAction func trackBarThicknessValueChanged(_ slider: UISlider) {
     
      RangeSliderCurrency.trackThickness = CGFloat(slider.value)
    }
    override class func didChangeValue(forKey key: String) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
