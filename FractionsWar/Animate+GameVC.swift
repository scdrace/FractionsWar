//
//  CardSwipeAnimations.swift
//  FractionsWar
//
//  Created by David Race on 3/12/18.
//

import Foundation
import UIKit

extension GameViewController {

    /**
     Moves cards horizontally across screen
     - Parameter distance: distance to move cards
     */
    func moveHorizontal(distance: CGFloat) {
        for card in cardViews {
            for cardImage in card.subviews {
                cardImage.center.x += distance
            }
        }
    }
    
    /**
     Animates cards
     - Parameter direction: moveVertical or moveHorizontal
     - Parameter distanceAway: distance away to move
     - Parameter distanceBack: distance back to move
     */
    func animationCorrect(distance: CGFloat) {
        UIView.animate(withDuration: 1.2,
                       animations: { self.moveHorizontal(distance: distance) },
                       completion: {
                        finished in
                        self.removeAsyncDisplayFlag(name: .displayMoveCards)
        })
    }
    
    
    /**
     Animates cards for incorrect swipe
     - Parameter direction: moveVertical or moveHorizontal
     - Parameter distanceAway: distance to move in wrong direction
     - Parameter distanceAway: distance away to move
     - Parameter distanceBack: distance back to move
     */
    func animationIncorrect(phase1: CGFloat, phase2: CGFloat) {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    
                
                                    //add keyframes
                
                
                                    //Wrong direction
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.35,
                                                       animations: { self.moveHorizontal(distance: phase1) })
                                    
                                    //Correct direction
                                    UIView.addKeyframe(withRelativeStartTime: 0.35,
                                                       relativeDuration: 1.5,
                                                       animations: { self.moveHorizontal(distance: phase2) })
                                    
                                },
                                completion: {
                                    finished in
                                    self.removeAsyncDisplayFlag(name: .displayMoveCards)
        })
    }
    
    
    
    /**
     Moves cards depending on player's response
     - Parameter player: PlayerType of player who responded
     - Parameter playerResponse: ResponseType of player's response
     - Parameter isAnswerCorrect: true if response was correct, otherwise false
     */
    func moveCards(response: ResponseType, isAnswerCorrect: Bool) {
        asyncDisplayFlags.append(.displayMoveCards)
        
        let distCorrect = self.view.bounds.size.width
        let distWrongPhase1 = self.widthProportion(distance: 200)
        let distWrongPhase2 = self.view.bounds.size.width + self.widthProportion(distance: 200)
        
        //Swipe Responses
        switch response {
        case .swipeLeft where isAnswerCorrect == true:
            animationCorrect(distance: -distCorrect)
            break
        case .swipeLeft where isAnswerCorrect == false:
            animationIncorrect(phase1: -distWrongPhase1, phase2: distWrongPhase2)
            break
        case .swipeRight where isAnswerCorrect == true:
            animationCorrect(distance: distCorrect)
            break
        case .swipeRight where isAnswerCorrect == false:
            animationIncorrect(phase1: distWrongPhase1, phase2: -distWrongPhase2)
            break
        default:
            break
        }
        
        //let highHand = game.highHand

        /*
        //Declare War response
        switch response {
        case .tapP1 where isAnswerCorrect == true:
            //setupCards()
            break
        case .tapP1 where isAnswerCorrect == false:
            if highHand == "player1" {
                animationCorrect()
            }
            else {
                animationCorrect()
            }
            break
        case .tapP2 where isAnswerCorrect == true:
            //setupCards()
            break
        case .tapP2 where isAnswerCorrect == false:
            if highHand == "player1" {
                animationCorrect()
            }
            else {
                animationCorrect()
            }
            break
        default:
            break
        }
        */
    }
}
