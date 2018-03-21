//
//  Contraints+GameViewController.swift
//  FractionsWar
//
//  Created by David Race on 3/4/18.
//

import Foundation
import UIKit

extension GameViewController {
    
    func proportionHandler() {
        //view.translatesAutoresizingMaskIntoConstraints = false
        p1CardCount.translatesAutoresizingMaskIntoConstraints = false
        p2CardCount.translatesAutoresizingMaskIntoConstraints = false
        p1Pause.translatesAutoresizingMaskIntoConstraints = false
        p2Pause.translatesAutoresizingMaskIntoConstraints = false
        p1Points.translatesAutoresizingMaskIntoConstraints = false
        p1ScoreDiffLabel.translatesAutoresizingMaskIntoConstraints = false
        p2ScoreDiffLabel.translatesAutoresizingMaskIntoConstraints = false
        p1DeckDiffLabel.translatesAutoresizingMaskIntoConstraints = false
        p2DeckDiffLabel.translatesAutoresizingMaskIntoConstraints = false
        warBoom.translatesAutoresizingMaskIntoConstraints = false
        for cardView in cardViews {
            cardView.translatesAutoresizingMaskIntoConstraints = false
        }
//        setupImageConstraints(forSize: p1Numerator.bounds.size)
        setupImageConstraints(forSize: view.bounds.size)

    }
    
    private func setupImageConstraints(forSize size: CGSize) {
        NSLayoutConstraint.deactivate(imageConstraints)
        imageConstraints.removeAll()
        
        viewProportions()
        centerButtonText()
        vinculumConstraints()
        cardConstraints()
        pointsContraints()
        deckConstraints()
        cardCountConstraints()
        pauseConstraints()
        pointsWonConstraints()
        deckDiffConstraints()
        //warBackConstraints()
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    func viewProportions() {
        // Set each view proportional to the ratio of the device.
        // Proportion is based on screen height
        for subview in view.subviews {
            if subview.tag == 1 {
                imageConstraints.append(subview.aspectHeightConstraint(view: view))
            }
        }
    }
    
    func centerButtonText() {
        // Points & Buttons
        // Adjust text in buttons
        let buttons = [p1Name, p1Points, p2Name, p2Points]
        for button in buttons {
            button!.titleLabel?.adjustsFontSizeToFitWidth = true
            button!.titleLabel?.baselineAdjustment = .alignCenters
        }
    }
    
    func vinculumConstraints() {
        imageConstraints.append(view.centerXAnchor.constraint(equalTo: p1Vinculum.trailingAnchor,
                                                              constant: spaceHorVinculumToViewCenter))
        imageConstraints.append(view.centerYAnchor.constraint(equalTo: p1Vinculum.centerYAnchor))
        
        imageConstraints.append(p2Vinculum.leadingAnchor.constraint(equalTo: view.centerXAnchor,
                                                                    constant: spaceHorVinculumToViewCenter))
        imageConstraints.append(view.centerYAnchor.constraint(equalTo: p2Vinculum.centerYAnchor))
    }
    
    func cardConstraints() {
        func horizontal() {
            imageConstraints.append(p1Numerator.centerXAnchor.constraint(equalTo: p1Vinculum.centerXAnchor))
            imageConstraints.append(p1Denominator.centerXAnchor.constraint(equalTo: p1Vinculum.centerXAnchor))
            imageConstraints.append(p2Numerator.centerXAnchor.constraint(equalTo: p2Vinculum.centerXAnchor))
            imageConstraints.append(p2Denominator.centerXAnchor.constraint(equalTo: p2Vinculum.centerXAnchor))
        }
        
        func vertical() {
            imageConstraints.append(p1Vinculum.topAnchor.constraint(equalTo: p1Numerator.bottomAnchor,
                                                                    constant: spaceVertCardToVinculum))
            imageConstraints.append(p1Denominator.topAnchor.constraint(equalTo: p1Vinculum.bottomAnchor,
                                                                       constant: spaceVertCardToVinculum))
            
            imageConstraints.append(p2Vinculum.topAnchor.constraint(equalTo: p2Numerator.bottomAnchor,
                                                                    constant: spaceVertCardToVinculum))
            imageConstraints.append(p2Denominator.topAnchor.constraint(equalTo: p2Vinculum.bottomAnchor,
                                                                       constant: spaceVertCardToVinculum))
        }
        
        horizontal()
        vertical()
    }
    
    func pointsContraints() {
        
        func horizontal() {
            imageConstraints.append(p1Name.centerXAnchor.constraint(equalTo: p1Points.centerXAnchor))
            imageConstraints.append(p1Name.centerXAnchor.constraint(equalTo: p1Deck.centerXAnchor))
            imageConstraints.append(p1Name.centerXAnchor.constraint(equalTo: p1War.centerXAnchor))
            
            imageConstraints.append(p2Name.centerXAnchor.constraint(equalTo: p2Points.centerXAnchor))
            imageConstraints.append(p2Name.centerXAnchor.constraint(equalTo: p2Deck.centerXAnchor))
            imageConstraints.append(p2Name.centerXAnchor.constraint(equalTo: p2War.centerXAnchor))
        }
        
        func vertical() {
            imageConstraints.append(p1Points.topAnchor.constraint(equalTo: p1Name.topAnchor))
            imageConstraints.append(p1Numerator.topAnchor.constraint(equalTo: p1Name.topAnchor,
                                                                     constant: spaceVertNameToNumerator))
            
            imageConstraints.append(p2Name.topAnchor.constraint(equalTo: p2Points.topAnchor))
            imageConstraints.append(p2Name.centerYAnchor.constraint(equalTo: p1Name.centerYAnchor))
            imageConstraints.append(p2Deck.centerYAnchor.constraint(equalTo: p1Deck.centerYAnchor))
            imageConstraints.append(p2War.centerYAnchor.constraint(equalTo: p1War.centerYAnchor))
        }
        
        horizontal()
        vertical()
    }
    
    func deckConstraints() {
        
        func horizontal() {
            imageConstraints.append(p1Numerator.leadingAnchor.constraint(equalTo: p1Deck.trailingAnchor,
                                                                         constant: spaceHorDeckButtonToHand))
            
            imageConstraints.append(p2Deck.leadingAnchor.constraint(equalTo: p2Denominator.trailingAnchor,
                                                                    constant: spaceHorDeckButtonToHand))
        }
        
        func vertical() {
            imageConstraints.append(p1Deck.topAnchor.constraint(equalTo: p1Denominator.topAnchor,
                                                                constant: spaceVertDeckButtonToDenominator))
            
            imageConstraints.append(p1War.topAnchor.constraint(equalTo: p1Deck.bottomAnchor,
                                                               constant: spaceVertDeckButonToWar))
        }
        
        horizontal()
        vertical()
    }
    
    func cardCountConstraints() {
        imageConstraints.append(p1CardCount.centerXAnchor.constraint(equalTo: p1Deck.trailingAnchor))
        imageConstraints.append(p1CardCount.centerYAnchor.constraint(equalTo: p1Deck.topAnchor))
        
        imageConstraints.append(p2CardCount.centerXAnchor.constraint(equalTo: p2Deck.leadingAnchor))
        imageConstraints.append(p2CardCount.centerYAnchor.constraint(equalTo: p2Deck.topAnchor))
    }
    
    func pauseConstraints() {
        imageConstraints.append(p1Pause.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                                 constant: spaceHorPauseToView))
        imageConstraints.append(p1Pause.topAnchor.constraint(equalTo: view.topAnchor,
                                                             constant: spaceVertPauseToView))
        
        imageConstraints.append(view.trailingAnchor.constraint(equalTo: p2Pause.trailingAnchor,
                                                               constant: spaceHorPauseToView))
        imageConstraints.append(p2Pause.topAnchor.constraint(equalTo: view.topAnchor,
                                                             constant: spaceVertPauseToView))
    }
    
    // TODO: Think about renaming "diff" name
    func pointsWonConstraints() {
        imageConstraints.append(p1ScoreDiffLabel.centerYAnchor.constraint(equalTo: p1Points.centerYAnchor))
        imageConstraints.append(p1ScoreDiffLabel.leadingAnchor.constraint(equalTo: p1Points.trailingAnchor,
                                                                      constant: spaceHorPointsToDiff))
        
        imageConstraints.append(p2ScoreDiffLabel.centerYAnchor.constraint(equalTo: p1ScoreDiffLabel.centerYAnchor))
        imageConstraints.append(p2Points.leadingAnchor.constraint(equalTo: p2ScoreDiffLabel.trailingAnchor,
                                                                  constant: spaceHorPointsToDiff))


    }
    
    func deckDiffConstraints() {
        imageConstraints.append(p1DeckDiffLabel.centerYAnchor.constraint(equalTo: p1CardCount.centerYAnchor))
        imageConstraints.append(p1DeckDiffLabel.leadingAnchor.constraint(equalTo: p1CardCount.trailingAnchor,
                                                                      constant: spaceHorDeckCountToDiff))
        
        imageConstraints.append(p2DeckDiffLabel.centerYAnchor.constraint(equalTo: p1DeckDiffLabel.centerYAnchor))
        imageConstraints.append(p2CardCount.leadingAnchor.constraint(equalTo: p2DeckDiffLabel.trailingAnchor,
                                                                         constant: spaceHorDeckCountToDiff))
    }
    
//    func warBackConstraints() {
//        for (index, warBack) in warBackImageViews.enumerated() {
//            imageConstraints.append(cardViews[index].centerXAnchor.constraint(equalTo: warBack.centerXAnchor,
//                                                                      constant: 10))
//            imageConstraints.append(warBack.centerYAnchor.constraint(equalTo: cardViews[index].centerYAnchor,
//                                                                     constant: 10))
//        }
//    }
}

extension UIView {
    func aspectDecimal() -> CGFloat {
        return self.bounds.size.height / self.bounds.size.width
    }
    
    func heightProportion(view: UIView) -> CGFloat {
        return (self.bounds.size.height / 768) * view.bounds.size.height
    }
    
    func widthProportionToHeight(view: UIView) -> CGFloat {
        return (aspectDecimal() * self.heightProportion(view: view))
    }
    
    func aspectHeightConstraint(view: UIView) -> NSLayoutConstraint {
        return self.heightAnchor.constraint(equalToConstant: self.heightProportion(view: view))
    }
    
    func aspectWidthConstraint(view: UIView) -> NSLayoutConstraint {
        return self.widthAnchor.constraint(equalToConstant: self.widthProportionToHeight(view: view))
    }
}