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
   
    
    // Mark: Response Buttons & Swipes
    @IBAction func pressDeclareWarP1Button(_ sender: AnyObject) {
        
        if (game.p1ready && game.p2ready) {
            swipeGesture(sender)
        }
    }
    
    @IBAction func pressDeclareWarP2Button(_ sender: AnyObject) {
        
        if (game.p1ready && game.p2ready) {
            swipeGesture(sender)
        }
    }

    
    /**
     Sends computer swipe
     */
    @objc func computerSwipe() {
        
        let highHand = game.highHand

        /**
         Initiates swipe depending on the gesture
         - Parameter direction: the swipe direction
         */
        func foo(_ direction: UISwipeGestureRecognizerDirection) {
            for item in p2AreaH.gestureRecognizers! {
                let gesture = item as! UISwipeGestureRecognizer
                if gesture.direction == direction {
                    swipeGesture(gesture)
                }
            }
        }
        
        // Get the UISwipeGestureRecognizer that represents a correct swipe
        switch highHand {
        case "player1":
            foo(.left)
            break
        case "player2":
            foo(.right)
            break
        case "tie":
            swipeGesture(p2WarButton)
            break
        default:
            break
        }
    }

    /**
     Returns PlayerType of player who responded
     - Parameter sender: AnyObject that sent response
     - Returns: PlayerType
     */
    func playerToAnswer(_ sender: AnyObject) -> PlayerType {
        
        
        // Handle button-press
        if sender === p1WarButton {
            return .player1
        }
        else if sender === p2WarButton {
            return .player2
        }
        
        // Handle swipe
        if let swipe = sender as? UISwipeGestureRecognizer {
            
            //Handle swipe
            switch swipe.view! {
            case p1AreaH:
                return .player1
            case p2AreaH:
                return .player2
            default:
                break
            }
        }

        // TODO: find better value to return; Maybe nil
        return .player1
    }
    
    /**
     Returns the ResponseType of player's response
     - Parameter sender: AnyObject that sent response
     - Returns: ResponseType
     */
    func playerResponse(_ sender: AnyObject) -> ResponseType {
        
        
        //Handle button-press
        if sender === p1WarButton {
            return .tapP1
        }
        else if sender === p2WarButton {
            return .tapP2
        }
        
        //Handle swipe
        if let swipe = sender as? UISwipeGestureRecognizer {
            
            switch swipe.direction {
            case UISwipeGestureRecognizerDirection.right:
                return .swipeRight
            case UISwipeGestureRecognizerDirection.left:
                return .swipeLeft
            default:
                break
            }
        }
        
        // TODO: find better value to return; Maybe nil
        return .swipeLeft
    }
    
    /**
     Return a Bool indicating whether the answer (swipe/tap) was correct
     - Parameter sender: AnyObject that sent response
     - Returns: Bool
     */
    func answerAnalysis(_ sender: AnyObject) -> Bool {
        
        let highHand = game.highHand
        
        /**
         Return a Bool indicating whether the swipe was correct
         - Parameter sender: swipe that sent response
         - Returns: Bool
         */
        func swipe(_ sender: UISwipeGestureRecognizer) -> Bool {
            
            let swipeDirection = sender.direction
            
            if swipeDirection == UISwipeGestureRecognizerDirection.right {
                game.data.setSwipeDirection(swipeDirection: "right")
            } else if swipeDirection == UISwipeGestureRecognizerDirection.left {
                game.data.setSwipeDirection(swipeDirection: "left")
            } else {
                game.data.setSwipeDirection(swipeDirection: "war")
            }
            
            if highHand == "player1" {
                game.data.setSwipeDirectionCorrect(swipeDirectionCorrect: "left")
            } else if highHand == "player2" {
                game.data.setSwipeDirectionCorrect(swipeDirectionCorrect: "right")
            } else {
                game.data.setSwipeDirectionCorrect(swipeDirectionCorrect: "war")
            }
            
            switch swipeDirection {
            // Correct Swipes
            case UISwipeGestureRecognizerDirection.right where highHand == "player2":
                return true
            case UISwipeGestureRecognizerDirection.left where highHand == "player1":
                return true
            // Incorrect Swipes
            case UISwipeGestureRecognizerDirection.right where highHand == "player1":
                return false
            case UISwipeGestureRecognizerDirection.left where highHand == "player2":
                return false
            // Incorrect Swipes On Tie; Player should press War-button instead
            case UISwipeGestureRecognizerDirection.right where highHand == "tie":
                return false
            case UISwipeGestureRecognizerDirection.left where highHand == "tie":
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
        func tap(_ sender: UIButton) -> Bool {
            
            guard sender === p1WarButton || sender === p2WarButton else {
                return false
            }
            
            switch highHand {
            case "tie":
                return true
            default:
                return false
            }
        }
        
        // Determine whether gesture was a swipe or tap (Declare-War Buttons)
        // Then compute whether the response was correct
        if let responseMode = sender as? UISwipeGestureRecognizer {
            return swipe(responseMode)
        }
        else if let responseMode = sender as? UIButton {
            return tap(responseMode)
        }
        
        return false
        
        /*
        if sender is UISwipeGestureRecognizer {
            let x = sender as! UISwipeGestureRecognizer
            return swipe(x)
        }
        else if sender is UIButton {
            let x = sender as! UIButton
            return tap(x)
        }
 
        return false
        */
    }

    /**
     Adds points to player's or opponent's score depending on player's response
     - Parameter player: String representation of player who responded
     - Parameter correctAnswer: true if response was correct, otherwise false
     */
    func assignPoints(_ player: PlayerType, correctAnswer: Bool) {
        
        switch player {
        case .player1 where correctAnswer == true:
            game.player1.addPoints(pointsToAdd)
            break
        case .player1 where correctAnswer == false:
            game.player2.addPoints(pointsToAdd)
            break
        case .player2 where correctAnswer == true:
            game.player2.addPoints(pointsToAdd)
            break
        case .player2 where correctAnswer == false:
            game.player1.addPoints(pointsToAdd)
        default:
            break
        }
        
        // Since this function is called before cards are setup for next round...
        // ...must setup points for next round here
        // GameStates listed below are for currentState, this may change in the next-round
        switch game.gameState {
        case .normal:
            pointsToAdd = 1
            break
        case .declareWar:
            pointsToAdd = 3
            break
        default:
            break
        }
    }
    
    /**
     Calls appropriate functions when swipe occurs
     - Parameter sender: AnyObject that sent action
     */
    @IBAction func swipeGesture(_ sender: AnyObject) {
        print(sender)
        
        // Prevent swipe action if cards are face down or if there is already a swipe happening
        if (!game.cardsAreUp || game.inAction) {
            return
        }
        
        // Sets flag so that no other player can act until current move finished
        game.inAction = true
        
        // Stop the computer timer
        // Maybe make the timer optional, so that it does not exist for one player mode
        game.computerTimer.invalidate()
        
        // Calculate the time it takes to swipe the cards
        let swipeTime = CACurrentMediaTime() - game.roundStartTime
        
        // Who answered
        let player = playerToAnswer(sender)
        
        // What was their answer
        let answer = playerResponse(sender)
        
        // Is the swipe/tap correct
        let correctAnswer: Bool = answerAnalysis(sender)

        // Assign Points
        assignPoints(player, correctAnswer: correctAnswer)
        
        
        // TODO: Only collect Data if: Collect-Data button was pressed to true
        //Append data from round to textfile
        game.saveDataImmediate(swipeTime)
        
        // Animate the cards
        move(player, playerResponse: answer, correctAnswer: correctAnswer)
        
        // Prepare player name
        var name: String?
        if (player == .player1) {
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
