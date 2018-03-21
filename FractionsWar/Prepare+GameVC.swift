//
//  PrepareBoard.swift
//  FractionsWar
//
//  Created by David Race on 3/5/18.
//

import Foundation
import UIKit

extension GameViewController {
    // MARK: - Game Display Setup
    
    internal func prepareBoard() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        p1Name.isUserInteractionEnabled = false
        p1Points.isUserInteractionEnabled = false
        
        p1Name.setTitle(game.player1.name, for: .normal)
        p2Name.setTitle(game.player2.name, for: .normal)
        
        prepareCardCounter()
        
        warBoom.isHidden = true
        
        editPauseButtonAttributes()
        editWarButtonAttributes()
        createSwipeViews()
    }
    
    // Player one swipe view will be full width for player one mode, otherwise half width
    fileprivate func createSwipeViews() {
        guard
            game.playerMode > 0,
            game.playerMode < 3
            else { return }
        
        // Player one swipe view will be full width for player one mode, otherwise half width
        var swipeViewWidth = self.view.frame.size.width
        let swipeViewHeight = self.view.frame.size.height
        
        func addSwipeView(swipeView: UIView) {
            swipeView.backgroundColor = UIColor.clear
            self.view.addSubview(swipeView)
            self.view.sendSubview(toBack: swipeView)
        }
        
        if game.playerMode == 1 {
            print("Player Mode == 1")
            p1SwipeView = UIView(frame: CGRect(x: 0, y: 0, width: swipeViewWidth, height: swipeViewHeight))
            addSwipeView(swipeView: p1SwipeView)
        
            p2Pause.isHidden = true
            //p2Name.setTitle("Computer", for: .normal)
            p2Deck.setImage(nil, for: .normal)            
            p2War.isHidden = true
            
            addSwipeGesture(p1SwipeView)
        } else {
            print("Player Mode == 2")
            swipeViewWidth = swipeViewWidth / 2
            p1SwipeView = UIView(frame: CGRect(x: 0, y: 0, width: swipeViewWidth, height: swipeViewHeight))
            p2SwipeView = UIView(frame: CGRect(x: self.view.center.x,
                                               y: 0,
                                               width: swipeViewWidth,
                                               height: swipeViewHeight))

            addSwipeView(swipeView: p1SwipeView)
            addSwipeGesture(p1SwipeView)

            addSwipeView(swipeView: p2SwipeView)
            addSwipeGesture(p2SwipeView)
        }
    }
    
    fileprivate func editWarButtonAttributes() {
        for war in [p1War, p2War] {
            war?.titleLabel?.font = gameFont
        }
    }
    
    fileprivate func editPauseButtonAttributes() {
        
        for pause in [p1Pause, p2Pause] {
            pause?.titleLabel!.font = gameFont
            pause?.setTitleColor(UIColor.lightGray.withAlphaComponent(0.4), for: UIControlState())
            pause?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            pause?.titleEdgeInsets.left = -(p1Pause.frame.size.width/3)
        }
    }
    
    fileprivate func addSwipeGesture(_ swipeArea: UIView) {
        swipeArea.isUserInteractionEnabled = true
        
        let p1SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.p1SwipeRight(_:)))
        p1SwipeRight.direction = .right
        p1SwipeView.addGestureRecognizer(p1SwipeRight)
        
        let p1SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.p1SwipeLeft(_:)))
        p1SwipeLeft.direction = .left
        p1SwipeView.addGestureRecognizer(p1SwipeLeft)
        
        if game.playerMode == 2 {
            let p2SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.p2SwipeRight(_:)))
            p2SwipeRight.direction = .right
            p2SwipeView.addGestureRecognizer(p2SwipeRight)
            
            let p2SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.p2SwipeLeft(_:)))
            p2SwipeLeft.direction = .left
            p2SwipeView.addGestureRecognizer(p2SwipeLeft)
        }
    }
    
    func prepareCardCounter() {
        p1CardCount.setTitle(String(game.player1.deck.count), for: .normal)
        p2CardCount.setTitle(String(game.player2.deck.count), for: .normal)
    }
}
