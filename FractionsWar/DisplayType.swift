//
//  DisplayType.swift
//  FractionsWar
//
//  Created by David Race on 3/13/18.
//

import Foundation

enum DisplayType {
    case displayMoveCards
    case displayName
    case displayWinCardCount
    case displayWinPoints
    case displayWarBoom
}

extension Double {
    // Given a value to round and a factor to round to,
    // round the value to the nearest multiple of that factor.
    func round(toNearest: Double) -> Double {
        return (self / toNearest).rounded() * toNearest
    }
}
