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
   
    // Mark: Declare War
    @IBAction func pressDeclareWarP1Button(_ sender: UIButton) {
        print("p1DeclareWar")
        
        let responseTime = responseDelay()
        let response = ResponseType.tapP1
        let responder = game.player1
        let win = winner(player: responder, response: response)
        
        
        responseHandler(responder: responder,
                        response: response,
                        isResponseCorrect: isResponseCorrect(response: response),
                        responseTime: responseTime,
                        winner: win)
    }
    
    @IBAction func pressDeclareWarP2Button(_ sender: UIButton) {
        print("p2DeclareWar")
        
        let responseTime = responseDelay()
        let response = ResponseType.tapP1
        let responder = game.player2
        let win = winner(player: responder, response: response)
        
        
        responseHandler(responder: responder,
                        response: response,
                        isResponseCorrect: isResponseCorrect(response: response),
                        responseTime: responseTime,
                        winner: win)
    }
    
    @IBAction func p1SwipeRight(_ sender: UISwipeGestureRecognizer) {
        print("p1SwipeRightGesture", sender.direction == UISwipeGestureRecognizerDirection.right)

        let responseTime = responseDelay()
        let response = ResponseType.swipeRight
        let responder = game.player1
        let win = winner(player: responder, response: response)
        
        
        responseHandler(responder: responder,
                        response: response,
                        isResponseCorrect: isResponseCorrect(response: response),
                        responseTime: responseTime,
                        winner: win)
    }
 
    func responseHandler(responder: Player, response: ResponseType, isResponseCorrect: Bool,
                         responseTime: Double, winner: Player) {
        
        computerAnswerTimer?.invalidate()
        disableUserInteraction()
        
        assignPointsAndCards(responder: responder, isAnswerCorrect: isResponseCorrect)
        
        dataHandler(responder: responder,
                    response: response,
                    responseTime: responseTime,
                    isResponseCorrect: isResponseCorrect,
                    winner: winner)
        
        responseDisplays(responder: responder,
                         response: response,
                         isResponseCorrect: isResponseCorrect,
                         winner: winner)
        
    }
    @IBAction func p1SwipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("p1SwipeLeftGesture", sender.direction)

        
        let responseTime = responseDelay()
        let response = ResponseType.swipeLeft
        let responder = game.player1
        let win = winner(player: responder, response: response)
        
        
        responseHandler(responder: responder,
                        response: response,
                        isResponseCorrect: isResponseCorrect(response: response),
                        responseTime: responseTime,
                        winner: win)
    }
    
    @IBAction func p2SwipeRight(_ sender: UISwipeGestureRecognizer) {
        print("p2SwipeRightGesture", sender.direction == UISwipeGestureRecognizerDirection.right)
        
        
        let responseTime = responseDelay()
        let response = ResponseType.swipeRight
        let responder = game.player2
        let win = winner(player: responder, response: response)
        
        
        responseHandler(responder: responder,
                        response: response,
                        isResponseCorrect: isResponseCorrect(response: response),
                        responseTime: responseTime,
                        winner: win)
    }
    
    @IBAction func p2SwipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("p2SwipeLeftGesture", sender.direction)
        
        
        let responseTime = responseDelay()
        let response = ResponseType.swipeLeft
        let responder = game.player2
        let win = winner(player: responder, response: response)
        
        
        responseHandler(responder: responder,
                        response: response,
                        isResponseCorrect: isResponseCorrect(response: response),
                        responseTime: responseTime,
                        winner: win)
    }
    
    /**
     Sends computer swipe
     */
    @objc func computerSwipe() {
        print("Computer Swipe")
        
        // Get the UISwipeGestureRecognizer that represents a correct swipe
        switch game.highHand {
        case "player1":
            p2SwipeLeft(UISwipeGestureRecognizer(target: self, action: #selector(self.p2SwipeLeft(_:))))
            break
        case "player2":
            p2SwipeRight(UISwipeGestureRecognizer(target: self, action: #selector(self.p2SwipeRight(_:))))
            break
        case "tie":
            pressDeclareWarP2Button(UIButton())
            break
        default:
            break
        }
    }
    
    
    
    
    // MARK: Helper Functions
    func responseDelay() -> Double {
        return CACurrentMediaTime() - game.roundStartTime
    }
    
    func isResponseCorrect(response: ResponseType) -> Bool {
        
        if response == .swipeRight && game.highHand == "player2" {
            return true
        }
        
        if response == .swipeLeft && game.highHand == "player1" {
            return true
        }
        
        if (response == .tapP1 || response == .tapP2) && game.highHand == "tie" {
            return true
        }
        
        return false
    }
    
    func winner(player: Player, response: ResponseType) -> Player {
     
        if isResponseCorrect(response: response) == true {
            return player
        }
        
        return oppositePlayer(from: player)
    }
    
    func oppositePlayer(from: Player) -> Player {
        if from === game.player1 { return game.player2 }
        return game.player1
    }
    
    func assignPointsAndCards(responder: Player, isAnswerCorrect: Bool) {
        if isAnswerCorrect == true {
            responder.addPoints(pointsToAdd)
            if game.warMode == false { game.addHandsToWinnerDeck(winner:  responder) }
        } else {
            oppositePlayer(from: responder).addPoints(pointsToAdd)
            if game.warMode == false { game.addHandsToWinnerDeck(winner:  oppositePlayer(from: responder)) }
        }
        
    }
}
