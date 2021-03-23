//
//  ProductListHeaderCollection_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 17/07/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

protocol SubcategoryDelegate {
    func onselectSubcategory(nCategoryId:String,productName:String)
    func onselectSort()
}
class ProductListHeaderCollection_Cell: UICollectionReusableView,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
        @IBOutlet weak var btnSort: UIButton!
        // MARK: - IBOutlets
       
       var arrCategoryList:NSArray = NSArray()
        @IBOutlet weak var lblTotalProducts: UILabel!
        
        @IBOutlet weak var imgNoData: UIImageView!
        @IBOutlet weak var subcategoryHeightCostant: NSLayoutConstraint!
        @IBOutlet weak var CollectionSubCat: UICollectionView!
        var nCategoryId = ""
        var delegate:SubcategoryDelegate?
    
        var visibleIndexPath: IndexPath? = nil
    
    @IBAction func onClickBtnSort(_ sender: UIButton) {
        delegate?.onselectSort()
    }

    // MARK: - Collectionview Delegates

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return arrCategoryList.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCollection_Cell", for: indexPath) as! SubcategoryCollection_Cell
           cell.viewBack.layer.cornerRadius = cell.viewBack.frame.height/2
           let dicProduct = self.arrCategoryList.object(at: indexPath.row) as! NSDictionary
           
           if let url = dicProduct.object(forKey: "cCategoryIcon") as? String {
               cell.imgIcon.cacheImage(urlString: url)
           }
                                    
            if let productName = dicProduct.object(forKey: "cCategoryName") as? String {
                cell.lblTitle.text = productName
            }
            cell.imgIcon.image = cell.imgIcon.image?.withRenderingMode(.alwaysTemplate)
           
           if let url = dicProduct.object(forKey: "cCategoryIcon") as? String {
               cell.imgIcon.cacheImage(urlString: url)
           }
           cell.lblLine.isHidden = true
           if let id = dicProduct.object(forKey: "nCategoryId") as? NSNumber {
               
               if "\(id)" != nCategoryId
                              {
                                  cell.viewBack.backgroundColor = UIColor.white
                                  cell.imgIcon.tintColor = .black
                                  cell.lblTitle.isHidden = false
                                  cell.imgHeight.constant = 30
                                  cell.imgWidth.constant = 30
                                  cell.imgCenterConstant.constant = -10
                               cell.lblLine.isHidden = true
                              }
                              else
                              {
                                  cell.imgHeight.constant = 40
                                  cell.imgWidth.constant = 40
                                  cell.viewBack.backgroundColor = UIColor.clear
                                   cell.imgIcon.tintColor = .lightGray
                                  cell.lblTitle.isHidden = true
                                  cell.imgCenterConstant.constant = 0
                               cell.lblLine.isHidden = false
                              }
                             
           }
           
           
          
                   return cell
         }
        
    
     
     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
         
         return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
         
         
     }
    
    func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.8) {
//            cell.alpha = 1
//        }

    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let dicProduct = self.arrCategoryList.object(at: indexPath.row) as! NSDictionary

        var name = ""
         if let productName = dicProduct.object(forKey: "cCategoryName") as? String
         {
             name = productName
         }

         if let id = dicProduct.object(forKey: "nCategoryId") as? NSNumber
         {
             nCategoryId = "\(id)"
         }
        
        delegate?.onselectSubcategory(nCategoryId: nCategoryId, productName: name)
//         TotalRecord = 0
//         CollectionSubCat.reloadData()
//         productsByCategory(ispaging: false)
     }
//
//     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//         if collectionView == productListCollection
//         {
//              if !(indexPath.row + 1 < self.arrProducts.count) {
//
//                         let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//                         spinner.startAnimating()
//             //            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//             //
//             //            self.tableview.tableFooterView = spinner
//             //            self.tableview.tableFooterView?.isHidden = false
//
//                         // self.isLoading = true;
//                         pageTo = pageFrom + 1
//
//                         pageFrom += 10
//
//                         if arrProducts.count < TotalRecord
//                         {
//
//                             if searchText != ""
//                             {
//                                 self.searchProducts(ispaging: true)
//                             }
//                             else
//                             {
//                                 productsByCategory(ispaging: true)
//                             }
//
//
//                         }
//                         else
//                         {
//
//                         }
//
//
//                     }
//         }
//
//
//     }
     

}
