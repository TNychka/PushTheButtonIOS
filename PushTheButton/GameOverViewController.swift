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
import Alamofire
import KeychainSwift
import Stormpath

protocol GameOverViewControllerDelegate {
    func getScore() -> Int
}

class GameOverViewController: UIViewController {
    var delegate: GameOverViewControllerDelegate?
    var highScoreLabel: UILabel?
    var keychain: KeychainSwift?
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain = KeychainSwift()
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            let restartLabel = UILabel()
            let scoreLabel = UILabel()
            let restartButton = UIButton()
            highScoreLabel = UILabel()
            weakSelf.setHighScore(completion: { returnVal in
                
                restartLabel.text = "Your button died..."
                restartLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
                restartLabel.textColor = UIColor.white
                restartLabel.textAlignment = .center
                restartLabel.frame = CGRect(x: 0,y: 10, width: weakSelf.view.bounds.width,height: 30)
                
                scoreLabel.text = "Final Score: \(self.delegate!.getScore())"
                scoreLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
                scoreLabel.textColor = UIColor.white
                scoreLabel.textAlignment = .center
                scoreLabel.frame = CGRect(x: 0,y: restartLabel.frame.maxY + 10,width: weakSelf.view.bounds.width,height: 100)
                
                weakSelf.highScoreLabel!.text = weakSelf.praseHighScores(input: returnVal)
                weakSelf.highScoreLabel!.lineBreakMode = .byWordWrapping
                weakSelf.highScoreLabel!.numberOfLines = 0
                weakSelf.highScoreLabel!.font = UIFont(name: "AvenirNext-Heavy", size: 20)
                weakSelf.highScoreLabel!.frame = CGRect(x: 0,y: scoreLabel.frame.maxY + 10, width: weakSelf.view.bounds.width, height: 200)
                weakSelf.highScoreLabel!.textColor = UIColor.white
                weakSelf.highScoreLabel!.textAlignment = .center
                
                restartButton.frame = CGRect(x: weakSelf.view.bounds.width/2 - 100 , y: weakSelf.view.bounds.width - 20, width: 200, height: 50)
                restartButton.setTitle("I'll do better next time!", for: .normal)
                restartButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
                restartButton.backgroundColor = .red
                restartButton.layer.cornerRadius = 5
                restartButton.addTarget(weakSelf, action: #selector(GameOverViewController.buttonPressed(_:)), for: UIControlEvents.touchUpInside)
                
                weakSelf.view.addSubview(restartButton)
                weakSelf.view.addSubview(restartLabel)
                weakSelf.view.addSubview(scoreLabel)
                weakSelf.view.addSubview(weakSelf.highScoreLabel!)
                
                weakSelf.view.backgroundColor = UIColor.black
            })
        }
    }
    
    func setHighScore(completion: @escaping (Any)->()) {
        let parameters: Parameters = ["score":delegate!.getScore()]
        if (Stormpath.sharedSession.accessToken == nil || Stormpath.sharedSession.accessToken == "") {
            print(Stormpath.sharedSession.me())
            Stormpath.sharedSession.refreshAccessToken() {success, error in
                if (success) {
                    let accessToken = Stormpath.sharedSession.accessToken
                    let headers = ["Authorization": "Bearer " + accessToken!]
                    Alamofire.request("https://fierce-savannah-51444.herokuapp.com/game/setNewScore", method: .post, parameters: parameters, headers: headers).validate(statusCode: 200...299).responseString(completionHandler: { response in
                        if let json = response.result.value {
                            completion(json)
                        }
                    })
                } else {
                    completion("")
                }
            }
        } else {
            let accessToken = Stormpath.sharedSession.accessToken
            let headers = ["Authorization": "Bearer " + accessToken!]
            //"https://fierce-savannah-51444.herokuapp.com/game/setNewScore"
            Alamofire.request("http://localhost:8080/game/setNewScore", method: .post, parameters: parameters, headers: headers).validate(statusCode: 200...299).responseString(completionHandler: { response in
                if let json = response.result.value {
                    completion(json)
                } else {
                    completion("")
                }
            })
        }
    }
    
    func praseHighScores(input: Any) -> String {
        var highScores = ""
        let JSON = input as? NSDictionary
        var i = 0
        if let JSON = JSON {
            while (JSON[String(i)] != nil) {
                switch(i) {
                case 0:
                    highScores = highScores + "1st: " + String(describing: JSON[String(i)])
                    break;
                case 1:
                    highScores = highScores + "2nd: " + String(describing: JSON[String(i)])
                    break;
                case 2:
                    highScores = highScores + "3rd: " + String(describing: JSON[String(i)])
                    break;
                default:
                    highScores = highScores + String(i) + "th: " + String(describing: JSON[String(i)])
                    break;
                }
                i = i + 1
            }
        }
        return highScores
    }
    
    func buttonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true);
    }
}
