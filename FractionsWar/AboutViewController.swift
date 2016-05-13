//
//  AboutViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 5/11/16.
//
//


import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var backToMainMenuButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    
    // Custom game fonts
    var gameFont: UIFont {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareAboutScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Settings Screen Interactions
    
    @IBAction func pressBackToMainMenuButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("unwindToMenuFromAbout", sender: self)
        })
    }
    
    // MARK: - About Screen Setup
    
    internal func prepareAboutScreen() {
        
        backToMainMenuButton.titleLabel?.font = gameFont
        backToMainMenuButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.7), forState: UIControlState.Normal)
        backToMainMenuButton.sizeToFit()
        
        aboutLabel.text = "Lorem ipsum bla blah"
        aboutLabel.textColor = UIColor.whiteColor()
        aboutLabel.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
}

