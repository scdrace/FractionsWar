//
//  DataCollectionViewController.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 5/27/16.
//
//

import Foundation
import UIKit

class DataCollectionViewController: UIViewController {
    
    @IBOutlet weak var backToSettingsButton: UIButton!
    @IBOutlet weak var dataCollectionLabel: UILabel!
    
    // Data collection buttons
    @IBOutlet weak var beginCollectingDataButton: UIButton!
    @IBOutlet weak var exportDataButton: UIButton!
    @IBOutlet weak var clearDataButton: UIButton!
    
    
    // Custom game fonts
    var gameFont: UIFont {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
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
    
    @IBAction func pressBackToSettingsButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    @IBAction func pressBeginCollectingDataButton(sender: AnyObject) {
        if (beginCollectingDataButton.selected) {
            sH.saveToSettings(false, settingsKey: sH.isCollectingDataDictionaryKey)
            beginCollectingDataButton.selected = false
        } else {
            sH.saveToSettings(true, settingsKey: sH.isCollectingDataDictionaryKey)
            beginCollectingDataButton.selected = true
        }
        updateDataCollectionLabelText()
    }
    
    @IBAction func pressExportDataButton(sender: AnyObject) {
        
        let exportAlert = UIAlertController(title: "Export Data", message: "Click Export to share your swipe data.", preferredStyle: UIAlertControllerStyle.Alert)
        
        exportAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Enter destination email address"
        })
        
        exportAlert.addAction(UIAlertAction(title: "Export", style: .Default, handler: { (action: UIAlertAction!) in
            
            // Handle export logic here
            
            let textField = exportAlert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
        }))
        
        exportAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(exportAlert, animated: true, completion: nil)
    }
    
    @IBAction func pressClearDataButton(sender: AnyObject) {
        
        let clearAlert = UIAlertController(title: "Clear Data", message: "All swipe data will be lost.\n\n Consider exporting your data first.", preferredStyle: UIAlertControllerStyle.Alert)
        
        clearAlert.addAction(UIAlertAction(title: "Clear Data", style: .Default, handler: { (action: UIAlertAction!) in
            
            // Handle clear logic here
        }))
        
        clearAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(clearAlert, animated: true, completion: nil)
    }
    
    // MARK: - Data Collection Screen Display Setup
    
    internal func prepareDataCollectionScreen() {
        
        backToSettingsButton.titleLabel?.font = gameFont
        backToSettingsButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.7), forState: UIControlState.Normal)
        backToSettingsButton.sizeToFit()
        
        updateDataCollectionLabelText()
        dataCollectionLabel.textColor = UIColor.whiteColor()
        dataCollectionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        dataCollectionLabel.sizeToFit()
        
        beginCollectingDataButton.titleLabel?.font = gameFont
        beginCollectingDataButton.sizeToFit()
        
        exportDataButton.titleLabel?.font = gameFont
        exportDataButton.sizeToFit()
        
        clearDataButton.titleLabel?.font = gameFont
        clearDataButton.sizeToFit()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    private func updateDataCollectionLabelText() {
        var text = ""
        
        let isCollecting = sH.retrieveFromSettings(sH.isCollectingDataDictionaryKey) as! Bool
        let collectionLimit = sH.retrieveFromSettings(sH.dataCollectionLimitDictionaryKey) as! NSNumber
        let collectionSize = dH.retrieveDataPlistSize()
        
        text += "Fractions War can collect swipe data as users play the game. The app will store data about each swipe on the device as long as data collection is active."+"\n\n"
        
        if (isCollecting) {
            text += "You are currently collecting data on this device."+"\n\n"
            text += "Current number of data entries stored on device: "+collectionSize.stringValue+"\n"
            text += "Maximum number of data entries that can be stored: "+collectionLimit.stringValue+"\n\n"
        } else {
            text += "You are currently not collecting data on this device."
        }
        
        dataCollectionLabel.text = text
    }
    
    internal func setSelectedOptions() {
        
        let isCollecting = sH.retrieveFromSettings(sH.isCollectingDataDictionaryKey) as! Bool
        
        if (isCollecting) {
            beginCollectingDataButton.selected = true
        } else {
            beginCollectingDataButton.selected = false
        }
    }
}