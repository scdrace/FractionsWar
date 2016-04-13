//
//  Round.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation

class Round {
    var player1: Player
    var player2: Player
    var round = 0
    
    var highHand: String {
        
        if player1.getHand().decimalValue - player2.getHand().decimalValue > 0 {
            return "player1"
        }
        else if player1.getHand().decimalValue - player2.getHand().decimalValue < 0 {
           return "player2"
        }
        else {
            return "even"
        }
    }
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func makeHand(deck: [Card2]) {
        
        if deck.isEmpty {
            print("Winner")
            return
        }

        self.round += 1
        
        player1.hand = Hand(card1: deck[0], card2: deck[1])
        player2.hand = Hand(card1: deck[2], card2: deck[3])
    }
    
    func imageClean() {
        player1.getHand().imageClean()
        player2.getHand().imageClean()
    }
}