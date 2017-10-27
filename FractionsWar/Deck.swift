//
//  Deck.swift
//  FractionsWar
//
//  Created by David Race on 3/2/16.
//
//

import UIKit

class Deck: NSObject, NSCoding {
    let rank = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let suit = ["clubs", "diamonds", "hearts", "spades"]
    
    var deckOrdered = [Card]()
    var deckRandom = [Card]()
    var deckWar = [Card]()
    
    let sH = SettingsHelper.shared
    
    /*
        Create each type of deck (property)
    */
    override init() {
        
        super.init()
        
        //Create each type of
        makeDeck()
        makeDeckRandom()
        makeDeckWar()
    }
    
    convenience init(customDeck: [[String]]) {
        self.init()
        
    }
    // MARK: - Reload (aDecoder) and Save (aCoder) methods
    
    required init?(coder aDecoder: NSCoder) {
        //rank = aDecoder.decodeObjectForKey("rank") as! [Int]
        //suit = aDecoder.decodeObjectForKey("suit") as! [String]
        
        deckOrdered = aDecoder.decodeObject(forKey: "deckOrdered") as! [Card]
        deckRandom = aDecoder.decodeObject(forKey: "deckRandom") as! [Card]
        deckWar = aDecoder.decodeObject(forKey: "deckWar") as! [Card]
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(suit, forKey: "suit")
        
        aCoder.encode(deckOrdered, forKey:"deckOrdered")
        aCoder.encode(deckRandom, forKey:"deckRandom")
        aCoder.encode(deckWar, forKey:"deckWar")
    }
    
    
    /*
        Create an array of four random index numbers for selecting a hand
    */
    func randomIntArray(_ count: Int) -> [Int] {
        
        //Convenience function that returns a random Int 0-deck.count (non-inclusive)
        func randomInt() -> Int {
            
            return Int(arc4random_uniform(UInt32(deckOrdered.count)))
        }
        
        //Fill array with random integers
        func fillArray() -> [Int] {
            
            var result = [Int]()
            
            //Add "count" integers to array
            //No repeating Ints
            while(result.count < count) {
                let temp = randomInt()
                
                if !result.contains(temp) {
                    result.append(temp)
                }
            }
            
            return result
        }
        
        
        return fillArray()
    }

    
    // MARK: - Make Deck methods
    
    /*
     Creates a nonrandom deck of Cards
     */
    func makeDeck() {
        
        //TODO: Abstract the Deck property
        
        let cardType = sH.retrieveFromSettings(sH.cardTypeDictionaryKey) as! String
        let deckSize = sH.retrieveFromSettings(sH.deckSizeDictionaryKey) as! String
        
        //Append a Card to the deck
        for number in rank {
            for name in suit {
                deckOrdered.append(Card(rank: Double(number), suit: name, cardType: cardType, deck: "2"))
            }
        }
        
        //Add more Cards if the user wants a large deck
        if (deckSize == "l") {
            for number in rank {
                for name in suit {
                    deckOrdered.append(Card(rank: Double(number), suit: name, cardType: cardType, deck: "2"))
                }
            }
        }
    }
    
    func makeDeckCustom(data: [[String]]) -> [[Card]] {
        
        var deckP1 = [Card]()
        var deckP2 = [Card]()
        
        for row in data {
            deckP1.append(Card(rank: Double(row[0])!, suit: row[1], cardType: row[3], deck: "2"))
            deckP2.append(Card(rank: Double(row[4])!, suit: row[5], cardType: row[6], deck: "2"))
        }
        
        return [deckP1, deckP2]
    }
    
    /*
     Creates a random deck of Cards
     */
    func makeDeckRandom() {
        let randomNumbers = randomIntArray(deckOrdered.count)
        
        for i in randomNumbers {
            deckRandom.append(deckOrdered[i])
        }
    }
    
    
    /*
     Creates a custom deck to test the War condition
    */
    func makeDeckWar() {
        
        let cardType = sH.retrieveFromSettings(sH.cardTypeDictionaryKey) as! String
        let deckSize = sH.retrieveFromSettings(sH.deckSizeDictionaryKey) as! String
        
        
        /*
         for _ in 0..<3 {
         let rank = 2
         deckWar.append(Card(rank: Double(2), suit: "hearts", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(2), suit: "diamonds", cardType: cardType, deck: "2"))
         }
         */
        
        deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(4), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(4), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(3), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(3), suit: "diamonds", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(3), suit: "hearts", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(6), suit: "diamonds", cardType: cardType, deck: "2"))
        
        
        deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(4), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(4), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(3), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(3), suit: "spades", cardType: cardType, deck: "2"))
        
        deckWar.append(Card(rank: Double(1), suit: "clubs", cardType: cardType, deck: "2"))
        deckWar.append(Card(rank: Double(2), suit: "spades", cardType: cardType, deck: "2"))
        
        /*
         deckWar.append(Card(rank: Double(5), suit: "hearts", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(9), suit: "clubs", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
         
         deckWar.append(Card(rank: Double(9), suit: "hearts", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(10), suit: "diamonds", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(5), suit: "clubs", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(10), suit: "spades", cardType: cardType, deck: "2"))
         
         
         
         deckWar.append(Card(rank: Double(3), suit: "hearts", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(3), suit: "diamonds", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(3), suit: "clubs", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(3), suit: "spades", cardType: cardType, deck: "2"))
         
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         deckWar.append(Card(rank: Double(), suit: "", cardType: cardType, deck: "2"))
         */
    }
}
