//
//  Card2.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

class Card2: CustomStringConvertible {
    var rank: Double
    var suit: String
    var imageName: String
    
    var cardView: UIView
    var back: UIImageView
    var front: UIImageView
    
    var cardSize: CGRect {
        return CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(100, 100))
    }
    
    var description: String {
        return "\(self.rank), \(self.suit)"
    }
 
    init(rank: Double, suit: String) {
        self.rank = rank
        self.suit = suit
        
        let shortSuit = Card2.shortenSuitName(suit)
        self.imageName =  String(Int(self.rank)) + "-" + shortSuit + "-n.png"
        
        self.cardView = UIView(frame: CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(100, 100)))
        
        self.back = UIImageView(image: UIImage(named: "back2.png"))
        self.front = UIImageView(image: UIImage(named: imageName))
        front.backgroundColor = UIColor.whiteColor()
        cardView.addSubview(back)
    }
    
    func resizeCard(frame: CGRect) {
        self.cardView.frame = frame
        self.back.frame = frame
        self.front.frame = frame
    }
    
    func flipCard() {
        UIView.transitionFromView(back, toView: self.front, duration: 0.5, options: [
            .TransitionFlipFromLeft], completion: nil)
    }
    
    private class func shortenSuitName(suit: String) -> String {
        var shortSuit: String? = nil
        
        switch suit {
        case "diamonds":
            shortSuit = "dm"
        case "hearts":
            shortSuit = "hr"
        case "spades":
            shortSuit = "sp"
        default:
            shortSuit = "cl"
        }
        
        return shortSuit!
    }
    
    func getRank() -> Double {
        return rank
    }
    
    func getSuit() -> String {
        return suit
    }
    
    func getImageName() -> String {
        return imageName
    }
    
    func getCardView() -> UIView {
        return cardView
    }
    
    func imageClean() {
        self.front.removeFromSuperview()
        self.back.removeFromSuperview()
    }
}