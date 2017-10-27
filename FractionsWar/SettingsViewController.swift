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
    @IBOutlet weak var dataCollectionButton: UIButton!
    
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
    @IBOutlet weak var extremeComputerButton: UIButton!
    
    var collectData = true
    
    // Custom game fonts
    var gameFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
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
    
    @IBAction func pressBackToMainMenuButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "unwindToMenuFromSettings", sender: self)
        })
    }
    
    // MARK: - Card Style Buttons
    
    @IBAction func pressNumberCardButton(_ sender: AnyObject) {
        sH.saveToSettings("n" as AnyObject, settingsKey: sH.cardTypeDictionaryKey)
        numberCardButton.isSelected = true
        regularCardButton.isSelected = false
        symbolCardButton.isSelected = false
    }
    
    @IBAction func pressRegularCardButton(_ sender: AnyObject) {
        sH.saveToSettings("r" as AnyObject, settingsKey: sH.cardTypeDictionaryKey)
        numberCardButton.isSelected = false
        regularCardButton.isSelected = true
        symbolCardButton.isSelected = false
    }
    
    @IBAction func pressSymbolCardButton(_ sender: AnyObject) {
        sH.saveToSettings("s" as AnyObject, settingsKey: sH.cardTypeDictionaryKey)
        numberCardButton.isSelected = false
        regularCardButton.isSelected = false
        symbolCardButton.isSelected = true
    }
    
    // MARK: - Deck Size Buttons
    
    @IBAction func pressNormalDeckButton(_ sender: AnyObject) {
        sH.saveToSettings("n" as AnyObject, settingsKey: sH.deckSizeDictionaryKey)
        normalDeckButton.isSelected = true
        largeDeckButton.isSelected = false
    }
    
    @IBAction func pressLargeDeckButton(_ sender: AnyObject) {
        sH.saveToSettings("l" as AnyObject, settingsKey: sH.deckSizeDictionaryKey)
        normalDeckButton.isSelected = false
        largeDeckButton.isSelected = true
    }
    
    // MARK: - Computer Speed Buttons
    
    @IBAction func pressSlowComputerButton(_ sender: AnyObject) {
        sH.saveToSettings("s" as AnyObject, settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.isSelected = true
        mediumComputerButton.isSelected = false
        fastComputerButton.isSelected = false
        extremeComputerButton.isSelected = false
    }
    
    @IBAction func pressMediumComputerButton(_ sender: AnyObject) {
        sH.saveToSettings("m" as AnyObject, settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.isSelected = false
        mediumComputerButton.isSelected = true
        fastComputerButton.isSelected = false
        extremeComputerButton.isSelected = false
    }
    
    @IBAction func pressFastComputerButton(_ sender: AnyObject) {
        sH.saveToSettings("f" as AnyObject, settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.isSelected = false
        mediumComputerButton.isSelected = false
        fastComputerButton.isSelected = true
        extremeComputerButton.isSelected = false
    }
    
    @IBAction func pressExtremeComputerButton(_ sender: AnyObject) {
        sH.saveToSettings("e" as AnyObject, settingsKey: sH.computerSpeedDictionaryKey)
        slowComputerButton.isSelected = false
        mediumComputerButton.isSelected = false
        fastComputerButton.isSelected = false
        extremeComputerButton.isSelected = true
    }
    
    
    // MARK: - Menu Display Setup
    
    internal func prepareSettingsMenu() {
        
        backToMainMenuButton.titleLabel?.font = gameFont
        backToMainMenuButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        backToMainMenuButton.sizeToFit()
        
        dataCollectionButton.titleLabel?.font = gameFont
        dataCollectionButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        dataCollectionButton.sizeToFit()
        
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
        
        extremeComputerButton.titleLabel?.font = gameFont
        extremeComputerButton.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    internal func setSelectedOptions() {
        
        let cardType = sH.retrieveFromSettings(sH.cardTypeDictionaryKey) as! String
        let deckSize = sH.retrieveFromSettings(sH.deckSizeDictionaryKey) as! String
        let computerSpeed = sH.retrieveFromSettings(sH.computerSpeedDictionaryKey) as! String
        
        switch (cardType) {
        case "n":
            numberCardButton.isSelected = true
            break
        case "r":
            regularCardButton.isSelected = true
            break
        case "s":
            symbolCardButton.isSelected = true
            break
        default: break
        }
        
        switch (deckSize) {
        case "n":
            normalDeckButton.isSelected = true
            break
        case "l":
            largeDeckButton.isSelected = true
            break
        default: break
        }
        
        switch (computerSpeed) {
        case "s":
            slowComputerButton.isSelected = true
            break
        case "m":
            mediumComputerButton.isSelected = true
            break
        case "f":
            fastComputerButton.isSelected = true
            break
        case "e":
            extremeComputerButton.isSelected = true
            break
        default: break
        }
        
    }
}
