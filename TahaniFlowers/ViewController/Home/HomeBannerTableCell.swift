//
//  HomeBannerTableCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 15/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

protocol HomeNavigation {
    func navigateToProductCaregory(id:Int,categoryName:String,api:String)
    func navigateToProductDetails(id:Int,productName:String)
}



class HomeBannerTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets
    
    var delegate:HomeNavigation?
    @IBOutlet weak var collectionBanner: UICollectionView!
    @IBOutlet weak var imgPlaceHolder: UIImageView!
    var index = 0
    var isLoadFirstTime:Bool = true
    var isScroll = false
    // MARK: - Variables
    
    
    var arrBanners:NSArray = NSArray()
    var timer:Timer = Timer()
    
    // MARK: - TableViewCell Methods
    let view1 = UIView()
    override func awakeFromNib() {
                
        super.awakeFromNib()
        view1.frame = UIScreen.main.bounds
        view1.backgroundColor = UIColor.clear
        contentView.addSubview(view1)
        self.addTimer()
        collectionBanner.delegate = self
        collectionBanner.dataSource = self
        
        //------------right  swipe gestures in collectionView--------------//
        
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwiped))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            view1.addGestureRecognizer(swipeRight)
            
            //-----------left swipe gestures in collectionView--------------//
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwiped))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            view1.addGestureRecognizer(swipeLeft)
        }
        else
        {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwiped))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            view1.addGestureRecognizer(swipeRight)
            
            //-----------left swipe gestures in collectionView--------------//
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwiped))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            view1.addGestureRecognizer(swipeLeft)
        }
        
        view1.tag = 10
        let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductCategory))
        openProductGesture.numberOfTapsRequired = 1
        view1.isUserInteractionEnabled = true
        
        view1.addGestureRecognizer(openProductGesture)
        //  self.collectionBanner.isScrollEnabled = false
        //self.collectionBanner.isUserInteractionEnabled = false
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrBanners.count != 0 {
            return arrBanners.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionCell", for: indexPath) as! HomeBannerCollectionCell
        self.imgPlaceHolder.isHidden = true
        self.collectionBanner.isHidden = false
        cell.btnNext.setImage(UIImage(named: "ic_back_ar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.btnNext.tintColor = UIColor.white
        cell.btnNext.isHidden = true
        cell.lblDetail.isHidden = true
        cell.lbltitle.isHidden = true
        if indexPath.row < arrBanners.count {
            
            
            let bannerDict = arrBanners.object(at: indexPath.row) as! NSDictionary
            
            if let name = bannerDict.object(forKey: "cSliderName") as? String {
                cell.lbltitle.text = name
            }
            
            if let name = bannerDict.object(forKey: "cDescription") as? String {
                cell.lblDetail.text = name
            }
            
            let imageUrl = bannerDict.object(forKey: "cSliderImage") as! String
            cell.imgBanner.cacheImage(urlString: imageUrl)
          //  cell.imgBanner.backgroundColor = UIColor.lightGray
            let openProductGesture = UITapGestureRecognizer(target: self, action: #selector(gotoProductCategory))
            openProductGesture.numberOfTapsRequired = 1
            cell.imgBanner.isUserInteractionEnabled = true
            cell.imgBanner.tag = indexPath.row
            cell.imgBanner.addGestureRecognizer(openProductGesture)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            view1.isHidden = false
            
        }
        else if indexPath.row == arrBanners.count-1
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
            
            
            //        if indexPath.row == self.arrBanners.count{
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0),at: .left, animated: false)
            //
            //                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            //                if currentLanguage == "en" {
            //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0),at: .left, animated: false)
            //                }
            //                else{
            //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0),at: .right, animated: false)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    @objc func rightSwiped()
    {
        timer.invalidate()
        addTimer()
        print("right swiped ")
        let index = collectionBanner.indexPathsForVisibleItems.last
        
        print("left",index?.row)
        if index?.row == 0
        {
            print(arrBanners.count-1)
            // collectionBanner.reloadData()
            
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
                self.collectionBanner?.scrollToItem(at:IndexPath(item: arrBanners.count-1, section: 0), at: .left, animated: false)
                
            }
            else{
                self.collectionBanner?.scrollToItem(at:IndexPath(item: arrBanners.count-1, section: 0), at: .right, animated: false)
            }
        }
        else if index?.row == arrBanners.count-1
        {
            
            collectionBanner.reloadData()
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
                self.collectionBanner?.scrollToItem(at:IndexPath(item: arrBanners.count-2, section: 0), at: .right, animated: true)
            }
            else{
                self.collectionBanner?.scrollToItem(at:IndexPath(item: arrBanners.count-2, section: 0), at: .right, animated: true)
            }
        }
    }
    
    @objc func leftSwiped()
    {
        timer.invalidate()
        addTimer()
        print("left swiped ")
        let index = collectionBanner.indexPathsForVisibleItems.last
        print("right",index?.row)
        
        if index?.row == arrBanners.count-1
        {
            
            collectionBanner.reloadData()
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
                self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
            }
            else{
                self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
            }
        }
        else if index?.row == 0
        {
            print(arrBanners.count-1)
            // collectionBanner.reloadData()
            
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
                self.collectionBanner?.scrollToItem(at:IndexPath(item: 1, section: 0), at: .left, animated: true)
                
            }
            else{
                self.collectionBanner?.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: true)
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //        isScroll = true
        //       // collectionBanner.collectionViewLayout.invalidateLayout()
        //
        //        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
        //
        //           let index = collectionBanner.indexPathsForVisibleItems.last
        //            // collectionBanner.reloadData()
        //
        //            print("left",index?.row)
        //            if index?.row == 0
        //            {
        //                print(arrBanners.count-1)
        //                collectionBanner.reloadData()
        //
        //                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        //                if currentLanguage == "en" {
        //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: arrBanners.count, section: 0), at: .left, animated: false)
        //
        //                }
        //                else{
        //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: arrBanners.count, section: 0), at: .right, animated: false)
        //                }
        //            }
        //
        //        } else {
        //            let index = collectionBanner.indexPathsForVisibleItems.last
        //            print("right",index?.row)
        //
        //            if index?.row == arrBanners.count-1
        //            {
        //
        //                collectionBanner.reloadData()
        //                let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        //                if currentLanguage == "en" {
        //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
        //                }
        //                else{
        //                    self.collectionBanner?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
        //                }
        //            }
        //        }
        //        let current = collectionBanner.indexPathsForVisibleItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        
    }
    
    // MARK: - @objc Action Methods
    
    @objc func gotoProductCategory(sender:UITapGestureRecognizer){
        
        
        //  let index = sender.view?.tag
        let index = collectionBanner.indexPathsForVisibleItems.last
        //        if index == 10
        //        {
        //
        //        }
        //        else
        //        {
        //
        //        }
        let bannerDict = arrBanners.object(at: (index?.row)!) as! NSDictionary
        var id = 0
        var productID = 0
        var categoryID = 0
        var productName = ""
        var categoryName = ""
        
        if let proudctId = bannerDict.object(forKey: "nProductId") as? NSNumber {
            productID = Int(truncating: proudctId)
            productName = bannerDict.object(forKey: "cSliderName") as! String
        }
        
        if let categoryId = bannerDict.object(forKey: "nCategoryId") as? NSNumber {
            categoryID = Int(truncating: categoryId)
            categoryName = bannerDict.object(forKey: "cSliderName") as! String
        }
        
        if productID > 0 {
            id = productID
            delegate?.navigateToProductDetails(id: id, productName: productName)
        }
        else {
            id = categoryID
            delegate?.navigateToProductCaregory(id: id, categoryName: categoryName, api: "")
        }
    }
    
    func addTimer(){
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
    @objc func nextPage(){
        let current = collectionBanner.indexPathsForVisibleItems
        
        if current.count > 0
        {
            
            if arrBanners.count + 1 > 0 {
                
                index = ((current.last)?.row)!
                
                if index == self.arrBanners.count {
                    index = ((current.last)?.row)! - 1
                }
                
                if index == arrBanners.count - 1 {
                    index = 0
                    let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                    if currentLanguage == "en" {
                        self.collectionBanner?.scrollToItem(at:IndexPath(item: index, section: 0), at: .left, animated: false)
                    }
                    else{
                        self.collectionBanner?.scrollToItem(at:IndexPath(item: index, section: 0), at: .right, animated: false)
                    }
                    
                }
                else {
                    index = index + 1
                    let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                    if currentLanguage == "en" {
                        self.collectionBanner?.scrollToItem(at:IndexPath(item: index, section: 0), at: .left, animated: true)
                    }
                    else{
                        self.collectionBanner?.scrollToItem(at:IndexPath(item: index, section: 0), at: .right, animated: true)
                    }
                }
            }
        }
    }
}
