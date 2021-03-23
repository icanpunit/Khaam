//
//  ProductDetailAttribute_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 30/07/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
protocol showAttributeImageDelegate {
    func showImagepopup(data:NSDictionary)
}
class ProductDetailAttribute_Cell: UITableViewCell {

    @IBOutlet weak var tblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var TblAttribute: UITableView!
    var ArrAttribute:NSArray = NSArray()
    var delegate:showAttributeImageDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let nibName = UINib(nibName: "AttributeTable_Cell", bundle: nil)
        TblAttribute.register(nibName, forCellReuseIdentifier: "AttributeTable_Cell")
        TblAttribute.delegate = self
               TblAttribute.dataSource = self
        
        self.TblAttribute.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        TblAttribute.layer.removeAllAnimations()
        tblHeightConstant.constant = TblAttribute.contentSize.height + 20
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }
    
    @objc func onclickseeimage(sender: UIButton!) {
        
        delegate?.showImagepopup(data: ArrAttribute.object(at: sender.tag) as! NSDictionary)
       print("Button tapped")
    }

}
extension ProductDetailAttribute_Cell : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrAttribute.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeTable_Cell", for: indexPath) as! AttributeTable_Cell
        
        if let cAttributeType = (ArrAttribute.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeType") as? String
        {
            if cAttributeType == "Image"
            {
                cell.btnSeeImage.isHidden = false
            }
            else
            {
               cell.btnSeeImage.isHidden = true
                if let name = (ArrAttribute.object(at: indexPath.row) as! NSDictionary).value(forKey: "cValue") as? String
                {
                    cell.lblValue.text = name
                }
            }
        }
        else
        {
            cell.btnSeeImage.isHidden = true
            if let name = (ArrAttribute.object(at: indexPath.row) as! NSDictionary).value(forKey: "cValue") as? String
            {
                cell.lblValue.text = name
            }
        }
        
        cell.btnSeeImage.tag = indexPath.row
        cell.btnSeeImage.addTarget(self, action: #selector(onclickseeimage), for: .touchUpInside)
        if let name = (ArrAttribute.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeName") as? String
        {
            cell.lblName.text = name
        }
        
        
        
        if let url = (ArrAttribute.object(at: indexPath.row) as! NSDictionary).value(forKey: "cAttributeImage") as? String
               {
                   cell.imgIcon.cacheImage(urlString: url)
               }
        
        
     let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                           if currentLanguage == "en" {
                            cell.lblName.textAlignment = .left
                            cell.lblValue.textAlignment = .left
                               
                           }
                           else{
                               cell.lblName.textAlignment = .right
                                 cell.lblValue.textAlignment = .right
                           }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let name = (ArrAttribute.object(at: indexPath.row) as! NSDictionary).value(forKey: "IsAttributeShow") as? NSString
        {
            if name == "True"
            {
                return UITableViewAutomaticDimension
            }
            else
            {
                return UITableViewAutomaticDimension
            }
        }
        else
        {
           return UITableViewAutomaticDimension
        }
    }
     func updateViewConstraints() {
        tblHeightConstant.constant = TblAttribute.contentSize.height  
       // super.updateViewConstraints()
    }
    
    override func layoutSubviews() {
        tblHeightConstant.constant = TblAttribute.contentSize.height
    }
}
