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
                if game.getGameState()  == .normal {
                    
                    // Add cards to winning player's deck
                    game.addHandsToWinnerDeck(game.highHand)
                    
                    // Clear the cards from the players hand
                    game.getPlayer1().hand.removeAll()
                    game.getPlayer2().hand.removeAll()
                }
            }
            
            // Update GameState now (before hands are dealt),
            // ...so that appropriate number of hands are dealt for .War state
            if game.getGameState() == .declareWar {
                game.setGameState(.war)
            }
            
            self.flipCards(.faceDown)
            self.game.cardsAreUp = false
            self.game.inAction = false
            
            addHandsToWinnerDeck()
        }
        
        
        func updateGameStateByWinningHand() {
            
            //Set the next hands based on the current GameState
            game.makeHands(game.getGameState())
            
            print("GameState before hand is dealt: \(game.getGameState())")
            
            //Update GameState
            switch game.highHand {
            case "tie":
                game.setGameState(.declareWar)
                break
            case "player1" where game.getGameState() == .declareWar:
                game.setGameState(.war)
                break
            case "player2" where game.getGameState() == .declareWar:
                game.setGameState(.war)
                break
            case "player1" where game.getGameState() != .declareWar:
                game.setGameState(.normal)
                break
            case "player2" where game.getGameState() != .declareWar:
                game.setGameState(.normal)
                break
            default:
                break
            }
            print("GameState after hand is dealt: \(game.getGameState())")
        }

        
        
        func gameOver() {
            
            // End the game if someone's deck is too small to continue
            if (game.getGameState() == GameState.war && (game.getPlayer1().subDeck.count < 4 || game.getPlayer2().subDeck.count < 4)) {
                
                // Set gameState to .GameOver
                game.setGameState(.gameOver)
                
                // Segue to GameOverViewController
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "goToGameOver", sender: self)
                })
            } else if (game.getPlayer1().subDeck.count < 2 || game.getPlayer2().subDeck.count < 2) {
                
                // Set gameState to .GameOver
                game.setGameState(.gameOver)
                
                // Segue to GameOverViewController
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "goToGameOver", sender: self)
                })
            }
        }
        
        func setUpCardsWar() {
            
            if game.getGameState() == .war {
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
        print("Points: \(game.getPlayer1().getPoints()), DeckCount: \(game.getPlayer1().subDeck.count)")
        print(game.getPlayer1().subDeck)
        
        print("Player2")
        print("Points: \(game.getPlayer2().getPoints()), DeckCount: \(game.getPlayer2().subDeck.count)")
        print(game.getPlayer1().subDeck)
        
        
        //print("Player1: \(game.getPlayer1().getPoints()), \(game.getPlayer1().subDeck.count)")
        //print(game.getPlayer1().subDeck)
        //print("Player2: \(game.getPlayer2().getPoints()), \(game.getPlayer2().subDeck.count)")
        //print(game.getPlayer2().subDeck)
        
    }

}
