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
}
