//
//  BookmarkViewController.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 18/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController {
    
    // attribute: https://developer.apple.com/reference/foundation/userdefaults
    let defaults = UserDefaults.standard
    var bookmarks = [String]()
    weak var delegate: DetailBookmarkDelegate?
    weak var star: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        if (defaults.object(forKey: "favorite")
//        let urlArray = defaults.object(forKey: "favorite") as! [String]
        var favorite = defaults.object(forKey: "favorite") as? [String] ?? [String]()
        let count = favorite.count
        if(count > 0) {
            print(count)
            for i in 0...count-1 {
                bookmarks.append(favorite[i])
            }
        } else {
            print("empty bookmark list")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)

        // Configure the cell...
//        for i in bookmarks {
//            print(i)
//        }
//        let url = urlArray[indexPath.row] as! String
        cell.textLabel?.text = bookmarks[indexPath.row]
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let url = bookmarks[indexPath.row]
//            print("test")
//            print(url)
            bookmarks.remove(at: indexPath.row)
            star.removeFromSuperview()
            var favorite = defaults.object(forKey: "favorite") as? [String] ?? [String]()
            let idx = favorite.index(of: url)
            favorite.remove(at: idx!)
            defaults.set(favorite, forKey: "favorite")
            defaults.synchronize()
            let count = favorite.count
            if(count > 0) {
                print("deleted, now ")
                print(count)
            } else {
                print("empty bookmark list")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentingViewController?.dismiss(animated: true, completion: nil)
        var favorite = defaults.object(forKey: "favorite") as? [String] ?? [String]()
        let url = favorite[indexPath.row]
//        self.dismiss(animated: true, completion: nil)
        delegate?.bookmarkPassedURL(url: url)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
