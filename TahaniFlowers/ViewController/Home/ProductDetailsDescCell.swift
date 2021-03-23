//
//  ProductDetailsDescCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ProductDetailsDescCell: UITableViewCell {

    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var lblVendorlabl: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    // MARK: - IBOutlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblProductDesc: UILabel!
    
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.text = "lbl_ProductDetail_DetailTitle".setlocalized()
       // lblVendorlabl.text = "lbl_ProductDetail_Vendor".setlocalized()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
