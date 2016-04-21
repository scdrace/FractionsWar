//
//  Deck.swift
//  FractionsWar
//
//  Created by David Race on 3/2/16.
//
//

import UIKit

/* A Deck holds Cards. 

    Possible Methods
    - shuffle()
    - drawCards()
    - etc.
*/

class Deck {
    let rank = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let suit = ["clubs", "diamonds", "hearts", "spades"]
    
    var deckOrdered = [Card]()
    var deckRandom = [Card]()
    
    init() {
        makeDeck()
        makeDeckRandom()
    }
    
    func makeDeck() {
        for number in rank {
            for name in suit {
                deckOrdered.append(Card(rank: Double(number), suit: name))
            }
        }
    }
    
    func makeDeckRandom() {
        let randomNumbers = randomIntArray(deckOrdered.count)
        
        for i in randomNumbers {
            deckRandom.append(deckOrdered[i])
        }
    }
    
    func randomInt() -> Int {
        
        return Int(arc4random_uniform(UInt32(deckOrdered.count)))
    }
    
    func randomIntArray(count: Int) -> [Int] {
        
        //Create an array of four random index numbers for selecting a hand
        var result = [Int]()
        
        while(result.count < count) {
            let temp = randomInt()
            
            if !result.contains(temp) {
                result.append(temp)
            }
        }
        
        return result
    }

}