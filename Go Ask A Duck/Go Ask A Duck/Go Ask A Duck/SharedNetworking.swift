//
//  SharedNetworking.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 19/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import Foundation

/* class SharedNetworking: NSObject, UIApplicationDelegate {
//    let app = UIApplication.sharedApplication()
//    func startActivity() {
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//    }
//    func endActivity() {
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//    }
    
    
//    attribute: https://www.ioscreator.com/tutorials/display-activity-indicator-status-bar-ios8-swift
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.addSubview(loading)
    }
    func endLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loading.removeFromSuperview()
    }
    
    //: # Prototype function to retrieve JSON and pass the results to a completion block
    func configSearch(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
        
        objects.removeAll()
        print(url)
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            //            fatalError("Unable to create NSURL from string")
            self.showAlert()
            return
        }
        
        // Create a vanilla url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            
            // Print out the response (for debugging purpose)
            //            print("Response: \(response)")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                //                fatalError("Error: \(error!.localizedDescription)")
                self.showAlert()
                return
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                //                fatalError("Data is nil")
                self.showAlert()
                return
            }
            
            // We received raw data, print it out for debugging
            // It needs to be converted to JSON
            //            print("Raw data: \(data)")
            
            // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
            // part of
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //                print(json)
                
                // Cast JSON as an array of dictionaries
                guard let results = json as? [String: AnyObject] else {
                    //                    fatalError("We couldn't cast the JSON to a dictionary")
                    self.showAlert()
                    return
                }
                let dictOfTopics = results["RelatedTopics"] as? [[String: AnyObject]]
                
                // parse json
                for json in dictOfTopics! {
                    
                    let url = json["FirstURL"] as? String
                    
                    let content = json["Text"] as? String
                    
                    self.objects.append(topic(url: url, content: content))
                }
                // Call the completion block closure and pass the issues array of dictionaries as the argument to the
                // completion block.  This means that the code executed as part of the
                // completion block will have access to the `issues` data
                completion(dictOfTopics)
                
                
            } catch {
                print("error serializing JSON: \(error)")
                self.showAlert()
                return
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
} */
