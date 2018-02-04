//
//  Functions.swift
//  FractionsWar
//
//  Created by David Race on 6/13/16.
//
//

import Foundation


func pathURL(_ fileName: String) -> URL {
    
    
    //Create path-name for file
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                                               in: .userDomainMask)
    let documentDirectory: URL = documentsDirectories.first!
    
    let newFile = fileName + ".txt"
    //print(newFile)

    return documentDirectory.appendingPathComponent(newFile)
}

func documentDirectoryURL() -> URL {
    
    //Create path-name for file
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                                               in: .userDomainMask)
    let documentDirectory: URL = documentsDirectories.first!
    
    return documentDirectory
}

func getDatafileNames() -> [URL]? {
    
    let documentDirectory = documentDirectoryURL()
    
    do {
        
        let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
        
        //print(files)
        
        var result = [URL]()
        for file in files {
            if file.lastPathComponent.hasPrefix("fracWar") {
                
                result.append(file)
            }
        }
        
        return result
    }
    catch {
        print("f")
    }
    
    return nil
}


func deleteDatafiles() {
    
    let documentDirectory = documentDirectoryURL()
    
    do {
        
        let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
        
        
        for file in files {
            if file.lastPathComponent.hasPrefix("fracWar") {
                
                try FileManager.default.removeItem(at: file)
                
            }
        }
    }
    catch {
        print("f")
    }
}


func printDatafileNames() {
    
    let documentDirectory = documentDirectoryURL()
    
    do {
        
        let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
        
        for file in files {
            if file.lastPathComponent.hasPrefix("fracWar") {
                
                print(file)
                
            }
        }
    }
    catch {
        print("f")
    }
}


func player1IDURL() -> URL {
    
    
    //Create path-name for file
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                                               in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    
    return documentDirectory.appendingPathComponent("player1ID.txt")
}
