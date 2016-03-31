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

    //Ports in which Card2.view is placed
    //Ports are used so that we can set up constraints in IB
    @IBOutlet weak var p1Numerator: UIView!
    @IBOutlet weak var p1Denominator: UIView!
    @IBOutlet weak var p2Numerator: UIView!
    @IBOutlet weak var p2Denominator: UIView!
    
    @IBOutlet weak var boardMidline: UIView! //An IB object used to help with autoLayout
    
    //Decimal value of hands
    @IBOutlet weak var p1DecimalValue: UILabel!
    @IBOutlet weak var p2DecimalValue: UILabel!
    
    //Player Scores
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    
    //Cards left in deck
    @IBOutlet weak var cardsLeft: UILabel!
    
    //These view sit on top of everything, so that they can detect a touch
    //!!!P1AreaX will eventually be P1AreaV, for the vertial layout; it we keep it
    var p1AreaX: UIView!
    var p2AreaX: UIView!
    var p1AreaH: UIView!
    var p2AreaH: UIView!
    
    
    let moveDistance: CGFloat = 900 //Distance for cards to move
    
    var game = Game() //COntroller interacts with game through Game interface
    
    //Used to resize Card2 to port size
    var cardFrame: CGRect {
        
        return CGRect(origin: CGPointMake(0, 0), size:  CGSize(width: p1Numerator.frame.width,
            height: p1Numerator.frame.height))
    }
    
    //May not use this anymore
    var cardBack: UIImageView {
        let back = UIImageView(image: UIImage(named: "back@2x.png.png"))
        back.frame = cardFrame
        
        return back
    }
    
    //Return the cardPorts, used for swiping
    var getCardPorts: [UIView] {
        return [p1Numerator, p1Denominator, p2Numerator, p2Denominator]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        p1AreaX = UIView(frame: CGRectMake(0, self.view.center.y, self.view.frame.size.width, self.view.frame.size.height/2))
        p1AreaX.backgroundColor = UIColor.clearColor()
        //self.view.addSubview(p1AreaX)
        //self.view.bringSubviewToFront(p1AreaX)
        
        p2AreaX = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height))
        p2AreaX.backgroundColor = UIColor.clearColor()
        //self.view.addSubview(p2AreaX)
        //self.view.bringSubviewToFront(p2AreaX)
        
        p1AreaH = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height))
        p1AreaH.backgroundColor = UIColor.clearColor()
        self.view.addSubview(p1AreaH)
        self.view.bringSubviewToFront(p1AreaH)
        
        p2AreaH = UIView(frame: CGRectMake(self.view.center.x, 0, self.view.frame.size.width/2, self.view.frame.size.height))
        p2AreaH.backgroundColor = UIColor.clearColor()
        self.view.addSubview(p2AreaH)
        self.view.bringSubviewToFront(p2AreaH)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addSwipeGesture(p1AreaH)
        addSwipeGesture(p2AreaH)
        
        
        self.view.bringSubviewToFront(flipButton)
        self.view.bringSubviewToFront(boardMidline)
        
        
        setupCards()
        
        
    }
    
    
    //Adds swipeGestureRecognizer to each player area
    func addSwipeGesture(swipeArea: UIView) {
        
        swipeArea.userInteractionEnabled = true
        
        let direction = [UISwipeGestureRecognizerDirection.Up, UISwipeGestureRecognizerDirection.Down,
                         UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Right]
        
        for i in 0...3 {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
            swipe.direction = direction[i]
            swipeArea.addGestureRecognizer(swipe)
        }
    }
    
    
    func setupCards() {
        game.nextRound()
        
        
        //Size the Cards according to the cardPorts in Interface-Builder
        game.resizeCards(cardFrame)
        
        //Add Card2.view to corresponding card-port
        addCardImage()
        
        
        //Display the value of each hand
        //Used for debugging; REMOVE FOR FINAL PRODUCT
        p1DecimalValue.text = "Hand Value: " + String(round(100 * game.getPlayer1().getHand().decimalValue) / 100)
        p2DecimalValue.text = "Hand Value: " + String(round(100 * game.getPlayer2().getHand().decimalValue) / 100)
        
        //Stand-in to display scores
        p1Score.text = "Score: " + String(game.getPlayer1().points)
        p2Score.text = "Score: " + String(game.getPlayer2().points)
        
        //Stand-in to display text
        cardsLeft.text = "Cards Left: " + String(game.deck.deckRandom.count)
        
        
        //Prints each players hand in text-output
        //Used for debugging
        print("Player2: \(game.player2.hand!)")
        print("Player1: \(game.player1.hand!)")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

