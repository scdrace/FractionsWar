//
//  SettingsHelper.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/20/16.
//
//

import Foundation

class SettingsHelper {
    
    // Variables for interacting with Settings plist
    
    let settingsPlist = "Settings.plist"
    var settingsPlistPath: String = ""
    let cardTypeDictionaryKey = "CardType"
    var cardTypeDictionaryData: AnyObject?
    
    // MARK: - Settings Storage Helper Methods
    
    internal func formPlistPath() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        settingsPlistPath = documentsDirectory.stringByAppendingPathComponent(settingsPlist)
    }
    
    internal func saveToSettings(settingsData: AnyObject, settingsKey: String) {
        
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        let dictData = NSKeyedArchiver.archivedDataWithRootObject(settingsData)
        
        dict.setObject(dictData, forKey: settingsKey)
        dict.writeToFile(settingsPlistPath, atomically: false)
    }
    
    internal func retrieveFromSettings(settingsKey: String) -> AnyObject {
        
        var data: AnyObject?
        let fileManager = NSFileManager.defaultManager()
        
        if(!fileManager.fileExistsAtPath(settingsPlistPath)) {
            if let bundlePath = NSBundle.mainBundle().pathForResource("AppData", ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: settingsPlistPath)
                } catch {
                    print("Something went wrong")
                }
            }
        }
        
        let myDict = NSDictionary(contentsOfFile: settingsPlistPath)
        if let dict = myDict {
            if let dictValue = dict.objectForKey(settingsKey) as? NSData {
                data = NSKeyedUnarchiver.unarchiveObjectWithData(dictValue)
            }
        }
        
        return data!
    }
}