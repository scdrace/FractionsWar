//
//  Game.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

class Game: CustomStringConvertible {
    var deck = Deck()
    var round: Round
    var player1 = Player()
    var player2 = Player()
    
    struct Cards {
        var p1Numerator: Card
        var p1Denominator: Card
        var p2Numerator: Card
        var p2Denominator: Card
    }
    
    var description: String {
        return "x"
    }
    
    init() {
        self.round = Round(player1: player1, player2: player2)
        while (!deck.deckRandom.isEmpty) {
            player1.cards.append(self.deck.deckRandom.removeLast())
            player2.cards.append(self.deck.deckRandom.removeLast())
        }
    }
    
    func nextRound() {
        
        if (player1.cards.count > 1 && player2.cards.count > 1) {
            
            print("Player one deck: "+player1.cards.debugDescription)
            print("Player two deck: "+player2.cards.debugDescription)
            
            let p1n = self.player1.cards.removeLast()
            let p1d = self.player1.cards.removeLast()
            let p2n = self.player2.cards.removeLast()
            let p2d = self.player2.cards.removeLast()
            
            let h = [p1n, p1d, p2n, p2d]
            
            print("NEW HAND: "+h.debugDescription)

            self.round.makeHand(h)
        }
            
        else {
            if (player1.points > player2.points) {
                print("Player one wins")
                self.imageClean()
            } else {
                print("Player two wins")
                self.imageClean()
            }
        }
    }
    
    func flipCards() {
        player1.hand!.flipCards()
        player2.hand!.flipCards()
    }
    
    func flipDown() {
        player1.hand!.flipDown()
        player2.hand!.flipDown()
    }
    
    func resizeCards(cardFrame: CGRect) {
        player1.hand!.resizeCards(cardFrame)
        player2.hand!.resizeCards(cardFrame)
    }
    
    func getP1Numerator() -> Card {
        return player1.getNumerator()
    }

    func getP1Denominator() -> Card {
        return player1.getDenominator()
    }
    
    func getCards() -> Cards {
        
        let cards = Cards(p1Numerator: player1.getNumerator(), p1Denominator: player1.getDenominator(),
        p2Numerator: player2.getNumerator(), p2Denominator: player2.getDenominator())
        
        return cards
    }
    
    func getPlayer1() -> Player {
        return player1
    }
    
    func getPlayer2() -> Player {
        return player2
    }
    
    func getRound() -> Round {
        return round
    }
    
    func imageClean() {
        round.imageClean()
    }
    
    func highHand() -> String {
        return round.highHand
    }
}