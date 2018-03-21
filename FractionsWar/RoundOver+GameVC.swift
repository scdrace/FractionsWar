//
//  SetUpCardsExt.swift
//  FractionsWar
//
//  Created by David Race on 8/23/16.
//
//

import Foundation

extension GameViewController {
    
    
    public func roundOverMaintenance() {
        
        // Check for GameOver State
        gameOver()
        
        game.shouldShowWarCards = false
        if game.highHand == "tie" { game.shouldShowWarCards = true }
                
        if game.warMode == false { game.removeHands() }
        removeCardSubviews()
        
        game.player1.scoreDifferential = 0
        game.player2.scoreDifferential = 0
                
        game.gameState = .roundStart
        game.round += 1
        
        dealCards()
    }
    
    func gameOver() {
        // End the game if someone's deck is too small to continue
        let normalEnd = (game.player1.deck.count < 2 || game.player2.deck.count < 2)
        let warEnd = game.warMode == true &&
            (game.player1.deck.count < 4 || game.player2.deck.count < 4)
        
        if normalEnd || warEnd == true {
            // Set gameState to .GameOver
            game.gameState = .gameOver
            
            // Segue to GameOverViewController
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "goToGameOver", sender: self)
            })
        }
    }
}
