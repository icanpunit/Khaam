//
//  StartPage_Vc.swift
//  TahaniFlowers
//
//  Created by baps on 12/05/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

class StartPage_Vc: UIViewController {

    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStart.layer.cornerRadius = btnRadius
        self.btnStart.clipsToBounds = true
         self.navigationController?.isNavigationBarHidden = true
        lbltitle.text = "lbl_StartScreen_Title".setlocalized()
        lblDetail.text = "lbl_StartScreen_Detail".setlocalized()
        btnStart.setTitle("btn_StartScreen_StartShopping".setlocalized(), for: .normal)
        btnStart.backgroundColor = btnBackgroundColor
        btnStart.setTitleColor(btnTitleColor, for: .normal)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickbtnStart(_ sender: Any) {
        
        appDelegate.SetTabBarItem(0)
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
