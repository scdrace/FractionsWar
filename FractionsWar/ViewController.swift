//
//  ViewController.swift
//  FractionsWar
//
//  Created by David Race on 2/29/16.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardView: UIView! //UIView that contains Card object
    @IBOutlet weak var swipeView: UIView! //UIview that moves when swipe occurs

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //Initialize Card object
        //Note that currently views must be tagged to access them in different methods
        var cardView2 = Card(frame: cardView.bounds)
        cardView2.tag = 3
        cardView.addSubview(cardView2)
    }
    
    
    //Just calls the cardFlip method on the instance of card
    @IBAction func cardFlip(sender: AnyObject) {
        
        let face = self.cardView.viewWithTag(3) as! Card
        face.flipCard()
    }
    
    
    //A demo of swiping. Note that you need a UISwipeGestureRecognizer for each direction
    //UISwipeGestureRecognizers were added in IB
    @IBAction func swipeGesture(sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        if sender.direction == .Left {
            self.swipeView.center.x -= 100
        }
        else if sender.direction == .Right {
            self.swipeView.center.x += 100
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

