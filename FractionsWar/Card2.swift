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
        self.imageName =  String(Int(self.rank)) + "_of_" + self.suit + ".png"
        //print(imageName)
        
        self.cardView = UIView(frame: CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(100, 100)))
        
        //let casinoGreen = UIColor(red: 0, green: 153, blue: 0, alpha:1)
        //cardView.backgroundColor = casinoGreen
        //front.backgroundColor = UIColor.whiteColor()
        self.back = UIImageView(image: UIImage(named: "back.png"))
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
        //print(self.imageName)
        
        UIView.transitionFromView(back, toView: self.front, duration: 0.5, options: [
            .TransitionFlipFromLeft], completion: nil)
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