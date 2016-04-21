//
//  PauseViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/20/16.
//
//

import Foundation
import UIKit

class PauseViewController: UIViewController {
    
    @IBOutlet weak var forfeitButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    // Custom game fonts
    var gameFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 41)!
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
    
    @IBAction func pressForfeitButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("unwindToMenuFromPause", sender: self)
        })
    }
    
    @IBAction func pressReturnToGameButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    // MARK: - Pause Screen Display Setup
    
    internal func prepareScreen() {
        
        forfeitButton.titleLabel?.font = gameFont
        forfeitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        forfeitButton.sizeToFit()
        
        returnButton.titleLabel?.font = gameFont
        returnButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        forfeitButton.sizeToFit()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
