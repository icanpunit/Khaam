//
//  MyAppointmentTable_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 25/09/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

class MyAppointmentTable_Cell: UITableViewCell {

    @IBOutlet weak var btnOption: UIButtonX!
    @IBOutlet weak var lblTypeValue: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFor: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
   
    @IBOutlet weak var viewBack: UIViewX!
    var data:NSDictionary = NSDictionary()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowOnviewWithcornerRadius(YourView: viewBack)
       
        lblTiming.text = "lbl_Appoinment_Timing".setlocalized()
     lblFor.text = "lbl_Appoinment_For".setlocalized()
        lblType.text = "lbl_Appoinment_Timing".setlocalized()
        lblType.text = "lbl_Appoinment_Appointment_Type".setlocalized()
        btnOption.setTitle("lbl_Appoinment_Delete".setlocalized(), for: .normal)
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
