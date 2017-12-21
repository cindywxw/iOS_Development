//
//  ViewController.swift
//  TicTac
//
//  Created by Cynthia on 09/02/2017.
//  Copyright © 2017 Cynthia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var instrucButton: UIButton!
    @IBOutlet weak var howToPlay: UIView!
    @IBOutlet weak var cross: UIImageView!
    @IBOutlet weak var nought: UIImageView!
   
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view9: UIView!
    
    var viewArray = [UIView]()
    var imageArray = [UIImageView]() // keep track of added image, when restart, delete the images
    var player = AVAudioPlayer()
    var state = [0,0,0,0,0,0,0,0,0] // once symbol placed, the state at that place will change to the player number
    let winComb = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]] // the winning combinations
    var playing = true // true if the game is playing, false if it's finished
    var activePlayer = 1 // player 1=cross, 2=nought
    var turns = 1

    
    // once placed the X or O
//    @IBAction func placed(_ sender: AnyObject) {
//        if (state[sender.tag-1] == 0 && playing == true) {
//            state[sender.tag-1] = activePlayer
//            if (activePlayer == 1) {
//                sender.setImage(UIImage(named: "cross"), for: UIControlState())
//                activePlayer = 2
//            } else {
//                sender.setImage(UIImage(named: "nought"), for: UIControlState())
//                activePlayer = 1
//            }
//        }
//        
//    }

    @IBAction func playAgain() {
        state = [0,0,0,0,0,0,0,0,0]
        playing = true
        activePlayer = 1
        
//        replayButton.isHidden = true
//        whoWins.isHidden = true
        for i in imageArray {
            i.removeFromSuperview()
        }
        turnEffect(activePlayer)
    }
    
    @IBAction func ask(_ sender: Any) {
//        howToPlay.isHidden = false
       howToPlay.fallDown()
    }
    
    @IBAction func gotIt(_ sender: Any) {
//        howToPlay.isHidden = true
        howToPlay.fallOff()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewArray.append(view1)
        viewArray.append(view2)
        viewArray.append(view3)
        viewArray.append(view4)
        viewArray.append(view5)
        viewArray.append(view6)
        viewArray.append(view7)
        viewArray.append(view8)
        viewArray.append(view9)
        
//        howToPlay.isHidden = true
        cross.isUserInteractionEnabled = true
        nought.isUserInteractionEnabled = false
        turnEffect(activePlayer)
        let panGesture1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cross.addGestureRecognizer(panGesture1)
        nought.addGestureRecognizer(panGesture2)
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handlePan(_ recognizer:UIPanGestureRecognizer) {
//        let crossCenter = cross.center
//        print (crossCenter)
//        let noughtCenter = nought.center
//        let noughtCenter = CGPointMake(nought.width/2, nought.height/2)
        if recognizer.state == UIGestureRecognizerState.began {
            let rightSound = URL(fileURLWithPath: Bundle.main.path(forResource:"right.wav", ofType: nil)!)
            
            do {
                player = try AVAudioPlayer(contentsOf: rightSound)
                player.play()
                
            } catch {
                print("Cannot play sound.")
            }
        }
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == UIGestureRecognizerState.ended {
            if let view = recognizer.view {
                var checkedView = 0 // to keep track of views that have been tracked not intersecting, if all the views don't intersect, the image shouldn't be set
                for i in 0...8 {
                    if (view.frame.intersects(viewArray[i].frame)) {
                        if (state[i] != 0) { // if the view is already occupied, placing the symbol is forbidden
                            if (activePlayer == 1) {
                                view.frame =  CGRect(origin: CGPoint(x: 11,y :516), size: CGSize(width: 100, height: 100))
//                                view.center = crossCenter
                            } else {
//                                view.center = noughtCenter
                                view.frame =  CGRect(origin: CGPoint(x: 259,y :516), size: CGSize(width: 100, height: 100))
                            }
                            let buzzSound = URL(fileURLWithPath: Bundle.main.path(forResource:"buzzer.wav", ofType: nil)!)
                            do {
                                player = try AVAudioPlayer(contentsOf: buzzSound)
                                player.play()
                                
                            } catch {
                                print("Cannot play sound.")
                            }
                        //  if the view is not placed with any symbol before, place the symbol here
                        } else {
                            state[i] = activePlayer
//                            viewArray[i].setImage(UIImage(named: "cross"), for: UIControlState())
                            let newImage = UIImageView()
                            newImage.frame = viewArray[i].frame
                            if (activePlayer == 1) {
                                state[i] = 1
                                newImage.image = #imageLiteral(resourceName: "cross")
                            } else {
                                state[i] = 2
                                newImage.image = #imageLiteral(resourceName: "nought")
                            }
                            viewArray[i].superview?.addSubview(newImage)
                            imageArray.append(newImage)
                            
                            let placedSound = URL(fileURLWithPath: Bundle.main.path(forResource:"right.wav", ofType: nil)!)
                            do {
                                player = try AVAudioPlayer(contentsOf: placedSound)
                                player.play()
                                
                            } catch {
                                print("Cannot play sound.")
                            }
                            turns = turns + 1
//                            view.center = crossCenter
//                            view.center = noughtCenter
                            if (activePlayer == 1) {
//                                view.center = crossCenter
//                                cross.center = crossCenter
                                view.frame =  CGRect(origin: CGPoint(x: 11,y :516), size: CGSize(width: 100, height: 100))
                            } else {
//                                view.center = noughtCenter
//                                nought.center = noughtCenter
                                view.frame =  CGRect(origin: CGPoint(x: 259,y :516), size: CGSize(width: 100, height: 100))
                            }
                            activePlayer = 3 - activePlayer
                            
                            for comb in winComb {
                                
                                if state[comb[0]] != 0 && state[comb[0]] == state[comb[1]] && state[comb[1]] == state[comb[2]] {
                                    playing = false
                                    if state[comb[0]] == 1 {
                                        print("Cross wins!")
                                        // draw the line
                                        let linePath = UIBezierPath()
                                        linePath.move(to: viewArray[comb[0]].center)
                                        linePath.addLine(to: viewArray[comb[0]].center)
                                        linePath.close()
                                        UIColor.blue.set()
//                                        linePath.lineWidth = 10
                                        linePath.stroke()
                                         linePath.fill()
                                        showAlert(1)
                                    } else {
                                        // draw the line
                                        print("Nought wins!")
                                        let linePath = UIBezierPath()
                                        linePath.move(to: viewArray[comb[0]].center)
                                        linePath.addLine(to: viewArray[comb[0]].center)
                                        linePath.close()
                                        UIColor.blue.set()
//                                        linePath.lineWidth = 10
                                        linePath.stroke()
                                        linePath.fill()
                                        showAlert(2)
                                    }
//                                    replayButton.isHidden = false
//                                    whoWins.isHidden  = false
                                }
                            }
                            for i in state {
                                if i == 0 {
                                    playing = true
                                    break
                                }
                                playing = false
                            }
                            if playing == false {
//                                whoWins.text = "Draw!"
                                showAlert(3)
                            }
                            turnEffect(activePlayer)
                        }
                    } else {
                        // if the symbol is placed not in any uiview
                        checkedView = checkedView + 1
                        if checkedView == 9 {
                            if (activePlayer == 1) {
//                                view.center = cross.center
//                                view.center = crossCenter
//                                cross.center = crossCenter
                                view.frame =  CGRect(origin: CGPoint(x: 11,y :516), size: CGSize(width: 100, height: 100))
                            } else {
//                                view.center = nought.center
//                                view.center = noughtCenter
//                                nought.center = noughtCenter
                                view.frame =  CGRect(origin: CGPoint(x: 259,y :516), size: CGSize(width: 100, height: 100))
                            }
                            let buzzSound = URL(fileURLWithPath: Bundle.main.path(forResource:"buzzer.wav", ofType: nil)!)
                            do {
                                player = try AVAudioPlayer(contentsOf: buzzSound)
                                player.play()
                                
                            } catch {
                                print("Cannot play sound.")
                            }

                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func showAlert(_ winner: Int) {
        
        let title: String
        let message: String
        title = "Game over"
        if (winner == 1) {
            message = "X wins"
        } else if (winner == 2)  {
            message = "O wins"
        } else {
            message = "Draw"
        }
        
        let alert = UIAlertController(title: title,  //polished
            message: message,     // changed
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Game", style: .default,  // changed
            handler: { action in
                self.playAgain()
                
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
//        startNewRound()
    }
    // effect of enlarge and shrink symbol
    func turnEffect(_ player: Int) {
        if player == 1 {
            UIView.animate(withDuration: 1, animations: {
                self.cross.alpha = 1
                self.cross.transform = CGAffineTransform(scaleX: 2, y: 2)
                self.cross.isUserInteractionEnabled = true
                
                self.nought.alpha = 0.5
                self.nought.isUserInteractionEnabled = false
            }) { (finished) in
                    self.cross.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        } else if (player == 2) {
            UIView.animate(withDuration: 1, animations: {
                self.nought.alpha = 1
                self.nought.transform = CGAffineTransform(scaleX: 2, y: 2)
                self.nought.isUserInteractionEnabled = true
                
                self.cross.alpha = 0.5
                self.cross.isUserInteractionEnabled = false
            }) { (finished) in
                    self.nought.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }
        }
    }
}

extension UIView {
    func fallDown() {
        UIView.animate(withDuration: 0.8, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.center.y = self.frame.width
        }){ (finishd)in}
    }
    func fallOff() {
        UIView.animate(withDuration: 0.8, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.center.y = self.frame.width + 700
        }){ (finishd)in}
        
    }
}







