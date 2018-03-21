//
//  TouchHandler+GameViewController.swift
//  FractionsWar
//
//  Created by David Race on 3/6/18.
//

import Foundation
import UIKit

// Button-Press Handler
extension GameViewController {
    
    @IBAction func pressP1DeckButton(_ sender: AnyObject) {
        print("Deck1", game.gameState)
        guard game.gameState == .cardsDealt else { return }
        deckButtonActions()
    }
    
    @IBAction func pressP2DeckButton(_ sender: AnyObject) {
        print("Deck2")
        guard
            game.playerMode == 2,
            game.gameState == .cardsDealt
        else { return }
        
        deckButtonActions()
    }
    
    func deckButtonActions() {
        flipCards(.faceUp)
        resetTimer()
        s.playPlace()
        
        // Update GameState
        game.gameState = .cardsFlipped
        
        //Reset the startTime for the round
        game.roundStartTime = CACurrentMediaTime()
    }
    
    func widthProportion(distance: CGFloat) -> CGFloat {
        return CGFloat((distance / 1024.0) * view.bounds.size.width)
    }
    
    func heightProportion(distance: CGFloat) -> CGFloat {
        return CGFloat((distance / 768.0) * view.bounds.size.height)
    }
    
    internal func flipCards(_ flipType: CardFlipType) {
        for x in cardStructs {
            x.flipCard()
        }

        self.p1Deck.isUserInteractionEnabled = false
        self.p2Deck.isUserInteractionEnabled = false
    }
}
