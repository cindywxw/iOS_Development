//
//  SharedNetworking.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 19/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import Foundation

//class SharedNetworking: UITableViewController, UIApplicationDelegate {
class SharedNetworking {
    
//    var urlString: String?
    var objects = [Any]()
    static let sharedInstance = SharedNetworking()
    init() {}
//    
//    init(url:String) {
//        urlString = url
//    }
    
    var stillPassing = true
    var error = false
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    attribute: https://www.ioscreator.com/tutorials/display-activity-indicator-status-bar-ios8-swift
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func endLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func hasError() {
//        while self.stillPassing {}
        error = true
    }
    
    func getCell()-> [Any] {
//        objects.removeAll()
        while self.stillPassing {}
        print("count: \(objects.count)")
        return objects
    }
    
    func getData(url: String) {
        self.startLoading()
//        objects.removeAll()
        configSearch(url: url) { (results) in
            for i in results! {
                if i["FirstURL"] != nil {
                    let Url = i["FirstURL"] as! String?
                    let Content = i["Text"] as! String?
                    
                    self.objects.append(topic(url: Url, content: Content))
                }
            }
//            self.parsingFinished 
            self.stillPassing = false
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                //tableView.reload()
//                self.tableView.reloadData()
                self.endLoading()
            }
        }
        
//        return objects
    }
    
    
    //: # Prototype function to retrieve JSON and pass the results to a completion block
    func configSearch(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
        
//        objects.removeAll()
        print(url)
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            //            fatalError("Unable to create NSURL from string")
//            self.showAlert()
            self.hasError()
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
                 //               fatalError("Error: \(error!.localizedDescription)")
//                self.showAlert()
                self.hasError()
                return
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                //                fatalError("Data is nil")
//                self.showAlert()
                self.hasError()
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
//                    self.showAlert()
                    self.hasError()
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
//                self.showAlert()
                self.hasError()
                return
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
        
    }
    
//    func showAlert() {
//        
//        let title: String
//        let message: String
//        title = "Can't open. Try again later"
//        message = "There might be some problem on the connection."
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
    
}
