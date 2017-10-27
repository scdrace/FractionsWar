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
    @IBOutlet weak var outOfCardsLabel: UILabel!
    @IBOutlet weak var p1PtsLabel: UILabel!
    @IBOutlet weak var p2PtsLabel: UILabel!
    @IBOutlet weak var returnToMainMenuButton: UIButton!
    
    var winner: String?
    var out: String?
    var p1Pts: String?
    var p2Pts: String?
    
    // Custom game fonts
    var gameButtonFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 32)!
        default:
            return UIFont(name: "DINCond-Bold", size: 42)!
        }
    }
    var gameBigLabelFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 38)!
        default:
            return UIFont(name: "DINCond-Bold", size: 62)!
        }
    }
    var gameLabelFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 18)!
        default:
            return UIFont(name: "DINCond-Bold", size: 36)!
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
    
    @IBAction func pressReturnToMainMenuButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "unwindToMenuFromGameOver", sender: self)
        })
    }
    
    // MARK: - Pause Screen Display Setup
    
    internal func prepareScreen() {
        
        // adjust label styles
        winnerLabel.text = winner
        winnerLabel.font = gameBigLabelFont
        winnerLabel.sizeToFit()
        
        outOfCardsLabel.text = out
        outOfCardsLabel.font = gameLabelFont
        outOfCardsLabel.sizeToFit()
        
        p1PtsLabel.text = p1Pts
        p1PtsLabel.font = gameLabelFont
        p1PtsLabel.sizeToFit()
        
        p2PtsLabel.text = p2Pts
        p2PtsLabel.font = gameLabelFont
        p2PtsLabel.sizeToFit()
        
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
