//
//  MenuTableViewCell.swift
//  LNSideMenu
//
//  Created by Luan Nguyen on 10/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    
  //  titleLabel.font = UIFont(name: RalewaySemiBold, size: CGFloat(FontSizwNoramal))
    //btnMore.titleLabel?.font = UIFont(name: RalewaySemiBold, size: CGFloat(FontSizeSmall))
    titleLabel.textColor = colorBlue
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
