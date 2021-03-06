//
//  SharedNetworking.swift
//  Photo Phabulous
//
//  Created by Cynthia on 01/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

var images_cache = NSCache<AnyObject, UIImage>.sharedInstance

//Error Type
enum networkError: Error {
    case Connection
//    case Request
//    case Parsing
//    case JOSNCasting
//    case Data
}

//class SharedNetworking: UIViewController, UIApplicationDelegate {
class SharedNetworking {
    
    static let sharedInstance = SharedNetworking()
    let username: String
    let urlString: String
    init() {
        username = "cindywen"
        urlString = "http://stachesandglasses.appspot.com/user/\(username)/json/"
    }
    
    func isConnectedToNetwork() throws {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            throw networkError.Connection
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            throw networkError.Connection
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        if ret == false {
            throw networkError.Connection
        }
        
    }
    
    
    var displayArray = [UIImage]()
    //    var images_cache = [String:UIImage]()
    var images = [String]()
//    let urlString = "http://stachesandglasses.appspot.com/user/cindywen/json/"
    
    func createDirectory(){
        let fileManager = FileManager.default
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("phabulous")
        if !fileManager.fileExists(atPath: filePath){
            try! fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    //: # Prototype function to retrieve JSON and pass the results to a completion block
    func get_image(url: String, completion:@escaping ([String]?) -> Void) {
        
        //        arrayOfImage.removeAll()
        //        print(url)
        // Transform the `url` parameter argument to a `URL`
        guard let url = URL(string: url) else {
            //  fatalError("Unable to create NSURL from string")
//            self.showAlert()
            completion(nil)
            return
        }
        
        // Create a vanilla url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            // Print out the response (for debugging purpose)
            // print("Response: \(response)")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                // fatalError("Error: \(error!.localizedDescription)")
//                self.showAlert()
                completion(nil)
                return
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                // fatalError("Data is nil")
//                self.showAlert()
                completion(nil)
                return
            }
            
            // We received raw data, print it out for debugging
            // It needs to be converted to JSON
            // print("Raw data: \(data)")
            
            AppFileManager.sharedInstance.saveToFile(data: data)
            
            // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
            // part of
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //                print(json)
                
                // Cast JSON as an array of dictionaries
                guard let results = json as? [String: AnyObject] else {
                    // fatalError("We couldn't cast the JSON to a dictionary")
//                    self.showAlert()
                    completion(nil)
                    return
                }
                let arrayOfImage = results["results"] as? [[String: AnyObject]]
                
                // parse json
                for json in arrayOfImage! {
                    
                    var url = json["image_url"] as? String
                    
                    if (url != nil) {
                        url = "http://stachesandglasses.appspot.com/" + url!
                        //   print(url as Any)
                        self.images.append(url!)
                    }
                    
                }
                // Call the completion block closure and pass the issues array of dictionaries as the argument to the
                // completion block.  This means that the code executed as part of the
                // completion block will have access to the `issues` data
                completion(self.images)
                
                
            } catch {
                print("error serializing JSON: \(error)")
//                self.showAlert()
                completion(nil)
                return
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
    func uploadRequest(user: NSString, image: UIImage, caption: NSString, completion:@escaping ([String]?) -> Void){
        do {
        try isConnectedToNetwork()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let boundary = generateBoundaryString()
        let scaledImage = resize(image: image, scale: 0.1)
        let imageJPEGData = UIImageJPEGRepresentation(scaledImage,0.1)
        
        guard let imageData = imageJPEGData else {return}
        
        // Create the URL, the user should be unique
        let url = NSURL(string: "http://stachesandglasses.appspot.com/post/\(user)/")
        
        // Create the request
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set the type of the data being sent
        let mimetype = "image/jpeg"
        // This is not necessary
        let fileName = "test.png"
        
        // Create data for the body
        let body = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        // Caption data
        body.append("Content-Disposition:form-data; name=\"caption\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("CaptionText\r\n".data(using: String.Encoding.utf8)!)
        
        // Image data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        // Trailing boundary
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        // Set the body in the request
        request.httpBody = body as Data
        
        // Create a data task
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Need more robust errory handling here
            // 200 response is successful post
            //            print(error!)
            guard response != nil else{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(nil)
                return
            }
//            print(response)
            
            if let error = error{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(error)
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                //                print(json)
                
                // Cast JSON as an array of dictionaries
                guard let results = json as? [String: AnyObject] else {
                    // fatalError("We couldn't cast the JSON to a dictionary")
                    completion(nil)
                    return
                }
                let arrayOfImage = results["results"] as? [[String: AnyObject]]
                
                // parse json
                var recent = arrayOfImage?[0]
                var url = recent?["image_url"] as? String
                if (url != nil) {
                    url = "http://stachesandglasses.appspot.com/" + url!
                    // print(url as Any)
                    self.images.append(url!)
                }
                completion(self.images)
            } catch {
                print("error serializing JSON: \(error)")
               // self.showAlert("connection")
                completion(nil)
                return
            }
            
            // The data returned is the update JSON list of all the images
            //            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print(dataString!)
            
//            let title: String
//            let message: String
//            title = "Image uploaded"
//            message = "Thank you for uploading"
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)

        }
        
        task.resume()
        } catch let error {
            completion(nil)
            print("error: \(error.localizedDescription)")
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// based on session7 playground
    func resize(image: UIImage, scale: CGFloat) -> UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: scale,y: scale))
        let hasAlpha = true
        
        // Automatically use scale factor of main screen
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
//    func showAlert() {
//        
//        let title: String
//        let message: String
//        title = "Can't open.Try again later"
//        message = "There might be some problem on the connection."
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//        
//    }
}
