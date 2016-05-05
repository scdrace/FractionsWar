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
    
    // Custom game fonts
    var gameButtonFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 41)!
    }
    var gameLabelFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 62)!
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
        
        // prepare modal background
        let width = modalView.bounds.size.width
        let height = modalView.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "overlay")
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        modalView.addSubview(imageViewBackground)
        modalView.sendSubviewToBack(imageViewBackground)
        
        // adjust label style
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