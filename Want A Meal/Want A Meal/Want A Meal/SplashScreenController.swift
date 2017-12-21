//
//  LaunchViewController.swift
//  Want A Meal
//
//  Created by Cynthia on 15/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        perform(#selector(showTabBarController), with: nil, afterDelay: 2)
    }

    func showTabBarController() {
        performSegue(withIdentifier: "SplashScreenController", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
