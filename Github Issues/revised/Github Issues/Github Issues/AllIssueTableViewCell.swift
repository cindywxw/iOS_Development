//
//  AllIssueTableViewCell.swift
//  Github Issues
//
//  Created by Cynthia on 06/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class AllIssueTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
