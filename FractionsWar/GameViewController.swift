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

    var warDeck = false
    // Player info
    var p1NameText: String!
    var p2NameText: String!
    
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
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
    }
    var gameCounterFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
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
    
    @IBOutlet weak var warBoomImageView: UIImageView!
    @IBOutlet weak var p1NumeratorWar: UIImageView!
    @IBOutlet weak var p2NumeratorWar: UIImageView!
    @IBOutlet weak var p1DenominatorWar: UIImageView!
    @IBOutlet weak var p2DenominatorWar: UIImageView!
    
    var p1NumeratorCardView: CardView!
    var p1DenominatorCardView: CardView!
    var p2NumeratorCardView: CardView!
    var p2DenominatorCardView: CardView!
    
    //@IBOutlet weak var p1NumeratorFD: UIView!
    
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
    
    // These views are a quick fix to hide cards under the cards on the field after round one
    var p1NHide: UIView!
    var p1DHide: UIView!
    var p2NHide: UIView!
    var p2DHide: UIView!
        
    // Game animation parameters
    var game: Game! //(deckType: warDeck)
    let moveDistance: CGFloat = 900
    let moveDistanceWrong: CGFloat = 200
    var pointsToAdd = 1
    
    // Used to store/load settings
    let sH = SettingsHelper.shared
    
    // Used to play sound effects
    let s = Sounds.shared
    
    var difficulty: Double {
        let code = sH.retrieveFromSettings(sH.computerSpeedDictionaryKey) as! String
        return getDifficultyValue(code)
    }
    
    // MARK: - View Lifecycle Management
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //self.game = Game(deckType: warDeck)
        //print(game.gameArchiveURL.path!)
 
        
        //TODO: Possibly move this into a setup/prepare Method
        //Make sure the Ports are the same color as the background
        for port in getCardPorts {
            port.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        }
        
        /*
        if let archivedData = NSKeyedUnarchiver.unarchiveObjectWithFile(game.gameArchiveURL.path!) as? Game {
            //game = archivedData
            print("Loading archived Data")
 
            /*
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("goToPause", sender: self)
            })
            s.playPause()
            */
        }
        */
        
       prepareBoard()
        
       s.playBegin()
         
        
        print(game.getPlayer1ID(), game.getPlayer2ID())
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        addSwipeGesture(p1AreaH)
        addSwipeGesture(p2AreaH)
        
        
        self.view.bringSubview(toFront: p1WarButtonView)
        self.view.bringSubview(toFront: p2WarButtonView)
        self.view.bringSubview(toFront: p1PauseButtonView)
        self.view.bringSubview(toFront: p2PauseButtonView)
        self.view.bringSubview(toFront: p1DeckView)
        self.view.bringSubview(toFront: p2DeckView)
        
        setupCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - On Screen Button Presses
    @IBAction func pressPauseP1Button(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "goToPause", sender: self)
        })
        s.playPause()
    }
    
    @IBAction func pressPauseP2Button(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "goToPause", sender: self)
        })
        s.playPause()
    }
    
    @IBAction func pressP1DeckButton(_ sender: AnyObject) {
       
        // Set Player1 to "ready"
        game.p1ready = true
        p1DeckButton.isHidden = true
        
        // Flip cards if both players are "ready"
        if (game.p1ready && game.p2ready) {
            flipCards(.faceUp)
            s.playPlace()
        }
        // Set Player2 to ready if we are in one player mode
        else if (game.playerMode == 1) {
            pressP2DeckButton(sender)
        }
    }
    
    @IBAction func pressP2DeckButton(_ sender: AnyObject) {
        
        // Set Player2 to "ready"
        game.p2ready = true
        if (game.playerMode == 2) {
            p2DeckButton.isHidden = true
        }
            
        // Flip cards if both players are "ready"
        if (game.p1ready && game.p2ready) {
            flipCards(.faceUp)
            s.playPlace()
        }
    }
    
    // MARK: - Game Display Setup
    
    internal func prepareBoard() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        p1Name.text = p1NameText
        p2Name.text = p2NameText
        
        warBoomImageView.isHidden = true
        p1NumeratorWar.isHidden = true
        p1DenominatorWar.isHidden = true
        p2NumeratorWar.isHidden = true
        p2DenominatorWar.isHidden = true
        
        setFonts()
        decorateButtons()
        
        // Player one swipe view will be full width for player one mode, otherwise half width
        var p1width = self.view.frame.size.width
        if (game.playerMode == 2) {
            p1width = p1width/2
        }
        
        // Add swipe views
        p1AreaH = UIView(frame: CGRect(x: 0, y: 0, width: p1width, height: self.view.frame.size.height))
        p1AreaH.backgroundColor = UIColor.clear
        self.view.addSubview(p1AreaH)
        self.view.bringSubview(toFront: p1AreaH)
        
        
        p2AreaH = UIView(frame: CGRect(x: self.view.center.x, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.height))
        p2AreaH.backgroundColor = UIColor.clear
        
        // Only add player 2 swipe view if two player mode
        if game.playerMode == 2 {
            self.view.addSubview(p2AreaH)
            self.view.bringSubview(toFront: p2AreaH)
        } else {
            p2Name.text = "Computer"
            p2DeckButton.removeFromSuperview()
            p2PauseButton.removeFromSuperview()
            // button is hidden instead of removed so that computer can declare war
            p2WarButton.isHidden = true
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
        
        p1PauseButton.setTitleColor(UIColor.lightGray.withAlphaComponent(0.4), for: UIControlState())
        p1PauseButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        p1PauseButton.titleEdgeInsets.left = -(p1PauseButton.frame.size.width/3)
        
        p2PauseButton.setTitleColor(UIColor.lightGray.withAlphaComponent(0.4), for: UIControlState())
        p2PauseButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        p2PauseButton.titleEdgeInsets.left = -(p2PauseButton.frame.size.width/3)
    }
    
    
    // Card Maintenance
    /**
     Updates values of score labels and displays popup label with difference
     */
    internal func updateScores() {
        
        // Get before point value
        let p1DiffIdx = p1Score.text!.characters.index(p1Score.text!.endIndex, offsetBy: -7)
        let p1DiffStr = p1Score.text!.substring(to: p1DiffIdx)
        let p2DiffIdx = p2Score.text!.characters.index(p2Score.text!.endIndex, offsetBy: -7)
        let p2DiffStr = p2Score.text!.substring(to: p2DiffIdx)
        
        // Get differnce in current vs updated values
        let p1Diff =  game.getPlayer1().getPoints() - Int(p1DiffStr)!
        let p2Diff =  game.getPlayer2().getPoints() - Int(p2DiffStr)!
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            dst = 58.0
        default:
            dst = 100.0
        }
        
        // Update player one score if applicable
        if (p1Diff > 0) {

            // Set new counter values
            p1Score.text = String(game.getPlayer1().points) + " Points"
            
            // Prepare update counter for player one
            let p1: CGPoint = (p1Score.superview?.convert(p1Score.center, to: self.view))!
            let p1DiffCounter = UILabel(frame: p1Score.frame)
            p1DiffCounter.center = CGPoint(x: p1.x + dst!, y: p1.y)
            p1DiffCounter.textAlignment = NSTextAlignment.center
            p1DiffCounter.text = String(p1Diff)
            p1DiffCounter.font = gameCounterFont
            p1DiffCounter.textColor = UIColor.white.withAlphaComponent(0.6)
            p1DiffCounter.alpha = 0.0
            self.view.addSubview(p1DiffCounter)
            
            // Display counter then remove it
            popLabel(p1DiffCounter)
            
        }
        // Update player two score if applicable
        else if (p2Diff > 0) {
            
            // Set new counter values
            p2Score.text = String(game.getPlayer2().getPoints()) + " Points"
            
            // Prepare update counter for player two
            let p2: CGPoint = (p2Score.superview?.convert(p2Score.center, to: self.view))!
            let p2DiffCounter = UILabel(frame: p2Score.frame)
            p2DiffCounter.center = CGPoint(x: p2.x - dst!, y: p2.y)
            p2DiffCounter.textAlignment = NSTextAlignment.center
            p2DiffCounter.text = String(p2Diff)
            p2DiffCounter.font = gameCounterFont
            p2DiffCounter.textColor = UIColor.white.withAlphaComponent(0.6)
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
        var p1Diff = game.getPlayer1().subDeck.count - Int(p1Cards.text!)!
        var p2Diff = game.getPlayer2().subDeck.count - Int(p2Cards.text!)!
        
        // Adjust for war mode wonkiness (displays +10 on war win, should be +12)
        if (p1Diff == 10) { p1Diff = 12 }
        if (p2Diff == 10) { p2Diff = 12 }
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            dst = 26.0
        default:
            dst = 40.0
        }
        
        // Set new counter values
        p1Cards.text = String(game.getPlayer1().subDeck.count)
        p2Cards.text = String(game.getPlayer2().subDeck.count)
        
        // Prepare update counter for player one
        let p1: CGPoint = (p1Cards.superview?.convert(p1Cards.center, to: self.view))!
        let p1DiffCounter = UILabel(frame: p1Cards.frame)
        p1DiffCounter.center = CGPoint(x: p1.x + dst!, y: p1.y)
        p1DiffCounter.textAlignment = NSTextAlignment.center
        p1DiffCounter.text = String(p1Diff)
        p1DiffCounter.font = gameCounterFont
        p1DiffCounter.textColor = UIColor.white.withAlphaComponent(0.6)
        p1DiffCounter.alpha = 0.0
        self.view.addSubview(p1DiffCounter)
        
        // Prepare update counter for player two
        let p2: CGPoint = (p2Cards.superview?.convert(p2Cards.center, to: self.view))!
        let p2DiffCounter = UILabel(frame: p2Cards.frame)
        p2DiffCounter.center = CGPoint(x: p2.x - dst!, y: p2.y)
        p2DiffCounter.textAlignment = NSTextAlignment.center
        p2DiffCounter.text = String(p2Diff)
        p2DiffCounter.font = gameCounterFont
        p2DiffCounter.textColor = UIColor.white.withAlphaComponent(0.6)
        p2DiffCounter.alpha = 0.0
        self.view.addSubview(p2DiffCounter)
        
        // Display counters then remove them
        popLabel(p1DiffCounter)
        popLabel(p2DiffCounter)
    }
    
    /**
     Places notification message at top of screen
     */
    internal func notify(_ message: String) {
        
        // Get appropriate distance depending on device
        var dst: CGFloat?
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            dst = 20.0
        default:
            dst = 44.0
        }
        
        // Prepare update counter for player one
        let p = self.view.center
        let t = self.view.frame.minY
        let notification = UILabel()
        notification.textAlignment = NSTextAlignment.center
        notification.text = message
        notification.font = gameCounterFont
        notification.textColor = UIColor.white.withAlphaComponent(0.6)
        notification.alpha = 0.0
        notification.sizeToFit()
        notification.center = CGPoint(x: p.x, y: t + dst!)
        self.view.addSubview(notification)
        
        // Display message then remove it
        popLabel(notification)
    }

    // MARK: - Game Interaction
    
    internal func addSwipeGesture(_ swipeArea: UIView) {
        
        swipeArea.isUserInteractionEnabled = true
        
        let direction = [UISwipeGestureRecognizerDirection.left, UISwipeGestureRecognizerDirection.right]
        
        var i = 0;
        
        for _ in direction {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
            swipe.direction = direction[i]
            swipeArea.addGestureRecognizer(swipe)
            i += 1
        }
    }
    
    // MARK: - UI Display Utility Functions
    
    /**
     Delays thread for specified amount of seconds, then executes action in separate thread
     - Parameter delay: delay amount in seconds
     */
    internal func delay(_ delay: Double, closure: @escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    /**
     Displays UILabel with 0.6 second fade in, 1.4 second delay, 0.5 second fade out.
     Removes label from superview upon completing fade out.
     - Parameter label: UILabel to fade in and out
     */
    internal func popLabel(_ label: UILabel) {
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { label.alpha = 1.0 },
            completion: {
                (finished: Bool) -> Void in
                //Once the label is completely visible, fade it back out
                self.delay(1.4) {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { label.alpha = 0.0 },
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send along the winner message to the game over screen
        if segue.identifier == "goToGameOver" {
            
            var winner: String?
            var out: String?
            var p1Pts: String?
            var p2Pts: String?
            
            if (game.getPlayer1().getPoints() > game.getPlayer2().getPoints()) {
                winner = p1Name.text!+" wins!"
            } else if (game.getPlayer1().getPoints() < game.getPlayer2().getPoints()) {
                winner = p2Name.text!+" wins!"
            } else {
                winner = "It's a tie!"
            }
            
            if (game.getPlayer1().subDeck.count > game.getPlayer2().subDeck.count) {
                out = p2Name.text!+" ran out of cards"
            } else {
                out = p1Name.text!+" ran out of cards"
            }
            
            p1Pts = p1Name.text! + " points: " + game.getPlayer1().getPoints().description + "     "
            p2Pts = "     " + p2Name.text! + " points: " + game.getPlayer2().getPoints().description
            
            let vc = segue.destination as! GameOverViewController
            vc.winner = winner
            vc.out = out
            vc.p1Pts = p1Pts
            vc.p2Pts = p2Pts
        }
    }
}

extension GameViewController {
    
    /*
     Extension contains code for displaying and flipping cards
     */
    
    // Used to resize Card to port size
    var cardFrame: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: 0), size:
            CGSize(width: p1Numerator.frame.width, height: p1Numerator.frame.height)
        )
    }
    
    var getCardView: [CardView] {
        return [p1NumeratorCardView, p1DenominatorCardView, p2NumeratorCardView, p2DenominatorCardView]
    }
    
    
    // Return the cardPorts, used for swiping
    var getCardPorts: [UIView] {
        return [p1Numerator, p1Denominator, p2Numerator, p2Denominator]
    }
    
    
    internal func addCardImage() {
        
        // Create structure that holds current cards
        let cards = game.getCards()
        
        p1NumeratorCardView = CardView(size: cardFrame, backImage:cards.p1Numerator.backImageName,
                                       faceImage: cards.p1Numerator.imageName)
        p1DenominatorCardView = CardView(size: cardFrame, backImage:cards.p1Denominator.backImageName,
                                         faceImage: cards.p1Denominator.imageName)
        
        p2NumeratorCardView = CardView(size: cardFrame, backImage:cards.p2Numerator.backImageName,
                                       faceImage: cards.p2Numerator.imageName)
        p2DenominatorCardView = CardView(size: cardFrame, backImage:cards.p2Denominator.backImageName,
                                         faceImage: cards.p2Denominator.imageName)
        
        // Add the View of each card to user interface
        self.p1Numerator.addSubview(p1NumeratorCardView.getCardView())
        self.p1Denominator.addSubview(p1DenominatorCardView.getCardView())
        self.p2Numerator.addSubview(p2NumeratorCardView.getCardView())
        self.p2Denominator.addSubview(p2DenominatorCardView.getCardView())
    }
    
    internal func addCoverLayer() {
        
        p1NHide = UIView(frame: CGRect(x: 0, y: 0, width: p1Numerator.frame.size.width, height: p1Numerator.frame.size.height))
        p1NHide.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        p1DHide = UIView(frame: CGRect(x: 0, y: 0, width: p1Denominator.frame.size.width, height: p1Denominator.frame.size.height))
        p1DHide.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        p2NHide = UIView(frame: CGRect(x: 0, y: 0, width: p2Numerator.frame.size.width, height: p2Numerator.frame.size.height))
        p2NHide.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        p2DHide = UIView(frame: CGRect(x: 0, y: 0, width: p2Denominator.frame.size.width, height: p2Denominator.frame.size.height))
        p2DHide.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        p1Numerator.addSubview(p1NHide)
        p1Numerator.bringSubview(toFront: p1NHide)
        p1Numerator.bringSubview(toFront: p1NumeratorWar)
        p1Numerator.bringSubview(toFront: p1NumeratorCardView.cardView)
        
        p1Denominator.addSubview(p1DHide)
        p1Denominator.bringSubview(toFront: p1DHide)
        p1Denominator.bringSubview(toFront: p1DenominatorWar)
        p1Denominator.bringSubview(toFront: p1DenominatorCardView.cardView)
        
        p2Numerator.addSubview(p2NHide)
        p2Numerator.bringSubview(toFront: p2NHide)
        p2Numerator.bringSubview(toFront: p2NumeratorWar)
        p2Numerator.bringSubview(toFront: p2NumeratorCardView.cardView)
        
        p2Denominator.addSubview(p2DHide)
        p2Denominator.bringSubview(toFront: p2DHide)
        p2Denominator.bringSubview(toFront: p2DenominatorWar)
        p2Denominator.bringSubview(toFront: p2DenominatorCardView.cardView)
    }
    
    internal func removeCoverLayer() {
        
        self.p1Numerator.willRemoveSubview(self.p1NHide)
        self.p1NHide.removeFromSuperview()
        
        self.p1Denominator.willRemoveSubview(self.p1DHide)
        self.p1DHide.removeFromSuperview()
        
        self.p2Numerator.willRemoveSubview(self.p2NHide)
        self.p2NHide.removeFromSuperview()
        
        self.p2Denominator.willRemoveSubview(self.p2DHide)
        self.p2DHide.removeFromSuperview()
        
    }
    
    internal func flipCards(_ flipType: CardFlipType) {
        
        switch flipType {
        case .faceUp:
            
            if (p1NumeratorWar.isHidden) {
                // hack-y fix: add view to cover cards that stay field after first round
                addCoverLayer()
            }
            
            game.cardsAreUp = true
            
            for cardView in getCardView {
                cardView.flipFaceUp()
            }
            
            game.roundStartTime = CACurrentMediaTime()
            
            if game.playerMode == 1 {
                game.computerTimer = Timer.scheduledTimer(timeInterval: difficulty, target:self, selector: #selector(self.computerSwipe), userInfo: nil, repeats: false)
            }
            
            if (p1NumeratorWar.isHidden) {
                delay(0.5) {
                    // hack-y fix: remove view to cover cards that stay field after first round
                    self.removeCoverLayer()
                }
            }
            
        case .faceDown:
            for cardView in getCardView {
                cardView.flipFaceDown()
            }
        }
    }
    
    
    struct CardView {
        
        fileprivate var cardView: UIView!
        
        fileprivate var backImage: UIImageView!
        fileprivate var faceImage: UIImageView!
        
        //TODO: Adjust flip Speed?
        let flipDuration: Double = 0.5
        
        init(size: CGRect, backImage: String, faceImage: String) {
            
            //Create self.backImage and resize to fit CardPort (based on screenSize)
            self.backImage = UIImageView(image: UIImage(named: backImage))
            self.backImage.frame = size
            
            //Create self.faceImage and resize to fit CardPort (based on screenSize)
            self.faceImage = UIImageView(image: UIImage(named: faceImage))
            self.faceImage.frame = size
            
            //Creat UIView to contain the UIImageViews
            cardView = UIView(frame: size)
            cardView.addSubview(self.backImage)
        }
        
        mutating func setBackImage(_ backImage: String) {
            self.backImage = UIImageView(image: UIImage(named: backImage))
        }
        
        mutating func setFaceImage(_ faceImage: String) {
            self.faceImage = UIImageView(image: UIImage(named: faceImage))
        }
        
        func getCardView() -> UIView {
            return cardView
        }
        
        /*
         Flip the cardView from Back to Face
         */
        func flipFaceUp() {
            UIView.transition(from: backImage, to: faceImage, duration: flipDuration, options: [
                .transitionFlipFromLeft], completion: nil)
        }
        
        /*
         Flip the carView from Face to Back
         */
        func flipFaceDown() {
            UIView.transition(from: faceImage, to: backImage, duration: flipDuration, options: [
                .transitionFlipFromRight], completion: nil)
        }
    }
}
