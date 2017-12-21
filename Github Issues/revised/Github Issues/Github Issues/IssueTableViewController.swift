//
//  IssueTableViewController.swift
//  Github Issues
//
//  Created by Cynthia on 05/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

//class IssueTableViewController: UITableViewController, UITableViewDataSource,UITableViewDelegate {
class IssueTableViewController: UITableViewController {
    @IBOutlet weak var share: UIBarButtonItem!
    
    
    var openIssues = [Issue]()
    
    func refreshTable(refreshControl: UIRefreshControl) {
        getIssues(url: urlString) { (issues) in
            
            // Reload the table.  The tables data source should be the property you copied the
            // issues to (above). Remember to refresh the table on the main thread
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                //tableView.reload()
                self.tableView.reloadData()
            }
        }
//        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    /// The array of dictionaries that will hold all of our issues
    /// data returned from the network request
    var issues:[[String: AnyObject]]?
    
    /// The url of the JSON endpoint
    let urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=open"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Get all the issues from GitHub. The issues will be returned as `issues` in the closure.
        /// This would be a great place to update the table view showing the issues.  Remember that
        /// any UIKit elements need to be updated on the main thread.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshTable),
                                 for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        getIssues(url: urlString) { (issues) in
            
            // Reload the table.  The tables data source should be the property you copied the
            // issues to (above). Remember to refresh the table on the main thread
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                //tableView.reload()
                self.tableView.reloadData()
            }
        }
//        print(issues)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return openIssues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         Configure the cell...
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "openIssues", for: indexPath) as! IssueTableViewCell

        cell.accessoryType = .disclosureIndicator
        
        cell.title?.text = openIssues[indexPath.row].title
        cell.photo?.image = openIssues[indexPath.row].status  == "open" ? UIImage(named: "open") : UIImage(named: "closed")
        cell.username?.text = openIssues[indexPath.row].author
        cell.date?.text = openIssues[indexPath.row].date
//        print(cell.title?.text)
        return cell
    }
    
    
    //: # Prototype function to retrieve JSON and pass the results to a completion block
    
    /// Retrieve class Issues using GitHub API v3 and pass back the
    /// array of dictionaries in the completion block `completion()`
    /// - Attributions: Assignment write-up
    /// - Parameter url: A `String` of the url
    /// - Parameter completion: A closure to run on the converted JSON
    /// - Returns: An `Array` of `Dictionary` objects
    func getIssues(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
        
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            fatalError("Unable to create NSURL from string")
        }
        
        // Create a vanilla url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            // Print out the response (for debugging purpose)
//            print("Response: \(response)")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                fatalError("Error: \(error!.localizedDescription)")
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                fatalError("Data is nil")
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
                guard let issues = json as? [[String: AnyObject]] else {
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                // parse json
                for json in issues {
                    let title = json["title"] as? String
                    let user = json["user"] as? [String: AnyObject]
                    let username = user?["login"] as? String
                    let date = json["created_at"] as? String
                    let comment = json["comments"] as? Int
                    let body = json["body"] as? String
                    let url = json["html_url"] as? String
                    let status = json["state"] as? String
                    
                    self.openIssues.append(Issue(title: title, author: username, date: date, status: status, comment: comment, body: body, url: url))
                }
                // Call the completion block closure and pass the issues array of dictionaries as the argument to the
                // completion block.  This means that the code executed as part of the
                // completion block will have access to the `issues` data
                completion(issues)
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
    // MARK: - Segue
    // to prepare for the Issue Detail View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let idvc = segue.destination as? IssueDetailViewController
        let index = tableView.indexPathForSelectedRow?.row
        idvc?.passedIssueData = openIssues[index!]
    }
    
}

// Issue class stores the information of the issues
class Issue {
    var title: String?
    var author: String?
    var date: String?
    var status: String?
    var comment: String?
    var body: String?
    var url: String?
    
    init(title: String?, author: String?, date: String?, status: String?, comment: Int?, body: String?, url: String?) {
        self.title = title
        self.author = author
        self.comment = String(comment!)
        self.body = body
        self.status = status
        self.url = url
        
        // parse date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let dateObj = dateFormatter.date(from: date!)
        
        dateFormatter.dateFormat = "MM/dd HH:mm"
        // print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        self.date = dateFormatter.string(from: dateObj!)
    }
}
