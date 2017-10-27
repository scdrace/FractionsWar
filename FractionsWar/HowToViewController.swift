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
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
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
    
    @IBAction func pressBackToMenuButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "unwindToMenuFromHowTo", sender: self)
        })
    }
    
    // MARK: - How To Display Setup
    
    internal func prepareHowToMenu() {
        
        backToMenuButton.titleLabel?.font = gameFont
        backToMenuButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        backToMenuButton.sizeToFit()
        
        contentLabel.textColor = UIColor.white
        contentLabel.sizeToFit()
    }
}
