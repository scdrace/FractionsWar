//
//  SettingsViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/20/16.
//
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var backToMainMenuButton: UIButton!
    
    // Card style buttons
    @IBOutlet weak var numberCardButton: UIButton!
    @IBOutlet weak var regularCardButton: UIButton!
    @IBOutlet weak var symbolCardButton: UIButton!
    
    // Deck size buttons
    @IBOutlet weak var normalDeckButton: UIButton!
    @IBOutlet weak var largeDeckButton: UIButton!
    
    // Computer speed buttons
    @IBOutlet weak var slowComputerButton: UIButton!
    @IBOutlet weak var mediumComputerButton: UIButton!
    @IBOutlet weak var fastComputerButton: UIButton!
    
    // Custom game fonts
    var gameFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 32)!
    }
    
    let sH = SettingsHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSettingsMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Settings Screen Interactions
    
    @IBAction func pressBackToMainMenuButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("unwindToMenuFromSettings", sender: self)
        })
    }
    
    // MARK: - Card Style Buttons
    
    @IBAction func pressNumberCardButton(sender: AnyObject) {
        sH.saveToSettings("n", settingsKey: sH.cardTypeDictionaryKey)
    }
    
    @IBAction func pressRegularCardButton(sender: AnyObject) {
        sH.saveToSettings("r", settingsKey: sH.cardTypeDictionaryKey)
    }
    
    @IBAction func pressSymbolCardButton(sender: AnyObject) {
        sH.saveToSettings("s", settingsKey: sH.cardTypeDictionaryKey)
    }
    
    // MARK: - Deck Size Buttons
    
    @IBAction func pressNormalDeckButton(sender: AnyObject) {
        sH.saveToSettings("n", settingsKey: sH.deckSizeDictionaryKey)
    }
    
    @IBAction func pressLargeDeckButton(sender: AnyObject) {
        sH.saveToSettings("l", settingsKey: sH.deckSizeDictionaryKey)
    }
    
    // MARK: - Computer Speed Buttons
    
    @IBAction func pressSlowComputerButton(sender: AnyObject) {
        sH.saveToSettings("s", settingsKey: sH.computerSpeedDictionaryKey)
    }
    
    @IBAction func pressMediumComputerButton(sender: AnyObject) {
        sH.saveToSettings("m", settingsKey: sH.computerSpeedDictionaryKey)
    }
    
    @IBAction func pressFastComputerButton(sender: AnyObject) {
        sH.saveToSettings("f", settingsKey: sH.computerSpeedDictionaryKey)
    }
    
    // MARK: - Menu Display Setup
    
    internal func prepareSettingsMenu() {
        
        backToMainMenuButton.titleLabel?.font = gameFont
        backToMainMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backToMainMenuButton.sizeToFit()
        
        normalDeckButton.titleLabel?.font = gameFont
        normalDeckButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        normalDeckButton.sizeToFit()
        
        largeDeckButton.titleLabel?.font = gameFont
        largeDeckButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        largeDeckButton.sizeToFit()
        
        slowComputerButton.titleLabel?.font = gameFont
        slowComputerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        slowComputerButton.sizeToFit()
        
        mediumComputerButton.titleLabel?.font = gameFont
        mediumComputerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        mediumComputerButton.sizeToFit()
        
        fastComputerButton.titleLabel?.font = gameFont
        fastComputerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fastComputerButton.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
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
