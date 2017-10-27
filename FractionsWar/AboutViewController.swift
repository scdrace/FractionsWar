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
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
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
    
    @IBAction func pressBackToMainMenuButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "unwindToMenuFromAbout", sender: self)
        })
    }
    
    // MARK: - About Screen Setup
    
    internal func prepareAboutScreen() {
        
        backToMainMenuButton.titleLabel?.font = gameFont
        backToMainMenuButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        backToMainMenuButton.sizeToFit()
        
        aboutLabel.text = "Fractions War was designed and developed through a collaboration of educational researchers and software developers at the University of Wisconsin-Madison.  Support was provided by the Educational Neuroscience and MELD Labs and CS 407: Foundations of Mobile Systems and Applications.\n\nThe game was created to help study how children and adults think about numerical quantities when they play card games such as War.\n\nThe game is designed with the goal of providing a fun way for students, teachers, and gamers to play with fractions."
        aboutLabel.textColor = UIColor.white
        aboutLabel.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
}

