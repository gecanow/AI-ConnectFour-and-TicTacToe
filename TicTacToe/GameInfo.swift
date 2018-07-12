//
//  GameInfo.swift
//  
//
//  Created by Necanow on 7/12/18.
//

import UIKit

class GameInfo: NSObject {
    static var numPlayers = 1
    static var levelIndex = 0
    
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
}
