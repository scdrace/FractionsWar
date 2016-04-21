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
    
    @IBOutlet weak var numberCardButton: UIButton!
    @IBOutlet weak var regularCardButton: UIButton!
    @IBOutlet weak var symbolCardButton: UIButton!
    
    // Custom game fonts
    var gameFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 32)!
    }
    
    let sH = SettingsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sH.formPlistPath()
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
    
    @IBAction func pressNumberCardButton(sender: AnyObject) {
        sH.saveToSettings("n", settingsKey: sH.cardTypeDictionaryKey)
    }
    
    @IBAction func pressRegularCardButton(sender: AnyObject) {
        sH.saveToSettings("r", settingsKey: sH.cardTypeDictionaryKey)
    }
    
    @IBAction func pressSymbolCardButton(sender: AnyObject) {
        sH.saveToSettings("s", settingsKey: sH.cardTypeDictionaryKey)
    }
    
    // MARK: - Menu Display Setup
    
    internal func prepareSettingsMenu() {
        
        backToMainMenuButton.titleLabel?.font = gameFont
        backToMainMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backToMainMenuButton.sizeToFit()
        
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
