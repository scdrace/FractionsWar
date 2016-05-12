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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}