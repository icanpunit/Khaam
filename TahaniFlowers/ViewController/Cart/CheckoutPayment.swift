//
//  CheckoutPayment.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class CheckoutPayment: UIViewController,UISearchBarDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var viewPaymentTitle: UIView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewRoundCircle: UIView!
    @IBOutlet weak var viewCardHolderName: UIView!
    @IBOutlet weak var imgCardHolder: UIImageView!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var viewCardNumber: UIView!
    @IBOutlet weak var imgCardNumber: UIImageView!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var viewExpiryDate: UIView!
    @IBOutlet weak var imgExpiryDate: UIImageView!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var viewCvv: UIView!
    @IBOutlet weak var imgCvv: UIImageView!
    @IBOutlet weak var txtCvv: UITextField!
    @IBOutlet weak var btnPay: UIButton!
    
    // MARK: - Variables
    
    var searchBar = UISearchBar()
    var paymentMethod = ""
    var selecedTime = ""
    var selectedDate = ""
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
        
        self.viewRoundCircle.layer.cornerRadius = 7.5
        self.viewRoundCircle.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewRoundCircle.clipsToBounds = true
        self.viewRoundCircle.layer.borderWidth = 1
        self.viewRoundCircle.backgroundColor = UIColor.white
        
        self.viewLine.backgroundColor = UIColor(hexString: "#B0B1B3")
        
        self.btnPay.layer.cornerRadius = btnRadius
        self.btnPay.clipsToBounds = true
        
        self.viewCardHolderName.layer.cornerRadius = 20
        self.viewCardHolderName.layer.borderWidth = 1
        self.viewCardHolderName.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewCardHolderName.clipsToBounds = true
        
        self.viewCardNumber.layer.cornerRadius = 20
        self.viewCardNumber.layer.borderWidth = 1
        self.viewCardNumber.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewCardNumber.clipsToBounds = true
        
        self.viewExpiryDate.layer.cornerRadius = 20
        self.viewExpiryDate.layer.borderWidth = 1
        self.viewExpiryDate.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewExpiryDate.clipsToBounds = true
        
        self.viewCvv.layer.cornerRadius = 20
        self.viewCvv.layer.borderWidth = 1
        self.viewCvv.layer.borderColor = UIColor(hexString: "#B0B1B3").cgColor
        self.viewCvv.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBAction
    
    @IBAction func onClickPay(_ sender: UIButton) {
        let nextViewController = objCart.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    // MARK: - @objc Action
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @objc func addSarchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        
        let backButton:UIButton = UIButton()
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            backButton.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            backButton.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        backButton.addTarget(self, action: #selector(self.hideSearchBar), for: UIControlEvents.touchUpInside)
        let backView = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItems = [backView]
        
        let languageButton:UIButton = UIButton()
        languageButton.setImage(UIImage(named: "ic_language"), for: .normal)
        languageButton.addTarget(self, action: #selector(self.hideSearchBar), for: UIControlEvents.touchUpInside)
        let languageView = UIBarButtonItem(customView: languageButton)
        //self.navigationItem.rightBarButtonItems = [languageView]
        
        self.searchBar.tintColor = UIColor(hexString: "#000000")
        self.searchBar.setImage(UIImage(named: "ic_search_outline"), for: .search, state: .normal)
        let width = self.searchBar.frame.width
        let height = self.searchBar.frame.height
        let underline:UIView = UIView(frame: CGRect(x: 0, y: height, width: width, height: 1))
        underline.backgroundColor = UIColor(hexString: "#000000")
        self.searchBar.addSubview(underline)
        
        var txtSearchBarFiled: UITextField?
        if #available(iOS 13.0, *) {
            txtSearchBarFiled = searchBar.searchTextField
        } else {
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                txtSearchBarFiled = searchField
            }
        }
        
        txtSearchBarFiled!.borderStyle = .none
        txtSearchBarFiled!.backgroundColor = UIColor.clear
                   txtSearchBarFiled!.textColor = UIColor(hexString: "#000000")
                   txtSearchBarFiled!.font = UIFont(name: RalewayLight, size: 17)
                   txtSearchBarFiled!.attributedPlaceholder = NSAttributedString(string: "home_search_flowers".setlocalized() ,
                                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#000000")])
        txtSearchBarFiled!.becomeFirstResponder()
        
       
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            
        })
    }
    
    @objc func hideSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 0
        }, completion: { finished in
            self.addNavigationBar()
        })
    }
    
    // MARK: - Custom Methods

    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lbNavTitle.text = "step3".setlocalized()
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let buttonBack = UIButton.init(type: .custom)
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            buttonBack.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            buttonBack.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        buttonBack.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonBack.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonBack = UIBarButtonItem.init(customView: buttonBack)
        self.navigationItem.leftBarButtonItem = barButtonBack
        
        let buttonSearch = UIButton.init(type: .custom)
        buttonSearch.setImage(UIImage.init(named: "ic_search"), for: UIControlState.normal)
        buttonSearch.addTarget(self, action:#selector(addSarchBar), for: UIControlEvents.touchUpInside)
        buttonSearch.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 20, height: 20)
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonSearch = UIBarButtonItem.init(customView: buttonSearch)
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
//        self.navigationItem.rightBarButtonItems = [barButtonLanguage,barButtonSearch]
        
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        var searchBarButtonItem: UIBarButtonItem?
        searchBar.delegate = self
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
