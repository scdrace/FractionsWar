//
//  Data.swift
//  FractionsWar
//
//  Created by David Race on 4/25/16.
//
//

import Foundation

class Data {
    
    weak var game: Game!
    var customDeck = [[String]]()
    
    var swipeTimeCumulative: Double =  0.0
    var swipeDirection = "empty"
    var swipeDirectionCorrect = "empty"
    
    var header: String {
        
        //TODO
        //total time, additive round time, swipe direction
        let a = "Round,SwipeTime,SwipeTimeCumulative,SwipeDirection,SwipeDirectionCorrect,RoundWinner,"
        
        let b = "player1ID,Player1Points,"
        let c = "Player1NumeratorRank,Player1NumeratorSuit,Player1NumeratorCardType,"
        let d = "Player1DenominatorRank,Player1DenominatorSuit,Player1DenominatorCardType,"
        let player1 = b + c + d
        
        let e = "Player2ID,Player2Points,"
        let f = "Player2NumeratorRank,Player2NumeratorSuit,Player2NumeratorCardType,"
        let g = "Player2DenominatorRank,Player2DenominatorSuit,Player2DenominatorCardType"
        let player2 = e + f + g
        
        
        let result = a + player1 + player2 + "\n"
        return result
    }
    
    func setSwipeDirection(swipeDirection: String) {
        self.swipeDirection = swipeDirection
    }
    
    func setSwipeDirectionCorrect(swipeDirectionCorrect: String) {
        self.swipeDirectionCorrect = swipeDirectionCorrect
    }
    
    func saveRoundData(_ round: Int, swipeTime: Double, highHand: String) {
        
        // Update swipeTimeCumulative
        swipeTimeCumulative += swipeTime
        
        let round = String(round)
        let swipeTime = String(swipeTime)
        let highHand = highHand
        let roundData = [round, swipeTime, String(swipeTimeCumulative), swipeDirection, swipeDirectionCorrect, highHand]
        
        let player1Data = playerData(game.player1)
        let player2Data = playerData(game.player2)
        
        let player1ID = [game.player1.id]
        var player2ID = ["computer"]
        
        if game.player2.id != nil {
            player2ID = [game.player2.id]
        }
        
    
        var result = roundData + player1ID
        result = result + player1Data
        result = result + player2ID
        result = result + player2Data
        
        let resultString = result.joined(separator: ",") + "\n"
        
        print("Player1Data: \(resultString)")
        
        saveToFile(resultString)
    }
    
    /*
     Return: [String], with info about the hand
     */
    func playerData(_ player: Player) -> [String] {
        
        func cardData(_ card: Card) -> [String] {
            let rank = String(Int(card.rank))
            let suit = card.suit
            let type = card.cardType
            
            return [rank, suit, type]
        }
        
        let name = player.name
        let points = String(player.points)
        
        let numeratorData = cardData(player.hand!.numerator)
        let denominatorData = cardData(player.hand!.denominator)
        
        let playerDataArray = [points] + numeratorData + denominatorData
        
        return playerDataArray
    }
    
    
    func saveToFile(_ line: String) {
        
        do {
            
            // Make fileName
            var fileName = "fracWar_" + game.player1.id
            
            if game.player2.id != nil {
                fileName = fileName + "_" + game.player2.id
            }
            
            fileName = fileName + "_" + game.timeStamp!
            
            //print(fileName)
            
            // Final fileName URL
            let playerDataURL = documentDirectoryURL().appendingPathComponent(fileName)
            
            // Test whether file exists
            // If not, begin by writing file header line
            if !FileManager.default.fileExists(atPath: playerDataURL.path) {
                try header.write(to: playerDataURL, atomically: true, encoding: String.Encoding.utf8)
            }
        
            // Write data from round (one line) to file
            let fileHandle =  try FileHandle(forWritingTo: playerDataURL)
            fileHandle.seekToEndOfFile()
            fileHandle.write(line.data(using: String.Encoding.utf8)!)
            
            fileHandle.closeFile()
            
        }
        catch {
            print("SaveError!")
        }
        
    }

}




struct DataFile {
    
    enum PlistError: Error {
        case fileNotWritten
        case fileDoesNotExist
    }
    
    let name = "Data"
    
    var sourcePath: String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }
    
    var destPath: String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent("\(name).plist")
    }
    
    init?() {
        
        let fileManager = FileManager.default
        
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else { return nil }
        
        if !fileManager.fileExists(atPath: destination) {
            
            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func getValuesInPlistFile() -> NSDictionary? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
    
    func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
    
    func addValuesToPlistFile(_ dictionary:NSDictionary) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            if !dictionary.write(toFile: destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.fileNotWritten
            }
        } else {
            throw PlistError.fileDoesNotExist
        }
    }
}

extension Data {
    
    static func readDeckData(fileName: String) -> [[String]] {
        
        /*
        do {
            let x = try FileManager.default.contentsOfDirectory(atPath: documentDirectoryURL().path)
            print(FileManager.default.contents(atPath: x[1]))
        } catch {
            
        }
         */
        
        
        let fileURL = documentDirectoryURL().appendingPathComponent("deck.txt")
        //print(documentDirectoryURL())
        //print(FileManager.default.fileExists(atPath: filePath.path))
        
        
        // Reading back from the file
        var customDeck = [[String]]()
        var inString = ""
        do {
            inString = try String(contentsOf: fileURL)
            let q = inString.components(separatedBy: .newlines)
            for line in q {
                let r = line.components(separatedBy: ",")
                print(r)
                customDeck.append(r)
            }
           
        } catch {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        
        return customDeck
    
    }
    
}

class DataHelper {
    
    // Singleton DataHelper
    static let shared = DataHelper()
    let dataFile = DataFile()
    
    // Variables for interacting with Data plist
    
    let dataPlist = "Data.plist"
    var dataPlistPath: String = ""
    
    fileprivate init() { }
    
    // MARK: - Data Storage Helper Methods
    
    internal func saveToData(_ data: AnyObject, dataKey: String) {
        
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
        
        return dict.count as NSNumber
    }
}
