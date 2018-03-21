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
    
    var asyncDisplayFlags = [DisplayType]()
    
    @IBOutlet weak var p1Numerator: UIView!
    @IBOutlet weak var p1Denominator: UIView!
    @IBOutlet weak var p1Vinculum: UIView!
    
    @IBOutlet weak var p1Pause: UIButton!
    @IBOutlet weak var p1Name: UIButton!
    @IBOutlet weak var p1Points: UIButton!
    @IBOutlet weak var p1Deck: UIButton!
    @IBOutlet weak var p1CardCount: UIButton!
    @IBOutlet weak var p1War: UIButton!
    @IBOutlet weak var p1ScoreDiffLabel: UILabel!
    @IBOutlet weak var p1DeckDiffLabel: UILabel!
    
    @IBOutlet weak var p2Numerator: UIView!
    @IBOutlet weak var p2Denominator: UIView!
    @IBOutlet weak var p2Vinculum: UIView!
    
    @IBOutlet weak var p2Pause: UIButton!
    @IBOutlet weak var p2Name: UIButton!
    @IBOutlet weak var p2Points: UIButton!
    @IBOutlet weak var p2Deck: UIButton!
    @IBOutlet weak var p2CardCount: UIButton!
    @IBOutlet weak var p2War: UIButton!
    @IBOutlet weak var p2ScoreDiffLabel: UILabel!
    @IBOutlet weak var p2DeckDiffLabel: UILabel!
    
    @IBOutlet weak var warBoom: UIImageView!
    
    
    var cardViews: [UIView] {
        return [p1Numerator, p1Denominator, p2Numerator, p2Denominator]
    }
    
    var p1NumeratorStruct: CardView!
    var p1DenominatorStruct: CardView!
    var p2NumeratorStruct: CardView!
    var p2DenominatorStruct: CardView!
    
    var cardStructs: [CardView] {
        return [p1NumeratorStruct, p1DenominatorStruct, p2NumeratorStruct, p2DenominatorStruct]
    }
    
    var imageConstraints: [NSLayoutConstraint] = []
    var spaceVertCardToVinculum: CGFloat  { return heightProportion(distance: 10) }
    var spaceHorDeckButtonToHand: CGFloat { return heightProportion(distance: 80) }
    var spaceVertNameToNumerator: CGFloat { return heightProportion(distance: 10) }
    var spaceVertDeckButtonToDenominator: CGFloat { return heightProportion(distance: 10) }
    var spaceVertDeckButonToWar: CGFloat { return heightProportion(distance: 20) }
    var spaceHorVinculumToViewCenter: CGFloat { return heightProportion(distance: 40) }
    var spaceVertPauseToView: CGFloat { return heightProportion(distance: 20) }
    var spaceHorPauseToView: CGFloat { return heightProportion(distance: 20) }
    var spaceHorPointsToDiff: CGFloat { return heightProportion(distance: 20) }
    var spaceHorDeckCountToDiff: CGFloat { return heightProportion(distance: 20) }
    
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
    
    // Regions for detecting swipe gestures
    // Must sit behind other views until it is time to detect a swipe
    var p1SwipeView: UIView!
    var p2SwipeView: UIView!
    
    // Game
    var game: Game!
    
    // Used to store/load settings
    let sH = SettingsHelper.shared
    
    // Used to play sound effects
    let s = Sounds.shared
    
    var difficulty: Double {
        let code = sH.retrieveFromSettings(sH.computerSpeedDictionaryKey) as! String
        return getDifficultyValue(code)
    }
    
    var computerAnswerTimer: Timer?
        
    var pointsToAdd: Int {
        if game.warMode == false  {
            return 1
        } else {
            return 3
        }
    }
    
    // MARK: - View Lifecycle Management
    override func viewDidLoad() {
        super.viewDidLoad()
                
        proportionHandler()
        prepareBoard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveChanges),
                                               name: NSNotification.Name(rawValue: "ResignActive"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {        
    }
    
    override func viewDidLayoutSubviews() {
        if game.gameState == .start {
            dealCards()
        }
        
        if game.loadGame == true {
            game.loadGame = false
            loadedGameSetup()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dealCards() {
        computerAnswerTimer?.invalidate()
                
        game.dealCards()
        placeCardViewsInScene()
        updateCardCounterText()
        
        enableUserInteraction()
        
        // Show the stacked cards image below the new hand
        for card in cardStructs {
            if game.shouldShowWarCards == true {
                card.showWarBack()
            } else {
                card.hideWarBack()
            }
        }
    }
    
    /* Place the cardImageStruct in the cardView */
    func placeCardViewsInScene() {
        guard
            let p1Hand = game.player1.hand,
            let p2Hand = game.player2.hand
        else { return }
        
        let size = p1Numerator!.bounds.size
        
        p1NumeratorStruct = p1Hand.numerator.imageContainer(size: size)
        p1DenominatorStruct = p1Hand.denominator.imageContainer(size: size)
        p2NumeratorStruct = p2Hand.numerator.imageContainer(size: size)
        p2DenominatorStruct = p2Hand.denominator.imageContainer(size: size)
        
        for (index, card) in cardViews.enumerated() {
            for subView in card.subviews {
                subView.removeFromSuperview()
            }
            
            // TODO: Figure out why I have to add this view; otherwise the other views will not show
            let x = UIView(frame: CGRect(origin: CGPoint.zero, size: card.bounds.size))
            card.addSubview(x)
            
            card.addSubview(cardStructs[index].cardContainerView)
        }
    }
    
    func removeCardSubviews() {
        for card in cardViews {
            for subView in card.subviews {
                subView.removeFromSuperview()
            }
        }
    }
    
    
    func resetTimer() {
        computerAnswerTimer?.invalidate()
        computerAnswerTimer = Timer.scheduledTimer(timeInterval: 3,
                             target: self, selector: #selector(computerSwipe), userInfo: nil, repeats: false)
    }
    
    
    func disableUserInteraction() {
        p1Deck.isUserInteractionEnabled = false
        p1SwipeView.isUserInteractionEnabled = false
        p1War.isUserInteractionEnabled = false
        
        if game.playerMode == 2 {
            p2Deck.isUserInteractionEnabled = false
            p2SwipeView.isUserInteractionEnabled = false
            p2War.isUserInteractionEnabled = false
        }
    }
    
    func enableUserInteraction() {
        p1Deck.isUserInteractionEnabled = true
        p1SwipeView.isUserInteractionEnabled = true
        p1War.isUserInteractionEnabled = true
        
        if game.playerMode == 2 {
            p2Deck.isUserInteractionEnabled = true
            p2SwipeView.isUserInteractionEnabled = true
            p2War.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Send along the winner message to the game over screen
        if segue.identifier == "goToGameOver" {
            
            var winner: String?
            var out: String?
            var p1Pts: String?
            var p2Pts: String?
            
            if (game.player1.points > game.player2.points) {
                winner = p1Name.titleLabel!.text!+" wins!"
            } else if (game.player1.points < game.player2.points) {
                winner = p2Name.titleLabel!.text!+" wins!"
            } else {
                winner = "It's a tie!"
            }
            
            if (game.player1.deck.count > game.player2.deck.count) {
                out = p2Name.titleLabel!.text!+" ran out of cards"
            } else {
                out = p1Name.titleLabel!.text!+" ran out of cards"
            }
            
            p1Pts = p1Name.titleLabel!.text! + " points: " + game.player1.points.description + "     "
            p2Pts = "     " + p2Name.titleLabel!.text! + " points: " + game.player2.points.description
            
            let vc = segue.destination as! GameOverViewController
            vc.winner = winner
            vc.out = out
            vc.p1Pts = p1Pts
            vc.p2Pts = p2Pts
        }
    }
    
    func loadedGameSetup() {
        
        func updates() {
            dealCards()
            updateButtonText()
        }
        
        switch (game.gameState) {
        case .roundStart:
            updates()
            break
        case .cardsDealt:
            updates()
            break
        case .cardsFlipped:
            updates()
            pressP1DeckButton(p1Deck)
            break
        case .playerResponded:
            updateButtonText()
            roundOverMaintenance()
            break
        case .roundEnd:
            game.gameState = .roundStart
            updates()
            break
        default:
            break
        }
    }
    
    func updateButtonText() {
        print(game.player1.points, game.player2.points)
        updateCardCounterText()
        updateScoreButtons()
    }
}
