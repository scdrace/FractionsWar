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
    
    /**
     Sends computer swipe
     */
    func computerSwipe() {
        
        let highHand = game.getRound().highHand

        /**
         Initiates swipe depending on the gesture
         - Parameter direction: the swipe direction
         */
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

    /**
     Returns String representation of player who responded
     - Parameter sender: AnyObject that sent response
     - Returns: String
     */
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
    
    /**
     Returns String representation of player's response
     - Parameter sender: AnyObject that sent response
     - Returns: String
     */
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
    
    /**
     Return a Bool indicating whether the answer (swipe/tap) was correct
     - Parameter sender: AnyObject that sent response
     - Returns: Bool
     */
    func answerAnalysis(sender: AnyObject) -> Bool {
        
        let highHand = game.getRound().highHand
        
        /**
         Return a Bool indicating whether the swipe was correct
         - Parameter sender: swipe that sent response
         - Returns: Bool
         */
        func swipe(sender: UISwipeGestureRecognizer) -> Bool {
            
            let swipeDirection = sender.direction
            
            switch swipeDirection {
            // Correct Swipes
            case UISwipeGestureRecognizerDirection.Right where highHand == "player2":
                return true
            case UISwipeGestureRecognizerDirection.Left where highHand == "player1":
                return true
            // Incorrect Swipes
            case UISwipeGestureRecognizerDirection.Right where highHand == "player1":
                return false
            case UISwipeGestureRecognizerDirection.Left where highHand == "player2":
                return false
            // Incorrect Swipes On Tie
            case UISwipeGestureRecognizerDirection.Right where highHand == "tie":
                return false
            case UISwipeGestureRecognizerDirection.Left where highHand == "tie":
                return false
            default:
                return false
            }
        }
        
        /**
         Return a Bool indicating whether the button tap was correct
         - Parameter sender: button that sent response
         - Returns: Bool
         */
        func tap(sender: UIButton) -> Bool {
            
            switch highHand {
            case "tie":
                if sender === p1WarButton { return true }
                else if sender === p2WarButton { return true }
            default:
                if sender == p1WarButton { return false }
                else if sender == p2WarButton { return false }
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

    /**
     Adds points to player's or opponent's score depending on player's response
     - Parameter player: String representation of player who responded
     - Parameter correctAnswer: true if response was correct, otherwise false
     */
    func assignPoints(player: String, correctAnswer: Bool) {

        switch player {
        case "player1":
            if correctAnswer == true { game.getPlayer1().addPoints(1) }
            else if correctAnswer == false { game.getPlayer2().addPoints(1) }
            break
        case "player2":
            if correctAnswer == true { game.getPlayer2().addPoints(1) }
            else if correctAnswer == false { game.getPlayer1().addPoints(1) }
        default:
            break
        }
    }
    
    /**
     Moves cards depending on player's response
     - Parameter player: String representation of player who responded
     - Parameter playerResponse: String representation of player's response
     - Parameter correctAnswer: true if response was correct, otherwise false
     */
    func move(player: String, playerResponse: String, correctAnswer: Bool) {

        let cardPorts = getCardPorts
        
        /**
         Moves cards horizontally across screen
         - Parameter distance: distance to move cards
         */
        func moveHorizontal(distance: CGFloat) {
            for port in cardPorts {
                port.center.x += distance
            }
        }
        
        /**
         Moves cards vertically across screen
         - Parameter distance: distance to move cards
         */
        func moveVertical(distance: CGFloat) {
            for port in cardPorts {
                port.center.y += distance
            }
        }
        
        /**
         Animates cards
         - Parameter direction: moveVertical or moveHorizontal
         - Parameter distanceAway: distance away to move
         - Parameter distanceBack: distance back to move
         */
        func animationCorrect(direction: (CGFloat)->(), distanceAway: CGFloat, distanceBack: CGFloat) {
            
            UIView.animateWithDuration(1.2,
                animations: {
                    
                    // Correct direction
                    direction(distanceAway)
                },
                completion: {
                    finished in
                    
                    // Card maintainence
                    self.game.flipDown()
                    self.setupCards()
                    self.cardsAreUp = false
                    self.inAction = false
                    
                    // Place cards in original position
                    direction(distanceBack)
                }
            )
        }
        
        /**
         Animates cards for incorrect swipe
         - Parameter direction: moveVertical or moveHorizontal
         - Parameter distanceAway: distance to move in wrong direction
         - Parameter distanceAway: distance away to move
         - Parameter distanceBack: distance back to move
         */
        func animationIncorrect(direction: (CGFloat)->(), distanceWrong: CGFloat, distanceAway: CGFloat, distanceBack: CGFloat) {
            
            UIView.animateKeyframesWithDuration(1, delay: 0.0, options: [],
                animations: {
                
                    //add keyframes
                    
                    //Wrong direction
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.35,
                        animations: { direction(distanceWrong) }
                    )
                
                    //Correct direction
                    UIView.addKeyframeWithRelativeStartTime(0.35, relativeDuration: 1.5,
                        animations: { direction(distanceAway) }
                    )
                },
                completion: {
                    finished in
                    
                    //Card maintainence
                    self.game.flipDown()
                    self.setupCards()
                    self.cardsAreUp = false
                    self.inAction = false
                    
                    //Place Cards in original position
                    direction(distanceBack)
                }
            )
        }
        
        let q = playerResponse
        if q == "left" || q == "p1WarButton" {
            if correctAnswer == true {
                animationCorrect(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
            }
            else if correctAnswer == false {
                animationIncorrect(moveHorizontal, distanceWrong: -moveDistanceWrong ,
                                   distanceAway: moveDistance + moveDistanceWrong,
                                   distanceBack: -moveDistance)
            }
        }
        else if q == "right" || q == "p2WarButton" {
            if correctAnswer == true {
                animationCorrect(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
            }
            else if correctAnswer == false {
                animationIncorrect(moveHorizontal, distanceWrong: moveDistanceWrong,
                                   distanceAway: -(moveDistance + moveDistanceWrong),
                                   distanceBack: moveDistance)
            }
        }
    }

    /**
     Calls appropriate functions when swipe occurs
     - Parameter sender: AnyObject that sent action
     */
    @IBAction func swipeGesture(sender: AnyObject) {
        
        // Prevent swipe action if cards are face down or if there is already a swipe happening
        if (!cardsAreUp || inAction) {
            return
        }
        
        // Sets flag so that no other player can act until current move finished
        inAction = true
        
        // Stop the computer timer
        // Maybe make the timer optional, so that it does not exist for one player mode
        computerTimer.invalidate()
        
        // Calculate the time it takes to swipe the cards
        let swipeTime = CACurrentMediaTime() - roundStartTime
        
        // Who answered
        let player = playerToAnswer(sender)
        
        // What was their answer
        let answer = playerResponse(sender)
        
        // Is the swipe/tap correct
        let correctAnswer: Bool = answerAnalysis(sender)

        // Assign Points and Set Cards
        assignPoints(player, correctAnswer: correctAnswer)
        game.getRound().addToPlayerCards(game.getRound().highHand)
        
        // TODO: Collect data from round
        game.addRoundData(swipeTime)
        
        // Animate the cards
        move(player, playerResponse: answer, correctAnswer: correctAnswer)
        
        // Prepare player name
        var name: String?
        if (player == "player1") {
            name = p1Name.text!
        } else {
            name = p2Name.text!
        }
        
        // Sound effect and notification
        if (correctAnswer) {
            s.playMove()
            notify("Correct swipe by \(name!)")
        } else {
            s.playError()
            notify("Incorrect swipe, \(name!)")
        }
    }
}
