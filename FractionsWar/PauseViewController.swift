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
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 32)!
        default:
            return UIFont(name: "DINCond-Bold", size: 42)!
        }
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
    
    @IBAction func pressForfeitButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "unwindToMenuFromPause", sender: self)
        })
    }
    
    @IBAction func pressReturnToGameButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Pause Screen Display Setup
    
    internal func prepareScreen() {
        
        forfeitButton.titleLabel?.font = gameFont
        forfeitButton.sizeToFit()
        
        returnButton.titleLabel?.font = gameFont
        returnButton.sizeToFit()
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
