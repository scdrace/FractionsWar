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
class Game: NSObject, NSCoding {
    
    var warDeck = false
    
    let appBeginTime = CACurrentMediaTime()
    fileprivate var timeStamp: String?
    var deck = Deck()
    var round: Int = 0
    var data = Data()
    fileprivate var player1 = Player(name: "player1")
    fileprivate var player2 = Player(name: "player2")
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
    fileprivate var gameState = GameState.start
    
    
    struct Cards {
        var p1Numerator: Card
        var p1Denominator: Card
        var p2Numerator: Card
        var p2Denominator: Card
        
    }
    
    override var description: String {
        return "x"
    }
    
    
    let gameArchiveURL: URL = {
        
        
        //Create path-name for file
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                                                   in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent("gameData.archive")
    }()
    
    override init() {
        
        func timeStamp() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'_'MM'_'dd'_'a'_'HH'_'mm'_'ss"
            
            let date = Date()
            let dateX = dateFormatter.string(from: date)
            
            return dateX
        }
        
        //print("init")
        //print("FilePath \(pathURL("david"))")
        
        self.timeStamp = timeStamp()
        
        super.init()
        
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
        
        
        let deckRandom = deck.deckRandom
        //let deckWar = deck.deckWar
        
        makePlayerDecks(deckRandom)
        
    }
    
    convenience init(customDeck: [[String]]) {
        self.init()
        
        
        let deckCustom = deck.makeDeckCustom(data: customDeck)
        
        makeCustomDecks(playerDecks: deckCustom)
        
    }
    // MARK: - Reload (aDecoder) and Save (aCoder) methods
    
    required init?(coder aDecoder: NSCoder) {
        deck = aDecoder.decodeObject(forKey: "deck") as! Deck
        //round = aDecoder.decodeObjectForKey("round") as! Round
        data = aDecoder.decodeObject(forKey: "data") as! Data
        player1 = aDecoder.decodeObject(forKey: "player1") as! Player
        player2 = aDecoder.decodeObject(forKey: "player2") as! Player
        
        player1ID = aDecoder.decodeObject(forKey: "player1ID") as? String
        player2ID = aDecoder.decodeObject(forKey: "player2ID") as? String
        
        timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? String
        
        print("required init")
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        print("encode")
        
        aCoder.encode(timeStamp, forKey: "timeStamp")
        
        aCoder.encode(deck, forKey: "deck")
        aCoder.encode(round, forKey: "round")
        aCoder.encode(data, forKey: "data")
        aCoder.encode(player1, forKey: "player1")
        aCoder.encode(player2, forKey: "player2")
        aCoder.encode(player1ID, forKey: "player1ID")
        aCoder.encode(player2ID, forKey: "player2ID")
        
    }
    
    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(gameArchiveURL.path)")
        
        //return true
        return NSKeyedArchiver.archiveRootObject(self, toFile: gameArchiveURL.path)
    }

    
    func makeCustomDecks(playerDecks: [[Card]]) {
        player1.subDeck = playerDecks[0]
        player2.subDeck = playerDecks[1]
    }
    
    func makePlayerDecks(_ deckType: [Card]) {
        player1.subDeck.removeAll()
        player2.subDeck.removeAll()
        
        //Get number of elements in half the original deck
        let length = deckType.count / 2
        
        deck.deckRandom.removeLast() //???
        
        //Append half the elements from the original deck to player1-deck
        for index in 0..<length {
            player1.subDeck.append(deckType[index])
        }
        
        //Append final cards from the original deck to player2-deck
        for index in length..<deckType.count {
            player2.subDeck.append(deckType[index])
        }
    }
    
    func makeHands(_ gameState: GameState) {
        
        if (player1.subDeck.count > 1 && player2.subDeck.count > 1) {
            
            //print("MakeHand")
            player1.makeHand(gameState)
            player2.makeHand(gameState)
        }
    }
    
    
    //MARK: - Setter & Getter methods
    
    func getCards() -> Cards {
        
        let cards = Cards(p1Numerator: player1.getNumerator(), p1Denominator: player1.getDenominator(),
                          p2Numerator: player2.getNumerator(), p2Denominator: player2.getDenominator())
        
        return cards
    }
    
    
    func setGameState(_ gameState: GameState) {
        self.gameState = gameState
    }
    
    func getGameState() -> GameState {
        return self.gameState
    }
    
    func setPlayer1ID(_ playerID: String) {
        self.player1ID = playerID
    }
    
    func getPlayer1ID() -> String? {
        return self.player1ID
    }
    
    func setPlayer2ID(_ playerID: String) {
        self.player2ID = playerID
    }
    
    func getPlayer2ID() -> String? {
        return self.player2ID
    }
    
    
    func getPlayer1() -> Player {
        return player1
    }
    
    func getPlayer2() -> Player {
        return player2
    }
    
    func getP1Numerator() -> Card {
        return player1.getNumerator()
    }
    
    func getP1Denominator() -> Card {
        return player1.getDenominator()
    }
    
    func getTimeStamp() -> String {
        return self.timeStamp!
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
        
        if player1.getHand().decimalValue - player2.getHand().decimalValue > 0 {
            return "player1"
        }
        else if player1.getHand().decimalValue - player2.getHand().decimalValue < 0 {
            return "player2"
        }
        else {
            return "tie"
        }
    }
    
    func addHandsToWinnerDeck(_ player: String) {
        
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
    }
    
    
    func getRound() -> Int {
        return round
    }
}
