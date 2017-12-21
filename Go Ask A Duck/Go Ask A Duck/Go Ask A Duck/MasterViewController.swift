//
//  MasterViewController.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 18/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    let NBColor = UIColor(red:255/255.0, green: 80/255.0, blue: 80/255.0, alpha:1.0)
    
    @IBAction func nightMode(_ sender: Any) {
        
        let mode = defaults.string(forKey: "nightmode")!

        if (mode == "normal") {
//            navigationController?.navigationBar.barTintColor = UIColor.darkGray
//            UINavigationBar.appearance().barTintColor = UIColor.darkGray
//            UINavigationBar.appearance().tintColor = UIColor.white
//            UISearchBar.appearance().barTintColor = NBColor
//            UISearchBar.appearance().tintColor = UIColor.black
//            UIToolbar.appearance().barTintColor = NBColor
//            UIToolbar.appearance().tintColor = UIColor.blue
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.barTintColor = UIColor.darkGray
            searchBar.barTintColor = UIColor.darkGray
            searchBar.tintColor = UIColor.white
//            cell.backgroundColor = UIColor.darkGray
//            cell.Url?.textColor = UIColor.white
//            cell.Content?.textColor = UIColor.white
//            tableView.backgroundColor = UIColor.darkGray
//            tableView.tintColor = UIColor.white
            
//            self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
            //            webView.backgroundColor = UIColor.clear
            //            webView.isOpaque = false
            defaults.set("night", forKey: "nightmode")
        } else {
//            UINavigationBar.appearance().barTintColor = NBColor
//            UINavigationBar.appearance().tintColor = UIColor.black
//            UISearchBar.appearance().barTintColor = NBColor
//            UISearchBar.appearance().tintColor = UIColor.black
//            UIToolbar.appearance().barTintColor = NBColor
//            UIToolbar.appearance().tintColor = UIColor.blue
            
            navigationController?.navigationBar.barTintColor = NBColor
            navigationController?.navigationBar.tintColor = UIColor.white
            searchBar.barTintColor = NBColor
            searchBar.tintColor = UIColor.black
//            cell.backgroundColor = UIColor.white
//            cell.Url?.textColor = UIColor.black
//            cell.Content?.textColor = UIColor.black
            //            self.view.backgroundColor = UIColor.white
            //            webView.backgroundColor = UIColor.white
            //            webView.isOpaque = true
            defaults.set("normal", forKey: "nightmode")
        }

    }
    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var Url: UILabel!
//    @IBOutlet weak var Content: UITextField!
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
//        let proxyNavig = UINavigationBar.appearance()
//        let mode = defaults.string(forKey: "nightmode") ?? "normal"
////        print(mode)
//        if (mode == "normal") {
//            UINavigationBar.appearance().barTintColor = NBColor
//            UINavigationBar.appearance().tintColor = UIColor.black
//            UISearchBar.appearance().barTintColor = NBColor
//            UISearchBar.appearance().tintColor = UIColor.black
//        } else {
//            UINavigationBar.appearance().barTintColor = UIColor.darkGray
//            UINavigationBar.appearance().tintColor = UIColor.white
//            UISearchBar.appearance().barTintColor = UIColor.darkGray
//            UISearchBar.appearance().tintColor = UIColor.white
//           
//        }
//        defaults.set("normal", forKey:"nightnode")
        var lastQuery: String?
        if (defaults.string(forKey: "lastQuery") != nil) {
            lastQuery = defaults.string(forKey: "lastQuery")
        } else {
            lastQuery = "apple"
        }
        let urlString = "https://api.duckduckgo.com/?q=\(lastQuery!)&format=json&pretty=1"
        configSearch(url: urlString) { (dictOfTopics) in
            
            // Reload the table.  The tables data source should be the property you copied the
            // issues to (above). Remember to refresh the table on the main thread
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                //tableView.reload()
                self.tableView.reloadData()
            }
        }
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        let mode = defaults.string(forKey: "nightmode") ?? "normal"
        //        print(mode)
        if (mode == "normal") {
            navigationController?.navigationBar.barTintColor = NBColor
            navigationController?.navigationBar.tintColor = UIColor.black
            searchBar.barTintColor = NBColor
            searchBar.tintColor = UIColor.black
//            UINavigationBar.appearance().barTintColor = NBColor
//            UINavigationBar.appearance().tintColor = UIColor.black
//            UISearchBar.appearance().barTintColor = NBColor
//            UISearchBar.appearance().tintColor = UIColor.black
//            UIToolbar.appearance().barTintColor = NBColor
//            UIToolbar.appearance().tintColor = UIColor.blue
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.darkGray
            navigationController?.navigationBar.tintColor = UIColor.white
            searchBar.barTintColor = UIColor.darkGray
            searchBar.tintColor = UIColor.white
//            UINavigationBar.appearance().barTintColor = UIColor.darkGray
//            UINavigationBar.appearance().tintColor = UIColor.white
//            UISearchBar.appearance().barTintColor = UIColor.darkGray
//            UISearchBar.appearance().tintColor = UIColor.white
//            UIToolbar.appearance().barTintColor = UIColor.darkGray
//            UIToolbar.appearance().tintColor = UIColor.white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
                let object = objects[indexPath.row] as! topic
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
//                print(object.url)
                controller.url = object.url
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                defaults.set(object.url, forKey: "lastView")
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterViewCell

        let object = objects[indexPath.row] as! topic
//        if (object.url != nil) {
            cell.Url?.text = object.url
//            print(object.url)
            cell.Content?.text = object.content
//        }
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        return cell
    }

    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }*/
    
//    let queryWord = searchBar.text

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
    
    @IBAction func showAlert() {
        
        let title: String
        let message: String
        title = "Can't open...Try again later"
        message = "There might be some problem on the connection."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
  
    }


}


extension MasterViewController: UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("Search Bar Button Clicked \()")
        defaults.set(searchBar.text, forKey: "lastQuery")
        let newUrl = "https://api.duckduckgo.com/?q=\(searchBar.text!)&format=json&pretty=1"
//        print(newUrl)
        configSearch(url: newUrl) { (relatedTopics) in
//            print(relatedTopics)
            // Reload the table.  The tables data source should be the property you copied the
            // issues to (above). Remember to refresh the table on the main thread
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                //tableView.reload()
                self.tableView.reloadData()
            }
        }
        self.searchBar.endEditing(true)
    }
    // live search by the text entered into the bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // updated with each character typed
//        print("searchText \(searchText)")
    }
    
}

class UIProgressView: UIView {
    // initialization
    override init (frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.black
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle
    override func didMoveToSuperview() {
        frame = superview!.frame
        
        //        let square = UIView(frame: CGRectMake(0,0,300,300))
        /// attribute: https://medium.com/swift-programming/swift-cgrect-cgsize-cgpoint-5f4196da9cf8#.5kas85r9u
        let sqView = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 300, height: 300))
        let square = UIView(frame: sqView)
        square.backgroundColor = UIColor.red
        square.center = superview!.center
        square.isUserInteractionEnabled = true
        square.alpha = 0.5
        self.addSubview(square)
    }
    
}

class topic {
    var url: String?
    var content: String?
    
    init(url: String?, content: String?) {
        self.url = url
        self.content = content
    }
}


