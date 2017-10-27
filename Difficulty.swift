//
//  Difficulty.swift
//  FractionsWar
//
//  Created by David Race on 4/27/16.
//
//

import Foundation

enum Difficulty: Double {
    case easy = 10.0
    case normal = 5.0
    case hard = 2.0
    case extreme = 1.0
}

internal func getDifficultyValue(_ difficultyCode: String) -> Double {
    switch(difficultyCode) {
    case "s": return Difficulty.easy.rawValue
    case "m": return Difficulty.normal.rawValue
    case "f": return Difficulty.hard.rawValue
    case "e": return Difficulty.extreme.rawValue
    default: return Difficulty.easy.rawValue
    }
}
