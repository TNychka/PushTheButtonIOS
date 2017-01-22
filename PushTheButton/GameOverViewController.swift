//
//  GameOverViewController.swift
//  PushTheButton
//
//  Created by Nychka, Tyler on 1/22/17.
//  Copyright © 2017 Nychka, Tyler. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameOverViewControllerDelegate {
    func didRestart()
    func getScore() -> Int
}

class GameOverViewController: UIViewController {
    var delegate: GameOverViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            let restartLabel = UILabel()
            let scoreLabel = UILabel()
            let restartButton = UIButton()

            restartLabel.text = "Your button died..."
            restartLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            restartLabel.textColor = UIColor.white
            restartLabel.textAlignment = .center
            restartLabel.frame = CGRect(x: weakSelf.view.bounds.width/2 - 150 ,y: weakSelf.view.bounds.height/2,width: 300,height: 100)
            
            scoreLabel.text = "Final Score: \(self.delegate!.getScore())"
            scoreLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
            scoreLabel.textColor = UIColor.white
            scoreLabel.textAlignment = .center
            scoreLabel.frame = CGRect(x: weakSelf.view.bounds.width/2 - 150 ,y: weakSelf.view.bounds.height/2 + 30,width: 300,height: 100)
            
            restartButton.frame = CGRect(x: weakSelf.view.bounds.width/2 - 50 ,y: weakSelf.view.bounds.height - 120, width: 100, height: 50)
            restartButton.setTitle("Try again", for: .normal)
            restartButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
            restartButton.backgroundColor = .red
            restartButton.layer.cornerRadius = 5
            restartButton.addTarget(weakSelf, action: #selector(GameOverViewController.buttonPressed(_:)), for: UIControlEvents.touchUpInside)
            
            weakSelf.view.addSubview(restartButton)
            weakSelf.view.addSubview(restartLabel)
            weakSelf.view.addSubview(scoreLabel)

            weakSelf.view.backgroundColor = UIColor.black
        }
    }
    
    func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.didRestart()
        })
        
    }
}
