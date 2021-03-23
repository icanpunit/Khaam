//
//  LounchScreenManagement.swift
//  TahaniFlowers
//
//  Created by baps on 21/05/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import FLAnimatedImage
class LounchScreenManagement: UIViewController {
    
    
    @IBOutlet weak var logo: FLAnimatedImageView!
    
    private let dataModel = localizationDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlpath:String = Bundle.main.path(forResource: "Khaam Logo", ofType: "gif")!
        let url   = URL(fileURLWithPath: urlpath)
        let data = try? Data(contentsOf: url)
        
       
        var img:FLAnimatedImage = FLAnimatedImage.init(gifData: data)
        logo.animatedImage = img
       
               logo.animationRepeatCount = 1
        
        appDelegate.createSqlDatabase()
               
                       dataModel.RemoveDataBase { [weak self] (_ isremove: Bool) in
                           print("Database Remove")
                        //  DeleteTableAllrow()
               
                           dataModel.requestData { [weak self] (_ data: Bool) in
                               // self?.useData(data: data)
                               if data == true
                               {
                               DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { // in half a second...
                                                                     if UserDefaults.standard.object(forKey: kFirstTime) != nil {
                                     appDelegate.SetTabBarItem(0)
                                }
                                else
                                 {
                                     appDelegate.FirstTime()
                                }
                                   print("Are we there yet?")
                               }

                                  // self!.movenext()
                               }
                               print("Successfull download")
                           }
               
                       }
        // Do any additional setup after loading the view.
    }


    func Gonext()
    {
         appDelegate.FirstTime()
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
