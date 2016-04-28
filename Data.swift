//
//  Data.swift
//  FractionsWar
//
//  Created by David Race on 4/25/16.
//
//

import Foundation

class Data {
    
    var player1: Player
    var player2: Player
    var gameData = [[String]]()
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        
    }
    
    func addRoundData(round: Int, swipeTime: Double, highHand: String) {
        
        let round = String(round)
        let swipeTime = String(swipeTime)
        let highHand = String(highHand)
        
        let player1 = playerData(self.player1, addCardType: true)
        let player2 = playerData(self.player2, addCardType: false)
        
        var result = [String]()
        result.append(round)
        result.append(swipeTime)
        result.append(highHand)
        result.appendContentsOf(player1)
        result.appendContentsOf(player2)
        
        gameData.append(result)
        
        print(gameData)
    }
    
    
    func cardData(card: Card, addCardType: Bool ) -> [String] {
        let rank = String(card.rank)
        let suit = card.suit
        let cardType = card.cardType
        
        if addCardType == true {
            return [cardType, rank, suit]
        }
        
        return [rank, suit]
    }
    
    func playerData(player: Player, addCardType: Bool) -> [String] {
        
        let name = player.getName()
        var numerator = [String]()
        
        if addCardType == true {
            numerator = cardData(player.getNumerator(), addCardType: true)
        }
        else {
            numerator = cardData(player.getNumerator(), addCardType: false)
        }
        let denominator = cardData(player.getDenominator(), addCardType: false)
        
        let points = [String(player.getPoints())]
        
        var result = [String]()
        result.append(name)
        result.appendContentsOf(numerator)
        result.appendContentsOf(denominator)
        result.appendContentsOf(points)
        
        return result
    }
}