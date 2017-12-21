//
//  ProgressView.swift
//  Go Ask A Duck
//
//  Created by Cynthia on 19/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import Foundation

class ProgressView: UIView {

   // attribute: https://coderwall.com/p/su1t1a/ios-customized-activity-indicator-with-swift

    override init (frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func didMoveToSuperview() {
        frame = superview!.frame
        
        let square = UIView(frame: CGRect(x: 150, y: 150, width: 10, height: 10))
        square.backgroundColor = UIColor.white
        square.center = superview!.center
        square.isUserInteractionEnabled = true
        square.alpha = 0.5
        self.addSubview(square)
    }
}
