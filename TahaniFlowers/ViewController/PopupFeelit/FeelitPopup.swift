//
//  FeelitPopup.swift
//  TahaniFlowers
//
//  Created by baps on 29/07/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

protocol PopupFeelitDelegate {
    func popupFeelitClose()
    
}
class FeelitPopup: UIViewController {

    @IBOutlet weak var imgCenter: UIImageView!
    @IBOutlet weak var btnok: UIButton!
    var delegate:PopupFeelitDelegate?
    var isSize = false
    var data:NSDictionary = NSDictionary()
    var isFeelitStock = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnok.setTitle("lbl_FeelitPopup_Ok_Button".setlocalized(), for: .normal)
        
       
               
        
         if isSize == true
         {
            if let url = data.value(forKey: "cValue") as? String
            {
                imgCenter.cacheImage(urlString: url)
            }
        }
            else if isFeelitStock == true
         {
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
            if currentLanguage == "en" {
               if let url = "lbl_Feelit_PopupImage_Stock_En".setlocalized() as? String {
                   imgCenter.cacheImage(urlString: url)
                }
            }
            else{
                if let url = "lbl_Feelit_PopupImage_Stock_Ar".setlocalized() as? String {
                   imgCenter.cacheImage(urlString: url)
                }
            }
         }
        else
         {
            let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
                          if currentLanguage == "en" {
                             if let url = "lbl_Feelit_PopupImage".setlocalized() as? String {
                                 imgCenter.cacheImage(urlString: url)
                              }
                          }
                          else{
                              if let url = "lbl_Feelit_PopupImage_ar".setlocalized() as? String {
                                 imgCenter.cacheImage(urlString: url)
                              }
                          }
        }

        
        // Do any additional setup after loading the view.
    }

    @IBAction func OnclickClose(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.delegate != nil
            {
                self.delegate?.popupFeelitClose()
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
