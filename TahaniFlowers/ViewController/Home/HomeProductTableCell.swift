//
//  HomeProductTableCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 15/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

protocol HomeProductNavigation {
    func navigateCategoryToProduct(categoryId:Int,categoryName:String,api:String,isSubCategory:String,parentCateogyId:Int)
    func navigateToFeaturedProduct(productId:Int,ProductName:String)
}

class HomeProductTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionProduct: UICollectionView!
    
    // MARK: - Variables
    
    var delegate:HomeProductNavigation?
    var arrProductDetails:NSArray =  NSArray()
    var currentIndex:Int!

    var isZigzagOn = true
    
    // MARK: - TableViewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionProduct.delegate = self
        collectionProduct.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductDetails.count
    }
    
    
    func applyZizag(view:UIImageView)
      {
        
        let mask = CALayer()
        mask.contents =  [ UIImage(named: "design-img")?.cgImage] as Any
        mask.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.layer.mask = mask
        view.layer.masksToBounds = true
        
          
//          let width = view.frame.size.width + 100
//                       let height = view.frame.size.height
//                       //let givenFrame = self.frame
//
//                       let zigZagWidth = CGFloat(6)
//                       let zigZagHeight = CGFloat(4)
//
//                       var yInitial = height-zigZagHeight
//                       let zigZagPath = UIBezierPath()
//                       zigZagPath.move(to: CGPoint(x:0, y:0))
//                       zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))
//
//                       var slope = -1
//                       var x = CGFloat(0)
//                       var i = 0
//                       while x < width {
//                           x = zigZagWidth * CGFloat(i)
//                           let p = zigZagHeight * CGFloat(slope)
//                           let y = yInitial + p
//                           let point = CGPoint(x: x, y: y)
//                           zigZagPath.addLine(to: point)
//                           slope = slope*(-1)
//                           i += 1
//                       }
//
//                       zigZagPath.addLine(to: CGPoint(x:width,y: 0))
//
//                      // draw the line from top right to Bottom
//                       zigZagPath.addLine(to: CGPoint(x:width,y:height))
//
//                       yInitial = 0 + zigZagHeight
//                       x = CGFloat(width)
//                       i = 0
//                       while x > 0 {
//                           x = width - (zigZagWidth * CGFloat(i))
//                           let p = zigZagHeight * CGFloat(slope)
//                           let y = yInitial + p
//                           let point = CGPoint(x: x, y: y)
//                           zigZagPath.addLine(to: point)
//                           slope = slope*(-1)
//                           i += 1
//                       }
//
//
//                    // Now Close the path
//                       zigZagPath.close()
//
//                      view.layer.mask = CAShapeLayer()
//                       let shapeLayer = CAShapeLayer()
//                       shapeLayer.path = zigZagPath.cgPath
//                       view.layer.mask = shapeLayer
      }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCollectionCell", for: indexPath) as! HomeProductCollectionCell
        
        let dictProduct = arrProductDetails.object(at: indexPath.row) as! NSDictionary
        print(dictProduct)
        cell.viewProduct.layer.cornerRadius = 10.0
       cell.imgProductacc.layer.cornerRadius = 10.0
        cell.imgProduct.layoutIfNeeded()
      //  applyZizag(view: cell.imgProduct)
       // cell.viewProduct.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        cell.viewProduct.backgroundColor = UIColor.white
      //  cell.viewProduct.layer.shadowOffset = CGSize.zero
      //  cell.viewProduct.layer.shadowOpacity = 2.0
     //  cell.viewProduct.layer.shadowRadius = 2.0
        
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
       // cell.viewProduct.layer.masksToBounds = false
        
//        cell.viewProduct.layer.cornerRadius = 2
//        cell.viewProduct.layer.borderColor = UIColor(hexString: "#F2F3F4").cgColor
//        cell.viewProduct.layer.borderWidth = 1
    // cell.viewProduct.clipsToBounds = true
 
        if let currency = dictProduct.object(forKey: "Currency") as? String {
              UserDefaults.standard.set(currency, forKey: kCurrency)
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
        return CGSize(width: collectionView.frame.width/2.7, height: collectionView.frame.width/2)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print(currentIndex)
        if currentIndex == 1 {
            return UIEdgeInsetsMake(0, 15, 15, 0)
        }
        else {
            return UIEdgeInsetsMake(0, 15, 0, 15)
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
