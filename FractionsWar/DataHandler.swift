//
//  DataHandler.swift
//  FractionsWar
//
//  Created by David Race on 3/16/18.
//

import Foundation
import UIKit

extension GameViewController {
    
    @objc func saveChanges() -> Bool {
        //print("Saving items to: \(gameArchiveURL.path)")
        
        return saveGameObj() && saveData()
    }
    
    func saveGameObj() -> Bool {
        let fName = game.player1.name + "_" + game.player2.name
        do {
            let jsonURL = FileManager.documentDirectoryURL.appendingPathComponent(fName).appendingPathExtension("json")
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(game)
            try jsonData.write(to:jsonURL)
            print("SAVED FILE", jsonURL)
            
            return true
        } catch {
            
        }
        
        return false
    }
    
    func saveData() -> Bool {
        let fName = game.player1.name + "_" + game.player2.name
        
        do {
            let txtURL = FileManager.documentDirectoryURL.appendingPathComponent(fName).appendingPathExtension("txt")
            
            var fData = ""
            for column in header() {
                fData += column.capitalized
                fData += ","
            }
            fData = String(fData.dropLast()) + "\n"
            
            for dataHash in game.data {
                var line = ""
                for column in header() {
                    if let value = dataHash[column] {
                        line += value
                        line += ","
                    }
                }
                line = String(line.dropLast()) + "\n"
                fData.append(line)
            }
            
            try fData.write(to: txtURL, atomically: true, encoding: String.Encoding.utf8)
            print(fData)
        } catch {
            
        }
        
        return false
    }
    
    func header() -> [String] {
        
        let result = [
            "round",
            "responder",
            "response",
            "correctResponse",
            "isResponseCorrect",
            "responseTime",
            "responseTimeStamp",
            
            "player1ID",
            "player1Points",
            "player1NumeratorRank",
            "player1NumeratorSuit",
            "player1NumeratorCardType",
            "player1DenominatorRank",
            "player1DenominatorSuit",
            "player1DenominatorCardType",
            "player1HandValue",
            
            "player2ID",
            "player2Points",
            "player2NumeratorRank",
            "player2NumeratorSuit",
            "player2NumeratorCardType",
            "player2DenominatorRank",
            "player2DenominatorSuit",
            "player2DenominatorCardType",
            "player2HandValue"
            ]
        
        return result
    }
    
    func correctResponse() -> String {
        
        if game.highHand == "player1" {
            return "swipeLeft"
        }
        
        if game.highHand == "player2" {
            return "swipeRight"
        }
        
        return "declareWar"
    }
    
    func responseData(responder: Player, response: ResponseType, responseTime: Double,
                      isResponseCorrect: Bool, winner: Player) -> [String: String] {
        
        game.cumulativeTime += responseTime
        var result = [String:String]()
        result["round"] = String(game.round)
        result["responder"] = (responder === game.player1) ? "player1" : "player2"
        result["response"] = response.rawValue
        result["correctResponse"] = correctResponse()
        result["isResponseCorrect"] = (isResponseCorrect == true) ? "correct" : "incorrect"
        result["roundWinner"] = (winner === game.player1) ? "player1" : "player2"
        result["responseTime"] = String(responseTime.round(toNearest: 0.01))
        result["responseTimeStamp"] = String((CACurrentMediaTime() - game.gameStartTime).round(toNearest: 0.01))
        
        return result
    }
    
    func playerData(playerType: PlayerType) -> [String: String] {
        
        var playerNumber = "player1"
        var playerObj = game.player1
        if playerType == .player2 {
            playerNumber = "player2"
            playerObj = game.player2
        }
        
        let hand = playerObj.hand!
        
        var result = [String: String]()
        result[playerNumber+"ID"] = String(playerObj.name)
        result[playerNumber+"Points"] = String(playerObj.points)
        result[playerNumber+"NumeratorRank"] = String(hand.numerator.rank)
        result[playerNumber+"NumeratorSuit"] = hand.numerator.suit
        result[playerNumber+"NumeratorCardType"] = hand.numerator.cardType
        result[playerNumber+"DenominatorRank"] = String(hand.denominator.rank)
        result[playerNumber+"DenominatorSuit"] = hand.denominator.suit
        result[playerNumber+"DenominatorCardType"] = hand.denominator.cardType
        result[playerNumber+"HandValue"] = String(hand.decimalValue.round(toNearest: 0.01))
        
        return result
    }
    
    func mergeDicts<K,V>(dict1: [K: V], dict2: [K: V]) -> [K: V] {
        var result = dict1
        for (key, value) in dict2 {
            result[key] = value
        }
        return result
    }
    
    func dataHandler(responder: Player, response: ResponseType, responseTime: Double,
                     isResponseCorrect: Bool, winner: Player) {
        
        let respData = responseData(responder: responder,
                                    response: response,
                                    responseTime: responseTime,
                                    isResponseCorrect: isResponseCorrect,
                                    winner: winner)
        
        let p1Data = playerData(playerType: .player1)
        let p2Data = playerData(playerType: .player2)
        
        let playersData = mergeDicts(dict1: p1Data, dict2: p2Data)
        let allData = mergeDicts(dict1: playersData, dict2: respData)
        
        game.data.append(allData)
        print(game.round, game.data.count)
        //print(allData)
    }

}
