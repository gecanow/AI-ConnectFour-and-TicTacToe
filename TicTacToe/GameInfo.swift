//
//  GameInfo.swift
//  
//
//  Created by Necanow on 7/12/18.
//

import UIKit

class GameInfo: NSObject {
    
    static let defaults = UserDefaults.standard
    static var numPlayers = 1
    static var levelIndex = 0
    
    static var wins = ["TTT": 0, "CF": 0]
    
    override init() {
        if let savedData = GameInfo.defaults.object(forKey: "winInformation") as? Data {
            if let decoded = try? JSONDecoder().decode([String: Int].self, from: savedData) {
                GameInfo.wins = decoded
            }
        }
    }
    
    static func getGameDescription() -> String {
        if numPlayers == 2 {
            return "2 Players"
        } else {
            switch levelIndex {
            case 0:
                return "vs. Easy Computer"
            case 1:
                return "vs. Medium Computer"
            default:
                return "vs. Hard Computer"
            }
        }
    }
    
    static func wonTTT() {
        wins["TTT"]! += 1
        saveData()
    }
    
    static func wonCF() {
        wins["CF"]! += 1
        saveData()
    }
    
    static func saveData() {
        print(wins)
        if let encoded = try? JSONEncoder().encode(wins) {
            defaults.set(encoded, forKey: "winInformation")
        }
    }
}
