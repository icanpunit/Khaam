//
//  SelecteLanguageCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 29/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class SelecteLanguageCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imgLanguage: UIImageView!
    @IBOutlet weak var lblLanguageName: UILabel!
    
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
