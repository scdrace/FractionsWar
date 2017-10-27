//
//  DataCollectionViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 5/27/16.
//
//

import Foundation
import UIKit
import MessageUI

class DataCollectionViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    /*
    //TODO: This is temporary
    let itemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent("textFile0.txt")
    }()
    */
    
    @IBOutlet weak var backToSettingsButton: UIButton!
    @IBOutlet weak var dataCollectionLabel: UILabel!
    
    // Data collection buttons
    @IBOutlet weak var beginCollectingDataButton: UIButton!
    @IBOutlet weak var exportDataButton: UIButton!
    @IBOutlet weak var clearDataButton: UIButton!
    
    
    // Custom game fonts
    var gameFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIFont(name: "DINCond-Bold", size: 17)!
        default:
            return UIFont(name: "DINCond-Bold", size: 32)!
        }
    }
    
    let sH = SettingsHelper.shared
    let dH = DataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareDataCollectionScreen()
        setSelectedOptions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Collection Screen Interactions
    
    @IBAction func pressBackToSettingsButton(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: false, completion: nil)
            
            let x = self.presentingViewController as! SettingsViewController
            print(x.collectData)
        })
    }
    
    @IBAction func pressBeginCollectingDataButton(_ sender: AnyObject) {
        
        
        func dataCollection() {
            // TODO: Set variable in plist to true or false;
            // TODO: Look in SwipeLogicExt for 'game.saveDataImmediate(swipeTime)'
            // TODO: wrap that call in test (if or switch) based on plist value
            
            let x = self.presentingViewController as! SettingsViewController
            
            if (beginCollectingDataButton.isSelected) {
                sH.saveToSettings(false as AnyObject, settingsKey: sH.isCollectingDataDictionaryKey)
                beginCollectingDataButton.isSelected = false
                
                //TODO: Better implementation; SettingsHelper?
                x.collectData = false
            } else {
                sH.saveToSettings(true as AnyObject, settingsKey: sH.isCollectingDataDictionaryKey)
                beginCollectingDataButton.isSelected = true
                
                //TODO: Better implementation; SettingsHelper?
                x.collectData = true
            }
            updateDataCollectionLabelText()
        }
        
        self.enterPassword(dataCollection)
    }
    
    
    @IBAction func pressExportDataButton(_ sender: AnyObject) {
        
        func exportData() {
            let export = ExportDataViewController()

            present(export, animated: false, completion: nil)
        }
        
        self.enterPassword(exportData)
    }
    
    
    @IBAction func pressClearDataButton(_ sender: AnyObject) {
        
        func clearData() {
            let clearAlert = UIAlertController(title: "Clear Data", message: "All swipe data will be lost.\n\n Consider exporting your data first.", preferredStyle: UIAlertControllerStyle.alert)
            
            
            clearAlert.addAction(UIAlertAction(title: "Clear Data", style: .default, handler: { (action: UIAlertAction!) in
                
                // Handle clear logic here
                deleteDatafiles()
            }))
            
            clearAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(clearAlert, animated: true, completion: nil)
        }
        
        self.enterPassword(clearData)
    }
    
    // MARK: - Data Collection Screen Display Setup
    
    internal func prepareDataCollectionScreen() {
        
        backToSettingsButton.titleLabel?.font = gameFont
        backToSettingsButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: UIControlState())
        backToSettingsButton.sizeToFit()
        
        updateDataCollectionLabelText()
        dataCollectionLabel.textColor = UIColor.white
        dataCollectionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        dataCollectionLabel.sizeToFit()
        
        beginCollectingDataButton.titleLabel?.font = gameFont
        beginCollectingDataButton.sizeToFit()
        
        exportDataButton.titleLabel?.font = gameFont
        exportDataButton.sizeToFit()
        
        clearDataButton.titleLabel?.font = gameFont
        clearDataButton.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    fileprivate func updateDataCollectionLabelText() {
        var text = ""
        
        let isCollecting = sH.retrieveFromSettings(sH.isCollectingDataDictionaryKey) as! Bool
        //let collectionLimit = sH.retrieveFromSettings(sH.dataCollectionLimitDictionaryKey) as! NSNumber
        //let collectionSize = dH.retrieveDataPlistSize()
        
        text += "Fractions War can collect swipe data as users play the game. The app will store data about each swipe on the device as long as data collection is active."+"\n\n"
        
        if (isCollecting) {
            text += "You are currently collecting data on this device."+"\n\n"
            text += "Periodically clear your data to keep the application size from inflating."+"\n\n"
        } else {
            text += "You are currently not collecting data on this device."
        }
        
        dataCollectionLabel.text = text
    }
    
    internal func setSelectedOptions() {
        
        let isCollecting = sH.retrieveFromSettings(sH.isCollectingDataDictionaryKey) as! Bool
        
        if (isCollecting) {
            beginCollectingDataButton.isSelected = true
        } else {
            beginCollectingDataButton.isSelected = false
        }
    }
    
    func enterPassword(_ passwordAction: @escaping ()->()) {
        
        // TODO: Password cannot exist here
        let password = sH.retrieveFromSettings(sH.dataCollectionPasswordDictionaryKey) as! String
        
        let passwordAlert = UIAlertController(title: "Enter Password", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        passwordAlert.addTextField(configurationHandler: { (textField) -> Void in
            
            //textField.placeholder = "password"
        })
        
        passwordAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        passwordAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
            
            if passwordAlert.textFields?.first!.text! == String(password) {
                print("Password Match")
                passwordAction()
                return
            }
            print(passwordAlert.textFields?.first?.text)
            print("password mismatch")
        }))
        
        present(passwordAlert, animated: true) {
        }

    }
}
