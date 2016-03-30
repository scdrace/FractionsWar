//
//  ViewController.swift
//  FractionsWar
//
//  Created by David Race on 2/29/16.
//
//

import Foundation
import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var flipButton: UIButton!
    
    @IBOutlet weak var cardView: UIView! //UIView that contains Card object
    @IBOutlet weak var swipeView: UIView! //UIview that moves when swipe occurs

    @IBOutlet weak var p1Numerator: UIView!
    @IBOutlet weak var p1Denominator: UIView!
    @IBOutlet weak var p1Area: UIView!
    
    @IBOutlet weak var p2Numerator: UIView!
    @IBOutlet weak var p2Denominator: UIView!
    @IBOutlet weak var p2Area: UIView!
    
    @IBOutlet weak var boardMidline: UIView!
    
    @IBOutlet weak var p1DecimalValue: UILabel!
    @IBOutlet weak var p2DecimalValue: UILabel!
    
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    
    @IBOutlet weak var cardsLeft: UILabel!
    
    var p1AreaX: UIView!
    var p2AreaX: UIView!
    
    let moveDistance: CGFloat = 600
    
    var game = Game()
    
    var cardFrame: CGRect {
        
        return CGRect(origin: CGPointMake(0, 0), size:  CGSize(width: p1Numerator.frame.width,
            height: p1Numerator.frame.height))
    }
    
    var cardBack: UIImageView {
        let back = UIImageView(image: UIImage(named: "back@2x.png.png"))
        back.frame = cardFrame
        
        return back
    }
    
    var getCardPorts: [UIView] {
        return [p1Numerator, p1Denominator, p2Numerator, p2Denominator]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // p1Area.frame.size.width = self.view.frame.size.width
        //p1Area.center.x = self.view.center.x
        
        p1AreaX = UIView(frame: CGRectMake(0, self.view.center.y, self.view.frame.size.width, self.view.frame.size.height/2))
        p1AreaX.backgroundColor = UIColor.clearColor()
        self.view.addSubview(p1AreaX)
        self.view.bringSubviewToFront(p1AreaX)
        
        p2AreaX = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2))
        p2AreaX.backgroundColor = UIColor.clearColor()
        self.view.addSubview(p2AreaX)
        self.view.bringSubviewToFront(p2AreaX)
        
        /*
        let swipeUp = UISwipeGestureRecognizer(target: self.p1AreaX, action: #selector(foo))
        swipeUp.direction = .Up
        
        swipeUp.delegate = self
        p1AreaX.userInteractionEnabled = true
        p1AreaX.addGestureRecognizer(swipeUp)
*/
        /*
        // create an instance of UITapGestureRecognizer and tell it to run
        // an action we'll call "handleTap:"
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        // we use our delegate
        tap.delegate = self
        // allow for user interaction
        tapView.userInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        tapView.addGestureRecognizer(tap)
        */
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let swipeUpP1 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeUpP1.direction = .Up
        
        let swipeDownP1 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeDownP1.direction = .Down
        
        p1AreaX.userInteractionEnabled = true
        p1AreaX.addGestureRecognizer(swipeUpP1)
        p1AreaX.addGestureRecognizer(swipeDownP1)
        
        
        let swipeUpP2 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeUpP2.direction = .Up
        
        let swipeDownP2 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeDownP2.direction = .Down
        
        p2AreaX.userInteractionEnabled = true
        p2AreaX.addGestureRecognizer(swipeUpP2)
        p2AreaX.addGestureRecognizer(swipeDownP2)

        self.view.bringSubviewToFront(flipButton)
        self.view.bringSubviewToFront(boardMidline)
        
        
        setupCards()
        
        
    }
    
    func foo(sender: UISwipeGestureRecognizer) {
        print("SWIPE")
    }
    func setupCards() {
        game.nextRound()
        
        
        game.resizeCards(cardFrame)
        addCardImage()
        
        
        p1DecimalValue.text = "Hand Value: " + String(round(100 * game.getPlayer1().getHand().decimalValue) / 100)
        p2DecimalValue.text = "Hand Value: " + String(round(100 * game.getPlayer2().getHand().decimalValue) / 100)
        
        
        p1Score.text = "Score: " + String(game.getPlayer1().points)
        p2Score.text = "Score: " + String(game.getPlayer2().points)
        
        cardsLeft.text = "Cards Left: " + String(game.deck.deckRandom.count)
        
        
        print("Player2: \(game.player2.hand!)")
        print("Player1: \(game.player1.hand!)")
        //print(game.deck.deckRandom)

    }
    
    
    func addCardImage() {
        
        //Create structure that holds current cards
        let cards = game.getCards()
        
        //Add the View of each card to user interface
        self.p1Numerator.addSubview(cards.p1Numerator.getCardView())
        self.p1Denominator.addSubview(cards.p1Denominator.getCardView())
        self.p2Numerator.addSubview(cards.p2Numerator.getCardView())
        self.p2Denominator.addSubview(cards.p2Denominator.getCardView())
    }
    
    
    //Just calls the cardFlip method on the instance of card
    @IBAction func cardFlip(sender: AnyObject) {
        
        
        //let casinoGreen = UIColor(red: 0, green: 153, blue: 0, alpha:1)
        p2Numerator.backgroundColor = self.view.backgroundColor
        p2Denominator.backgroundColor = self.view.backgroundColor
        
        p1Numerator.backgroundColor = self.view.backgroundColor
        p1Denominator.backgroundColor = self.view.backgroundColor
        
        
        game.flipCards()

    }
    
    
    func swipeUp() {
        
        let cardPorts = self.getCardPorts
        
        UIView.animateWithDuration(0.8, animations: {
            
            for port in cardPorts {
                port.center.y -= self.moveDistance
            }

            }, completion: { finished in
                
                self.game.imageClean()
                
                self.setupCards()
                
                for port in cardPorts {
                    port.center.y += self.moveDistance
                }
        })
    }
    
    func swipeDown() {
        
        let cardPorts = self.getCardPorts
        
        UIView.animateWithDuration(0.8, animations: {
            
            for port in cardPorts {
                port.center.y += self.moveDistance
            }

            }, completion: { finished in
                
                self.game.imageClean()
                
                self.setupCards()
                
                for port in cardPorts {
                    port.center.y -= self.moveDistance
                }
                
        })
    }
    
    
    func p1SwipePoints(sender: UISwipeGestureRecognizer) {
        
        if game.getRound().highHand != "player1" {
            
            if sender.view === self.p1AreaX {
                game.getPlayer1().addPoints(1)
            }
            else if sender.view === self.p2AreaX {
                game.getPlayer2().addPoints(1)
            }
        }
    }

    
    func p2SwipePoints(sender: UISwipeGestureRecognizer) {
        
        if game.getRound().highHand != "player2" {
            if sender.view === self.p1AreaX {
                game.getPlayer1().addPoints(1)
            }
            else if sender.view === self.p2AreaX {
                game.getPlayer2().addPoints(1)
            }
        }
    }

        
    //A demo of swiping. Note that you need a UISwipeGestureRecognizer for each direction
    //UISwipeGestureRecognizers were added in IB
    @IBAction func swipeGesture(sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        
        if sender.direction == .Up {
            print("swipeUp")
            
            p1SwipePoints(sender)
            swipeUp()
        }
            
        else if sender.direction == .Down {
            print("swipeDown")
            
            p2SwipePoints(sender)
            swipeDown()
        }
        
        print("Player1: \(game.player1.points)")
        print("Player2: \(game.player2.points)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

