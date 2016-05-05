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
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
    }
    
    let sH = SettingsHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSettingsMenu()
        setSelectedOptions()
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
        numberCardButton.selected = true
        regularCardButton.selected = false
        symbolCardButton.selected = false
    }
    
    @IBAction func pressRegularCardButton(sender: AnyObject) {
        sH.saveToSettings("r", settingsKey: sH.cardTypeDictionaryKey)
        numberCardButton.selected = false
        regularCardButton.selected = true
        symbolCardButton.selected = false
    }
    
    @IBAction func pressSymbolCardButton(sender: AnyObject) {
        sH.saveToSettings("s", settingsKey: sH.cardTypeDictionaryKey)
        numberCardButton.selected = false
        regularCardButton.selected = false
        symbolCardButton.selected = true
    }
    
    // MARK: - Deck Size Buttons
    
    @IBAction func pressNormalDeckButton(sender: AnyObject) {
        sH.saveToSettings("n", settingsKey: sH.deckSizeDictionaryKey)
        normalDeckButton.selected = true
        largeDeckButton.selected = false
    }
    
    @IBAction func pressLargeDeckButton(sender: AnyObject) {
        sH.saveToSettings("l", settingsKey: sH.deckSizeDictionaryKey)
        normalDeckButton.selected = false
        largeDeckButton.selected = true
    }
    
    // MARK: - Computer Speed Buttons
    
    @IBAction func pressSlowComputerButton(sender: AnyObject) {
        sH.saveToSettings("s", settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.selected = true
        mediumComputerButton.selected = false
        fastComputerButton.selected = false
    }
    
    @IBAction func pressMediumComputerButton(sender: AnyObject) {
        sH.saveToSettings("m", settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.selected = false
        mediumComputerButton.selected = true
        fastComputerButton.selected = false
    }
    
    @IBAction func pressFastComputerButton(sender: AnyObject) {
        sH.saveToSettings("f", settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.selected = false
        mediumComputerButton.selected = false
        fastComputerButton.selected = true
    }
    
    // MARK: - Menu Display Setup
    
    internal func prepareSettingsMenu() {
        
        backToMainMenuButton.titleLabel?.font = gameFont
        backToMainMenuButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.7), forState: UIControlState.Normal)
        backToMainMenuButton.sizeToFit()
        
        normalDeckButton.titleLabel?.font = gameFont
        normalDeckButton.sizeToFit()
        
        largeDeckButton.titleLabel?.font = gameFont
        largeDeckButton.sizeToFit()
        
        slowComputerButton.titleLabel?.font = gameFont
        slowComputerButton.sizeToFit()
        
        mediumComputerButton.titleLabel?.font = gameFont
        mediumComputerButton.sizeToFit()
        
        fastComputerButton.titleLabel?.font = gameFont
        fastComputerButton.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    internal func setSelectedOptions() {
        
        let cardType = sH.retrieveFromSettings(sH.cardTypeDictionaryKey) as! String
        let deckSize = sH.retrieveFromSettings(sH.deckSizeDictionaryKey) as! String
        let computerSpeed = sH.retrieveFromSettings(sH.computerSpeedDictionaryKey) as! String
        
        switch (cardType) {
        case "n":
            numberCardButton.selected = true
            break
        case "r":
            regularCardButton.selected = true
            break
        case "s":
            symbolCardButton.selected = true
            break
        default: break
        }
        
        switch (deckSize) {
        case "n":
            normalDeckButton.selected = true
            break
        case "l":
            largeDeckButton.selected = true
            break
        default: break
        }
        
        switch (computerSpeed) {
        case "s":
            slowComputerButton.selected = true
            break
        case "m":
            mediumComputerButton.selected = true
            break
        case "f":
            fastComputerButton.selected = true
            break
        default: break
        }
        
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
