//
//  GameViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/13/16.
//
//

import Foundation
import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    // On screen information labels
    @IBOutlet weak var p1Name: UILabel!
    @IBOutlet weak var p2Name: UILabel!
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    @IBOutlet weak var p1Cards: UILabel!
    @IBOutlet weak var p2Cards: UILabel!
    
    // On screen buttons
    @IBOutlet weak var p1PauseButton: UIButton!
    @IBOutlet weak var p1WarButton: UIButton!
    @IBOutlet weak var p2PauseButton: UIButton!
    @IBOutlet weak var p2WarButton: UIButton!
    @IBOutlet weak var p1DeckButton: UIButton!
    @IBOutlet weak var p2DeckButton: UIButton!
    
    // Custom game fonts
    var gameFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 22)!
    }
    var gameCounterFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 32)!
    }
    
    // Ports in which Card.view is placed
    // Ports are used so that we can set up constraints in IB
    @IBOutlet weak var p1Numerator: UIView!
    @IBOutlet weak var p1Denominator: UIView!
    @IBOutlet weak var p2Numerator: UIView!
    @IBOutlet weak var p2Denominator: UIView!
    
    @IBOutlet weak var p1NumeratorFD: UIView!
    
    
    // Return the cardPorts, used for swiping
    var getCardPorts: [UIView] {
        return [p1Numerator, p1Denominator, p2Numerator, p2Denominator]
    }
    
    // Views containing the on screen buttons
    // Doing this so we can bring the buttons in front of swipe areas
    @IBOutlet weak var p1WarButtonView: UIView!
    @IBOutlet weak var p1PauseButtonView: UIView!
    @IBOutlet weak var p2WarButtonView: UIView!
    @IBOutlet weak var p2PauseButtonView: UIView!
    @IBOutlet weak var p1DeckView: UIView!
    @IBOutlet weak var p2DeckView: UIView!
    
    // These view sit on top of everything, so that they can detect a touch
    var p1AreaX: UIView!
    var p2AreaX: UIView!
    var p1AreaH: UIView!
    var p2AreaH: UIView!
        
    // Game animation parameters
    var game = Game() 
    let moveDistance: CGFloat = 900
    
    var p1ready = false
    var p2ready = false
    var cardsAreUp = false
    
    // Used to resize Card to port size
    var cardFrame: CGRect {
        return CGRect(origin: CGPointMake(0, 0), size:
            CGSize(width: p1Numerator.frame.width, height: p1Numerator.frame.height)
        )
    }
    
    let sH = SettingsHelper.shared
    
    var difficulty: Double {
        let code = sH.retrieveFromSettings(sH.computerSpeedDictionaryKey) as! String
        return getDifficultyValue(code)
    }
    
    var roundStartTime = 0.0
    var swipeTime = 0.0
    var computerTimer =  NSTimer()
    
    var playerMode = 0
    var warMode = false
    
    // MARK: - View Lifecycle Management
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBoard()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addSwipeGesture(p1AreaH)
        addSwipeGesture(p2AreaH)
        
        self.view.bringSubviewToFront(p1WarButtonView)
        self.view.bringSubviewToFront(p2WarButtonView)
        self.view.bringSubviewToFront(p1PauseButtonView)
        self.view.bringSubviewToFront(p2PauseButtonView)
        self.view.bringSubviewToFront(p1DeckView)
        self.view.bringSubviewToFront(p2DeckView)
        
        setupCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - On Screen Button Presses
    
    @IBAction func pressDeclareWarP1Button(sender: AnyObject) {
        
        if (p1ready && p2ready) {
            swipeGesture(sender)
        }
    }
    
    @IBAction func pressDeclareWarP2Button(sender: AnyObject) {
        
        if (p1ready && p2ready) {
            swipeGesture(sender)
        }
    }
    
    @IBAction func pressPauseP1Button(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("goToPause", sender: self)
        })
    }
    
    @IBAction func pressPauseP2Button(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("goToPause", sender: self)
        })
    }
    
    @IBAction func pressP1DeckButton(sender: AnyObject) {
       
        //Set Player1 to "ready"
        p1ready = true
        p1DeckButton.hidden = true
        
        //Flip cards if both players are "ready"
        if (p1ready && p2ready) {
            flipCards()
        }
        
        //Set Player2 to ready if we are in one player mode
        if (playerMode == 1) {
            pressP2DeckButton(sender)
        }
    }
    
    @IBAction func pressP2DeckButton(sender: AnyObject) {
        
        //Set Player2 to "ready"
        p2ready = true
        p2DeckButton.hidden = true
            
        //Flip cards if both players are "ready"
        if (p1ready && p2ready) {
            flipCards()
        }
    }
    
    // MARK: - Game Display Setup
    
    internal func prepareBoard() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        setFonts()
        decoratePlayerInfo()
        decorateDeckCounters()
        decorateButtons()
        
        // Add swipe views
        p1AreaH = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height))
        p1AreaH.backgroundColor = UIColor.clearColor()
        p2AreaH = UIView(frame: CGRectMake(self.view.center.x, 0, self.view.frame.size.width/2, self.view.frame.size.height))
        p2AreaH.backgroundColor = UIColor.clearColor()
        self.view.addSubview(p1AreaH)
        self.view.bringSubviewToFront(p1AreaH)
        
        if playerMode == 2 {
            self.view.addSubview(p2AreaH)
            self.view.bringSubviewToFront(p2AreaH)
        }
    }
    
    internal func setFonts() {
        
        p1PauseButton.titleLabel!.font = gameFont
        p1WarButton.titleLabel!.font = gameFont
        p2PauseButton.titleLabel!.font = gameFont
        p2WarButton.titleLabel!.font = gameFont
    }
    
    internal func decorateButtons() {
        
        p1PauseButton.setTitleColor(UIColor.lightGrayColor().colorWithAlphaComponent(0.4), forState: UIControlState.Normal)
        p1PauseButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        p1PauseButton.titleEdgeInsets.left = -(p1PauseButton.frame.size.width/3)
        
        p2PauseButton.setTitleColor(UIColor.lightGrayColor().colorWithAlphaComponent(0.4), forState: UIControlState.Normal)
        p2PauseButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        p2PauseButton.titleEdgeInsets.left = -(p2PauseButton.frame.size.width/3)
    }
    
    internal func decoratePlayerInfo() {
        
        let p1back: UIImage = UIImage(named: "p1back")!
        let p1NameSize: CGSize = p1Name.frame.size
        UIGraphicsBeginImageContext(p1NameSize)
        p1back.drawInRect(CGRectMake(0, 0, p1NameSize.width, p1NameSize.height))
        let newP1back: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        p1Name.backgroundColor = UIColor(patternImage: newP1back)
        
        let p2back: UIImage = UIImage(named: "p2back")!
        let p2NameSize: CGSize = p2Name.frame.size
        UIGraphicsBeginImageContext(p2NameSize)
        p2back.drawInRect(CGRectMake(0, 0, p2NameSize.width, p2NameSize.height))
        let newP2back: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        p2Name.backgroundColor = UIColor(patternImage: newP2back)
    }
    
    internal func decorateDeckCounters() {
        
        let dot: UIImage = UIImage(named: "dot")!
        let size: CGSize = p1Cards.frame.size
        UIGraphicsBeginImageContext(size)
        dot.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let dotBack: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        p1Cards.backgroundColor = UIColor(patternImage: dotBack)
        p2Cards.backgroundColor = UIColor(patternImage: dotBack)
    }
    
    internal func addCardImage() {
        
        // Create structure that holds current cards
        let cards = game.getCards()
        
        // Add the View of each card to user interface
        self.p1Numerator.addSubview(cards.p1Numerator.getCardView())
        self.p1Denominator.addSubview(cards.p1Denominator.getCardView())
        self.p2Numerator.addSubview(cards.p2Numerator.getCardView())
        self.p2Denominator.addSubview(cards.p2Denominator.getCardView())
    }
    
    // Card Maintenance
    
    internal func setupCards() {
        
        game.nextRound(warMode)
        
        // Resize card_image to fit Card-Ports in IB
        game.resizeCards(cardFrame)
        
        // Add Card.view to corresponding card-port
        addCardImage()
        
        // Update scores
        p1Score.text = String(game.getPlayer1().points) + " Points"
        p2Score.text = String(game.getPlayer2().points) + " Points"
        
        updateCardCounters()
        
        p1ready = false
        p2ready = false
        p1DeckButton.hidden = false
        p2DeckButton.hidden = false
        
        // End the game if there is a winner
        if (game.player1.cards.count < 2 || game.player1.cards.count < 2) {
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("goToGameOver", sender: self)
            })
        }
    }
    
    
    internal func setupCardsWar() { }
    
    
    internal func updateCardCounters() {
        
        // Get differnce in current vs updated values
        let p1Diff = Int(p1Cards.text!)! - game.player1.cards.count
        let p2Diff = Int(p2Cards.text!)! - game.player2.cards.count
        
        // Set new counter values
        p1Cards.text = String(game.player1.cards.count)
        p2Cards.text = String(game.player2.cards.count)
        
        // Prepare update counter for player one
        let p1: CGPoint = (p1Cards.superview?.convertPoint(p1Cards.center, toView: self.view))!
        let p1DiffCounter = UILabel(frame: p1Cards.frame)
        p1DiffCounter.center = CGPointMake(p1.x + 40, p1.y)
        p1DiffCounter.textAlignment = NSTextAlignment.Center
        p1DiffCounter.text = String(p1Diff)
        p1DiffCounter.font = gameCounterFont
        p1DiffCounter.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        p1DiffCounter.alpha = 0.0
        self.view.addSubview(p1DiffCounter)
        
        // Prepare update counter for player two
        let p2: CGPoint = (p2Cards.superview?.convertPoint(p2Cards.center, toView: self.view))!
        let p2DiffCounter = UILabel(frame: p2Cards.frame)
        p2DiffCounter.center = CGPointMake(p2.x - 40, p2.y)
        p2DiffCounter.textAlignment = NSTextAlignment.Center
        p2DiffCounter.text = String(p2Diff)
        p2DiffCounter.font = gameCounterFont
        p2DiffCounter.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        p2DiffCounter.alpha = 0.0
        self.view.addSubview(p2DiffCounter)
        
        // Display counters then remove them
        popLabel(p1DiffCounter)
        popLabel(p2DiffCounter)
    }

    // MARK: - Game Interaction
    
    internal func addSwipeGesture(swipeArea: UIView) {
        
        swipeArea.userInteractionEnabled = true
        
        let direction = [UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Right]
        
        var i = 0;
        
        for _ in direction {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
            swipe.direction = direction[i]
            swipeArea.addGestureRecognizer(swipe)
            i += 1
        }
    }
    
    internal func flipCards() {
        
        p2Numerator.backgroundColor = self.view.backgroundColor
        p2Denominator.backgroundColor = self.view.backgroundColor
        p1Numerator.backgroundColor = self.view.backgroundColor
        p1Denominator.backgroundColor = self.view.backgroundColor
        
        cardsAreUp = true
        
        game.flipCards()
        
        roundStartTime = CACurrentMediaTime()
        
        if playerMode == 1 {
            computerTimer = NSTimer.scheduledTimerWithTimeInterval(difficulty, target:self, selector: #selector(self.computerSwipe), userInfo: nil, repeats: false)
        }
    }
    
    internal func printMessage() {
        print("Times up")
    }
    
    // MARK: - UI Display Utility Functions
    
    internal func delay(delay: Double, closure: ()->()) {
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    internal func popLabel(label: UILabel) {
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { label.alpha = 1.0 },
            completion: {
                (finished: Bool) -> Void in
                //Once the label is completely visible, fade it back out
                self.delay(1.4) {
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { label.alpha = 0.0 },
                        completion: {
                            (finished: Bool) -> Void in
                            //Once the label is completely invisible, remove it from the superview
                            label.removeFromSuperview()
                        }
                    )
                }
            }
        )
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Send along the winner message to the game over screen
        if segue.identifier == "goToGameOver" {
            
            var winner: String?
            
            if (game.player1.points > game.player2.points) {
                winner = "Player One Wins!"
            } else if (game.player1.points < game.player2.points) {
                if (playerMode == 1) {
                    winner = "The Computer Wins!"
                } else {
                    winner = "Player Two Wins!"
                }
            } else {
                winner = "It's a Tie!"
            }
            
            let vc = segue.destinationViewController as! GameOverViewController
            vc.winner = winner
        }
    }
}
