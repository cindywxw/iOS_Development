//
//  ViewController.swift
//  It’s A Zoo in There
//
//  Created by Cynthia on 29/01/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var animalLabel: UILabel! // UILabel at the bottom of the screen
    
    var animalArray = [Animal]() // hold array of animals
    var imageArray = [UIImageView]() // array of imageviews for subviews
    var buttonArray = [UIButton] () // array of UIButtons for subviews
    var player = AVAudioPlayer() // to play sounds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 3 Animal elements
        let newDog = Animal(name:"Dogson", species: "dog", age: 2, image:UIImage(named: "dogImage.jpg")!, soundPath:"dog.mp3")
        let newCat = Animal(name:"Catty", species: "cat", age: 1, image:UIImage(named: "catImage.jpg")!, soundPath:"meow.mp3")
        let newHorse = Animal(name:"Horsee", species: "horse", age: 3, image:UIImage(named: "horseImage.jpg")!, soundPath:"horse.mp3")
        
        // load data in animal array
        animalArray.append(newDog)
        animalArray.append(newCat)
        animalArray.append(newHorse)
        
        // shuffle the Animal array, so the animals are arranged in a ddifferent order each time the app is lauched
        animalArray.shuffle()
        
        animalLabel.text = animalArray[0].name
        self.scrollView.contentSize = CGSize(width: 1125, height: 500)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        
        // create 3 subviews of UIButtons and 3 imageViews on top of them
        for i in 0...2 {
            // set the position based on the order/index
            imageArray.append(UIImageView(frame:CGRect(x: 375*i, y: 0, width: 375, height: 500)))
            imageArray[i].image = animalArray[i].image
            self.scrollView.addSubview(imageArray[i])
            
            // set the position based on the order/index
            buttonArray.append(UIButton(frame:CGRect(x: 150+375*i, y: 20, width: 75, height: 50)))
            self.buttonArray[i].setTitle(animalArray[i].name, for: UIControlState.normal)
            self.buttonArray[i].setTitleColor(UIColor.purple, for:.normal)
            self.buttonArray[i].tag = i // animal index
            self.buttonArray[i].addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            self.scrollView.addSubview(buttonArray[i])
        }
        
    }
    
    // buttonTapped() method to receive the touches from the buttons
    func buttonTapped(sender: UIButton!) {
        let tag = sender.tag
        
        // present the animal's name and age
        let alert = UIAlertController(title: animalArray[tag].name, message: "This \(animalArray[tag].species) is \(animalArray[tag].age) years old", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default,
                                   handler: nil)
        //            handler: { (action) in player.stop()})
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        // call the dumpAnimalObject() method to print the properties of the animal to console
        animalArray[tag].dumpAnimalObject()
        
        // play animal sound
        let animalSound = URL(fileURLWithPath: Bundle.main.path(forResource:animalArray[tag].soundPath, ofType: nil)!)
        do {
            player = try AVAudioPlayer(contentsOf: animalSound)
            player.play()
 
        } catch {
            print("Cannot play sound.")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Position: \(scrollView.contentOffset)")
        animalLabel.fadeOut() // previous name label fades out
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("Done moving")
        // update UILabel
        let i = Int(scrollView.contentOffset.x)/375
        animalLabel.text = animalArray[i].name
        animalLabel.fadeIn() // current name label fades in
    }
}


class Animal {
    // properties of Animal
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    let soundPath: String
    
    // Initialization
    init( name: String, species: String, age: Int, image: UIImage,soundPath: String) {
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
    }
    
    // print the attributes of Animal for debugging
    func dumpAnimalObject() {
        print("> Animal Object: name=\(name), species=\(species), age=\(age), image=\(image)")
    }
}


extension Array where Element: Animal {
    // shuffle in place method, randomly shuffles the contents of an array
    mutating func shuffle(){
        let c = self.count
        guard c > 1 else {
            return
        }
        for i in 0..<c{
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

// fadeIn and fadeOut method
/// Modified from Attributions: https://www.andrewcbancroft.com/2014/07/27/fade-in-out-animations-as-class-extensions-with-swift/
extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
