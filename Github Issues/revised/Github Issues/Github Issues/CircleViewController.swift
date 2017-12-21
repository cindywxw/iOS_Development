//
//  CircleViewController.swift
//  Github Issues
//
//  Created by Cynthia on 06/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {

    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var open = 0;
        var closed = 0;
        
        let urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=all"
        guard let url = URL(string: urlString) else {
            fatalError("Unable to create NSURL from string")
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // request number of open and closed issues
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("Request Failed!")
                return
            }
            do {
                if let data = data, let rawData = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [[String: AnyObject]] {
                    
                    for json in rawData {
                        let status = json["state"] as? String
                        if (status == "open") {
                            open += 1
                        } else {
                            closed += 1
                        }
                    }
                } else {
                    print("JSON Error")
                }
            } catch let error as NSError {
                print("Error parsing results: \(error.localizedDescription)")
            }
//            draw circle
            let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))
            
            circle.center = self.view.center
            circle.center.y = circle.center.y - 50
            circle.layer.cornerRadius = circle.frame.size.height/2
            circle.clipsToBounds = true
            circle.layer.borderWidth = 6
            circle.layer.borderColor = UIColor.green.cgColor
            
            let circle2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0))
            
            circle2.center = self.view.center
            circle2.center.y = circle2.center.y - 50
            circle2.layer.cornerRadius = circle2.frame.size.height/2
            circle2.clipsToBounds = true
            circle2.layer.borderWidth = 6
            circle2.layer.borderColor = UIColor.red.cgColor
            
            
            // set the labels
            self.label1.center.x = self.view.center.x
            self.label2.center.x = self.view.center.x
            self.label1.center.y = self.view.center.y-70
            self.label2.center.y = self.view.center.y-20

            DispatchQueue.main.async {
                self.view.addSubview(circle)
                self.view.addSubview(circle2)
                self.label1.text = "\(String(open)) Open Issues"
                self.label2.text = "\(String(closed)) Closed Issues"
            }
            
        }
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
