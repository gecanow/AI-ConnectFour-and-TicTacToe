//
//  Chip.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/22/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class Chip: UILabel {
    var canMove = true
    var colorStr = ""
    
    convenience init(center: CGPoint, color: String) {
        self.init(frame: CGRect(origin: center, size: CGSize(width: 40, height: 40)))
        self.center = center
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        setColor(to: color)
    }
    
    func setColor(to: String) {
        colorStr = to
        if colorStr == "r" {
            backgroundColor = .red
        } else {
            backgroundColor = .blue
        }
    }
}
