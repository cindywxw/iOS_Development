//
//  MenuViewController.swift
//  Want A Meal
//
//  Created by Cynthia on 09/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var menu = [dish]()
//    var orders = [order]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        
        // menu stores all the dishes
        menu.append(dish(name:"Bean and beef", price:9.0, image:#imageLiteral(resourceName: "beanandbeef")))
        menu.append(dish(name:"Roast pork", price:8.5, image:#imageLiteral(resourceName: "chashao")))
        menu.append(dish(name:"Pineapple bread", price: 2.5,image:#imageLiteral(resourceName: "boluobao")))
        menu.append(dish(name:"Roast pork bread", price:2.5, image: #imageLiteral(resourceName: "chashaobao")))
        menu.append(dish(name:"Curry beef", price: 8.5, image: #imageLiteral(resourceName: "currybeef")))
        menu.append(dish(name:"Hainan chicken", price: 9.5,image: #imageLiteral(resourceName: "hainanchicken")))
        menu.append(dish(name:"Lemon chicken", price: 9.0, image:#imageLiteral(resourceName: "lemonchicken")))
        menu.append(dish(name:"Mongo pudding", price: 4.0, image: #imageLiteral(resourceName: "mangopudding")))
        menu.append(dish(name:"Mapo tofu", price: 8.5, image: #imageLiteral(resourceName: "mapotoufu")))
        menu.append(dish(name:"Pork chop", price: 9.0,image: #imageLiteral(resourceName: "porkchop")))
        menu.append(dish(name:"Red bean icing", price: 4.5, image:#imageLiteral(resourceName: "redbeanicing")))
        menu.append(dish(name:"Rice chicken", price: 9.5, image: #imageLiteral(resourceName: "ricechicken")))
        menu.append(dish(name:"Rice noodle roll", price: 8.0,image: #imageLiteral(resourceName: "ricenoodlerool")))
        menu.append(dish(name:"Sanbao Rice", price: 8.5,image: #imageLiteral(resourceName: "sanbao")))
        menu.append(dish(name:"Shredded pork", price: 9.5, image: #imageLiteral(resourceName: "shreddedpork")))
        menu.append(dish(name:"Shrimp and egg", price: 9.0, image: #imageLiteral(resourceName: "shrimpegg")))
        menu.append(dish(name:"Tomato and beef", price: 9.5,image:#imageLiteral(resourceName: "tomatoandbeef")))
        menu.append(dish(name:"Genaral Tso's chicken", price: 9.5,image: #imageLiteral(resourceName: "zuozongtangchicken")))
        
        defaults.set(false, forKey:"isUserLoggedIn")
        defaults.synchronize()
    
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
        return menu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuViewCell
//        print("cell touched")
        // Configure the cell...        
        cell.dishname?.text = menu[indexPath.row].name
        cell.dishPhoto?.image = menu[indexPath.row].image
        cell.price.text = "$\(menu[indexPath.row].price!.description)"
        
        return cell
    }
 
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = tableView.indexPathForSelectedRow?.row
//        //        let row = 7 //or what you set
//        let cellWhereIsTheLabel = tableView.cellForRow(at: IndexPath(row: index!, section: 0)) as! MenuViewCell
//        
//        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissImage"))
//        cellWhereIsTheLabel.dishPhoto.isUserInteractionEnabled = true
//        cellWhereIsTheLabel.dishPhoto.addGestureRecognizer(tap)
//        //            self.view.addSubview(imageview)
//    }
//
//    func dismissImage(sender: UITapGestureRecognizer) {
//        //        sender.view?.transform = CGAffineTransform.identity
//        //        let tappedImageView = sender.view!
//        //        imageview.removeFromSuperview()
//        let myCell = sender.view as! MenuViewCell
//        var imageview = UIImageView(image: myCell.dishPhoto.image)
//        if (zoom == 1) {
//            imageview.frame = self.view.frame
//            imageview.contentMode = .scaleAspectFill
//            self.view.addSubview(imageview)
//            zoom = 0
//        }
//        if (zoom == 0) {
//            imageview.removeFromSuperview()
//            imageview.image = nil
//        }
//        
//    }
    

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
