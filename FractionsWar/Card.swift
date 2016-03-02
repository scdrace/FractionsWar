//
//  Card.swift
//  FractionsWar
//
//  Created by David Race on 3/1/16.
//
//

import UIKit

/*  At the moment, the Card class is a UIView containing two UIImage views for the back and front of the card.
    
    I placed it wihtin a UIView that I created with Interface Builder (IB). I did this so that we can use IB to handle
    layout constraints.

    Added a method to flip the Card when a button is pressed. Just a demonstration, as there are other ways to do this.

    Future Goals:
        - Initializer that has parameters for rank and suit.
        - Determine whether the card should be contained within an IB object
        - Modify current methods
        - Add new methods
        - Figure out what dimensions (width X height) are best for design
        - Possibly create a Card Protocol (similar to Java Interface)

*/


class Card: UIView {
    var back: UIImageView?
    var front: UIImageView?
    
    //Computed property
    var cardViewCenter: CGPoint {
         return CGPointMake(self.frame.width/2, self.frame.height/2)
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame : frame)
        self.backgroundColor = UIColor.orangeColor()
        
        
        //Initialize Cards
        self.back = UIImageView(image: UIImage(named: "back@2x.png.png"))
        self.back!.center = cardViewCenter
        self.back!.tag = 1
        self.addSubview(self.back!)
        
        self.front = UIImageView(image: UIImage(named: "2_of_clubs.png"))
        self.front!.center = cardViewCenter
        self.front!.tag = 2

    }

    //It seems that inheritance requires "required init?(...)". I just played around with it until it worked
    //Probably not the best solution
    
    /*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    /*
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    */
    
    required init(coder aDecoder: NSCoder!) {
        //foo = "some string"
        //bar = 9001
        
        super.init(coder: aDecoder)!
    }
    
    func flipCard() {
        
        if let back = self.viewWithTag(1) {
            UIView.transitionFromView(back, toView: self.front!, duration: 0.5, options: [
                .TransitionFlipFromLeft], completion: nil)
        }
        else {
            UIView.transitionFromView(self.viewWithTag(2)!, toView: self.back!, duration: 0.5, options: [
                .TransitionFlipFromLeft], completion: nil)
        }
    }
}
