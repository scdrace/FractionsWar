//
//  Player.swift
//  FractionsWar
//
//  Created by David Race on 3/27/16.
//
//

import Foundation

class Player: CustomStringConvertible {
    
    var points = 0
    var hand: Hand?
    

    var description: String {
        return ""
    }
    
    func getNumerator() -> Card2 {
        return self.hand!.getNumerator()
    }
    
    func getDenominator() -> Card2 {
        return self.hand!.getDenominator()
    }
    
    func getHand() -> Hand {
        return self.hand!
    }
    
    func addPoints(points: Int = 1) {
        self.points += points
    }
    
}