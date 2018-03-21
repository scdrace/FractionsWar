//
//  PauseButton+GameViewController.swift
//  FractionsWar
//
//  Created by David Race on 3/8/18.
//

import Foundation
import UIKit

extension GameViewController {
    @IBAction func pressPauseP1Button(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "goToPause", sender: self)
        })
        s.playPause()
    }
    
    @IBAction func pressPauseP2Button(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "goToPause", sender: self)
        })
        s.playPause()
    }
}
