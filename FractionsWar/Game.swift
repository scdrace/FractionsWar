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
        print(deck.deckRandom.count)
    }
    
    func nextRound() {
        if deck.deckRandom.count > 0 {
            
            let a = self.deck.deckRandom.removeLast()
            let b = self.deck.deckRandom.removeLast()
            let c = self.deck.deckRandom.removeLast()
            let d = self.deck.deckRandom.removeLast()
            
            let e = [a, b, c, d]
            self.round.makeHand(e)
        }
        else {
            print("Winner!")
        }
    }
    
    func flipCards() {
        player1.hand!.flipCards()
        player2.hand!.flipCards()
    }
    
    
    func resizeCards(cardFrame: CGRect) {
        player1.hand!.resizeCards(cardFrame)
        player2.hand!.resizeCards(cardFrame)
    }
    
    func getP1Numerator() -> Card {
        return player1.getNumerator()
    }

    func getP1Denominator() -> Card {
        return player1.getNumerator()
    }
    
    func getCards() ->  Cards {
        
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