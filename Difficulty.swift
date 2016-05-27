//
//  Difficulty.swift
//  FractionsWar
//
//  Created by David Race on 4/27/16.
//
//

import Foundation

enum Difficulty: Double {
    case Easy = 10.0
    case Normal = 5.0
    case Hard = 2.0
    case Extreme = 1.0
}

internal func getDifficultyValue(difficultyCode: String) -> Double {
    switch(difficultyCode) {
    case "s": return Difficulty.Easy.rawValue
    case "m": return Difficulty.Normal.rawValue
    case "f": return Difficulty.Hard.rawValue
    case "e": return Difficulty.Extreme.rawValue
    default: return Difficulty.Easy.rawValue
    }
}