//
//  CardView.swift
//  FractionsWar
//
//  Created by David Race on 3/9/18.
//

import Foundation
import UIKit


struct CardView {
    
    var cardContainerView: UIView
    var cardView: UIView
    var cardViewFace: UIImageView
    var cardViewBack = UIImageView(image: UIImage(named: "back2"))
    var warBackImage = UIImageView(image: UIImage(named: "war-stack"))
    var standardFrame: CGRect
    
    init(faceName: String, size: CGSize) {
        cardContainerView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        cardContainerView.backgroundColor = UIColor.yellow
        
        cardViewFace = UIImageView(image: UIImage(named: faceName))
        standardFrame = CGRect(origin: CGPoint.zero, size: size)
        cardContainerView = UIView(frame: standardFrame)
        cardView = UIView(frame: standardFrame)

        cardViewFace.frame = standardFrame
        cardViewBack.frame = standardFrame
        warBackImage.frame = CGRect(origin: CGPoint(x: -10, y: 2), size: standardFrame.size)
        
        cardContainerView.addSubview(warBackImage)
        cardContainerView.addSubview(cardView)
        cardView.addSubview(cardViewFace)
        cardView.addSubview(cardViewBack)
    }
    
    func flipCard() {
        UIView.transition(from: cardViewBack, to: cardViewFace, duration: 0.5, options: [
            .transitionFlipFromLeft], completion: { finished in })
    }

    func showWarBack() {
        warBackImage.isHidden = false
    }

    func hideWarBack() {
        warBackImage.isHidden = true
    }
}

