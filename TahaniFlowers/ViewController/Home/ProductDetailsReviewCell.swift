//
//  ProductDetailsReviewCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ProductDetailsReviewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewRate: HCSStarRatingView!
    @IBOutlet weak var lblUserReview: UILabel!
    
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
