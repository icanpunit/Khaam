//
//  Filtertable_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 16/08/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
protocol CallApiFilterDelegate {
    func FilterReloadData()
}
class Filtertable_Cell: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
    var delegate: CallApiFilterDelegate?
    @IBOutlet weak var collectionHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CollectionFilter: UICollectionView!
    @IBOutlet weak var mainview: UIView!
    var myArray:NSMutableArray = NSMutableArray()
     var SelectedArray:NSMutableArray = NSMutableArray()
    var Data:NSDictionary = NSDictionary()
    var index = IndexPath()
    var nAttributeId = ""
       var cAttributeType = ""
    var selectedProduct = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let nib = UINib(nibName: "CollectionViewCellTop", bundle: nil)
        CollectionFilter?.register(nib, forCellWithReuseIdentifier: "CollectionViewCellTop")
        CollectionFilter.delegate = self
        CollectionFilter.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
     // MARK: - CollectionView Delegates
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return myArray.count;
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let CollectionFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellTop", for: indexPath) as! CollectionViewCellTop
            
            CollectionFilterCell.backview.isHidden = false;
            CollectionFilterCell.imgvCollectionViewCellTopHomeVC.isHidden = true;
              
              CollectionFilterCell.backview.layer.cornerRadius = btnRadius;
            
            CollectionFilterCell.backview.layer.borderColor = UIColor.gray.cgColor
//            CollectionFilterCell.backview.layer.shadowColor = UIColor.black.cgColor
//            CollectionFilterCell.backview.layer.shadowRadius = 4;
//
//            CollectionFilterCell.backview.layer.shadowColor = UIColor.black.cgColor
//            CollectionFilterCell.backview.layer.shadowOpacity = 0.2
//            CollectionFilterCell.backview.layer.shadowOffset = .zero
           // CollectionFilterCell.backview.layer.shadowRadius = 10
           // CollectionFilterCell.backview.layer.shadowOffset = off
//              [CollectionFilterCell.backview.layer setShadowColor:[[UIColor blackColor] CGColor]];
//              [CollectionFilterCell.backview.layer setShadowRadius:4.0f];
//              [CollectionFilterCell.backview.layer setShadowOffset:CGSizeMake(0,2)];
//              [CollectionFilterCell.backview.layer setShadowOpacity:0.2f];
          
            
        if currentLanguage == "en" {
                             
            if let value = (myArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeValueEn") as? String
            {
                CollectionFilterCell.lblCollectionViewCellTopHomeVC.text = value
            }
                        
        }
        else{
            if let value = (myArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeValueAr") as? String
            {
                CollectionFilterCell.lblCollectionViewCellTopHomeVC.text = value
            }
        }
           
            
            var nAttributesValuesId = ""
                   if let value = (myArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributesValuesId") as? String
                   {
                       nAttributesValuesId = value
                   }
                   else if let value = (myArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributesValuesId") as? NSNumber
                   {
                       nAttributesValuesId = "\(value)"
                   }
            
            if (appDelegate.FilterDataArrayName.contains(nAttributesValuesId))
            {
                CollectionFilterCell.backview.backgroundColor = btnBackgroundColor
                CollectionFilterCell.lblCollectionViewCellTopHomeVC.textColor = UIColor.white;
               CollectionFilterCell.backview.layer.borderWidth = 0
                CollectionFilterCell.lblCollectionViewCellTopHomeVC.layer.borderColor = UIColor.lightGray.cgColor
            }
            else
            {
                CollectionFilterCell.backview.layer.borderWidth = 1
                CollectionFilterCell.backview.backgroundColor = UIColor.white;
                CollectionFilterCell.lblCollectionViewCellTopHomeVC.textColor = UIColor.gray
            }
            
            
            return CollectionFilterCell
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: CollectionFilter.frame.width/2-20, height: 50)
            
              
        }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = indexPath
        
        var nAttributesValuesId = ""
        if let value = (myArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributesValuesId") as? String
        {
            nAttributesValuesId = value
        }
        else if let value = (myArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "nAttributesValuesId") as? NSNumber
        {
            nAttributesValuesId = "\(value)"
        }
        
        if (appDelegate.FilterDataArrayName.contains(nAttributesValuesId))
                 {
                    appDelegate.FilterDataArrayName.remove(nAttributesValuesId)
                     
                 }
               else
               {
                
                appDelegate.FilterDataArrayName.add(nAttributesValuesId)
                  
               }
        createData()
        CollectionFilter.reloadData()
    }
     
    
    func createData()
        {
    //       [{"nAttributeId":12,"cAttributeType":"Numeric","cAttributeValue":"1.0,5.0","cAttributeMinValue":"1.0"}]
           
            var arrname:NSMutableArray = NSMutableArray()
            
            if appDelegate.FilterDataArrayName.count > 0
            {
                for index in 0...appDelegate.FilterDataArrayName.count-1 {
                    var nAttributesValuesId = ""
                    
                    if myArray.count > 0
                    {
                        for index2 in 0...myArray.count-1 {
                            if let value = (myArray.object(at: index2) as! NSDictionary).value(forKey: "nAttributesValuesId") as? String
                            {
                                nAttributesValuesId = value
                            }
                            else if let value = (myArray.object(at: index2) as! NSDictionary).value(forKey: "nAttributesValuesId") as? NSNumber
                            {
                                nAttributesValuesId = "\(value)"
                            }
                            
                            if appDelegate.FilterDataArrayName.contains(nAttributesValuesId)
                            {
                                arrname.add(nAttributesValuesId)
                            }
                        }
                    }
                    
                    
                    
                    
                }
                
            }
            
            let strID = arrname.componentsJoined(by: ",")
             let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(nAttributeId, forKey: "nAttributeId")
            dic.setValue(cAttributeType, forKey: "cAttributeType")
             dic.setValue(strID, forKey: "cAttributeValue")
             dic.setValue("", forKey: "cAttributeMinValue")
            
            
            if strID == ""
            {
                
                if appDelegate.FilterDataArray.count > 0
                {
                    for index in 0...appDelegate.FilterDataArray.count-1 {
                                       var nAttributeId1 = ""
                                                      if let value = (appDelegate.FilterDataArray.object(at: index) as! NSDictionary).value(forKey: "nAttributeId") as? String
                                                      {
                                                          nAttributeId1 = value
                                                      }
                                                      else if let value = (appDelegate.FilterDataArray.object(at: index) as! NSDictionary).value(forKey: "nAttributeId") as? NSNumber
                                                      {
                                                          nAttributeId1 = "\(value)"
                                                      }
                                                      
                                       if nAttributeId1 == nAttributeId
                                       {
                                           appDelegate.FilterDataArray.removeObject(at: index)
                                       }
                                       
                                       
                                   }
                }
               
            }
            else
            {
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
                
                if istrue == true
                              {
                                  appDelegate.FilterDataArray.replaceObject(at: dataindex, with: dic)
                              }
                              else
                              {
                                   appDelegate.FilterDataArray.add(dic)
                              }
                       
                
            }
            
//            if appDelegate.FilterDataArrayName.count > 0
//            {
//                for index in 0...appDelegate.FilterDataArrayName.count-1 {
//                   let inData:NSDictionary = appDelegate.FilterDataArrayName.object(at: index) as! NSDictionary
//                 if let id = inData.value(forKey: "nAttributeId") as? String
//                   {
//                                  if "\(id)" == nAttributeId
//                                  {
//                                  istrue = true
//                                   dataindex = index
//                       }
//                               }
//                               else if let id = inData.value(forKey: "nAttributeId") as? NSNumber
//                               {
//                                   if "\(id)" == nAttributeId
//                                              {
//                                            istrue = true
//                                               dataindex = index
//                                   }
//                               }
//                }
//            }
            
            
            
           
           
            
            
            
            
            print(appDelegate.FilterDataArray)
            delegate?.FilterReloadData()
        }
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            print(currentIndex)
//            if currentIndex == 1 {
//                return UIEdgeInsetsMake(0, 15, 15, 0)
//            }
//            else {
//                return UIEdgeInsetsMake(0, 15, 0, 15)
//            }
//        }
}
