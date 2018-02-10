//
//  swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

//CustomStringConvertible
class Game: CustomStringConvertible {
    
    var warDeck = false
    
    let appBeginTime = CACurrentMediaTime()
    fileprivate var _timeStamp: String?
    var timeStamp: String? { return _timeStamp }
    var round: Int = 0
    var data = Data()
    
    
    fileprivate var _player1 = Player(name: "player1")
    var player1: Player { return _player1 }
    fileprivate var _player2 = Player(name: "player2")
    var player2: Player { return _player2 }
    
    fileprivate var player1ID: String?
    fileprivate var player2ID: String?
    
    // Game state variables
    var p1ready = false
    var p2ready = false
    var cardsAreUp = false
    var inAction = false
    
    //Misc. variables
    var roundStartTime = 0.0
    var swipeTime = 0.0
    var computerTimer =  Timer()
    
    var playerMode = 0
    fileprivate var _gameState = GameState.start
    var gameState: GameState {
        get {
            return _gameState
        }
        set {
            _gameState = (newValue)
        }
    }
    
    
    struct Cards {
        var p1Numerator: Card
        var p1Denominator: Card
        var p2Numerator: Card
        var p2Denominator: Card
        
    }
    
    var description: String {
        return "x"
    }
    
    
    let gameArchiveURL: URL = {
        
        
        //Create path-name for file
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                                                   in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent("gameData.archive")
    }()
    
    init() {
        
        func timeStamp() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'_'MM'_'dd'_'a'_'HH'_'mm'_'ss"
            
            let date = Date()
            let dateX = dateFormatter.string(from: date)
            
            return dateX
        }
        
        //print("init")
        //print("FilePath \(pathURL("david"))")
        
        _timeStamp = timeStamp()
        
        self.data.game = self
        self.round = 1
        
        /*
        do {
            player1.id = try String(contentsOfURL: player1IDURL(), encoding: NSUTF8StringEncoding)
            print(player1.id)
        }
        catch {
            
        }
        */
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveChanges),
                                                         name: NSNotification.Name(rawValue: "ResignActive"), object: nil)
        
        
        //let deckRandom = deck.deckRandom
        //let deckWar = deck.deckWar
        
        //makePlayerDecks(deckRandom)
        
        let deck = DeckRandomizer()
        deck.dealCards(player1: player1, player2: player2)
        
    }
    
    convenience init(customDeck: [[String]]) {
        self.init()
        
        
        //let deckCustom = deck.makeDeckCustom(data: customDeck)
        
        //makeCustomDecks(playerDecks: deckCustom)
        
    }
    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(gameArchiveURL.path)")
        
        //return true
        //return NSKeyedArchiver.archiveRootObject(self, toFile: gameArchiveURL.path)
        return false
    }
    
    //MARK: - Setter & Getter methods
    
    func getCards() -> Cards {
        
        
        let cards = Cards(p1Numerator: player1.hand!.numerator, p1Denominator: player1.hand!.denominator,
                          p2Numerator: player2.hand!.numerator, p2Denominator: player2.hand!.denominator)
        
        return cards
    }
    
    //MARK: - Save Data
    func saveDataImmediate(_ swipeTime: Double) {
        data.saveRoundData(round, swipeTime: swipeTime, highHand: highHand)
        //print("XXXXXXX:\(info)")
        //data.saveToTextImmediately(info)
        
    }
}

extension Game {
    
    var highHand: String {
        
        if player1.hand!.decimalValue - player2.hand!.decimalValue > 0 {
            return "player1"
        }
        else if player1.hand!.decimalValue - player2.hand!.decimalValue < 0 {
            return "player2"
        }
        else {
            return "tie"
        }
    }
    
    
    func addHandsToWinnerDeck(_ player: String) {
        
        /*
        let hands = player1.hand + player2.hand
        
        switch player {
        case "player1":
            player1.addCardsToPlayerDeck(hands)
            break
        case "player2":
            player2.addCardsToPlayerDeck(hands)
            break
        default: break
        }
        */
    }
    
    
    func getRound() -> Int {
        return round
    }
}
