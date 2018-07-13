//
//  MainViewController.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/23/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet var playerButtons: [UIButton]!
    @IBOutlet var levelButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pulseIn()
    }
    
    func pulseIn() {
        UIView.animate(withDuration: 2.0, animations: {
            self.welcomeLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (void) in
            self.pulseOut()
        }
    }
    
    func pulseOut() {
        UIView.animate(withDuration: 2.0, animations: {
            self.welcomeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (void) in
            self.pulseIn()
        }
    }
    
    @IBAction func onTappedPlayerNumber(_ sender: UIButton) {
        updateUI(onArr: playerButtons, selectedButton: sender)
        GameInfo.numPlayers = sender.tag
        
        for l in levelButtons {
            if GameInfo.numPlayers == 2 {
                l.setBackgroundImage(UIImage(named: "uptapped"), for: .normal)
                l.setTitleColor(.white, for: .normal)
            } else {
                updateUI(onArr: levelButtons, selectedButton: levelButtons[GameInfo.levelIndex])
            }
        }
    }
    
    @IBAction func onTappedLevel(_ sender: UIButton) {
        if GameInfo.numPlayers == 2 {
            onTappedPlayerNumber(playerButtons[0])
        }
        updateUI(onArr: levelButtons, selectedButton: sender)
        GameInfo.levelIndex = sender.tag
    }
    
    func updateUI(onArr: [UIButton], selectedButton: UIButton) {
        for button in onArr {
            button.setBackgroundImage(UIImage(named: "uptapped1"), for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
        
        selectedButton.setBackgroundImage(UIImage(named: "tapped1"), for: .normal)
        selectedButton.setTitleColor(.black, for: .normal)
    }
}
