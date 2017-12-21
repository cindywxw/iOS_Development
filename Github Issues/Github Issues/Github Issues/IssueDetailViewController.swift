//
//  IssueDetailViewContoller.swift
//  Github Issues
//
//  Created by Cynthia on 06/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class IssueDetailViewController: UIViewController {


    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var createDate: UILabel!
    @IBOutlet weak var body: UITextView!
    var passedIssueData: Issue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.issueTitle?.text = passedIssueData?.title
//        self.photo?.image = passedIssueData?.status == "open" ? UIImage(named: "open") : UIImage(named: "closed")
//        self.username.text = passedIssueData?.author
        
        if let username = passedIssueData?.author {
            self.username.text = "User: \(username)"
        }
//        if let comment = passedIssueData?.comment {
//            self.comment.text = "Comments: \(comment)"
//        }
        self.body.text = passedIssueData?.body
        if let date = passedIssueData?.date {
            self.createDate.text = "Created at: \(date)"
        }
    }
    
    // MARK: - Share Button
    /// Open the url in safari

    @IBAction func pressButton(_ sender: Any) {
        if let url = URL(string: (passedIssueData?.url)!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
