//
//  ViewController.swift
//  BullsEye
//
//  Created by Cynthia on 23/01/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue: Int = 50 // this is to store the slider value, the value assigned here doesn't really matter. The initial value is set in Interface Builder.
    
    var targetValue: Int = 0 // target value, initial value 0 is never used. "randomized" every time. ": Int" can be removed
    
    var score = 0  // keep track of player's total score
    var round = 0  // keep track of the rounds the player has played
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewGame()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startNewRound() {  // function that start a new round every time
        round += 1   
        targetValue = 1 + Int(arc4random_uniform(100)) // arc4random_uniform generates whole numbers [0,100), targetValue ranges [1,100]
        currentValue = 50
        //        currentValue = lroundf(slider.value)  //use this line if don't want to reset the slider to halfway position
        slider.value = Float(currentValue)
        
    }
    
    func updateLabels() {  // update the labels for target value, score value and round everytime that starts a new round
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
    
    func startNewGame() {
        score = 0
        round = 0
        startNewRound()
    }
    
    @IBOutlet weak var slider: UISlider! // connects the slider object from storyboard to view controler's slider outlet, to reference the slider anywhere from within the view controller
    
    @IBOutlet weak var targetLabel: UILabel!  // ceate an outlet for the label so as to send it messages
    
    @IBOutlet weak var scoreLabel: UILabel!  // hook up the score label to an outlet and put the score value into the label’s text property
    
    @IBOutlet weak var roundLabel: UILabel!  // hook up the round label to an outlet and put the number of rounds into the label's text property
    
    @IBAction func showAlert() {
        
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference  //points got on this round
        
        let title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        score += points  //total score
        
        let message = "You scored \(points) points"
        let alert = UIAlertController(title: title,  //polished
                                      message: message,     // changed
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default,  // changed
                                   handler: { action in
                                    self.startNewRound()
                                    self.updateLabels()
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        startNewRound()
        updateLabels()
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
//        print("The value of the slider is now: \(slider.value)")
    }
    
    @IBAction func startOver() {
        startNewGame()
        updateLabels()
    }
    

}

