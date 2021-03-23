//
//  ProfileFirstCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 19/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ProfileFirstCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var viewProfileDetails: UIView!
    @IBOutlet weak var imgCoverImage: UIImageView!
    @IBOutlet weak var btnCoverImage: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    // MARK: - Variables
    
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
