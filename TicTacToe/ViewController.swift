//
//  ViewController.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/21/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var gl1: GridLabel!
    @IBOutlet weak var gl2: GridLabel!
    @IBOutlet weak var gl3: GridLabel!
    @IBOutlet weak var gl4: GridLabel!
    @IBOutlet weak var gl5: GridLabel!
    @IBOutlet weak var gl6: GridLabel!
    @IBOutlet weak var gl7: GridLabel!
    @IBOutlet weak var gl8: GridLabel!
    @IBOutlet weak var gl9: GridLabel!
    var gridLabels = [GridLabel]()
    var xTurn = true
    var delegate : WalkthoughDelegate?
    
    //=============================================
    // VIEW DID LOAD FUNCTION
    //=============================================
    override func viewDidLoad() {
        super.viewDidLoad()
        gridLabels.append(gl1)
        gridLabels.append(gl2)
        gridLabels.append(gl3)
        gridLabels.append(gl4)
        gridLabels.append(gl5)
        gridLabels.append(gl6)
        gridLabels.append(gl7)
        gridLabels.append(gl8)
        gridLabels.append(gl9)
    }
    
    //=============================================
    // VIEW WILL APPEAR FUNCTION
    //=============================================
    override func viewWillAppear(_ animated: Bool) {
        gameDescription.text = GameInfo.getGameDescription()
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        delegate?.goToMain(from: 0)
    }
    
    //=============================================
    // Handles when the grid was tapped on
    //=============================================
    @IBAction func onTappedGridLabel(_ sender: UITapGestureRecognizer) {
        for myLabel in gridLabels {
            if myLabel.canTap && myLabel.frame.contains(sender.location(in: backgroundView)) {
                
                if xTurn { myLabel.text = "X" }
                else { myLabel.text = "O" }
                myLabel.canTap = false
                
                if !checkForWinner() {
                    if !gameIsOver() && GameInfo.numPlayers == 1 {
                        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:     #selector(ViewController.comPlayer), userInfo: nil, repeats: false)
                    } else { xTurn = !xTurn }
                }
            }
        }
    }
    
    //=============================================
    // Checks for a winner or a cat's game
    //=============================================
    func checkForWinner() -> Bool {
        var winner = ""
        if checkCells(gl1: gridLabels[0], gl2: gridLabels[1], gl3: gridLabels[2]) {
            winner = gridLabels[0].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[3], gl2: gridLabels[4], gl3: gridLabels[5]) {
            winner = gridLabels[3].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[6], gl2: gridLabels[7], gl3: gridLabels[8]) {
            winner = gridLabels[6].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[0], gl2: gridLabels[3], gl3: gridLabels[6]) {
            winner = gridLabels[0].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[1], gl2: gridLabels[4], gl3: gridLabels[7]) {
            winner = gridLabels[1].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[2], gl2: gridLabels[5], gl3: gridLabels[8]) {
            winner = gridLabels[2].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[0], gl2: gridLabels[4], gl3: gridLabels[8]) {
            winner = gridLabels[0].text! + " Wins!"
        } else if checkCells(gl1: gridLabels[2], gl2: gridLabels[4], gl3: gridLabels[6]) {
            winner = gridLabels[2].text! + " Wins!"
        } else if gameIsOver() {
            winner = "Cat's Game"
        } else {
            winner = ""
        }
        if winner != "" {
            presentWinningAlert(winner)
            return true
        }
        return false
    }
    
    //=============================================
    // Restarts the game ADD BUTTON?
    //=============================================
    func reset() {
        for label in gridLabels {
            label.text = ""
            label.canTap = true
        }
        xTurn = true
    }
    
    //=============================================
    // Checks three cells and returns true
    // if they are all the same
    //=============================================
    func checkCells(gl1: GridLabel, gl2: GridLabel, gl3: GridLabel) -> Bool {
        if !gl1.canTap && gl1.text == gl2.text && gl1.text == gl3.text {
            return true
        }
        return false
    }
    
    //=============================================
    // Checks to see if two of the three
    // cells are the same
    //=============================================
    func checkCellsClose(gl1: GridLabel, gl2: GridLabel, gl3: GridLabel, player: String) -> GridLabel? {
        if gl1.text == player && gl1.text == gl2.text && gl3.canTap {
            return gl3
        } else if gl1.text == player && gl1.text == gl3.text && gl2.canTap {
            return gl2
        } else if gl2.text == player && gl2.text == gl3.text && gl1.canTap {
            return gl1
        } else { return nil }
    }
    
    //=============================================
    // Returns true is the game is over
    //=============================================
    func gameIsOver() -> Bool {
        for label in gridLabels {
            if label.canTap { return false }
        }
        return true
    }
    
    //=============================================
    // Handles presenting the win
    //=============================================
    func presentWinningAlert(_ winner:String) {
        let alert = UIAlertController(title: winner, message: nil,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Reset", style: .default) {
            (action) -> Void in self.reset()
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    //=============================================
    // The computer player's moves
    //=============================================
    @objc func comPlayer() {
        var comSpot = gridLabels[0]
        
        // Level 2: first look is to win, second look is to block their win, third is to take the center, fourth the best corner
        if GameInfo.levelIndex >= 1 {
            let tempMyWin = almostWin(check: "O")
            let tempTheirWin = almostWin(check: "X")
            let nextBest = bestCorner(check: "X")
            let randEdge = randomOpenEdge()
            
            if tempMyWin != nil {
                comSpot = tempMyWin! // WINS
            } else if tempTheirWin != nil {
                comSpot = tempTheirWin! // BLOCKS THEIR WIN
            } else if gridLabels[4].canTap {
                comSpot = gridLabels[4] // TAKES CENTER
            } else if justCenter(check: "X") && GameInfo.levelIndex == 2 {
                comSpot = gridLabels[0] // TESTS FOR JUST CENTER
            } else if justCenterMove2(check: "X") && GameInfo.levelIndex == 2 {
                comSpot = gridLabels[2] // TESTS FOR CENTER MOVE 2
            } else if nextBest != nil {
                comSpot = nextBest!     // TAKES A BEST CORNER
            } else if randEdge != nil && GameInfo.levelIndex == 2 {
                comSpot = randEdge!     // TAKES AN EDGE
            } else {}
        }
        
        // Level 1: finds the first spot open
        var index = 0
        while !comSpot.canTap && index < 8 {
            index += 1
            comSpot = gridLabels[index]
        }
        
        comSpot.text = "O"
        comSpot.canTap = false
        
        let _ = checkForWinner()
    }
    
    //=============================================
    // Returns a grid label that, if filled, would
    // either win the game or block a win
    //=============================================
    func almostWin(check: String) -> GridLabel? {
        var outputLabel = checkCellsClose(gl1: gridLabels[0], gl2: gridLabels[1], gl3: gridLabels[2], player: check)
        
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[3], gl2: gridLabels[4], gl3: gridLabels[5], player: check)
        }
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[6], gl2: gridLabels[7], gl3: gridLabels[8], player: check)
        }
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[0], gl2: gridLabels[3], gl3: gridLabels[6], player: check)
        }
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[1], gl2: gridLabels[4], gl3: gridLabels[7], player: check)
        }
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[2], gl2: gridLabels[5], gl3: gridLabels[8], player: check)
        }
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[0], gl2: gridLabels[4], gl3: gridLabels[8], player: check)
        }
        if outputLabel == nil {
            outputLabel = checkCellsClose(gl1: gridLabels[2], gl2: gridLabels[4], gl3: gridLabels[6], player: check)
        }
        
        return outputLabel
    }
    
    //=============================================
    // Returns a corner that is in between two
    // filled edges
    //=============================================
    func bestCorner(check: String) -> GridLabel? {
        // check the top left for two
        if checkCorner(corner: gridLabels[0], side1: gridLabels[1], side2: gridLabels[3], check: "X") == 2 {
            return gridLabels[0]
        }
        // check the top right
        if checkCorner(corner: gridLabels[2], side1: gridLabels[1], side2: gridLabels[5], check: "X") == 2 {
            return gridLabels[2]
        }
        // check the bottom left
        if checkCorner(corner: gridLabels[6], side1: gridLabels[3], side2: gridLabels[7], check: "X") == 2 {
            return gridLabels[6]
        }
        // check the bottom right
        if checkCorner(corner: gridLabels[8], side1: gridLabels[7], side2: gridLabels[5], check: "X") == 2 {
            return gridLabels[8]
        }
        
        return nil
    }
    
    //=============================================
    // Checks how many edges next to a corner are
    // filled
    //=============================================
    func checkCorner(corner: GridLabel, side1: GridLabel, side2: GridLabel, check: String) -> Int {
        var sides = 0
        if corner.canTap {
            if !side1.canTap && side1.text != check {
                sides += 1
            }
            if !side2.canTap && side2.text != check {
                sides += 1
            }
            return sides
        }
        return -1
    }
    
    //=============================================
    // Returns a random open edge
    //=============================================
    func randomOpenEdge() -> GridLabel? {
        if gridLabels[1].canTap { return gridLabels[1] }
        else if gridLabels[3].canTap { return gridLabels[3] }
        else if gridLabels[5].canTap { return gridLabels[5] }
        else if gridLabels[7].canTap { return gridLabels[7] }
        else { return nil }
    }
    
    //=============================================
    // Checks if just the center is an X/O
    //=============================================
    func justCenter(check: String) -> Bool {
        if gridLabels[4].text != check { return false }
        for index in 0...3 {
            if !gridLabels[index].canTap { return false }
        }
        for index in 5...8 {
            if !gridLabels[index].canTap { return false }
        }
        return true
    }
    
    //=============================================
    // Checks if there's an O-X-X or X-O-O diagonal
    //=============================================
    func justCenterMove2(check: String) -> Bool {
        if gridLabels[0].canTap { return false }
        if gridLabels[4].text != check { return false }
        if gridLabels[8].canTap { return false }
        
        if !gridLabels[1].canTap { return true }
        if !gridLabels[3].canTap { return true }
        for index in 5...7 {
            if !gridLabels[index].canTap { return false }
        }
        return true
    }
}

