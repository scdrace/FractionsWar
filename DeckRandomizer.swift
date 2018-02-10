//
//  DeckRandomizer.swift
//  ComLineWarJson
//
//  Created by David Race on 1/30/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class DeckRandomizer {
    let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let suits = ["clubs", "diamonds", "hearts", "spades"]
    
    var baseDeck: [String] {
        var result = [String]()
        for suit in suits {
            for rank in ranks {
                result.append(rank + "_" + suit)
            }
        }
        return result
    }
    
    func shuffle(deck: [String], multiplier: Int=1) -> [String] {
        var resultDeck = deck
        for _ in 1...multiplier {
            resultDeck = shuffle(deck: resultDeck)
        }
        return resultDeck
    }
    
    func shuffle(deck: [String]) -> [String] {
        var tempDeck = deck
        var result = [String]()
        
        func randomInt(value: Int) -> Int {
            return Int(arc4random_uniform(UInt32(value)))
        }
        
        while !tempDeck.isEmpty {
            result.append(tempDeck.remove(at: randomInt(value: tempDeck.count)))
        }
        
        return result
    }
    
    func dealCards(player1: Player, player2: Player) {
        var cardNames = shuffle(deck: baseDeck, multiplier: 5)
        while cardNames.count >= 2 {
            player1.deck.append(createCard(name: cardNames.popLast()!))
            player2.deck.append(createCard(name: cardNames.popLast()!))
        }
    }
    
    func createCard(name: String) -> Card {
        let nameArray = name.split(separator: "_")
        let rank = Double(nameArray[0])!
        let suit = String(nameArray[1])
        
        return Card(rank: rank, suit: suit, cardType: "2")
    }
}
