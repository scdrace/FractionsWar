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


struct DataFile {
    
    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    
    let name = "Data"
    
    var sourcePath: String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else { return .None }
        return path
    }
    
    var destPath: String? {
        guard sourcePath != .None else { return .None }
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
    }
    
    init?() {
        
        let fileManager = NSFileManager.defaultManager()
        
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExistsAtPath(source) else { return nil }
        
        if !fileManager.fileExistsAtPath(destination) {
            
            do {
                try fileManager.copyItemAtPath(source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func getValuesInPlistFile() -> NSDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            if !dictionary.writeToFile(destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
}


class DataHelper {
    
    // Singleton DataHelper
    static let shared = DataHelper()
    let dataFile = DataFile()
    
    // Variables for interacting with Data plist
    
    let dataPlist = "Data.plist"
    var dataPlistPath: String = ""
    
    private init() { }
    
    // MARK: - Data Storage Helper Methods
    
    internal func saveToData(data: AnyObject, dataKey: String) {
        
        let dict = dataFile!.getMutablePlistFile()!
        dict[dataKey] = data
        
        do {
            try dataFile!.addValuesToPlistFile(dict)
        } catch {
            print(error)
        }
    }
    
    internal func retrieveDataPlistSize() -> NSNumber {
        
        let dict = dataFile!.getValuesInPlistFile()!
        
        return dict.count
    }
}