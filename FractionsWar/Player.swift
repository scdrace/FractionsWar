//
//  Player.swift
//  FractionsWar
//
//  Created by David Race on 3/27/16.
//
//

import Foundation

class Player: CustomStringConvertible {
    
    var points = 0
    var hand: Hand?
    var cards = [Card]()
    
    var description: String {
        return "\(self.points) points & \(self.hand!.description) hand & \(self.cards.debugDescription) all cards"
    }
    
    func getNumerator() -> Card {
        return self.hand!.getNumerator()
    }
    
    func getDenominator() -> Card {
        return self.hand!.getDenominator()
    }
    
    func getHand() -> Hand {
        return self.hand!
    }
    
    func addPoints(points: Int = 1) {
        self.points += points
    }
    
    func addToCards(hands: [Hand]) {
        for hand in hands {
            cards.insert(hand.numerator, atIndex: 0)
            cards.insert(hand.denominator, atIndex: 0)
        }
    }
}