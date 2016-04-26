//
//  Settings.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/25/16.
//
//

import Foundation

struct Settings {
    
    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    
    let name = "Settings"
    
    var sourcePath: String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else { return .None }
        return path
    }
    
    var destPath: String? {
        guard sourcePath != .None else { return .None }
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
    }
    
    init?() {

        let fileManager = NSFileManager.defaultManager()

        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExistsAtPath(source) else { return nil }

        if !fileManager.fileExistsAtPath(destination) {

            do {
                try fileManager.copyItemAtPath(source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func getValuesInPlistFile() -> NSDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }

    func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }

    func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            if !dictionary.writeToFile(destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
}


class SettingsHelper {
    
    // Singleton SettingsHelper
    
    static let shared = SettingsHelper()
    let settings = Settings()
    
    // Variables for interacting with Settings plist
    
    let settingsPlist = "Settings.plist"
    var settingsPlistPath: String = ""
    
    let cardTypeDictionaryKey = "CardType"
    var cardTypeDictionaryData: AnyObject?
    
    let deckSizeDictionaryKey = "DeckSize"
    var deckSizeDictionaryData: AnyObject?
    
    let computerSpeedDictionaryKey = "ComputerSpeed"
    var computerSpeedDictionaryData: AnyObject?
    
    private init() { }
    
    // MARK: - Settings Storage Helper Methods
    
    internal func saveToSettings(settingsData: AnyObject, settingsKey: String) {
        
        let dict = settings!.getMutablePlistFile()!
        dict[settingsKey] = settingsData
        
        do {
            try settings!.addValuesToPlistFile(dict)
        } catch {
            print(error)
        }
    }
    
    internal func retrieveFromSettings(settingsKey: String) -> AnyObject {
        
        let dict = settings!.getValuesInPlistFile()!
        
        if let myVal = dict[settingsKey] as? String {
            if (myVal == "") {
                return setDefaultSettingsValue(settingsKey)
            }
            return myVal
        } else {
            return setDefaultSettingsValue(settingsKey)
        }
    }
    
    internal func setDefaultSettingsValue(settingsKey: String) -> AnyObject {
        
        if (settingsKey == cardTypeDictionaryKey) {
            saveToSettings("r", settingsKey: cardTypeDictionaryKey)
            return "r"
        } else if (settingsKey == deckSizeDictionaryKey) {
            saveToSettings("n", settingsKey: deckSizeDictionaryKey)
            return "n"
        } else {
            saveToSettings("s", settingsKey: computerSpeedDictionaryKey)
            return "s"
        }
    }
}