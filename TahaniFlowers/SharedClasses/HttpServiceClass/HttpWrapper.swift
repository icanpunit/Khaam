//
//  HttpWrapper.swift
//  Deputize America
//
//  Created by Vishal on 24/05/17.
//  Copyright © 2017 darshak. All rights reserved.
//

import UIKit
import Alamofire

protocol HttpWrapperDelegate
{
    func HttpWrapperfetchDataSuccess(wrapper : HttpWrapper,dicsResponse : NSMutableDictionary)
    func HttpWrapperfetchDataFail(wrapper : HttpWrapper,error : NSError);
}

class HttpWrapper: NSObject
{
    var delegate:HttpWrapperDelegate? = nil
    
    // MARK:- requestWithparamdictParam
    
    func requestWithparamdictParam(_ url : String)
    {
        //        let newURL = url.replacingOccurrences(of: " ", with: "%")
        
        if !self.checkInternetConnection()
        {
            return
        }
        
        Alamofire.request(url)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    // print("\nRequestURL: \((response.request?.url)!)\n")
                    // print("Sucees But Error: \(response.result.error!)")
                }
            }
            .responseJSON { response in
                // print("\nRequestURL: \((response.request?.url)!)\n")
                // print("Response JSON: \n \(response.result.value!)")
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                        }
                    }
                    else
                    {
                        AppHelper.showAlert("Alert", message: "Please try again.")
                        // print("response not converted to JSON")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.result.error! as NSError);
                    }
                }
        }
    }
    
    
    // MARK:- requestWithparamdictParamPostMethodwithHeader
    
    func requestWithparamdictParamPostMethodwithHeader(url : String ,dicsParams : [String: AnyObject],  headers: [String: AnyObject]?)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: dicsParams, encoding:  JSONEncoding.default , headers:headers as? HTTPHeaders ).responseString
            { response in
                
                print(dicsParams)
                if((response.result.error) != nil)
                {
                    // print("Sucees But Error: \(String(describing: response.result.error))")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseString(completionHandler: { (string) in
                
            })
            .responseJSON { response in
                print("Response JSON: \n \(String(describing: response.result.value))")
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value
                    {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                        }
                    }
                    else
                    {
                        // print("response not converted to JSON")
                        //                        SharedUtility.showAlert("Alert", message: "Please try again.")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.result.error! as NSError);
                    }
                }
        }
        
    }
    // MARK:- requestWithparamdictParamPostMethodwithHeader
    
    func requestWithparamdictParamPostMethodwithHeaderGet(url : String , headers: [String: AnyObject]?)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        
         //let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(url, method: .get,headers:headers as? HTTPHeaders ).responseString
            { response in
                //print(dicsParams)
                if((response.result.error) != nil)
                {
                    // print("Sucees But Error: \(String(describing: response.result.error))")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseString(completionHandler: { (string) in
                
            })
            .responseJSON { response in
                //print("Response JSON: \n \(String(describing: response.result.value))")
                if((response.result.error) == nil)
                {
                    if let kJSON = response.result.value
                    {
                        print(kJSON)
                        let mydict = NSDictionary()
                        if mydict == kJSON as? NSDictionary
                        {
                            if (self.delegate != nil){
                                self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                            }
                        }
                        else
                        {
                            
                            let newdata = kJSON as! NSArray
                            var mydict2 = NSDictionary()
                            
                            mydict2 = newdata[0] as! NSDictionary
                            print(mydict2)
                            if (self.delegate != nil){
                                self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict2.mutableCopy() as! NSMutableDictionary)
                            }
                        }
                        
                        
                    }
                    else
                    {
                        // print("response not converted to JSON")
                        //                        SharedUtility.showAlert("Alert", message: "Please try again.")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.result.error! as NSError);
                    }
                }
        }
        
    }
//    // MARK:- requestWithparamdictParamPostMethodwithHeader
//
//    func requestWithparamdictParamPostMethodwithHeaderGet(url : String , headers: [String: AnyObject]?)
//    {
//        if !self.checkInternetConnection()
//        {
//            return
//        }
//
//        Alamofire.request(url, method: .get,headers:headers as? HTTPHeaders ).responseString
//            { response in
//                //print(dicsParams)
//                if((response.result.error) != nil)
//                {
//                    // print("Sucees But Error: \(String(describing: response.result.error))")
//                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
//                }
//            }
//            .responseString(completionHandler: { (string) in
//
//            })
//            .responseJSON { response in
//                //print("Response JSON: \n \(String(describing: response.result.value))")
//                if((response.result.error) == nil)
//                {
//                    if let JSON = response.result.value
//                    {
//                        var mydict = NSDictionary()
//                        mydict = JSON as! NSDictionary
//
//                        if (self.delegate != nil){
//                            self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
//                        }
//                    }
//                    else
//                    {
//                        // print("response not converted to JSON")
//                        //                        SharedUtility.showAlert("Alert", message: "Please try again.")
//                    }
//                }
//                else
//                {
//                    if (self.delegate != nil){
//                        self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.result.error! as NSError);
//                    }
//                }
//        }
//
//    }
    //MARK:- Payment  stripe
    
    
    //MARK:- requestWithparamdictParamPostMethod
    
    func requestWithparamdictParamPostMethod(url : String ,dicsParams : [String: AnyObject])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        Alamofire.request(url, method: .post, parameters: dicsParams, encoding: URLEncoding.default).responseString
            { response in
                // print(dicsParams)
                if((response.result.error) != nil)
                {
                    // print("Sucees But Error: \(String(describing: response.result.error))")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseString(completionHandler: { (string) in
                
            })
            .responseJSON { response in
                //  print("Response JSON: \n \(String(describing: response.result.value))")
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value
                    {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                        }
                    }
                    else
                    {
                        // print("response not converted to JSON")
                        //                        SharedUtility.showAlert("Alert", message: "Please try again.")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.result.error! as NSError);
                    }
                }
        }
    }
    
    // MARK:- requestMultipartFormDataWithImageAndVideo
    
    func requestMultipartFormDataWithImageAndVideo(_ url : String ,dicsParams : [String: AnyObject],dictHeader : [String: AnyObject])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        
        let username = ""
        let password = ""
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        _ = ["Authorization": "Basic \(base64Credentials)"]
        
        
        //        let manager = Alamofire.Manager.sharedInstance
        //        let urlString = try! URLRequest(url: url, method: .post, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in dicsParams
            {
                
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            
            // print(dicsParams)
            
            for (key, value) in dicsParams
            {
                if value is UIImage
                {
                    if let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.0)
                    {
                        let format: DateFormatter = DateFormatter()
                        format.dateFormat = "yyyyMMddHHmmss"
                        let now: NSDate = NSDate()
                        let retStr: String = format.string(from: now as Date)
                        let randnumber = retStr
                        
                        //let randnumber = time(nil)
                        let random=String(format: "%d.jpeg", randnumber)
                        
                        multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
                    }
                }
            }
            
            for (key, value) in dicsParams
            {
                if value is NSArray
                {
                    for (image) in value as! NSArray
                    {
                        if  let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.0)
                        {
                            let format: DateFormatter = DateFormatter()
                            format.dateFormat = "yyyyMMddHHmmss"
                            let now: NSDate = NSDate()
                            let retStr: String = format.string(from: now as Date)
                            let randnumber = retStr
                            
                            //let randnumber = time(nil)
                            let random=String(format: "%d.jpeg", randnumber)
                            
                            //  print(imageData)
                            //  print(key)
                            //  print(random)
                            
                            multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
                            
                        }
                    }
                }
            }
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    //                    debugPrint(response)
                    //                    se.hideLoadingSpinner()
                    if response.result.value is NSNull
                    {
                        //                        AppHelper.showAlertWithTitle(kAleartTitle, description1: "Response nil")
                    }
                    else
                    {
                        if let JSON = response.result.value {
                            var mydict = NSDictionary()
                            mydict = JSON as! NSDictionary
                            
                            if (self.delegate != nil){
                                //                                print("response:--------------------\n %@",mydict)
                                self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                            }
                        }
                        else
                        {
                            //                            AppHelper.showAlertWithTitle(kAleartTitle, description1: "Please try again.")
                            //print("response not converted to JSON")
                        }
                        
                    }
                    //API error
                    /*
                     upload.response(completionHandler: { (request, response, data, error) -> Void in
                     
                     //                            NSLog("upload.response : data : %@", String(data: data!, encoding: NSUTF8StringEncoding)!)
                     NSLog("upload.response : response : %@", response!)
                     
                     
                     })*/
                }
            case .failure(let encodingError):
                print(encodingError)
                if (self.delegate != nil){
                    self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: encodingError as NSError);
                }
            }
        }
    }
    //
    func requestMultipartFormDataWithImageAndVideoHeaderParameter(url: String, imageData: Data?, parameters: [String : Any], Header:[String: Any]) {
        let token = Header["apiToken"] as? String
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "apiToken" : token!,
            "Content-type":"multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "userImage", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        return
                    }
                    if response.result.value is NSNull
                    {
                        //                        AppHelper.showAlertWithTitle(kAleartTitle, description1: "Response nil")
                    }
                    else
                    {
                        if let JSON = response.result.value {
                            var mydict = NSDictionary()
                            mydict = JSON as! NSDictionary
                            
                            if (self.delegate != nil){
                                //                                print("response:--------------------\n %@",mydict)
                                self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                            }
                        }
                        else
                        {
                            //                            AppHelper.showAlertWithTitle(kAleartTitle, description1: "Please try again.")
                            //print("response not converted to JSON")
                        }
                    }
                    
                }
            case .failure(let error):
                
                print("Error in upload: \(error.localizedDescription)")
                self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: error as NSError);
            }
        }
    }
    
    // MARK:- checkInternetConnection
    func checkInternetConnection() -> Bool
    {
        let reachability = Reachability.forInternetConnection() as Reachability;
        let internetStatus : Int = reachability.currentReachabilityStatus().rawValue
        if ((internetStatus == 0) || (reachability.connectionRequired() == true)) {
            return false;
        }
        return true;
    }
}
