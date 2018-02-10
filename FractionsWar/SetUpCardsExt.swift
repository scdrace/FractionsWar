//
//  SetUpCardsExt.swift
//  FractionsWar
//
//  Created by David Race on 8/23/16.
//
//

import Foundation

extension GameViewController {
    
    
    internal func setupCards() {
        
        func preRoundMaintenance() {
            
            print("Round: \(game.round)")
            guard game.round > 1 else {
                return
            }
            
            func addHandsToWinnerDeck() {
                // Add hands to winning Players subDeck
                // Only add hands when game is in state(.Normal)
                if game.gameState  == .normal {
                    
                    // Add cards to winning player's deck
                    game.addHandsToWinnerDeck(game.highHand)
                    
                    // Clear the cards from the players hand
                    game.player1.removeHands()
                    game.player2.removeHands()
                }
            }
            
            // Update GameState now (before hands are dealt),
            // ...so that appropriate number of hands are dealt for .War state
            if game.gameState == .declareWar {
                game.gameState = .war
            }
            
            self.flipCards(.faceDown)
            self.game.cardsAreUp = false
            self.game.inAction = false
            
            addHandsToWinnerDeck()
        }
        
        
        func updateGameStateByWinningHand() {
            
            //Set the next hands based on the current GameState
            game.makeHands(game.gameState)
            
            print("GameState before hand is dealt: \(game.gameState)")
            
            //Update GameState
            switch game.highHand {
            case "tie":
                game.gameState = .declareWar
                break
            case "player1" where game.gameState == .declareWar:
                game.gameState = .war
                break
            case "player2" where game.gameState == .declareWar:
                game.gameState = .war
                break
            case "player1" where game.gameState != .declareWar:
                game.gameState = .normal
                break
            case "player2" where game.gameState != .declareWar:
                game.gameState = .normal
                break
            default:
                break
            }
            print("GameState after hand is dealt: \(game.gameState)")
        }

        
        
        func gameOver() {
            
            // End the game if someone's deck is too small to continue
            if (game.gameState == GameState.war && (game.player1.deck.count < 4 || game.player2.deck.count < 4)) {
                
                // Set gameState to .GameOver
                game.gameState = .gameOver
                
                // Segue to GameOverViewController
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "goToGameOver", sender: self)
                })
            } else if (game.player1.deck.count < 2 || game.player2.deck.count < 2) {
                
                // Set gameState to .GameOver
                game.gameState = .gameOver
                
                // Segue to GameOverViewController
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "goToGameOver", sender: self)
                })
            }
        }
        
        func setUpCardsWar() {
            
            if game.gameState == .war {
                s.playWar()
                warBoomImageView.isHidden = false
                p1NumeratorWar.isHidden = false
                p1DenominatorWar.isHidden = false
                p2NumeratorWar.isHidden = false
                p2DenominatorWar.isHidden = false
                
                delay(2.0) {
                    self.notify("You've entered WAR MODE")
                }
            } else if (!warBoomImageView.isHidden) {
                warBoomImageView.isHidden = true
                p1NumeratorWar.isHidden = true
                p1DenominatorWar.isHidden = true
                p2NumeratorWar.isHidden = true
                p2DenominatorWar.isHidden = true
            }
            
        }
        
        
        
        //Clean up hands from last round
        preRoundMaintenance()
        
        game.round += 1

        // Basic setup for WarMode
        setUpCardsWar()
        
        // Update gameState depending on the winning hand for the round
        updateGameStateByWinningHand()
        
        // Add Card.view to corresponding card-port
        addCardImage()
        
        // Update card counts and player scores
        updateScores()
        updateCardCounters()
        
        
        // TODO: Update comments on this section
        game.p1ready = false
        game.p2ready = false
        p1DeckButton.isHidden = false
        if (game.playerMode == 2) {
            p2DeckButton.isHidden = false
        }
        
        // Check whether gameOver conditions are met
        // If so, end game
        gameOver()
        
        print("Player1")
        print("Points: \(game.player1.points), DeckCount: \(game.player1.deck.count)")
        print(game.player1.deck)
        
        print("Player2")
        print("Points: \(game.player2.points), DeckCount: \(game.player2.deck.count)")
        print(game.player1.deck)
        
        
        //print("Player1: \(game.getPlayer1().getPoints()), \(game.getPlayer1().subDeck.count)")
        //print(game.getPlayer1().subDeck)
        //print("Player2: \(game.getPlayer2().getPoints()), \(game.getPlayer2().subDeck.count)")
        //print(game.getPlayer2().subDeck)
        
    }

}
