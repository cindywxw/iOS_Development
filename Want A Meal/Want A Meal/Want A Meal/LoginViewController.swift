//
//  LoginViewController.swift
//  Want A Meal
//
//  Created by Cynthia on 13/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var show = 1
    @IBOutlet weak var userPhoneField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var logout: UIButton!
    
   
    @IBOutlet weak var infoText: UITextView!
    
    @IBOutlet weak var info: UIButton!
    @IBAction func infoButton(_ sender: Any) {
        print("show instruction")
        if(show == 1) {
            DispatchQueue.main.async {
                self.infoText.isHidden = false
                self.show = 0
            }
        }
        if(show == 0) {
            DispatchQueue.main.async {
            self.infoText.isHidden = true
            self.show = 1
            }
        }
        
    }
    // log out
    @IBAction func logoutTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey:"isUserLoggedIn")
        defaults.removeObject(forKey: "currentUser")
        defaults.synchronize()
        userLabel.text = ""
        greeting.isHidden = true
        userLabel.isHidden = true
        logout.isHidden = true
        print("logged out")
    }
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoText.isHidden = true

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
//        defaults.set(false, forKey: "isUserLoggedIn")
//        defaults.synchronize()
        var userLoggedIn = defaults.object(forKey: "isUserLoggedIn")
        userLoggedIn = false
        if (userLoggedIn as! Bool == false) {
            greeting.isHidden = true
            userLabel.isHidden = true
            logout.isHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // attempting to log in
    @IBAction func loginTapped(_ sender: Any) {
        let userPhone = userPhoneField.text
        let userPassword = userPasswordField.text
        let defaults = UserDefaults.standard
        
        // check for empty fields
        if((userPhone?.isEmpty)! || (userPassword?.isEmpty)!) {
            showalert(userMessage: "All fields are required")
            print("log in fails")
            return
        }
        
        // store data
//        if (!(defaults.object(forKey: userPhone!) != nil)) {
//            showalert(userMessage: "Account doesn't exist. Please double check the phone number or register a new account.")
//            return
//        }
//        
//        if defaults.object(forKey: userPhone!) as? String != userPassword {
//            showalert(userMessage: "Phone and password don't match. Please double check the account information.")
//            return
//            
//        }
        // store data
        if(Reachability.isConnectedToNetwork() == false) {
            showalert(userMessage: "Process interrupted. Not network available. Please try again later.")
            print("log in fails")
            return
        }
        
        let myUrl = NSURL(string: "https://mpcs53001.cs.uchicago.edu/~cindywen/userLogin.php")
        let request = NSMutableURLRequest(url: myUrl as! URL)
        request.httpMethod = "POST"
        let postString = "phone=\(userPhone!)&password=\(userPassword!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        //        print(request.httpBody!)
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                // print("error1: \(error)")
                self.showalert(userMessage: "Error in database connection")
                print("log in fails")
                return
            }
            
            if response != nil {
                print("response: \(response)")
            }
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    let resultValue = parseJSON["status"] as? String
                    print("Logging in: \(resultValue!)")
                    
                    let messageToDisplay: String = parseJSON["message"] as! String
                    DispatchQueue.main.async {
                        if(resultValue == "Success") {
                            // log in successfully
                            defaults.set(true, forKey: "isUserLoggedIn")
                            defaults.set(userPhone,forKey:"currentUser")
                            defaults.synchronize()
                            print("logged in")
                            self.userPhoneField.text = ""
                            self.userPasswordField.text = ""
                            self.greeting.isHidden = false
                            self.userLabel.isHidden = false
                            self.userLabel.text = "Log in with phone number: " + userPhone!
                            self.logout.isHidden = false
                            self.view.endEditing(true)
                        }
                        let myAlert = UIAlertController(title: resultValue, message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated:true, completion:nil)
                    }
                }
            } catch {
                print("error: \(error)")
                self.showalert(userMessage: "Error in parsing JSON")
                print("log in fails")
            }
            
        }
        //executing the task
        task.resume()
        
    
    }
    func showalert(userMessage:String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        print("show alert")
        self.present(myAlert, animated:true, completion:nil)
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


