//
//  HowToViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 5/12/16.
//
//

import Foundation
import UIKit

class HowToViewController: UIViewController {
    
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
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
        
        prepareHowToMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressBackToMenuButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("unwindToMenuFromHowTo", sender: self)
        })
    }

    // MARK: - How To Display Setup
    
    internal func prepareHowToMenu() {
        
        backToMenuButton.titleLabel?.font = gameFont
        backToMenuButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.7), forState: UIControlState.Normal)
        backToMenuButton.sizeToFit()
        
        contentLabel.text = "Content TBD"
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.sizeToFit()
    }
}