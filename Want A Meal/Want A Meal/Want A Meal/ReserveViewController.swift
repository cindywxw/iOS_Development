//
//  FirstViewController.swift
//  Want A Meal
//
//  Created by Cynthia on 20/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class ReserveViewController: UIViewController {
    
    @IBOutlet weak var time: UIDatePicker!
    
    @IBOutlet weak var peopleField: UITextField!
    
    @IBOutlet weak var guestField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    let defaults = UserDefaults.standard
    
    // attempting to make a reservation
    @IBAction func makeReservation(_ sender: Any) {
        var people = peopleField.text
        let guestName = guestField.text
        let phone = phoneField.text
        print("making a reservation...")
        if ((phone?.isEmpty)!) {
            showalert(userMessage: "Please leave a phone number, so that we can contact you.")
            print("reservation not made")
            return
        }
        if ((guestName?.isEmpty)!) {
            showalert(userMessage: "Please leave a preferred name, so that we can contact you.")
            print("reservation not made")
            return
//            guestName = "NA"
        }
        if ((people?.isEmpty)!) {
//            showalert(userMessage: "Please tell us the number of people coming, so that we can prepare the table ahead of time")
            people = "2"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:00"
        let date = dateFormatter.string(from: time.date)
        let rsvInfo = "Reservation made: " + date + ", with phone number: " + phone! + ", for " + people! + " people, under name: " + guestName!
        
        // store data
        if(Reachability.isConnectedToNetwork() == false) {
            showalert(userMessage: "Process interrupted. Not network available. Please try again later.")
            print("reservation not made")
            return
        }
        let myUrl = NSURL(string: "https://mpcs53001.cs.uchicago.edu/~cindywen/makeReservation.php")
        let request = NSMutableURLRequest(url: myUrl as! URL)
        request.httpMethod = "POST"
        let postString = "phone=\(phone!)&time=\(date)&underName=\(guestName!)&people=\(people!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        //        print(request.httpBody!)
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                //  print("error1: \(error)")
                self.showalert(userMessage: "Error in database connection")
                print("reservation not made")
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
                    print("Reservation: \(resultValue!)")

                    let messageToDisplay: String = parseJSON["message"] as! String
                    DispatchQueue.main.async {
                        let myAlert = UIAlertController(title: resultValue, message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil )
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated:true, completion:nil)
                        if (resultValue == "Success") {
                            print(rsvInfo)
                        }
                    }
                }
            } catch {
                print("error: \(error)")
                self.showalert(userMessage: "Error in parsing JSON, possibly duplicated reservation request.")
                print("reservation not made")
            }
            
        }
        //executing the task
        task.resume()
        
    }
    
    func showalert(userMessage:String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        print("Reservation not made")
        self.present(myAlert, animated:true, completion:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        // set the mindate as today
        let today = NSDate()
        let currentCalendar = NSCalendar.current
        let dateComponents = NSDateComponents()
        let mindate = currentCalendar.date(byAdding: dateComponents as DateComponents, to: today as Date)
//        dateByAddingComponents(dateComponents, toDate: today, options: [])!
        time.minimumDate = mindate

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


