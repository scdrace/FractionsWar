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
    
    var customDeckData = [[String]]()
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
        /*
        //aboutButton.titleLabel?.font = gameFont //gameGlobalFont
        aboutButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        aboutButton.sizeToFit()
        
        //onePlayerButton.titleLabel?.font = gameFont
        onePlayerButton.setTitleColor(UIColor.white, for: UIControlState())
        onePlayerButton.sizeToFit()
        
        //twoPlayerButton.titleLabel?.font = gameFont
        twoPlayerButton.setTitleColor(UIColor.white, for: UIControlState())
        twoPlayerButton.sizeToFit()
        
        //settingsButton.titleLabel?.font = gameFont
        settingsButton.setTitleColor(UIColor.white, for: UIControlState())
        settingsButton.sizeToFit()
        
        //howToPlayButton.titleLabel?.font = gameFont
        howToPlayButton.setTitleColor(UIColor.white, for: UIControlState())
        howToPlayButton.sizeToFit()
        */
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {}
    
    @IBAction func press1PlayerModeButton(_ sender: AnyObject) {
        
        playerQuantity = 1
        enterPlayerID(1, playerNumber: "Player 1", sender: sender)
    }
    

    @IBAction func press2PlayerModeButton(_ sender: AnyObject) {
        
        playerQuantity = 2
        enterPlayerID(2, playerNumber: "Player 1", sender: sender)
    }
    
    
    @IBAction func readWarDeck(sender: UIButton) {
        
        self.customDeckData.removeAll()
        
        self.customDeckData = Data.readDeckData(fileName: "deck")
        //game = Game(warDeck: true)
        
        
    }
    
    func continueAction(_ alertController: UIAlertController, playerQuantity: Int,
                        playerNumber: String, sender: AnyObject) -> UIAlertAction {
        
        
        //TODO: Probably remove this; ID Data should be saved with Game-Object
        /*
        func saveID(input: String) {
            do {
                
                
                try self.player1ID!.writeToURL(player1IDURL(), atomically: true, encoding: NSUTF8StringEncoding)
                
                //if playerQuantity == 2 && playerNumber == "Player 1" {
                //    return
                //}
                
                self.performSegueWithIdentifier("MenuToGameSegue", sender: sender)
                
            }
            catch {
                
            }
        }
        */
        
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in

            
            //Get texField
            let textField = alertController.textFields!.first! as UITextField
            
            //Add textField text to playerID variables
            if playerNumber == "Player 1" {
                self.player1ID = textField.text
            }
            else if playerNumber == "Player 2" {
                self.player2ID = textField.text
            }
            
            //Update AlertView/Segue, depending on playerQuantity
            switch playerQuantity {
            case 1 where playerNumber == "Player 1":
                self.performSegue(withIdentifier: "MenuToGameSegue", sender: sender)
                break
            case 2 where playerNumber == "Player 1":
                self.enterPlayerID(2, playerNumber: "Player 2", sender: sender)
                break
            case 2 where playerNumber == "Player 2":
                self.performSegue(withIdentifier: "MenuToGameSegue", sender: sender)
                break
            default:
                break
            }
        })
    
        return continueAction
    }

    
    func enterPlayerID(_ playerQuantity: Int, playerNumber: String, sender: AnyObject) {
        
        let exportAlert = UIAlertController(title: playerNumber, message: "Enter your player code below and press \("Continue").", preferredStyle: UIAlertControllerStyle.alert)
        
        
        exportAlert.addTextField(configurationHandler: { (textField) -> Void in
            
            if playerNumber == "Player 1" {
               textField.placeholder = "Player 1 Code"
            }
            else if playerNumber == "Player 2" {
                textField.placeholder = "Player 2 Code"
            }
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        exportAlert.addAction(cancelAction)
        exportAlert.addAction(continueAction(exportAlert, playerQuantity: playerQuantity, playerNumber: playerNumber, sender: sender))
        
        
        present(exportAlert, animated: true, completion: {
        })
    }
    
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Pass data to GameViewController
        if let controller = segue.destination as? GameViewController {
            
            //WarDeck for testing
            if self.customDeckData.count == 0 {
                controller.game = Game()
            } else {
                controller.game = Game(customDeck: customDeckData)
                customDeckData.removeAll()
            }
            
            //Pass number of players
            controller.game.playerMode = self.playerQuantity
            
            //Pass player1ID
            if self.player1ID != nil {
                controller.game.setPlayer1ID(self.player1ID!)
                controller.p1NameText = self.player1ID!
            }
            
            //Pass player2ID
            if self.player2ID != nil {
                controller.game.setPlayer2ID(self.player2ID!)
                controller.p2NameText = self.player2ID!
            }
        }
    }
   
    
}
