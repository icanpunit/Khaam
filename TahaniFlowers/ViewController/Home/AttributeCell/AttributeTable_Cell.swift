//
//  AttributeTable_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 30/07/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

class AttributeTable_Cell: UITableViewCell {

    @IBOutlet weak var btnSeeImage: UIButton!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSeeImage.setTitle("lbl_ProductDetail_SeeSize".setlocalized(), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
