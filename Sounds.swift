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
    
    fileprivate var begin: SystemSoundID?
    fileprivate var error: SystemSoundID?
    fileprivate var move: SystemSoundID?
    fileprivate var pause: SystemSoundID?
    fileprivate var place: SystemSoundID?
    fileprivate var war: SystemSoundID?
    
    fileprivate init() {
    
        if let beginURL = Bundle.main.url(forResource: "begin", withExtension: "wav") {
            begin = 0
            AudioServicesCreateSystemSoundID(beginURL as CFURL, &begin!)
        }
        if let errorURL = Bundle.main.url(forResource: "error", withExtension: "wav") {
            error = 1
            AudioServicesCreateSystemSoundID(errorURL as CFURL, &error!)
        }
        if let moveURL = Bundle.main.url(forResource: "move", withExtension: "wav") {
            move = 2
            AudioServicesCreateSystemSoundID(moveURL as CFURL, &move!)
        }
        if let pauseURL = Bundle.main.url(forResource: "pause", withExtension: "wav") {
            pause = 3
            AudioServicesCreateSystemSoundID(pauseURL as CFURL, &pause!)
        }
        if let placeURL = Bundle.main.url(forResource: "place", withExtension: "wav") {
            place = 4
            AudioServicesCreateSystemSoundID(placeURL as CFURL, &place!)
        }
        if let warURL = Bundle.main.url(forResource: "war", withExtension: "wav") {
            war = 5
            AudioServicesCreateSystemSoundID(warURL as CFURL, &war!)
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
