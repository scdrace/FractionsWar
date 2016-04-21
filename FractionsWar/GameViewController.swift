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
    
    // Custom game fonts
    var gameFont: UIFont {
        return UIFont(name: "DINCond-Bold", size: 22)!
    }
    
    // Ports in which Card.view is placed
    // Ports are used so that we can set up constraints in IB
    @IBOutlet weak var p1Numerator: UIView!
    @IBOutlet weak var p1Denominator: UIView!
    @IBOutlet weak var p2Numerator: UIView!
    @IBOutlet weak var p2Denominator: UIView!
    
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
    
    // These view sit on top of everything, so that they can detect a touch
    var p1AreaX: UIView!
    var p2AreaX: UIView!
    var p1AreaH: UIView!
    var p2AreaH: UIView!
    
    // Game animation parameters
    var game = Game() 
    let moveDistance: CGFloat = 900
    
    // Used to resize Card to port size
    var cardFrame: CGRect {
        return CGRect(origin: CGPointMake(0, 0), size:
            CGSize(width: p1Numerator.frame.width, height: p1Numerator.frame.height)
        )
    }
    
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
        
        setupCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - On Screen Button Presses
    
    @IBAction func pressDeclareWarP1Button(sender: AnyObject) {
        flipCards()
    }
    
    @IBAction func pressDeclareWarP2Button(sender: AnyObject) {
        flipCards()
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
        self.view.addSubview(p2AreaH)
        self.view.bringSubviewToFront(p2AreaH)
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
        
        game.nextRound()
        game.resizeCards(cardFrame)
        
        // Add Card.view to corresponding card-port
        addCardImage()
        
        // Update scores
        p1Score.text = String(game.getPlayer1().points) + " Points"
        p2Score.text = String(game.getPlayer2().points) + " Points"
        
        updateCardCounters()
        
        // Debugging
        print("Player2: \(game.player2.hand!)")
        print("Player1: \(game.player1.hand!)")
    }
    
    internal func updateCardCounters() {
        p1Cards.text = String(game.player1.cards.count)
        p2Cards.text = String(game.player2.cards.count)
    }

    // MARK: - Game Interaction
    
    internal func addSwipeGesture(swipeArea: UIView) {
        
        swipeArea.userInteractionEnabled = true
        
        let direction = [UISwipeGestureRecognizerDirection.Up, UISwipeGestureRecognizerDirection.Down,
                         UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Right]
        
        for i in 0...3 {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
            swipe.direction = direction[i]
            swipeArea.addGestureRecognizer(swipe)
        }
    }
    
    internal func flipCards() {
        
        p2Numerator.backgroundColor = self.view.backgroundColor
        p2Denominator.backgroundColor = self.view.backgroundColor
        p1Numerator.backgroundColor = self.view.backgroundColor
        p1Denominator.backgroundColor = self.view.backgroundColor
        
        game.flipCards()
    }
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
