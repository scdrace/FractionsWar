//
//  Sounds.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 5/5/16.
//
//

import Foundation
import AudioToolbox

class Sounds {
    
    static let shared = Sounds()
    
    private var begin: SystemSoundID?
    private var error: SystemSoundID?
    private var move: SystemSoundID?
    private var pause: SystemSoundID?
    private var place: SystemSoundID?
    private var war: SystemSoundID?
    
    private init() {
    
        if let beginURL = NSBundle.mainBundle().URLForResource("begin", withExtension: "wav") {
            begin = 0
            AudioServicesCreateSystemSoundID(beginURL, &begin!)
        }
        if let errorURL = NSBundle.mainBundle().URLForResource("error", withExtension: "wav") {
            error = 1
            AudioServicesCreateSystemSoundID(errorURL, &error!)
        }
        if let moveURL = NSBundle.mainBundle().URLForResource("move", withExtension: "wav") {
            move = 2
            AudioServicesCreateSystemSoundID(moveURL, &move!)
        }
        if let pauseURL = NSBundle.mainBundle().URLForResource("pause", withExtension: "wav") {
            pause = 3
            AudioServicesCreateSystemSoundID(pauseURL, &pause!)
        }
        if let placeURL = NSBundle.mainBundle().URLForResource("place", withExtension: "wav") {
            place = 4
            AudioServicesCreateSystemSoundID(placeURL, &place!)
        }
        if let warURL = NSBundle.mainBundle().URLForResource("war", withExtension: "wav") {
            war = 5
            AudioServicesCreateSystemSoundID(warURL, &war!)
        }
    }
    
    // MARK: - Play sounds
    
    internal func playBegin() {
        AudioServicesPlaySystemSound(begin!)
    }
    
    internal func playError() {
        AudioServicesPlaySystemSound(error!)
    }
    
    internal func playMove() {
        AudioServicesPlaySystemSound(move!)
    }
    
    internal func playPause() {
        AudioServicesPlaySystemSound(pause!)
    }
    
    internal func playPlace() {
        AudioServicesPlaySystemSound(place!)
    }
    
    internal func playWar() {
        AudioServicesPlaySystemSound(war!)
    }
}