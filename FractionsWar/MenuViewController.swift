//
//  MenuViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/17/16.
//
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    var customDeckName: String?
    var game: Game?
    
    @IBOutlet weak var onePlayerButton: UIButton!
    @IBOutlet weak var twoPlayerButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    var player1ID: String?
    var player2ID: String?
    var playerQuantity = 0
    
    // Custom game fonts
    var gameGlobalFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
    }
    var gameFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 25)!
        default:
            return UIFont(name: "DINCond-Bold", size: 38)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UILabel.appearance().font = gameGlobalFont
        
        prepareMenu()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPlayer1ID),
                                                         name: NSNotification.Name(rawValue: "GameWantsPlayer1ID"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPlayer2ID),
                                                         name: NSNotification.Name(rawValue: "GameWantsPlayer2ID"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @objc func getPlayer1ID() -> String? {
        return player1ID
    }
    
    @objc func getPlayer2ID() -> String? {
        return player2ID
    }
    
    // MARK: - Menu Display Setup
    
    internal func prepareMenu() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        aboutButton.titleLabel?.font = gameGlobalFont
        aboutButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        aboutButton.sizeToFit()
        
        onePlayerButton.titleLabel?.font = gameFont
        onePlayerButton.setTitleColor(UIColor.white, for: UIControlState())
        onePlayerButton.sizeToFit()
        
        twoPlayerButton.titleLabel?.font = gameFont
        twoPlayerButton.setTitleColor(UIColor.white, for: UIControlState())
        twoPlayerButton.sizeToFit()
        
        settingsButton.titleLabel?.font = gameFont
        settingsButton.setTitleColor(UIColor.white, for: UIControlState())
        settingsButton.sizeToFit()
        
        howToPlayButton.titleLabel?.font = gameFont
        howToPlayButton.setTitleColor(UIColor.white, for: UIControlState())
        howToPlayButton.sizeToFit()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {}
    
    @IBAction func press1PlayerModeButton(_ sender: AnyObject) {
        
        playerQuantity = 1
        enterPlayerID(playerQuantity: 1, sender: sender)
    }
    

    @IBAction func press2PlayerModeButton(_ sender: AnyObject) {
        
        playerQuantity = 2
        enterPlayerID(playerQuantity: 2,  sender: sender)
    }
    
    
    @IBAction func customDeck(sender: AnyObject) {
        customDeckAlert()
    }
    
    func enterPlayerID(playerQuantity: Int, sender: AnyObject) {
        
        let exportAlert = UIAlertController(title: "Player Name", message: "Enter player name below and press \("Continue").", preferredStyle: UIAlertControllerStyle.alert)
        
        
        exportAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Player 1 Name"
        })
        
        if playerQuantity == 2 {
            exportAlert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Player 2 Name"
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exportAlert.addAction(cancelAction)
        
        exportAlert.addAction(continueAction(alertController: exportAlert, sender: sender))
        
        
        present(exportAlert, animated: true, completion: {})
    }
    
    func continueAction(alertController: UIAlertController, sender: AnyObject) -> UIAlertAction {
        
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in
            if self.doesFileExist(controller: alertController) == true {
                self.loadGameAlert(alertController: alertController)
            } else {
                self.createNewGame(alertController: alertController)
                self.performSegue(withIdentifier: "MenuToGameSegue", sender: sender)
            }
        })
        
        return continueAction
    }

    func createFileName(controller: UIAlertController) -> String? {
        // This is not really correct, but need a way to cancel if no name is given
        guard let player1 = controller.textFields?[0].text else { return nil }
        
        let player2: String = (controller.textFields?.count == 2) ? controller.textFields![1].text! : "Computer"
        
        let name = player1 + "_" + player2
        return name
    }
    
    func doesFileExist(controller: UIAlertController) -> Bool {
        
        // This is not really correct, but need a way to cancel if no name is given
        guard let name = createFileName(controller: controller) else { return true }

        let file = FileManager.documentDirectoryURL.appendingPathComponent(name).appendingPathExtension("txt")

        if FileManager.default.fileExists(atPath: file.path) {
            return true
        }
        return false
    }
    
    func loadGameAlert(alertController: UIAlertController) {
        
        guard let file = createFileName(controller: alertController) else { return }
        
        let exportAlert = UIAlertController(title: "File Exists for these Players", message: "Press \("Load") to resume game.", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exportAlert.addAction(cancelAction)
        
        let loadAction = UIAlertAction(title: "Load", style: .default, handler: { (action: UIAlertAction) in
            do {
                let url = FileManager.getFile(name: file, ext: "json")
                let jsonDecoder = JSONDecoder()
                let savedJSONData = try Data(contentsOf: url)
                let jsonGame = try jsonDecoder.decode(Game.self, from: savedJSONData)
                self.game = jsonGame
                self.game!.loadGame = true
                self.performSegue(withIdentifier: "MenuToGameSegue", sender: self)
            } catch { print("Load Problem")}
            })
        exportAlert.addAction(loadAction)

        present(exportAlert, animated: true, completion: {})
    }
    
    func createNewGame(alertController: UIAlertController) {
        
        let fileNames = createFileName(controller: alertController)!.components(separatedBy: "_")
        
        game = Game(player1Name: fileNames[0], player2Name: fileNames[1])
        
        //Pass number of players
        if fileNames[1] == "Computer" {
            game!.playerMode = 1
        } else {
            game!.playerMode = 2
        }
        
        print("FileNames:", fileNames)
    }
    
    
    func customDeckAlert() {
        
        let exportAlert = UIAlertController(title: "File Name", message: "Enter file-name below and press \("Continue").", preferredStyle: UIAlertControllerStyle.alert)
        
        exportAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "File Name"
        })
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exportAlert.addAction(cancelAction)
        
        let loadAction = UIAlertAction(title: "Load", style: .default, handler: { (action: UIAlertAction) in
            self.customDeckName = exportAlert.textFields!.first!.text!
        })
        exportAlert.addAction(loadAction)
        
        present(exportAlert, animated: true, completion: {})
        
    }
    
    func readDeckData(fileName: String) {
        
        guard let game = self.game else { return }
        
        let fileURL = FileManager.getFile(name: fileName, ext: "txt")

        // Reading back from the file
        var p1Deck = [Card]()
        var p2Deck = [Card]()
        
        do {
            let inString: String = try String(contentsOf: fileURL)
            let cards = inString.components(separatedBy: .newlines)
            print(cards)
            for line in cards {
                let cardStr = line.components(separatedBy: ",")
                if cardStr.count == 4 {
                    print(cardStr)
                    let player = cardStr[0]
                    let rank = Double(cardStr[1])!
                    let suit = cardStr[2]
                    let cardType = cardStr[3]
                    
                    let card = Card(rank: rank, suit: suit, cardType: cardType)
                    if player == "p1" {
                        p1Deck.append(card)
                    } else {
                        p2Deck.append(card)
                    }
                }
            }

            game.player1.deck = p1Deck.reversed()
            game.player2.deck = p2Deck.reversed()
        } catch {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Pass data to GameViewController
        if let controller = segue.destination as? GameViewController {
            
//            //WarDeck for testing
//            if self.customDeckData.count == 0 {
//                controller.game = Game()
//            } else {
//                controller.game = Game(customDeck: customDeckData)
//                customDeckData.removeAll()
//            }
            
            if let name = customDeckName {
                readDeckData(fileName: name)
            }
            controller.game = game
        }
    }
   
    
}
