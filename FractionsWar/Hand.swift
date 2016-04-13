//
//  Hand.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

class Hand: CustomStringConvertible {
    var numerator: Card2
    var denominator: Card2
    
    var decimalValue: Double {
        return self.numerator.getRank() / self.denominator.getRank()
    }
    
    var description: String {
        return "\(self.numerator), \(self.denominator), \(self.decimalValue)"
    }
    
    init(card1: Card2, card2: Card2) {
        
        if card1.rank > card2.rank {
            self.numerator = card2
            self.denominator = card1
        }
        else {
            self.numerator = card1
            self.denominator = card2
        }
    }
    
    func flipCards() {
        numerator.flipCard()
        denominator.flipCard()
    }
    
    func resizeCards(cardFrame: CGRect) {
        numerator.resizeCard(cardFrame)
        denominator.resizeCard(cardFrame)
    }
    
    func getNumerator() -> Card2 {
        return self.numerator
    }
    
    func getDenominator() -> Card2 {
        return self.denominator
    }
    
    func getDecimalValue() -> Double {
        return self.decimalValue
    }
    
    func imageClean() {
        numerator.imageClean()
        denominator.imageClean()
    }
}