//
//  ProductDetailsRelatedProductCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ProductDetailsRelatedProductCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    // MARK: - IBOutlets
    
    @IBOutlet weak var CollectionviewheghtConstant: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var relatedProductCollection: UICollectionView!
    var isZigzagOn = true
    // MARK: - Variables
    var isassignProduct = false
    var arrProductDetails:NSArray = NSArray()
     var delegate:HomeProductNavigation?
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        relatedProductCollection.delegate = self
        relatedProductCollection.dataSource = self
        
      //  relatedProductCollection.register(HomeProductCollectionCell.self, forCellWithReuseIdentifier: "HomeProductCollectionCell")

//        relatedProductCollection.register(<#T##nib: UINib?##UINib?#>, forCellWithReuseIdentifier: <#T##String#>)
        // Initialization code
        
        if isassignProduct == true
               {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                relatedProductCollection.setCollectionViewLayout(layout, animated: true)
               }
               else
               {
                  let layout = UICollectionViewFlowLayout()
                                 layout.scrollDirection = .horizontal
                                 relatedProductCollection.setCollectionViewLayout(layout, animated: true)
               }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - CollectionView Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCollectionCell", for: indexPath) as! HomeProductCollectionCell
                
                let dictProduct = arrProductDetails.object(at: indexPath.row) as! NSDictionary
                print(dictProduct)
                cell.viewProduct.layer.cornerRadius = 10.0
               // cell.imgProduct.layer.cornerRadius = 10.0
         cell.imgProductacc.layer.cornerRadius = 10.0
        
        if let nCategoryId = dictProduct.value(forKey: "IsAccessories") as? NSNumber
                                    {
                                       if nCategoryId == 1
                                       {
                                        isZigzagOn = true
                                        }
                                        else
                                       {
                                        isZigzagOn = false
                                        }
                                    }
                                    else if let nCategoryId = dictProduct.value(forKey: "IsAccessories") as? String
                                    {
                                       if nCategoryId == "1"
                                       {
                                     isZigzagOn = true
                                        }
                                        else
                                       {
                                        isZigzagOn = false
                                        }
                                    }
        
        if isZigzagOn
               {
                   cell.imgProduct.isHidden = true
                   cell.imgProductacc.isHidden = false
                 
               }
               else
               {
                  cell.imgProduct.isHidden = false
                   cell.imgProductacc.isHidden = true
               }
        
       // cell.imgProduct.backgroundColor = navigationbarColor
               // cell.viewProduct.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
                cell.viewProduct.backgroundColor = navigationbarColor
              //  cell.viewProduct.layer.shadowOffset = CGSize.zero
              //  cell.viewProduct.layer.shadowOpacity = 2.0
             //  cell.viewProduct.layer.shadowRadius = 2.0
                cell.viewProduct.layer.masksToBounds = false
                
        //        cell.viewProduct.layer.cornerRadius = 2
        //        cell.viewProduct.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
        //        cell.viewProduct.layer.borderWidth = 1
            // cell.viewProduct.clipsToBounds = true
         
                if let currency = dictProduct.object(forKey: "Currency") as? String {
                                         
                                         if let spcialprice1 = dictProduct.object(forKey: "fSpecialPrice")  as? NSNumber {
                                             
                                             if Float(truncating: spcialprice1) > Float(0)
                                             {
                                                 if let price1 = dictProduct.object(forKey: "fPrice")  as? NSNumber {
                                                 let price = Float(truncating: price1)
                                                     let spcprice = Float(truncating: spcialprice1)
                                                   
                                                     let full = "\(currency) \(String(format: "%.3f", price)) \(currency) \(String(format: "%.3f", spcprice))"
                                                     
                                                     cell.lblPrice.attributedText = appDelegate.setAttributedPrice(Priceone: "\(currency) \(String(format: "%.3f", price))", pricetwo: "\(currency) \(String(format: "%.3f", spcprice))", Fullstring: full, Font: cell.lblPrice.font)
                                                     //cell.lblPrice.text = "\(currency) \(String(format: "%.3f", price))"
                                                 }
                                                 
                                                
                                             }
                                             else{
                                                 if let price1 = dictProduct.object(forKey: "fPrice")  as? NSNumber {
                                                                              let price = Float(truncating: price1)
                                                                                
                                                                                  cell.lblPrice.text = "\(currency) \(String(format: "%.3f", price))"
                                                                              }
                                             }
                                        
                                         }
                                         
                                          
                                       }
                if let url = dictProduct.object(forKey: "cCategoryIcon") as? String {
                    cell.imgProduct.cacheImage(urlString: url)
                    cell.imgProductacc.cacheImage(urlString: url)
                }
                else if let url = dictProduct.object(forKey: "cImage") as? String {
                        cell.imgProduct.cacheImage(urlString: url)
                    cell.imgProductacc.cacheImage(urlString: url)
                }
                
                if let name = dictProduct.object(forKey: "cCategoryName") as? String {
                    cell.lblProductName.text = name
                }
                else if let name = dictProduct.object(forKey: "cName") as? String {
                    cell.lblProductName.text = name
                }
                
                if let currency = dictProduct.object(forKey: "Currency") as? String {
                    UserDefaults.standard.set(currency, forKey: kCurrency)
                }
                
                let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductCategory))
                openProductGesture.numberOfTapsRequired = 1
                cell.viewProduct.isUserInteractionEnabled = true
                cell.viewProduct.tag = indexPath.row
                cell.viewProduct.addGestureRecognizer(openProductGesture)

                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isassignProduct == true
        {
            return CGSize(width: collectionView.frame.width / 2 - 5, height: collectionView.frame.width / 2 + 40)
        }
        else
        {
            return CGSize(width: 156, height: 200)
        }
        
    }
    
    // MARK: - @objc Action Methods
    
    @objc func gotoProductCategory(sender:UITapGestureRecognizer){
        let index = sender.view?.tag
        let dictProduct = self.arrProductDetails.object(at: index!) as! NSDictionary
        
        var productID = 0
        var categoryID = 0
        var productName = ""
        var categoryName = ""
        
        print(dictProduct)
        if let nCategoryId = dictProduct.object(forKey: "nCategoryId") as? NSNumber {
            categoryID = Int(truncating: nCategoryId)
            if let cCategoryName = dictProduct.object(forKey: "cCategoryName") as? String {
                categoryName = cCategoryName
            }
        }
        
        if let nProductId = dictProduct.object(forKey: "nProductId") as? NSNumber {
            productID = Int(truncating: nProductId)
            if let cProductName = dictProduct.object(forKey: "cName") as? String {
                productName = cProductName
            }
        }
        
        if categoryID > 0 {
            
            var isSubCategory = ""
            var nParentCateogyId = 0
            if let nSubCategoryId = dictProduct.object(forKey: "IsSubCategory") as? String
            {
                isSubCategory = nSubCategoryId
            }
            
            if let parentId = dictProduct.object(forKey: "nParentCateogyId") as? NSNumber
            {
                nParentCateogyId = Int(truncating: parentId)
            }
            
            delegate?.navigateCategoryToProduct(categoryId: categoryID, categoryName: categoryName, api: kProductByCategory, isSubCategory: isSubCategory, parentCateogyId: nParentCateogyId)
        }
        else {
            delegate?.navigateToFeaturedProduct(productId: productID, ProductName: productName)
        }
        
    }
}
