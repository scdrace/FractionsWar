//
//  GameOverViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 5/4/16.
//
//

import Foundation
import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var returnToMainMenuButton: UIButton!
    
    var winner: String?
    
    // Custom game fonts
    var gameButtonFont: UIFont {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return UIFont(name: "DINCond-Bold", size: 32)!
        default:
            return UIFont(name: "DINCond-Bold", size: 42)!
        }
    }
    var gameLabelFont: UIFont {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return UIFont(name: "DINCond-Bold", size: 38)!
        default:
            return UIFont(name: "DINCond-Bold", size: 62)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Pause Screen Interactions
    
    @IBAction func pressReturnToMainMenuButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("unwindToMenuFromGameOver", sender: self)
        })
    }
    
    // MARK: - Pause Screen Display Setup
    
    internal func prepareScreen() {
        
        // adjust label style
        winnerLabel.text = winner
        winnerLabel.font = gameLabelFont
        
        // adjust button style
        returnToMainMenuButton.titleLabel?.font = gameButtonFont
        returnToMainMenuButton.sizeToFit()
    }
    
    // MARK: - Navigation
        
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}