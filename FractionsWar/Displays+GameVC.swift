//
//  Displays+GameVC.swift
//  FractionsWar
//
//  Created by David Race on 3/12/18.
//

import Foundation
import UIKit

extension GameViewController {
    
    // MARK: Non-Async Events
    /**
     Updates values of score buttons and displays popup label with difference
     */
    func updateScoreButtons() {
        p1Points.setTitle("Points: \(String(game.player1.points))", for: .normal)
        p2Points.setTitle("Points: \(String(game.player2.points))", for: .normal)
    }
    
    /**
     Updates values of card counters
     */
    internal func updateCardCounterText() {
        // Set new counter values
        p1CardCount.setTitle(String(game.player1.deck.count), for: .normal)
        p2CardCount.setTitle(String(game.player2.deck.count), for: .normal)
        
        /*
         // Adjust for war mode wonkiness (displays +10 on war win, should be +12)
         if (p1Diff == 10) { p1Diff = 12 }
         if (p2Diff == 10) { p2Diff = 12 }
         */
    }
    
    // MARK: Async Events
    /**
     Update value of points gained in round
     */
    func displayWinPoints() {
        asyncDisplayFlags.append(.displayWinPoints)
        
        let p1Diff = game.player1.scoreDifferential
        let p2Diff = game.player2.scoreDifferential
        
        func updateDiffLabel(label: UILabel) {
            label.font = gameCounterFont
            label.textColor = UIColor.white.withAlphaComponent(0.6)
            label.isHidden = false
            popLabel(label, asyncFlag: .displayWinPoints)
        }
        
        if (p1Diff > 0) {
            p1ScoreDiffLabel.text = String(p1Diff)
            updateDiffLabel(label: p1ScoreDiffLabel)
        } else if (p2Diff > 0) {
            p2ScoreDiffLabel.text = String(p2Diff)
            updateDiffLabel(label: p2ScoreDiffLabel)
        }
    }
    
    /**
     Displays popup label with the number of cards gained by round-winner
     */
    func displayWinCardCount(winner: Player) {
        asyncDisplayFlags.append(.displayWinCardCount)
        
        func updateDiffLabel(label: UILabel) {
            label.font = gameCounterFont
            label.textColor = UIColor.white.withAlphaComponent(0.6)
            label.isHidden = false
            popLabel(label, asyncFlag: .displayWinCardCount)
        }
        
        if winner === game.player1 {
            p1DeckDiffLabel.text = String(game.player1.deckDifferential)
            updateDiffLabel(label: p1DeckDiffLabel)
            
        } else {
            p2DeckDiffLabel.text = String(game.player2.deckDifferential)
            updateDiffLabel(label: p2DeckDiffLabel)
        }
    }
    
    /**
     Places notification message at top of screen
     */
    internal func notify(_ message: String) {
        asyncDisplayFlags.append(.displayName)
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            dst = 20.0
        default:
            dst = 44.0
        }
        
        // Prepare update counter for player one
        let p = self.view.center
        let t = self.view.frame.minY
        let notification = UILabel()
        notification.textAlignment = NSTextAlignment.center
        notification.text = message
        notification.font = gameCounterFont
        notification.textColor = UIColor.white.withAlphaComponent(0.6)
        notification.alpha = 0.0
        notification.sizeToFit()
        notification.center = CGPoint(x: p.x, y: t + dst!)
        self.view.addSubview(notification)
        
        // Display message then remove it
        popLabel(notification, asyncFlag: .displayName)
    }
    
    
    /**
     Displays UILabel with 0.6 second fade in, 1.4 second delay, 0.5 second fade out.
     Removes label from superview upon completing fade out.
     - Parameter label: UILabel to fade in and out
     */
    func popLabel(_ label: UILabel, asyncFlag: DisplayType) {
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { label.alpha = 1.0 },
                       completion: {
                        (finished: Bool) -> Void in
                        //Once the label is completely visible, fade it back out
                        UIView.animate(withDuration: 0.5, delay: 1.4,
                                       options: UIViewAnimationOptions.curveEaseIn,
                                       animations: { label.alpha = 0.0 },
                                       completion: {
                                        (finished: Bool) -> Void in
                                        self.removeAsyncDisplayFlag(name: asyncFlag)
                        })
        })
    }
    
    func displayWarBoom() {
        asyncDisplayFlags.append(.displayWarBoom)
        
        view.bringSubview(toFront: warBoom)
        warBoom.isHidden = false
        s.playWar()
        
        Timer.scheduledTimer(timeInterval: 0.8,
                                         target: self,
                                         selector: #selector(hideWarBoom),
                                         userInfo: nil,
                                         repeats: false)
    }
    
    @objc func hideWarBoom() {
        view.sendSubview(toBack: warBoom)
        warBoom.isHidden = true
        //isWarBoomCalled = true
        removeAsyncDisplayFlag(name: .displayWarBoom)
    }
    
    func removeAsyncDisplayFlag(name: DisplayType) -> Void {
        guard !asyncDisplayFlags.isEmpty else { return }
        
        asyncDisplayFlags = asyncDisplayFlags.filter { value in value != name }
        if asyncDisplayFlags.isEmpty {
            game.gameState = .roundEnd
            print("Round Ended!A")
            roundOverMaintenance()
        }
    }
    
    // Display Responser Name and whther their swipe was correct
    func displayNameAndSwipeCorrectness(responderName: String, isResponseCorrect: Bool) {
        // Sound effect and notification
        if (isResponseCorrect) {
            s.playMove()
            notify("Correct response by \(responderName)")
        } else {
            s.playError()
            notify("Incorrect response by \(responderName)")
        }
    }
    
    // Call functions for swipe-response displays
    func responseDisplays(responder: Player, response: ResponseType, isResponseCorrect: Bool, winner: Player) {
        
        if game.warMode == true {
            displayWarBoom()
        } else {
            moveCards(response: response, isAnswerCorrect: isResponseCorrect)
        }
        
        //let responderName = (responder === game.player1) ? responder.name : responder.name
        displayNameAndSwipeCorrectness(responderName: responder.name, isResponseCorrect: isResponseCorrect)
        updateCardCounterText()
        displayWinCardCount(winner: winner)
        updateScoreButtons()
        displayWinPoints()
    }
    
    // Call after all aysnchronous displays have ended.
    // Should not be able to interact with interface until displays have ended
    func resetDisplayFlags() {
        asyncDisplayFlags = [.displayMoveCards, .displayName, .displayWinCardCount, .displayWinPoints]
    }
}

