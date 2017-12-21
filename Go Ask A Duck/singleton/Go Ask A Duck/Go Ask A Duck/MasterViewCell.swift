//
//  MasterViewCell.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 18/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class MasterViewCell: UITableViewCell {

    @IBOutlet weak var Url: UILabel!
    
    
    @IBOutlet weak var Content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
