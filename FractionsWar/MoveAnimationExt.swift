//
//  MoveAnimation.swift
//  FractionsWar
//
//  Created by David Race on 8/21/16.
//
//

import Foundation
import UIKit

extension GameViewController {
    
    /**
     Moves cards horizontally across screen
     - Parameter distance: distance to move cards
     */
    func moveHorizontal(_ distance: CGFloat) {
        
        let warCards = [p1NumeratorWar, p1DenominatorWar, p2NumeratorWar, p2DenominatorWar]
        
        for card in warCards {
            card?.center.x += distance
            card?.isHidden = true
        }
        
        for port in getCardPorts {
            port.center.x += distance
        }
    }
    
    
    /**
     Moves cards vertically across screen
     - Parameter distance: distance to move cards
     */
    func moveVertical(_ distance: CGFloat) {
        for port in getCardPorts {
            port.center.y += distance
        }
    }
    
    /**
     Animates cards
     - Parameter direction: moveVertical or moveHorizontal
     - Parameter distanceAway: distance away to move
     - Parameter distanceBack: distance back to move
     */
    func animationCorrect(_ direction: @escaping (CGFloat)->(), distanceAway: CGFloat, distanceBack: CGFloat) {
        
        UIView.animate(withDuration: 1.2,
                                   animations: {
                                    
                                    // Correct direction
                                    direction(distanceAway)
            },
                                   completion: {
                                    finished in
                                    
                                    // Card maintainence
                                    self.setupCards()
                                    
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
    func animationIncorrect(_ direction: @escaping (CGFloat)->(), distanceWrong: CGFloat, distanceAway: CGFloat,
                            distanceBack: CGFloat) {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: [],
                                            animations: {
                                                
                                                //add keyframes
                                                
                                                //Wrong direction
                                                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.35,
                                                    animations: { direction(distanceWrong) }
                                                )
                                                
                                                //Correct direction
                                                UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 1.5,
                                                    animations: { direction(distanceAway) }
                                                )
            },
                                            completion: {
                                                finished in
                                                
                                                //Card maintainence
                                                self.setupCards()
                                                
                                                //Place Cards in original position
                                                direction(distanceBack)
            }
        )
    }
    
    
    
    /**
     Moves cards depending on player's response
     - Parameter player: PlayerType of player who responded
     - Parameter playerResponse: ResponseType of player's response
     - Parameter correctAnswer: true if response was correct, otherwise false
     */
    func move(_ player: PlayerType, playerResponse: ResponseType, correctAnswer: Bool) {
        
        let highHand = game.highHand
        
        //Swipe Responses
        switch playerResponse {
        case .swipeLeft where correctAnswer == true:
            animationCorrect(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
            break
        case .swipeLeft where correctAnswer == false:
            animationIncorrect(moveHorizontal, distanceWrong: -moveDistanceWrong ,
                               distanceAway: moveDistance + moveDistanceWrong,
                               distanceBack: -moveDistance)
            break
        case .swipeRight where correctAnswer == true:
            animationCorrect(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
            break
        case .swipeRight where correctAnswer == false:
            animationIncorrect(moveHorizontal, distanceWrong: moveDistanceWrong,
                               distanceAway: -(moveDistance + moveDistanceWrong),
                               distanceBack: moveDistance)
            break
        default:
            break
        }
        
        //Declare War response
        switch playerResponse {
        case .tapP1 where correctAnswer == true:
            setupCards()
            break
        case .tapP1 where correctAnswer == false:
            if highHand == "player1" {
                animationCorrect(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
            }
            else {
                animationCorrect(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
            }
            break
        case .tapP2 where correctAnswer == true:
            setupCards()
            break
        case .tapP2 where correctAnswer == false:
            if highHand == "player1" {
                animationCorrect(moveHorizontal, distanceAway: -moveDistance, distanceBack: moveDistance)
            }
            else {
                animationCorrect(moveHorizontal, distanceAway: moveDistance, distanceBack: -moveDistance)
            }
            break
        default:
            break
        }
    }

}
