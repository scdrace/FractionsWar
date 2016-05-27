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
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
    }
    var gameCounterFont: UIFont {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
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
    let moveDistanceWrong: CGFloat = 200
    
    // Game state variables
    var p1ready = false
    var p2ready = false
    var cardsAreUp = false
    var inAction = false
        
    // Used to resize Card to port size
    var cardFrame: CGRect {
        return CGRect(origin: CGPointMake(0, 0), size:
            CGSize(width: p1Numerator.frame.width, height: p1Numerator.frame.height)
        )
    }
    
    // Used to store/load settings
    let sH = SettingsHelper.shared
    
    // Used to play sound effects
    let s = Sounds.shared
    
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
        s.playBegin()
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
        s.playPause()
    }
    
    @IBAction func pressPauseP2Button(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("goToPause", sender: self)
        })
        s.playPause()
    }
    
    @IBAction func pressP1DeckButton(sender: AnyObject) {
       
        // Set Player1 to "ready"
        p1ready = true
        p1DeckButton.hidden = true
        
        // Flip cards if both players are "ready"
        if (p1ready && p2ready) {
            flipCards()
            s.playPlace()
        }
        // Set Player2 to ready if we are in one player mode
        else if (playerMode == 1) {
            pressP2DeckButton(sender)
        }
    }
    
    @IBAction func pressP2DeckButton(sender: AnyObject) {
        
        // Set Player2 to "ready"
        p2ready = true
        if (playerMode == 2) {
            p2DeckButton.hidden = true
        }
            
        // Flip cards if both players are "ready"
        if (p1ready && p2ready) {
            flipCards()
            s.playPlace()
        }
    }
    
    // MARK: - Game Display Setup
    
    internal func prepareBoard() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        setFonts()
        decorateButtons()
        
        // Player one swipe view will be full width for player one mode, otherwise half width
        var p1width = self.view.frame.size.width
        if (playerMode == 2) {
            p1width = p1width/2
        }
        
        // Add swipe views
        p1AreaH = UIView(frame: CGRectMake(0, 0, p1width, self.view.frame.size.height))
        p1AreaH.backgroundColor = UIColor.clearColor()
        self.view.addSubview(p1AreaH)
        self.view.bringSubviewToFront(p1AreaH)
        
        
        p2AreaH = UIView(frame: CGRectMake(self.view.center.x, 0, self.view.frame.size.width/2, self.view.frame.size.height))
        p2AreaH.backgroundColor = UIColor.clearColor()
        
        // Only add player 2 swipe view if two player mode
        if playerMode == 2 {
            self.view.addSubview(p2AreaH)
            self.view.bringSubviewToFront(p2AreaH)
        } else {
            p2Name.text = "Computer"
            p2DeckButton.removeFromSuperview()
            p2WarButton.removeFromSuperview()
            p2PauseButton.removeFromSuperview()
        }
    }
    
    internal func setFonts() {
        
        p1PauseButton.titleLabel!.font = gameFont
        p1WarButton.titleLabel!.font = gameFont
        p2PauseButton.titleLabel!.font = gameFont
        p2WarButton.titleLabel!.font = gameFont
    }
    
    internal func decorateButtons() {
        
        p1WarButton.titleLabel?.font = gameFont
        p2WarButton.titleLabel?.font = gameFont
        
        p1PauseButton.setTitleColor(UIColor.lightGrayColor().colorWithAlphaComponent(0.4), forState: UIControlState.Normal)
        p1PauseButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        p1PauseButton.titleEdgeInsets.left = -(p1PauseButton.frame.size.width/3)
        
        p2PauseButton.setTitleColor(UIColor.lightGrayColor().colorWithAlphaComponent(0.4), forState: UIControlState.Normal)
        p2PauseButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        p2PauseButton.titleEdgeInsets.left = -(p2PauseButton.frame.size.width/3)
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
        
        // Update card counts and player scores
        updateScores()
        updateCardCounters()
        
        p1ready = false
        p2ready = false
        p1DeckButton.hidden = false
        if (playerMode == 2) {
            p2DeckButton.hidden = false
        }
        
        // End the game if someone's deck is too small to continue
        if (warMode && (game.player1.cards.count < 4 || game.player2.cards.count < 4)) {
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("goToGameOver", sender: self)
            })
        } else if (game.player1.cards.count < 2 || game.player2.cards.count < 2) {
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("goToGameOver", sender: self)
            })
        }
        
        // Enter war mode if there was a tie, otherwise exit war mode
        if game.getRound().highHand == "tie" {
            warMode = true
        } else {
            warMode = false
        }
    }
    
    
    internal func setupCardsWar() { }
    
    /**
     Updates values of score labels and displays popup label with difference
     */
    internal func updateScores() {
        
        // Get before point value
        let p1DiffIdx = p1Score.text!.endIndex.advancedBy(-7)
        let p1DiffStr = p1Score.text!.substringToIndex(p1DiffIdx)
        let p2DiffIdx = p2Score.text!.endIndex.advancedBy(-7)
        let p2DiffStr = p2Score.text!.substringToIndex(p2DiffIdx)
        
        // Get differnce in current vs updated values
        let p1Diff =  game.player1.points - Int(p1DiffStr)!
        let p2Diff =  game.player2.points - Int(p2DiffStr)!
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            dst = 58.0
        default:
            dst = 100.0
        }
        
        // Update player one score if applicable
        if (p1Diff > 0) {

            // Set new counter values
            p1Score.text = String(game.player1.points) + " Points"
            
            // Prepare update counter for player one
            let p1: CGPoint = (p1Score.superview?.convertPoint(p1Score.center, toView: self.view))!
            let p1DiffCounter = UILabel(frame: p1Score.frame)
            p1DiffCounter.center = CGPointMake(p1.x + dst!, p1.y)
            p1DiffCounter.textAlignment = NSTextAlignment.Center
            p1DiffCounter.text = String(p1Diff)
            p1DiffCounter.font = gameCounterFont
            p1DiffCounter.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            p1DiffCounter.alpha = 0.0
            self.view.addSubview(p1DiffCounter)
            
            // Display counter then remove it
            popLabel(p1DiffCounter)
            
        }
        // Update player two score if applicable
        else if (p2Diff > 0) {
            
            // Set new counter values
            p2Score.text = String(game.player2.points) + " Points"
            
            // Prepare update counter for player two
            let p2: CGPoint = (p2Score.superview?.convertPoint(p2Score.center, toView: self.view))!
            let p2DiffCounter = UILabel(frame: p2Score.frame)
            p2DiffCounter.center = CGPointMake(p2.x - dst!, p2.y)
            p2DiffCounter.textAlignment = NSTextAlignment.Center
            p2DiffCounter.text = String(p2Diff)
            p2DiffCounter.font = gameCounterFont
            p2DiffCounter.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            p2DiffCounter.alpha = 0.0
            self.view.addSubview(p2DiffCounter)
            
            // Display counter then remove it
            popLabel(p2DiffCounter)
        }
    }
    
    /**
     Updates values of card counters and displays popup label with difference
     */
    internal func updateCardCounters() {
        
        // Get difference in current vs updated values
        let p1Diff = game.player1.cards.count - Int(p1Cards.text!)!
        let p2Diff = game.player2.cards.count - Int(p2Cards.text!)!
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            dst = 26.0
        default:
            dst = 40.0
        }
        
        // Set new counter values
        p1Cards.text = String(game.player1.cards.count)
        p2Cards.text = String(game.player2.cards.count)
        
        // Prepare update counter for player one
        let p1: CGPoint = (p1Cards.superview?.convertPoint(p1Cards.center, toView: self.view))!
        let p1DiffCounter = UILabel(frame: p1Cards.frame)
        p1DiffCounter.center = CGPointMake(p1.x + dst!, p1.y)
        p1DiffCounter.textAlignment = NSTextAlignment.Center
        p1DiffCounter.text = String(p1Diff)
        p1DiffCounter.font = gameCounterFont
        p1DiffCounter.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        p1DiffCounter.alpha = 0.0
        self.view.addSubview(p1DiffCounter)
        
        // Prepare update counter for player two
        let p2: CGPoint = (p2Cards.superview?.convertPoint(p2Cards.center, toView: self.view))!
        let p2DiffCounter = UILabel(frame: p2Cards.frame)
        p2DiffCounter.center = CGPointMake(p2.x - dst!, p2.y)
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
    
    /**
     Places notification message at top of screen
     */
    internal func notify(message: String) {
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            dst = 20.0
        default:
            dst = 44.0
        }
        
        // Prepare update counter for player one
        let p = self.view.center
        let t = self.view.frame.minY
        let notification = UILabel()
        notification.textAlignment = NSTextAlignment.Center
        notification.text = message
        notification.font = gameCounterFont
        notification.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        notification.alpha = 0.0
        notification.sizeToFit()
        notification.center = CGPointMake(p.x, t + dst!)
        self.view.addSubview(notification)
        
        // Display message then remove it
        popLabel(notification)
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
    
    // MARK: - UI Display Utility Functions
    
    /**
     Delays thread for specified amount of seconds, then executes action in separate thread
     - Parameter delaye: delay amount in seconds
     */
    internal func delay(delay: Double, closure: ()->()) {
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    /**
     Displays UILabel with 0.6 second fade in, 1.4 second delay, 0.5 second fade out.
     Removes label from superview upon completing fade out.
     - Parameter label: UILabel to fade in and out
     */
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
                winner = p1Name.text!+" Wins!"
            } else if (game.player1.points < game.player2.points) {
                winner = p2Name.text!+" Wins!"
            } else {
                winner = "It's a Tie!"
            }
            
            let vc = segue.destinationViewController as! GameOverViewController
            vc.winner = winner
        }
    }
}
