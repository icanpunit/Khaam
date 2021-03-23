//
//  AppUpdate_VC.swift
//  TahaniFlowers
//
//  Created by baps on 30/09/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

class AppUpdate_VC: UIViewController {

    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgicon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let versionInfo = appDelegate.newVerstion
        lblTitle.text = "lbl_UpdateApp_Title".setlocalized()
        lblDetail.text = "\("lbl_UpdateApp_Message".setlocalized()) \(versionInfo)"
      
        imgicon.cacheImage(urlString: "lbl_updatePopup_Icon".setlocalized())
        btnUpdate.layer.cornerRadius = btnRadius
         btnUpdate.backgroundColor = btnBackgroundColor
        btnUpdate.setTitleColor(btnTitleColor, for: .normal)
        btnUpdate.setTitle("\("lbl_UpdateApp_btn_UPdate".setlocalized())", for: .normal)
       
        btnUpdate.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }


    @IBAction func onClickbtnUpdate(_ sender: Any) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id1522466977?mt=8"),
                               UIApplication.shared.canOpenURL(url){
                               if #available(iOS 10.0, *) {
                                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
                               } else {
                                   UIApplication.shared.openURL(url)
                               }
                           }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
