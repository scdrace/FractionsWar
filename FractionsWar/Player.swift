//
//  Player.swift
//  FractionsWar
//
//  Created by David Race on 3/27/16.
//
//

import Foundation

class Player: CustomStringConvertible {
    
    let name: String        // Player name
    var id: String
    var warHands = 2
    
    fileprivate var _deck = [Card]()    // Deck that is subset of the Main-Deck; Player selects from this deck
    var deck: [Card] {
        get { return _deck }
        set { _deck = newValue }
    }
    
    fileprivate var _hands = [Hand]()
    var hand: Hand? { return _hands.last }
    
    fileprivate var _points = 0
    var points: Int { return _points }
    
    init (name: String) {
        self.name = name
        self.id = "qwe"
        
        makeHand(total: 1)
    }
    
    var description: String {
        return "\(points) points & \(hand?.description ?? "NoHand") hand & \(_deck.debugDescription) all cards"
    }
    
    /*
     Make the hand (numerator & denominator Cards)
     Select Cards from deck
     */
    func makeHand(total: Int=1) {
        
        let totalCards = total * 2
        guard deck.count >= totalCards else { return }
        
        for _ in 1...totalCards {
            let card1 = deck.removeLast()
            let card2 = deck.removeLast()
            _hands.append(Hand(card1: card1, card2: card2))
        }
    }
    
    func removeHands() {
        _hands.removeAll()
    }
    
    
    /*
     Add the cards from each hand to the winner's deck
     */
    func addHandsToDeck(hands: [Hand]) {
        
        
        // Place all cards into single stack
        var cards = [Card]()
        for hand in hands {
            cards.append(contentsOf: [hand.numerator, hand.denominator])
        }
        
        // Remove cards from stack in random order and place into deck at index 0
        while !cards.isEmpty {
            let index = Int(arc4random_uniform(UInt32(cards.count)))
            deck.insert(cards.remove(at: index), at: 0)
        }
        
    }
    
    func addPoints(_ value: Int) {
        _points += value
    }
}
