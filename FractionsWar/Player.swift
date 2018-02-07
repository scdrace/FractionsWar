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
    let id: String
    //var points = 0          // Current total points
    //var hand = [Hand]()    //
    var deck = [Card]()    // Deck that is subset of the Main-Deck; Player selects from this deck
    
    var warHands = 2
    
    fileprivate var _hand = [Hand]()
    var hand: [Hand] {
        return _hand
    }
    
    fileprivate var _points = 0
    var points: Int {
        get {
            return _points
        }
        set {
            _points += newValue
        }
    }
    
    init (name: String) {
        self.name = name
        self.id = "qwe"
    }
    
    var description: String {
        return "\(self.points) points & \(self.hand[0].description) hand & \(self.subDeck.debugDescription) all cards"
    }
    
    // MARK: - Setter & Getter Methods
    
    
    func getName() -> String {
        return name
    }
    
    func getHand() -> Hand {
        return self.hand[0]
    }
    
    /*
     Make the hand (numerator & denominator Cards)
     Select Cards from subDeck
     */
    func makeHand(_ gameState: GameState) {
        
        var maxHands = 1
        
        func setMaxHands() {
            if gameState == .war {
                maxHands = warHands
            }
        }
        
        /*
         Return [Card] with Cards from subDeck
         */
        func getCardsFromSubDeck() -> [Card] {
            var cardsForHand = [Card]()
            
            for x in 0..<(maxHands * 2) {
                cardsForHand.append(subDeck.removeLast())
                //print(x, maxHands, (maxHands * 2), cardsforHand.last)
            }
            
            return cardsForHand
        }
        
        
        /*
         Append Hand(s) to self.hand
         In normal mode, only one hand should exist
         In War-Mode, multiple hands should exist
         */
        func addHands(_ cards: [Card]) {
            
            var handIndex = 0
            var cardIndex = 0
            while handIndex < maxHands {
                let hand = Hand(card1: cards[cardIndex], card2: cards[cardIndex+1])
                _hand.insert(hand, at: handIndex)
                handIndex += 1
                cardIndex += 2
            }
        }
        
        setMaxHands()
        let localCards = getCardsFromSubDeck()
        addHands(localCards)
    }
    
    
    /*
     Add the cards from each hand to the winner's deck
     */
    func addCardsToPlayerDeck(_ hands: [Hand]) {
        
        
        // Place all cards into single stack
        var randCards = [Card]()
        for hand in hands {
            randCards.insert(hand.numerator, at: 0)
            randCards.insert(hand.denominator, at: 0)
        }
        
        // Remove cards from stack in random order and place into deck at index 0
        while !randCards.isEmpty {
            
            //TODO: random Int is used in multiple classes; Make this a global function
            let random = Int(arc4random_uniform(UInt32(randCards.count)))
            subDeck.insert(randCards.remove(at: random), at: 0)
        }
        
    }
}

/*
class Player: NSObject, NSCoding {
    
    var name: String        // Player name
    var id: String?
    var points = 0          // Current total points
    var hand = [Hand]()    //
    var subDeck = [Card]()    // Deck that is subset of the Main-Deck; Player selects from this deck
    
    var warHands = 2
    
    init (name: String) {
        self.name = name
        
        super.init()
    }
    
    override var description: String {
        return "\(self.points) points & \(self.hand[0].description) hand & \(self.subDeck.debugDescription) all cards"
    }
    
    // MARK: - Reload (aDecoder) and Save (aCoder) methods
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        points = aDecoder.decodeInteger(forKey: "points")
        //hand = aDecoder.decodeObjectForKey("hand") as! [Hand]
        subDeck = aDecoder.decodeObject(forKey: "subDeck") as! [Card]
        
        warHands = aDecoder.decodeInteger(forKey: "warHands")
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(points, forKey: "points")
        aCoder.encode(hand, forKey: "hand")
        aCoder.encode(subDeck, forKey: "subDeck")
        
        aCoder.encode(warHands, forKey: "warHands")
        
    }
    
    
    // MARK: - Setter & Getter Methods
    
    
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
    
    func addPoints(_ points: Int = 1) {
        self.points += points
    }
    
    func getPoints() -> Int {
        return points
    }
    
    
    /*
        Make the hand (numerator & denominator Cards)
        Select Cards from subDeck
    */
    func makeHand(_ gameState: GameState) {
        
        var maxHands = 1
        
        func setMaxHands() {
            if gameState == .war {
                maxHands = warHands
            }
        }
        
        /* 
        Return [Card] with Cards from subDeck
        */
        func getCardsFromSubDeck() -> [Card] {
            var cardsForHand = [Card]()
            
            for x in 0..<(maxHands * 2) {
                cardsForHand.append(subDeck.removeLast())
                //print(x, maxHands, (maxHands * 2), cardsforHand.last)
            }
            
            return cardsForHand
        }
        
        
        /*
        Append Hand(s) to self.hand
        In normal mode, only one hand should exist
        In War-Mode, multiple hands should exist
        */
        func addHands(_ cards: [Card]) {
            
            var handIndex = 0
            var cardIndex = 0
            while handIndex < maxHands {
                let hand = Hand(card1: cards[cardIndex], card2: cards[cardIndex+1])
                self.hand.insert(hand, at: handIndex)
                handIndex += 1
                cardIndex += 2
            }
        }
        
        setMaxHands()
        let localCards = getCardsFromSubDeck()
        addHands(localCards)
    }
    
    
    /*
        Add the cards from each hand to the winner's deck
    */
    func addCardsToPlayerDeck(_ hands: [Hand]) {
        
        
        // Place all cards into single stack
        var randCards = [Card]()
        for hand in hands {
            randCards.insert(hand.numerator, at: 0)
            randCards.insert(hand.denominator, at: 0)
        }
        
        // Remove cards from stack in random order and place into deck at index 0
        while !randCards.isEmpty {
            
            //TODO: random Int is used in multiple classes; Make this a global function 
            let random = Int(arc4random_uniform(UInt32(randCards.count)))
            subDeck.insert(randCards.remove(at: random), at: 0)
        }
        
    }
}
 */
