//
//  Sort_Vc.swift
//  TahaniFlowers
//
//  Created by baps on 10/04/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit

class Sort_Vc: UIViewController ,UITableViewDelegate , UITableViewDataSource{
   
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    var arrtitle = ["lbl_Sort_Poppularity".setlocalized(),"lbl_Sort_newestFirst".setlocalized(),"lbl_Sort_Atoz".setlocalized(),"lbl_Sort_ztoa".setlocalized(), "lbl_Sort_PriceHighToLow".setlocalized(),"lbl_Sort_PriceLowToHigh".setlocalized(),"lbl_Sort_BestSeller".setlocalized() ]
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "lbl_Sort_Title".setlocalized()
        viewHeightConstant.constant = CGFloat(60 *  arrtitle.count) + 74
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBtnClose(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
        dismiss(animated: true) {
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 0
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sorttable_cell", for: indexPath) as! sorttable_cell
        
        
        
        if appDelegate.Filtertype == indexPath.row
        {
           cell.btnRound.setImage(UIImage(named: "ic_radio_checked"), for: .normal)
        }
        else
        {
            cell.btnRound.setImage(UIImage(named: "ic_radio_unchecked"), for: .normal)
        }
        cell.lblTitle.text = arrtitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.Filtertype = indexPath.row
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
        dismiss(animated: true) {
           
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
