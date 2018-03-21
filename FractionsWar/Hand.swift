//
//  Hand.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

struct Hand: Codable, CustomStringConvertible {
    var numerator: Card
    var denominator: Card
    
    var decimalValue: Double {
        return self.numerator.rank / self.denominator.rank
    }
    
    init(card1: Card, card2: Card) {
        
        //Make sure that the card with the lower rank is in the numerator
        if card1.rank > card2.rank {
            self.numerator = card2
            self.denominator = card1
        }
        else {
            self.numerator = card1
            self.denominator = card2
        }
    }
    
    var description: String {
        return "\(self.numerator), \(self.denominator), \(self.decimalValue)"
    }
        
    func flatHand() -> [Card] {
        return [numerator, denominator]
    }
}
