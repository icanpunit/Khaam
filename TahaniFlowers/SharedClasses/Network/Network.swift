
import Foundation
import SystemConfiguration
//import SwiftMessageBar

public class Network {
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        var error: NSError?
     //   var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error : nil) as NSData?
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    Status = true
                }     
            }
            else
            {
//                SwiftMessageBar.showMessageWithTitle("", message: "No Internet Connection", type: .error)
                
            }
            
        } catch (let e) {
            print(e)
        }
        
        
        return Status
    }
}
