//
//  ProductDetailsAddToCartCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ProductDetailsAddToCartCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var viewCartCount: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var txtCartCounter: UITextField!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnOrderSample: UIButton!
    
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPlus.backgroundColor = UIColor.clear
        btnPlus.layer.borderColor = UIColor.black.cgColor
        btnPlus.layer.borderWidth = 1
        
        btnMinus.backgroundColor = UIColor.clear
        btnMinus.layer.borderColor = UIColor.black.cgColor
        btnMinus.layer.borderWidth = 1
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
