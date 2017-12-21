//
//  RegisterViewController.swift
//  Want A Meal
//
//  Created by Cynthia on 13/03/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userPhoneField: UITextField!
    
    @IBOutlet weak var userPasswordField: UITextField!
    
    @IBOutlet weak var repeatedPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    // attempting to register a new account
    @IBAction func registerTapped(_ sender: Any) {
        
        let userPhone = userPhoneField.text
        let userPassword = userPasswordField.text
        let repeatedPassword = repeatedPasswordField.text
        
        let defaults = UserDefaults.standard
//        if defaults.object(forKey: userPhone!) != nil {
//            showalert(userMessage: "Account already exists")
//            _ = navigationController?.popViewController(animated: true)
//            return
//        }
        
        
        // check for empty fields
        if((userPhone?.isEmpty)! || (userPassword?.isEmpty)! || (repeatedPassword?.isEmpty)!) {
            showalert(userMessage: "All fields are required")
            print("register fails")
            return
        }
        
        // check password matching
        if (userPassword != repeatedPassword) {
            showalert(userMessage: "Passwords do not match")
            print("register fails")
            return
        }
        
        
        // store data
        if(Reachability.isConnectedToNetwork() == false) {
            showalert(userMessage: "Process interrupted. Not network available. Please try again later.")
            print("register fails")
            return
        }
        let myUrl = NSURL(string: "https://mpcs53001.cs.uchicago.edu/~cindywen/userRegister.php")
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
//                print("error1: \(error)")
                self.showalert(userMessage: "Error in database connection")
                print("register fails")
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
                    print("registration: \(resultValue!)")
                    var isUserRegistered: Bool = false
                    if(resultValue == "Success") {
                        isUserRegistered = true
                    }
                    let messageToDisplay: String = parseJSON["message"] as! String
                    DispatchQueue.main.async {
                        let myAlert = UIAlertController(title: resultValue, message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default ) {
                            action in self.dismiss(animated: true, completion: nil)
                        }
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated:true, completion:nil)
                        if (isUserRegistered) {
                            // user registered
                            print("registered")
                            defaults.set(userPassword, forKey: userPhone!)
                            defaults.synchronize()
                        }
                    }
                }
            } catch {
                print("error: \(error)")
                self.showalert(userMessage: "Error in parsing JSON")
            }
            
        }
        //executing the task
        task.resume()

    }

    
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    func showalert(userMessage:String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        print("show alert")
        self.present(myAlert, animated:true, completion:nil)
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

