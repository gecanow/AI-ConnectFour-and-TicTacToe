//
//  ThirdViewController.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/22/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet var dropLabels: [UIImageView]!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var chipBox: UILabel!
    
    var currentChip : Chip?
    var currentChipIsMovable = false
    
    var chipStr = ["r", "b"]
    
    @IBOutlet weak var cell1A: Cell!
    @IBOutlet weak var cell2A: Cell!
    @IBOutlet weak var cell3A: Cell!
    @IBOutlet weak var cell4A: Cell!
    @IBOutlet weak var cell5A: Cell!
    @IBOutlet weak var cell6A: Cell!
    @IBOutlet weak var cell7A: Cell!
    
    @IBOutlet weak var cell1B: Cell!
    @IBOutlet weak var cell2B: Cell!
    @IBOutlet weak var cell3B: Cell!
    @IBOutlet weak var cell4B: Cell!
    @IBOutlet weak var cell5B: Cell!
    @IBOutlet weak var cell6B: Cell!
    @IBOutlet weak var cell7B: Cell!
    
    @IBOutlet weak var cell1C: Cell!
    @IBOutlet weak var cell2C: Cell!
    @IBOutlet weak var cell3C: Cell!
    @IBOutlet weak var cell4C: Cell!
    @IBOutlet weak var cell5C: Cell!
    @IBOutlet weak var cell6C: Cell!
    @IBOutlet weak var cell7C: Cell!
    
    @IBOutlet weak var cell1D: Cell!
    @IBOutlet weak var cell2D: Cell!
    @IBOutlet weak var cell3D: Cell!
    @IBOutlet weak var cell4D: Cell!
    @IBOutlet weak var cell5D: Cell!
    @IBOutlet weak var cell6D: Cell!
    @IBOutlet weak var cell7D: Cell!
    
    @IBOutlet weak var cell1E: Cell!
    @IBOutlet weak var cell2E: Cell!
    @IBOutlet weak var cell3E: Cell!
    @IBOutlet weak var cell4E: Cell!
    @IBOutlet weak var cell5E: Cell!
    @IBOutlet weak var cell6E: Cell!
    @IBOutlet weak var cell7E: Cell!
    
    @IBOutlet weak var cell1F: Cell!
    @IBOutlet weak var cell2F: Cell!
    @IBOutlet weak var cell3F: Cell!
    @IBOutlet weak var cell4F: Cell!
    @IBOutlet weak var cell5F: Cell!
    @IBOutlet weak var cell6F: Cell!
    @IBOutlet weak var cell7F: Cell!
    
    @IBOutlet var dragField: UIPanGestureRecognizer!
    
    var board = [[Cell]]()
    
    var redTurn = true
    
    var boardStr = ""
    var boardFeatures = [[["rrrr"],
                          ["rrro", "orrr", "rror", "rorr"],
                          ["rroo", "roro", "roor", "orro", "oror", "oorr"]],
                         [["bbbb"],
                          ["bbbo", "obbb", "bbob", "bobb"],
                          ["bboo", "bobo", "boob", "obbo", "obob", "oobb"]]]
    
    //==================================================
    // VIEW DID LOAD FUNCTION
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board.append([cell1F, cell2F, cell3F, cell4F, cell5F, cell6F, cell7F])
        board.append([cell1E, cell2E, cell3E, cell4E, cell5E, cell6E, cell7E])
        board.append([cell1D, cell2D, cell3D, cell4D, cell5D, cell6D, cell7D])
        board.append([cell1C, cell2C, cell3C, cell4C, cell5C, cell6C, cell7C])
        board.append([cell1B, cell2B, cell3B, cell4B, cell5B, cell6B, cell7B])
        board.append([cell1A, cell2A, cell3A, cell4A, cell5A, cell6A, cell7A])
        
        for row in board {
            for cell in row {
                cell.layer.cornerRadius = 20
                cell.layer.borderWidth = 5
                cell.backgroundColor = .clear
            }
        }
        updatePlayerTurn(isRed: true)
    }
    
    //==================================================
    // Tests for when the touch first hits, and 
    // whether it is on a chip or not
    //==================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first?.location(in: background)
        
        currentChipIsMovable = false
        
        if ((GameInfo.numPlayers == 2 && redTurn) || GameInfo.numPlayers == 1) && currentChip != nil {
            if (currentChip!.frame.contains(first!)) && (currentChip!.canMove) {
                currentChipIsMovable = true
            }
        }

    }

    //==================================================
    // Drags the chip if the pan gesture is recognized
    // and the first touch was on the chip
    //==================================================
    @IBAction func onDragged(_ sender: UIPanGestureRecognizer) {
        let point = dragField.location(in: background)
        
        if currentChipIsMovable {
            currentChip?.center = CGPoint(x: point.x, y: point.y)
            
            var landedOnDropLabel = false
            if dragField.state == UIGestureRecognizerState.ended && currentChip != nil {
                for label in dropLabels {
                    if label.frame.contains(currentChip!.center) {
                        if fallDown(col: label.tag, makeMove: true) >= 0 {
                            landedOnDropLabel = true
                        }
                        break
                    }
                }
                
                if !landedOnDropLabel {
                    // send 'em back!
                    currentChip!.center = chipBox.center
                }
            }
        }
    }
    
    //==================================================
    // Handles whether the chip can fall down
    // the column specified, and which row
    // it ends up at
    //==================================================
    func fallDown(col: Int, makeMove: Bool) -> Int {
        
        for checkMe in 0..<board.count {
            let cell = board[checkMe][col]
            if cell.isEmpty {
                if makeMove && currentChip != nil {
                    if !redTurn && GameInfo.numPlayers == 1 {
                        animateToDrop(dropIndex: col, toCell: cell)
                    } else { animateDownwards(toCell: cell) }
                
                    currentChip!.canMove = false
                    cell.isEmpty = false
                    cell.chipReference = currentChip
                }
                return checkMe
            }
        }
        return -1
    }
    
    //==================================================
    // Handles the animation from the down
    // arrow to the open cell
    //==================================================
    func animateDownwards(toCell: Cell) {
        currentChip?.center.x = toCell.center.x
        UIView.animate(withDuration: 0.4, animations: {
            self.currentChip?.center.y = toCell.center.y
            }, completion: { finished in
                
                // NOW CHECK FOR A WINNER
                let rank = self.determineRank()
                
                if rank == 1000000 {
                    self.presentWinAlert("Red Wins!")
                } else if rank == -1000000 {
                    self.presentWinAlert("Black Wins!")
                } else if self.checkForStalemate() {
                    self.presentWinAlert("Tie")
                } else {
                    self.updatePlayerTurn(isRed: !self.redTurn)
                    
                    if GameInfo.numPlayers == 1 && !self.redTurn {
                        self.comPlayer()
                    }
                }
        })
    }
    
    //==================================================
    // Create a new chip with image name, at the
    // specified place (redBox or blackBox)
    //==================================================
    func createNewChip(place: CGPoint, color: String) -> Chip {
        let newChip = Chip(center: place, color: color)
        background.addSubview(newChip)
        background.sendSubview(toBack: newChip)
        return newChip
    }
    
    //==================================================
    // Handles switching from red to black
    // or the other way around
    //==================================================
    func updatePlayerTurn(isRed: Bool) {
        redTurn = isRed
        
        if redTurn {
            currentChip = createNewChip(place: chipBox.center, color: chipStr[0])
        } else {
            currentChip = createNewChip(place: chipBox.center, color: chipStr[1])
        }
        currentChipIsMovable = false
    }
    
    //==================================================
    // Resets the board
    //==================================================
    @IBAction func reset(_ sender: Any) {
        for row in board {
            for cell in row {
                cell.isEmpty = true
                cell.chipReference?.removeFromSuperview()
                cell.chipReference = nil
            }
        }
        
        currentChip?.removeFromSuperview()
        updatePlayerTurn(isRed: true)
        //self.viewDidLoad()
    }

    // THE FOLLOWING DEALS WITH WINNING
    
    //==================================================
    // Determines the "rank" of the board:
    // higher ranking is in favor of red, 
    // lower ranking is in favor or black
    //==================================================
    func determineRank() -> Int {
        
        var boardRanking = 0
        evaluateBoard()

        var mult = 1
        
        for rb in boardFeatures {
            for feat in 0..<rb.count {
                for str in rb[feat] {
                    let repeats = occurancesWithin(mainString: boardStr, lookUp: str)
                    if feat == 0 && repeats > 0 {
                        return 1000000 * mult
                    } else if feat == 1 {
                        boardRanking += repeats * 1000 * mult
                    } else {
                        boardRanking += repeats * 10 * mult
                    }
                }
            }
            mult = -1
        }
        
        return boardRanking
    }
    
    //==================================================
    // Checks if the board is in a stalement
    //==================================================
    func checkForStalemate() -> Bool {
        for row in board {
            for cell in row {
                if cell.isEmpty { return false }
            }
        }
        return true
    }
    
    //==================================================
    // Handles the winning alert
    //==================================================
    func presentWinAlert(_ winner: String) {
        let alert = UIAlertController(title: winner, message: nil,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Reset", style: .default) {
            (action) -> Void in self.reset(self)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    //==================================================
    // Evaluates the board:
    // Tests for 4-in-a-row, 3-in-a-row, and
    // 2-in-a-row horizontally, vertically, and
    // diagonally
    //==================================================
    func evaluateBoard() {
        
        boardStr = "-"
        
        // HORIZONTAL
        for row in board {
            for cell in row {
                addCell(cell: cell)
            }
            addCell(cell: nil)
        }
        
        // VERTICAL
        for index in 0...6 {
            for row in board {
                addCell(cell: row[index])
            }
            addCell(cell: nil)
        }
        
        // MAIN DIAGONAL
        for i in [[3,0,3], [4,0,4], [5,0,5], [5,1,5], [5,2,4], [5,3,3]] {
            for ctr in 0...i[2] {
                addCell(cell: board[i[0] - ctr][i[1] + ctr])
            }
            addCell(cell: nil)
        }
        
        // MINOR DIAGONAL
        for i in [[2,0,3], [1,0,4], [0,0,5], [0,1,5], [0,2,4], [0,3,3]] {
            for ctr in 0...i[2] {
                addCell(cell: board[i[0] + ctr][i[1] + ctr])
            }
            addCell(cell: nil)
        }
    }
    
    //==================================================
    // Adds a cell to the board string:
    // Either add an 'r', 'b', 'o', '-', if it's
    // red, black, open, or the end
    //==================================================
    func addCell(cell: Cell?) {
        if cell == nil {
            boardStr += "-"
        } else if cell!.isEmpty {
            boardStr += "o"
        } else {
            boardStr += cell!.chipReference!.colorStr
        }
    }
    
    //==================================================
    // Returns how many occurances of lookUp
    // are in mainString
    //==================================================
    func occurancesWithin(mainString: String, lookUp: String) -> Int {
        var main = mainString
        var range = main.range(of: lookUp) //main.rangeOfString(lookUp)
        var ctr = 0
        
        while range != nil {
            ctr += 1
            main = String(main[range!.upperBound...])
            range = main.range(of: lookUp)
        }
        
        return ctr
    }
    
    // THE FOLLOWING DEALS WITH A COMPUTER PLAYER
    
    //==================================================
    // Handle's the computer player's move
    //==================================================
    func comPlayer() {
        if GameInfo.levelIndex > 0 {
            // LEVEL ONE/TWO: Based on the board evaluation
            let nextStepIndex = bestNextMoveFor(color: "b", position: GameInfo.levelIndex)[0]
            let _ = fallDown(col: nextStepIndex, makeMove: true)
        } else {
            // LEVEL ZERO: pick a random column
            var column : Int!
            repeat {
                column = Int(arc4random_uniform(UInt32(board.count)))
            } while fallDown(col: column, makeMove: true) == -1 && column < board.count
        }
    }
    
    //==================================================
    // Handles the animation from the box to the 
    // to the dropLabel
    //==================================================
    func animateToDrop(dropIndex: Int, toCell: Cell) {
        UIView.animate(withDuration: 0.5, animations: {
            self.currentChip?.center = self.dropLabels[dropIndex].center
            }, completion: { finished in
                self.animateDownwards(toCell: toCell)
        })
    }
    
    //==================================================
    // Computer Player's strategy:
    // temporarily place the computer player's chip
    // into the column specified and return a value 
    // based on how good that move was
    //==================================================
    func testFakeChip(color: String, col: Int, level: Int) -> Int? {
        
        let row = fallDown(col: col, makeMove: false)
        
        if row != -1 {
            // temporarily give board[row][col] a chip that is
            // detected by the code, but not the UI
            let newChip = Chip()
            newChip.colorStr = color
            board[row][col].chipReference = newChip
            board[row][col].isEmpty = false
            
            // Instantiate a ranking variable
            var ranking = determineRank()
            
            // if level > 2 (and i don't have a winning
            // move), test 7 more "chips"
            if level > 1 && ranking != -1000000 && ranking != 1000000 {
                ranking = bestNextMoveFor(color: chipStr[level % 2], position: level - 1)[1]
            }
            
            // finally, remove the temporary chip and return the ranking
            board[row][col].isEmpty = true
            board[row][col].chipReference = nil
            
            return ranking
        }
        return nil
    }
    
    //==================================================
    // Returns the best next move for a
    // given color, color
    //==================================================
    func bestNextMoveFor(color: String, position: Int) -> [Int] {
        var num = 1, mult = -1
        
        if color == "r" {
            num = 0
            mult = 1
        }
        
        var index = 3
        var rankAtIndex = testFakeChip(color: chipStr[num], col: 3, level: position)
        
        for i in 0..<dropLabels.count {
            let temp = testFakeChip(color: chipStr[num], col: i, level: position)
            if (temp != nil && rankAtIndex != nil && temp! * mult > rankAtIndex! * mult) || (rankAtIndex == nil) {
                rankAtIndex = temp
                index = i
            }
        }
        
        return [index, rankAtIndex!]
    }
    
}
