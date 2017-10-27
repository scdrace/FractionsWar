//
//  Card.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

class Card: NSObject, NSCoding {
    
    var rank: Double
    var suit: String
    var cardType: String
    var imageName: String
    var backImageName: String
    
    var cardView: UIView
    var back: UIImageView
    var front: UIImageView
        
    var cardSize: CGRect {
        //TODO: Centralize Size parameter
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))
    }
    
    override var description: String {
        return "\(self.rank) of \(self.suit)"
    }
 
    init(rank: Double, suit: String, cardType: String, deck: String) {
        
        self.rank = rank
        self.suit = suit
        self.cardType = cardType
        
        let shortSuit = Card.shortenSuitName(suit)
        self.imageName =  String(Int(self.rank))+"-"+shortSuit+"-"+cardType
        self.backImageName = "back" + deck
            
        //TODO: Centralize Size parameter
        self.cardView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100)))
        
        self.back = UIImageView(image: UIImage(named: "back"+deck))
        self.front = UIImageView(image: UIImage(named: imageName))
        cardView.addSubview(back)
    }
    
    
    // MARK: - Reload (aDecoder) and Save (aCoder) methods
    required init?(coder aDecoder: NSCoder) {
        rank = aDecoder.decodeDouble(forKey: "rank")
        suit = aDecoder.decodeObject(forKey: "suit") as! String
        cardType = aDecoder.decodeObject(forKey: "cardType") as! String
        imageName = aDecoder.decodeObject(forKey: "imageName") as! String
        backImageName = aDecoder.decodeObject(forKey: "backImageName") as! String
        
        cardView = aDecoder.decodeObject(forKey: "cardView") as! UIView
        back = aDecoder.decodeObject(forKey: "back") as! UIImageView
        front = aDecoder.decodeObject(forKey: "front") as! UIImageView
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(suit, forKey: "suit")
        aCoder.encode(cardType, forKey: "cardType")
        aCoder.encode(imageName, forKey: "imageName")
        
        aCoder.encode(cardView, forKey: "cardView")
        aCoder.encode(back, forKey: "back")
        aCoder.encode(front, forKey: "front")
    }
    
    
    // MARK: - Set & Get Methods
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
    
    
    
    // MARK: - Card flip methods
    
    /*
     Flip the cardView from Back to Face
     //TODO: Centralize the Duration parameter
    */
    func flipCard() {
        UIView.transition(from: back, to: self.front, duration: 0.5, options: [
            .transitionFlipFromLeft], completion: nil)
    }
    
    /*
     Flip the carView from Face to Back
    */
    func flipDown() {
        UIView.transition(from: front, to: self.back, duration: 0.5, options: [
            .transitionFlipFromRight], completion: nil)
    }
    
    
    // MARK: - Card Maintainence
    /*
     //TODO: Add description
    */
    fileprivate class func shortenSuitName(_ suit: String) -> String {
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
    
    
    /*
     Resize card.frame to dimensions of Card-View(Interface Builder)
     - Parameter frame: CGRect representing the size of the cardView property
     */
    func resizeCard(_ frame: CGRect) {
        self.cardView.frame = frame
        self.back.frame = frame
        self.front.frame = frame
    }
    
    /*
     Remove the Back and Face images from cardView
    */
    func imageClean() {
        self.front.removeFromSuperview()
        self.back.removeFromSuperview()
    }
    
    
    // MARK: - Card Data
    /*
     Return information about card. Used for saving data
     Return [String]: rank, suit, cardType
    */
    func data() -> [String] {
        let rank = String(self.rank)
        
        //TODO: Include cardType
        return [rank, suit, cardType]
    }

    
}
