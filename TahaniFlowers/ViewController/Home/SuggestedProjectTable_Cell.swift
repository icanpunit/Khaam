//
//  SuggestedProjectTable_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 16/08/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

class SuggestedProjectTable_Cell: UITableViewCell,UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CollectionProject: UICollectionView!
    var arrimagelist:NSArray = NSMutableArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CollectionProject.delegate = self
        CollectionProject.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - CollectionView Delegate
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return arrimagelist.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedProjectCollection_Cell", for: indexPath) as! SuggestedProjectCollection_Cell
           
       // cell.imgProject.layer.cornerRadius = cell.imgProject.frame.height/2
        if let url = (arrimagelist.object(at: indexPath.row) as! NSDictionary).value(forKey: "cSuggestedProjectImage") as? String
        {
            cell.imgProject.cacheImage(urlString: url)
        }
           return cell
       }
       
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 20, height: 20)
       }
       
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsetsMake(0, 0, 0, 0 )
//       }
}
