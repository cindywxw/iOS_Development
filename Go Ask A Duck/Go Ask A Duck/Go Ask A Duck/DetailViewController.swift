//
//  DetailViewController.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 18/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {
    
    let defaults = UserDefaults.standard
    let NBColor = UIColor(red:255/255.0, green: 80/255.0, blue: 80/255.0, alpha:1.0)
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet var loading: UIView!
    @IBAction func nightMode(_ sender: Any) {
        
        let mode = defaults.string(forKey: "nightmode")!
        print("detail: " + mode)
        
        
        if (mode == "normal") {
            navigationController?.navigationBar.barTintColor = UIColor.darkGray
            navigationController?.navigationBar.tintColor = UIColor.white
//            self.view.backgroundColor = UIColor.darkGray
//            webView.backgroundColor = UIColor.clear
//            webView.isOpaque = false
            favBar.barTintColor = UIColor.darkGray
            favBar.tintColor = UIColor.white
            
            defaults.set("night", forKey: "nightmode")
        } else {
            navigationController?.navigationBar.barTintColor = NBColor
            navigationController?.navigationBar.tintColor = UIColor.white
//            self.view.backgroundColor = UIColor.white
//            webView.backgroundColor = UIColor.white
//            webView.isOpaque = true
            favBar.barTintColor = NBColor
            favBar.tintColor = UIColor.blue
            
            defaults.set("normal", forKey: "nightmode")
        }
    
        
    }
    
    @IBOutlet var star: UIImageView!
    var url: String?
    var detailItem: topic?
  
    @IBOutlet weak var favBar: UIToolbar!
    
    @IBAction func addFavorite(_ sender: UIBarButtonItem) {
        var favorite = defaults.object(forKey: "favorite") as? [String] ?? [String]()
        if (!favorite.contains(url!)) {
            favorite.append(url!)
            defaults.set(favorite, forKey: "favorite")
            defaults.synchronize()
            print("star added")
            star.isHidden = false
            self.view.addSubview(star)
            self.view.bringSubview(toFront:star)
            
        }
//        let arrays = defaults.object(forKey: "favorite") as? [String] ?? [String]()
//        let count = arrays.count
//        if (count > 0) {
//            print(count)
//            for i in arrays {
//                print("bookmark: ")
//                print(i)
//            }
//        } else {
//            print("empty")
//        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.

        if url == nil {
            if let lastQuery = defaults.string(forKey: "lastView") {
                url = lastQuery
            } else {
                url = "https://duckduckgo.com/Apple"
            }
            
        }
        webView.scalesPageToFit = true
        webView.contentMode = .scaleToFill
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        defaults.set(url, forKey: "lastView")
        self.view.addSubview(webView)
        self.view.bringSubview(toFront: webView)
        let favorite = defaults.object(forKey: "favorite") as? [String] ?? [String]()
        print("OPENED: " + url!)
        if (favorite.contains(url!)) {
            print("star added")
            star.isHidden = false
            self.view.addSubview(star)
            self.view.bringSubview(toFront:star)
        } else {
            print("not favorite")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        star.isHidden = true
        loading.isHidden = true

        self.configureView()
        webView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        let mode = defaults.string(forKey: "nightmode") ?? "normal"
        //        print(mode)
        if (mode == "normal") {
            navigationController?.navigationBar.barTintColor = NBColor
            navigationController?.navigationBar.tintColor = UIColor.black
            favBar.barTintColor = NBColor
            favBar.tintColor = UIColor.blue
//            UINavigationBar.appearance().barTintColor = NBColor
//            UINavigationBar.appearance().tintColor = UIColor.black
//            UISearchBar.appearance().barTintColor = NBColor
//            UISearchBar.appearance().tintColor = UIColor.black
//            UIToolbar.appearance().barTintColor = NBColor
//            UIToolbar.appearance().tintColor = UIColor.blue
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.darkGray
            navigationController?.navigationBar.tintColor = UIColor.white
            favBar.barTintColor = UIColor.darkGray
            favBar.tintColor = UIColor.white
//            UINavigationBar.appearance().barTintColor = UIColor.darkGray
//            UINavigationBar.appearance().tintColor = UIColor.white
//            UISearchBar.appearance().barTintColor = UIColor.darkGray
//            UISearchBar.appearance().tintColor = UIColor.white
//            UIToolbar.appearance().barTintColor = UIColor.darkGray
//            UIToolbar.appearance().tintColor = UIColor.white
        }
    }

    
    // MARK: - Segue
    // to prepare for the Issue Detail View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToBookmarks" {
            let bvc = segue.destination as! BookmarkViewController
            bvc.delegate = self
            bvc.star = star
//            print("prepared")
        }
    }

    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.center = self.view.center
        loading.isHidden = false
        //        activity.isHidden = false
        //        activity.center = self.view.center
        self.view.bringSubview(toFront: loading)
        activity.startAnimating()
//        self.view.addSubview(loading)
    }
    func endLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        loading.removeFromSuperview()
        activity.stopAnimating()
        loading.isHidden = true
        self.view.sendSubview(toBack: loading)

    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("start")
        startLoading()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finish")
        endLoading()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showAlert()
        endLoading()
    }
    func showAlert() {
        
        let title: String
        let message: String
        title = "Can't open.Try again later"
        message = "There might be some problem on the connection."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

// implement the 'DetailBookmarkDelegate' methods
extension DetailViewController: DetailBookmarkDelegate {
    func bookmarkPassedURL(url: String) {

        webView.scalesPageToFit = true
        webView.contentMode = .scaleToFill
        webView.loadRequest(URLRequest(url: URL(string: url)!))
        self.view.addSubview(webView)
        self.view.bringSubview(toFront: webView)
//        print("We passed \(url) from the bookmark view controller to the detail view controller")
        let favorite = defaults.object(forKey: "favorite") as? [String] ?? [String]()
        print("OPENED: "+url)
        if (favorite.contains(url)) {
            print("star added")            
            star.isHidden = false
            self.view.addSubview(star)
            self.view.bringSubview(toFront:star)
            
        } else {
            print("not favorite")
        }
    }
}

