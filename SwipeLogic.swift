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
        
        func assignPoints() {
            
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
        
        
        switch swipeDirection {
        case UISwipeGestureRecognizerDirection.Up where highHand != "player1":
            assignPoints()
        case UISwipeGestureRecognizerDirection.Right where highHand != "player1":
            assignPoints()
        case UISwipeGestureRecognizerDirection.Down where highHand != "player2":
            assignPoints()
        case UISwipeGestureRecognizerDirection.Left where highHand != "player2":
            assignPoints()
        default:
            break
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
                    
                    self.game.imageClean()
                    self.setupCards()
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
    
    
    //Calls appropriate functions when swip occurs
    @IBAction func swipeGesture(sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        
        points(sender)
        move(sender)
        
        //Debugging
        print("Player1: \(game.player1.points)")
        print("Player2: \(game.player2.points)")
    }
}
