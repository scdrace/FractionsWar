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
    
    @IBOutlet weak var onePlayerButton: UIButton!
    @IBOutlet weak var twoPlayerButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
        
    // Custom game fonts
    var gameFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 32)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMenu()
        
        UILabel.appearance().font = gameFont
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // MARK: - Menu Display Setup
    
    internal func prepareMenu() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        onePlayerButton.titleLabel?.font = gameFont
        onePlayerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        onePlayerButton.sizeToFit()
        
        twoPlayerButton.titleLabel?.font = gameFont
        twoPlayerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        twoPlayerButton.sizeToFit()
        
        settingsButton.titleLabel?.font = gameFont
        settingsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        settingsButton.sizeToFit()
        
        howToPlayButton.titleLabel?.font = gameFont
        howToPlayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        howToPlayButton.sizeToFit()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    @IBAction func press1PlayerModeButton(sender: AnyObject) {
        
        performSegueWithIdentifier("GameControllerSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        playerMode(segue, sender: sender)
    }
    
    func playerMode(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        func getPlayerNum() -> Int? {
            if let button = sender as? UIButton {
                let text = button.titleLabel!.text!
                let players = Int(String(text[text.startIndex]))
                
                return players
            }
            
            return nil
        }
        
        func passData(players: Int) {
            let controller = segue.destinationViewController as! GameViewController
            
            if players == 1 {
                controller.playerMode = 1
            }
            else if players == 2 {
                controller.playerMode = 2
            }
        }
        
        let players = getPlayerNum()
        if let playerNum = players {
            passData(playerNum)
        }
    }
}
