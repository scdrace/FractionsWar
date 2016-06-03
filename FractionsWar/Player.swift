//
//  Player.swift
//  FractionsWar
//
//  Created by David Race on 3/27/16.
//
//

import Foundation

class Player: CustomStringConvertible {
    
    var name: String        // Player name
    var points = 0          // Current total points
    var hand = [Hand]()    //
    var cards = [Card]()    // Deck that is subset of the Main-Deck; Player selects from this deck
    
    var warHands = 2
    
    init (name: String) {
        self.name = name
    }
    
    var description: String {
        return "\(self.points) points & \(self.hand[0].description) hand & \(self.cards.debugDescription) all cards"
    }
    
    func getName() -> String {
        return name
    }
    
    func getNumerator() -> Card {
        return self.hand[0].getNumerator()
    }
    
    func getDenominator() -> Card {
        return self.hand[0].getDenominator()
    }
    
    func getHand() -> Hand {
        return self.hand[0]
    }
    
    func addPoints(points: Int = 1) {
        self.points += points
    }
    
    func getPoints() -> Int {
        return points
    }
    
    func makeHand(war: Bool) {
        
        var maxHands = 1
        
        func setMaxHands() {
            if war {
                maxHands = warHands
            }
            else {
                maxHands = 1
                self.hand.removeAll()
            }
        }
        
        func getTwoCards() -> [Card] {
            var twoCards = [Card]()
            
            for _ in 0..<2 {
                twoCards.append(cards.removeLast())
            }
            
            return twoCards
        }
        
        setMaxHands()
        for index in 0..<maxHands {
            
            var twoCards = getTwoCards()
            let hand = Hand(card1: twoCards[0], card2: twoCards[1])
            self.hand.insert(hand, atIndex: index)
        }
    }
    
    //Add the cards from each hand to the winner's deck
    func addToCards(hands: [Hand]) {
        
        // Place all cards into single stack
        var randCards = [Card]()
        for hand in hands {
            randCards.insert(hand.numerator, atIndex: 0)
            randCards.insert(hand.denominator, atIndex: 0)
        }
        
        // Remove cards from stack in random order and place into deck at index 0
        while !randCards.isEmpty {
            let random = Int(arc4random_uniform(UInt32(randCards.count)))
            cards.insert(randCards.removeAtIndex(random), atIndex: 0)
        }
    }
    
    func getWarHands() -> [Hand]? {
        
        var x = [Hand]()
        
        for (index, value) in hand.enumerate() {
            if index > 0 {
                x.append(value)
            }
        }
        
        if !x.isEmpty {
            return x
        }
        
        return nil
    }
    
    func data() -> [String] {
        let numerator = hand[0].numerator.data()
        let denominator = hand[0].denominator.data()
        let points = [String(self.points)]
        
        var result = [name] + numerator
        result = result + denominator
        result = result + points
        
        return result
    }
}