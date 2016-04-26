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
    
    //Add point for swipe
    func points(sender: UISwipeGestureRecognizer) {
        
        let highHand = game.getRound().highHand
        let swipeDirection = sender.direction
        
        func assignCorrectPoints() {
            
            let touchedView = sender.view
            
            switch touchedView {
            case _ where touchedView == self.p1AreaX:
                game.getPlayer1().addPoints(1)
            case _ where touchedView == self.p1AreaH:
                game.getPlayer1().addPoints(1)
            case _ where touchedView == self.p2AreaX:
                game.getPlayer2().addPoints(1)
            case _ where touchedView == self.p2AreaH:
                game.getPlayer2().addPoints(1)
            default:
                break
            }
        }
        
        func assignIncorrectPoints() {
            
            let touchedView = sender.view
            
            switch touchedView {
            case _ where touchedView == self.p1AreaX:
                game.getPlayer2().addPoints(1)
            case _ where touchedView == self.p1AreaH:
                game.getPlayer2().addPoints(1)
            case _ where touchedView == self.p2AreaX:
                game.getPlayer1().addPoints(1)
            case _ where touchedView == self.p2AreaH:
                game.getPlayer1().addPoints(1)
            default:
                break
            }
        }
        
        switch swipeDirection {
        // Correct Swipes
        case UISwipeGestureRecognizerDirection.Right where highHand != "player1": assignCorrectPoints()
        case UISwipeGestureRecognizerDirection.Left where highHand != "player2": assignCorrectPoints()
        // Incorrect Swipes
        case UISwipeGestureRecognizerDirection.Right where highHand != "player2": assignIncorrectPoints()
        case UISwipeGestureRecognizerDirection.Left where highHand != "player1": assignIncorrectPoints()
        default: break
        }
        
    }
    
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

    //Calls appropriate functions when swipe occurs
    @IBAction func swipeGesture(sender: UISwipeGestureRecognizer) {
        if (!cardsAreUp) {
            return
        }
        points(sender)
        move(sender)
    }
}
