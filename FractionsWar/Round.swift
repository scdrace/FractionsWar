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
            return "tie"
        }
    }
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func makeHand(deck: [Card]) {
        
        if deck.isEmpty {
            print("Winner")
            return
        }

        self.round += 1
        
        player1.hand.append(Hand(card1: deck[0], card2: deck[1]))
        player2.hand.append(Hand(card1: deck[2], card2: deck[3]))
    }
    
    func addToPlayerCards(player: String) {
        
        let hands = [player1.getHand(), player2.getHand()]
        
        print()
        print("Content of hands: "+hands.debugDescription)
        print()
        
        switch player {
        case "player1":
            player1.addToCards(hands)
            break
        case "player2":
            player2.addToCards(hands)
            break
        default: break
        }
    }
    
    func imageClean() {
        player1.getHand().imageClean()
        player2.getHand().imageClean()
    }
    
    func getRound() -> Int {
        return round
    }
}