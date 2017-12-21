//
//  MenuViewCell.swift
//  Want A Meal
//
//  Created by Cynthia on 12/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {

    
    @IBOutlet weak var dishname: UILabel!
    
    @IBOutlet weak var dishPhoto: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var quantityField: UITextField!
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
