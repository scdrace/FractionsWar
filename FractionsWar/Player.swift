//
//  Player.swift
//  FractionsWar
//
//  Created by David Race on 3/27/16.
//
//

import Foundation

class Player: Codable, CustomStringConvertible {
    
    let name: String        // Player name
    //var id: String
    var warHands = 2

    fileprivate var _deck = [Card]()    // Deck that is subset of the Main-Deck; Player selects from this deck
    var deck: [Card] {
        get { return _deck }
        set { _deck = newValue }
    }
    
    fileprivate var _deckDifferential = 0
    var deckDifferential: Int {
        get { return _deckDifferential }
        set { _deckDifferential = newValue }
    }
    
    fileprivate var _hands = [Hand]()
    var hand: Hand? { return _hands.last }
    
    fileprivate var _points = 0
    var points: Int {
        get { return _points }
    }
    
    fileprivate var _scoreDifferential = 0
    var scoreDifferential: Int {
        get { return _scoreDifferential }
        set { _scoreDifferential = newValue }
    }
    
    init (name: String) {
        self.name = name
        //self.id = "qwe"
        
        makeHands(totalHands: 1)
    }
    
    var description: String {
        return "\(points) points & \(hand?.description ?? "NoHand") hand & \(_deck.debugDescription) all cards"
    }
    
    func flatHands() -> [Card] {
        var cards = [Card]()
        
        for hand in _hands {
            cards += hand.flatHand()
        }
        return cards
    }
    
    /*
     Make the hand (numerator & denominator Cards)
     Select Cards from deck
     */
    func makeHands(totalHands: Int=1) {
        
        let totalCards = totalHands * 2
        guard deck.count >= totalCards else { return }
        
        for _ in 1...totalHands {
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
    func addCardsToDeck(cards: [Card]) {
        _deckDifferential = cards.count        
        deck = cards + deck
        print(self.name, deck.count)
    }
    
    func addPoints(_ value: Int) {
        let oldValue = _points
        _points += value
        scoreDifferential = _points - oldValue
   }
}
