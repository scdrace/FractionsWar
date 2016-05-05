//
//  SwipeLogic.swift
//  FractionsWar
//
//  Created by David Race on 3/31/16.
//
//

import Foundation
import UIKit

extension GameViewController {
    
    /*
    func manualSwipe(sender: AnyObject?) {
        
        //Get highHand for round
        let highHand = game.getRound().highHand
        
        //Get appropriate UIGestureRecognizer and call swipeGesture()
        func foo(gestArray: [UIGestureRecognizer], direction: UISwipeGestureRecognizerDirection) {
            for item in gestArray {
                let gesture = item as! UISwipeGestureRecognizer
                if gesture.direction == direction {
                    swipeGesture(gesture)
                }
            }
        }
        
        switch highHand {
            case "even":
                if sender === p1WarButton {
                    foo(p1AreaH.gestureRecognizers!, direction: UISwipeGestureRecognizerDirection.Left)
                }
                else if sender === 2 {
                    foo(p2AreaH.gestureRecognizers!, direction: UISwipeGestureRecognizerDirection.Right)
            }
            break
        default:
            if sender === p1WarButton {
                foo(p2AreaH.gestureRecognizers!, direction: UISwipeGestureRecognizerDirection.Right)
            }
            else if sender === p1WarButton {
                foo(p1AreaH.gestureRecognizers!, direction: UISwipeGestureRecognizerDirection.Left)
            }
        
            break
            
        }

    }
    */
    
    
    /*
     //Add point for swipe
     func points(sender: UISwipeGestureRecognizer) {
     
     let highHand = game.getRound().highHand
     let swipeDirection = sender.direction
     
     func assignCorrectPoints() {
     
     let touchedView = sender.view
     
     switch touchedView {
     case _ where touchedView == self.p1AreaX:
     game.getPlayer1().addPoints(1)
     break
     case _ where touchedView == self.p1AreaH:
     game.getPlayer1().addPoints(1)
     break
     case _ where touchedView == self.p2AreaX:
     game.getPlayer2().addPoints(1)
     break
     case _ where touchedView == self.p2AreaH:
     game.getPlayer2().addPoints(1)
     break
     default:
     break
     }
     }
     
     func assignIncorrectPoints() {
     
     let touchedView = sender.view
     
     switch touchedView {
     case _ where touchedView == self.p1AreaX:
     game.getPlayer2().addPoints(1)
     break
     case _ where touchedView == self.p1AreaH:
     game.getPlayer2().addPoints(1)
     break
     case _ where touchedView == self.p2AreaX:
     game.getPlayer1().addPoints(1)
     break
     case _ where touchedView == self.p2AreaH:
     game.getPlayer1().addPoints(1)
     break
     default:
     break
     }
     }
     
     switch swipeDirection {
     // Correct Swipes
     case UISwipeGestureRecognizerDirection.Right where highHand == "player2": assignCorrectPoints()
     case UISwipeGestureRecognizerDirection.Left where highHand == "player1": assignCorrectPoints()
     // Incorrect Swipes
     case UISwipeGestureRecognizerDirection.Right where highHand == "player1": assignIncorrectPoints()
     case UISwipeGestureRecognizerDirection.Left where highHand == "player2": assignIncorrectPoints()
     
     case UISwipeGestureRecognizerDirection.Right where highHand == "tie": assignIncorrectPoints()
     case UISwipeGestureRecognizerDirection.Left where highHand == "tie": assignIncorrectPoints()
     default: break
     }
     
     }
     */
    
    
    /*
     //The logic that moves the cards
     func move(sender: UISwipeGestureRecognizer) {
     
     let swipeDirection = sender.direction
     let cardPorts = getCardPorts
     
     func moveHorizontal(distance: CGFloat) {
     for port in cardPorts {
     port.center.x += distance
     }
     }
     
     func moveVertical(distance: CGFloat) {
     for port in cardPorts {
     port.center.y += distance
     }
     }
     
     func animation(direction: (CGFloat)->(), distanceAway: CGFloat, distanceBack: CGFloat) {
     
     UIView.animateWithDuration(0.8,
     animations: {
     direction(distanceAway)
     },
     completion: {
     finished in
     
     self.game.flipDown()
     self.setupCards()
     self.cardsAreUp = false;
     direction(distanceBack)
     }
     )
     }
     
     switch swipeDirection {
     case UISwipeGestureRecognizerDirection.Up:
     animation(moveVertical, distanceAway: -moveDistance, distanceBack: moveDistance)
     case UISwipeGestureRecognizerDirection.Down:
     animation(moveVertical, distanceAway: moveDistance, distanceBack: -moveDistance)
     case UISwipeGestureRecognizerDirection.Left:
     animation(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
     case UISwipeGestureRecognizerDirection.Right:
     animation(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
     default:
     break
     }
     }
     */
    
    
    func computerSwipe() {
        
        let highHand = game.getRound().highHand


        func foo(direction: UISwipeGestureRecognizerDirection) {
            for item in p2AreaH.gestureRecognizers! {
                let gesture = item as! UISwipeGestureRecognizer
                if gesture.direction == direction {
                    swipeGesture(gesture)
                }
            }
        }
        
        //Get the UISwipeGestureRecognizer that represents a correct swipe
        switch highHand {
        case "player1":
            foo(.Left)
            break
        case "player2":
            foo(.Right)
            break
        default:
            break
        }
    }
    

    
    
    func playerToAnswer(sender: AnyObject) -> String {
        
        if sender is UISwipeGestureRecognizer {
            let x = sender as! UISwipeGestureRecognizer
            
            if x.view == p1AreaH {return "player1"}
            else if x.view == p2AreaH {return "player2"}
        }
        else if sender === p1WarButton {return "player1"}
        else if sender === p2WarButton {return "player2"}
        
        return "error"
    }
    
    
    
    func playerResponse(sender: AnyObject) -> String {
        
        if sender is UISwipeGestureRecognizer {
            let x = sender as! UISwipeGestureRecognizer
            if x.direction == .Right {return "right"}
            if x.direction == .Left {return "left"}
        }
        else if sender === p1WarButton {return "p1WarButton"}
        else if sender === p2WarButton {return "p2WarButton"}
        
        return "error"
        
    }
    
    
    //Return a Bool indicating whether the answer (swipe/tap) was correct
    func answerAnalysis(sender: AnyObject) -> Bool {
        
        
        
        let highHand = game.getRound().highHand
        
        
        //Analysis if gesture was a swipe
        func swipe(sender: UISwipeGestureRecognizer) -> Bool {
            let swipeDirection = sender.direction
            print("Swipe!: \(highHand), \(sender.direction)")
            switch swipeDirection {
            // Correct Swipes
            case UISwipeGestureRecognizerDirection.Right where highHand == "player2":
                print("A")
                return true
            case UISwipeGestureRecognizerDirection.Left where highHand == "player1":
                print("B")
                return true
            // Incorrect Swipes
            case UISwipeGestureRecognizerDirection.Right where highHand == "player1":
                print("C")
                return false
            case UISwipeGestureRecognizerDirection.Left where highHand == "player2":
                print("D")
                return false
                
            case UISwipeGestureRecognizerDirection.Right where highHand == "tie": return false
            case UISwipeGestureRecognizerDirection.Left where highHand == "tie": return false
            default: break
            }
            return false
        }
        
        //Analysis if gesture was a tap (Declare-War Buttons)
        func tap(sender: UIButton) -> Bool {
            
            switch highHand {
            case "tie":
                if sender === p1WarButton {return true}
                else if sender === p1WarButton {return true}
            default:
                if sender == p1WarButton {return false}
                else if sender == p1WarButton {return false}
            }
            return false
        }
        
        //Determine whether gesture was a swipe or tap (Declare-War Buttons)
        if sender is UISwipeGestureRecognizer {
            let x = sender as! UISwipeGestureRecognizer
             return swipe(x)
        }
        else if sender is UIButton {
            let x = sender as! UIButton
             return tap(x)
        }
        
        return false
    }

    
    func assignPoints(player: String, correctAnswer: Bool) {
        print("XPAC0: \(player), \(correctAnswer)")
        switch player {
        case "player1":
            if correctAnswer == true {
                print("XPAC1")
                game.getPlayer1().addPoints(1)}
            else if correctAnswer == false {game.getPlayer2().addPoints(1)}
            break
        case "player2":
            if correctAnswer == true {game.getPlayer2().addPoints(1)}
            else if correctAnswer == false {game.getPlayer1().addPoints(1)}
        default:
            break
        }
        
    }
    
    
    
    func move(player: String, playerResponse: String, correctAnswer: Bool) {
        //let swipeDirection = sender.direction
        let cardPorts = getCardPorts
        
        func moveHorizontal(distance: CGFloat) {
            for port in cardPorts {
                port.center.x += distance
            }
        }
        
        func moveVertical(distance: CGFloat) {
            for port in cardPorts {
                port.center.y += distance
            }
        }
        
        func animation(direction: (CGFloat)->(), distanceAway: CGFloat, distanceBack: CGFloat) {
            
            UIView.animateWithDuration(0.8,
                                       animations: {
                                        direction(distanceAway)
                },
                                       completion: {
                                        finished in
                                        
                                        self.game.flipDown()
                                        self.setupCards()
                                        self.cardsAreUp = false;
                                        direction(distanceBack)
                }
            )
        }
        
        switch playerResponse {
        case "up":
            animation(moveVertical, distanceAway: -moveDistance, distanceBack: moveDistance)
            break
        case "down":
            animation(moveVertical, distanceAway: moveDistance, distanceBack: -moveDistance)
            break
        case "left":
            animation(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
            break
        case "right":
            animation(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
            break
        case "p1WarButton":
            animation(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
            break
        case "p2WarButton":
            animation(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
            break
        default:
            break
        }
    }

    
    
    
    
    //Calls appropriate functions when swipe occurs
    @IBAction func swipeGesture(sender: AnyObject) {
        
        if (!cardsAreUp) {
            return
        }
        
        // Stop the computer timer
        // Maybe make the timer optional, so that it does not exist for one player mode
        computerTimer.invalidate()
        
        // Calculate the time it takes to swipe the cards
        let swipeTime = CACurrentMediaTime() - roundStartTime
        print("SwipeTime: \(swipeTime)")
        
        
        //Who answered
        let player = playerToAnswer(sender)
        
        //What was their answer
        let answer = playerResponse(sender)
        
        //Is the swipe/tap correct
        let correctAnswer: Bool = answerAnalysis(sender)
        print("CorrectAnswer: \(correctAnswer)")
        //Assign Points
        assignPoints(player, correctAnswer: correctAnswer)
        
        
        // Calculate points
        //points(sender)
        
        // TODO: Collect data from round
        game.addRoundData(swipeTime)
        
        //var u = gameData.GameRound(player1Numerator: game.getP1Numerator())
        
        //var data = ["player1Numerator": game.getP1Numerator()]
        
        //var u = gameData.getGameRound()
        //u.player1Numerator = game.getP1Numerator()
        
        //Animate the cards
        //move(sender)
        move(player, playerResponse: answer, correctAnswer: correctAnswer)
    }
}
