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
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
