//
//  GameState.swift
//  FractionsWar
//
//  Created by David Race on 6/8/16.
//
//

import Foundation

enum GameState: String, Codable {
    
    case start
    case gameOver
    case pause
    
    case roundStart
    case cardsDealt
    case cardsFlipped
    case playerResponded
    case roundEnd
}
