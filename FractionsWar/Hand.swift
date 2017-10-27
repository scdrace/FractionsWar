//
//  Hand.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

class Hand: NSObject, NSCoding {
    var numerator: Card!
    var denominator: Card!
    
    // Dedicam value of the hand-(fraction)
    var decimalValue: Double {
        return self.numerator.getRank() / self.denominator.getRank()
    }
    
    override var description: String {
        return "\(self.numerator), \(self.denominator), \(self.decimalValue)"
    }
    
    
    init(card1: Card, card2: Card) {
        
        //Make sure that the card with the lower rank is in the numerator
        func cardPlacement() {
            if card1.rank > card2.rank {
                self.numerator = card2
                self.denominator = card1
            }
            else {
                self.numerator = card1
                self.denominator = card2
            }
        }
        
        super.init()
        
        cardPlacement()
     
    }
    
    // MARK: - Reload (aDecoder) and Save (aCoder) methods
    
    required init?(coder aDecoder: NSCoder) {
        numerator = aDecoder.decodeObject(forKey: "numerator") as! Card
        denominator = aDecoder.decodeObject(forKey: "denominator") as! Card
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numerator, forKey: "numerator")
        aCoder.encode(denominator, forKey: "denominator")
    }
    
    
    // MARK: - Setter & Getter Methods
    
    func getNumerator() -> Card {
        return self.numerator
    }
    
    func getDenominator() -> Card {
        return self.denominator
    }
    
    func getDecimalValue() -> Double {
        return self.decimalValue
    }
    
    func imageClean() {
        numerator.imageClean()
        denominator.imageClean()
    }
    
    
    // MARK: - Flip methods
    
    /*
        Flip cards in hand, (numerator & denominator), from Back to Face
    */
    func flipCards() {
        numerator.flipCard()
        denominator.flipCard()
    }
    
    /*
     Flip cards in hand, (numerator & denominator), from Face to Back
     */
    func flipDown() {
        numerator.flipDown()
        denominator.flipDown()
    }
    
    // MARK: - Card Maintenence Methods
    
    /*
        Resize the UIView (i.e. cardView) to fit cardPorts-(Interface Builder)
    */
    func resizeCards(_ cardFrame: CGRect) {
        numerator.resizeCard(cardFrame)
        denominator.resizeCard(cardFrame)
    }
    
}
