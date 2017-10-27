//
//  Settings.swift
//  FractionsWar
//
//  Created by Stephen Gaschignard on 4/25/16.
//
//

import Foundation

struct Settings {
    
    enum PlistError: Error {
        case fileNotWritten
        case fileDoesNotExist
    }
    
    let name = "Settings"
    
    var sourcePath: String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }
    
    var destPath: String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent("\(name).plist")
    }
    
    init?() {

        let fileManager = FileManager.default

        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else { return nil }

        if !fileManager.fileExists(atPath: destination) {

            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func getValuesInPlistFile() -> NSDictionary? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }

    func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }

    func addValuesToPlistFile(_ dictionary:NSDictionary) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            if !dictionary.write(toFile: destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.fileNotWritten
            }
        } else {
            throw PlistError.fileDoesNotExist
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
    
    // Game settings dictionary keys
    
    let cardTypeDictionaryKey = "CardType"
    var cardTypeDictionaryData: AnyObject?
    
    let deckSizeDictionaryKey = "DeckSize"
    var deckSizeDictionaryData: AnyObject?
    
    let computerSpeedDictionaryKey = "ComputerSpeed"
    var computerSpeedDictionaryData: AnyObject?
    
    // Data collection settings dictionary keys
    
    let isCollectingDataDictionaryKey = "IsCollectingData"
    var isCollectingDataDictionaryData: AnyObject?
    
    let dataCollectionEmailDictionaryKey = "DataCollectionEmail"
    var dataCollectionEmailDictionaryData: AnyObject?
    
    let dataCollectionLimitDictionaryKey = "DataCollectionLimit"
    var dataCollectionLimitDictionaryData: AnyObject?
    
    let dataCollectionPasswordDictionaryKey = "DataCollectionPassword"
    var dataCollectionPasswordDictionaryData: AnyObject?
    
    fileprivate init() { }
    
    // MARK: - Settings Storage Helper Methods
    
    internal func saveToSettings(_ settingsData: AnyObject, settingsKey: String) {
        
        let dict = settings!.getMutablePlistFile()!
        dict[settingsKey] = settingsData
                
        do {
            try settings!.addValuesToPlistFile(dict)
        } catch {
            print(error)
        }
    }
    
    internal func retrieveFromSettings(_ settingsKey: String) -> AnyObject {
        
        let dict = settings!.getValuesInPlistFile()!
        
        if let myStringVal = dict[settingsKey] as? String {
            if (myStringVal == "") {
                return setDefaultSettingsValue(settingsKey)
            }
            return myStringVal as AnyObject
        } else if let myNumVal = dict[settingsKey] as? NSNumber {
            return myNumVal
        } else if let myBoolVal = dict[settingsKey] as? Bool {
            return myBoolVal as AnyObject
        } else {
            return setDefaultSettingsValue(settingsKey)
        }
    }
    
    internal func setDefaultSettingsValue(_ settingsKey: String) -> AnyObject {
        
        if (settingsKey == cardTypeDictionaryKey) {
            saveToSettings("r" as AnyObject, settingsKey: cardTypeDictionaryKey)
            return "r" as AnyObject
        } else if (settingsKey == deckSizeDictionaryKey) {
            saveToSettings("n" as AnyObject, settingsKey: deckSizeDictionaryKey)
            return "n" as AnyObject
        } else if (settingsKey == computerSpeedDictionaryKey) {
            saveToSettings("s" as AnyObject, settingsKey: computerSpeedDictionaryKey)
            return "s" as AnyObject
        } else if (settingsKey == isCollectingDataDictionaryKey) {
            saveToSettings(false as AnyObject, settingsKey: isCollectingDataDictionaryKey)
            return false as AnyObject
        } else if (settingsKey == dataCollectionEmailDictionaryKey) {
            saveToSettings("undefined" as AnyObject, settingsKey: dataCollectionEmailDictionaryKey)
            return "undefined" as AnyObject
        } else if (settingsKey == dataCollectionLimitDictionaryKey) {
            saveToSettings(4000 as AnyObject, settingsKey: dataCollectionLimitDictionaryKey)
            return 4000 as AnyObject
        } else if (settingsKey == dataCollectionPasswordDictionaryKey) {
            saveToSettings("0000" as AnyObject, settingsKey: dataCollectionPasswordDictionaryKey)
            return "0000" as AnyObject
        } else {
            return "" as AnyObject
        }
    }
}
