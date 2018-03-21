//
//  Card.swift
//  FractionsWar
//
//  Created by David Race on 3/25/16.
//
//

import Foundation
import UIKit

public class Card: Codable, CustomStringConvertible {
    
    var imageName: String {
        var suitNameShort: String! {
            switch(suit) {
            case "clubs":
                return "cl"
            case "diamonds":
                return "dm"
            case "hearts":
                return "hr"
            case "spades":
                return "sp"
            default:
                return nil
            }
        }
        
        return String(Int(rank)) + "-" + suitNameShort + "-" + cardType
    }
    
    var backImageName: String {
        return "back2"
    }
    
    var cardSize: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))
    }
        
    var cardType: String
    var rank: Double
    var suit: String
        
    var backImage: UIImageView {
        return UIImageView(image: UIImage(named: "back2"))
    }
    
    var faceImage: UIImageView {
        return UIImageView(image: UIImage(named: imageName))
    }
    
    init(rank: Double, suit: String, cardType: String) {
        self.cardType = cardType
        self.rank = rank
        self.suit = suit
    }
    
    public var description: String {
        return "\(Int(rank)) of \(suit)"
    }
    
    func imageContainer(size: CGSize) -> CardView {
        return CardView(faceName: imageName, size: size)
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

