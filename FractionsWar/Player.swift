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
    var hand = [Hand?]()    //
    var cards = [Card]()    // Deck that is subset of the Main-Deck; Player selects from this deck
    
    var warHands = 2
    
    init (name: String) {
        self.name = name
    }
    
    var description: String {
        return "\(self.points) points & \(self.hand[0]!.description) hand & \(self.cards.debugDescription) all cards"
    }
    
    func getName() -> String {
        return name
    }
    
    func getNumerator() -> Card {
        return self.hand[0]!.getNumerator()
    }
    
    func getDenominator() -> Card {
        return self.hand[0]!.getDenominator()
    }
    
    func getHand() -> Hand {
        return self.hand[0]!
    }
    
    func addPoints(points: Int = 1) {
        self.points += points
    }
    
    func getPoints() -> Int {
        return points
    }
    
    func makeHand(war: Bool = false) {
        self.hand.removeAll()
        var maxHands = 1
        
        if war == true {
            maxHands = warHands
        }
        var cardsX = [Card]()
        
        for _ in 0..<maxHands {
            for _ in 0..<2 {
                cardsX.append(cards.removeLast())
            }
            self.hand.append(Hand(card1: cardsX[0], card2: cardsX[1]))
            cardsX = [Card]()
        }
    }
    
    //Add the cards from each hand to the winner's deck
    func addToCards(hands: [Hand]) {
        
        //Add each card to the index[0]
        for hand in hands {
            cards.insert(hand.numerator, atIndex: 0)
            cards.insert(hand.denominator, atIndex: 0)
        }
    }
    
    func getWarHands() -> [Hand]? {
        
        var x = [Hand]()
        
        for (index, value) in hand.enumerate() {
            if index > 0 {
                x.append(value!)
            }
        }
        
        if !x.isEmpty {
            return x
        }
        
        return nil
    }
    
    func data() -> [String] {
        let numerator = hand[0]!.numerator.data()
        let denominator = hand[0]!.denominator.data()
        let points = [String(self.points)]
        
        var result = [name] + numerator
        result = result + denominator
        result = result + points
        
        return result
    }
}