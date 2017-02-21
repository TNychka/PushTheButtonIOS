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
            setHighScore(completion: {
                weakSelf.getHighScores(completion: { returnVal in
                    weakSelf.highScoreLabel!.text = returnVal
                    weakSelf.highScoreLabel!.lineBreakMode = .byWordWrapping
                    weakSelf.highScoreLabel!.numberOfLines = 0
                    weakSelf.highScoreLabel!.font = UIFont(name: "AvenirNext-Heavy", size: 20)
                    weakSelf.highScoreLabel!.frame = CGRect(x: 0,y: 10, width: weakSelf.view.bounds.width, height: 200)
                    weakSelf.highScoreLabel!.textColor = UIColor.white
                    weakSelf.highScoreLabel!.textAlignment = .center
                    
                    restartLabel.text = "Your button died..."
                    restartLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
                    restartLabel.textColor = UIColor.white
                    restartLabel.textAlignment = .center
                    restartLabel.frame = CGRect(x: 0,y: weakSelf.highScoreLabel!.frame.maxY, width: weakSelf.view.bounds.width,height: 30)
                    
                    scoreLabel.text = "Final Score: \(self.delegate!.getScore())"
                    scoreLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
                    scoreLabel.textColor = UIColor.white
                    scoreLabel.textAlignment = .center
                    scoreLabel.frame = CGRect(x: 0,y: restartLabel.frame.maxY,width: weakSelf.view.bounds.width,height: 100)
                    
                    restartButton.frame = CGRect(x: weakSelf.view.bounds.width/2 - 100 ,y: weakSelf.view.bounds.width - 60, width: 200, height: 50)
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
            })
        }
    }
    
    func setHighScore(completion: @escaping ()->()) {
        let parameters: Parameters = ["score":delegate!.getScore()]
        if (Stormpath.sharedSession.accessToken == nil || Stormpath.sharedSession.accessToken == "") {
            print(Stormpath.sharedSession.me)
            Stormpath.sharedSession.refreshAccessToken() {success, error in
                if (success) {
                    let accessToken = Stormpath.sharedSession.accessToken
                    let headers = ["Authorization": "Bearer " + accessToken!]
                    Alamofire.request("https://fierce-savannah-51444.herokuapp.com/game/setNewScore", method: .post, parameters: parameters, headers: headers).validate(statusCode: 200...299).response(completionHandler: { response in
                    })
                }
                completion()
            }
        } else {
            let accessToken = Stormpath.sharedSession.accessToken
            let headers = ["Authorization": "Bearer " + accessToken!]
            Alamofire.request("https://fierce-savannah-51444.herokuapp.com/game/setNewScore", method: .post, parameters: parameters, headers: headers).validate(statusCode: 200...299).response(completionHandler: { response in
                completion()
            })
        }
    }
    
    func getHighScores(completion: @escaping (String)->()) {
        var highScores = ""
        let accessToken = Stormpath.sharedSession.accessToken ?? ""
        let headers = ["Authorization": "Bearer " + accessToken]
        Alamofire.request("https://fierce-savannah-51444.herokuapp.com/game/getLeaderBoard", method: .get,  headers: headers).validate(statusCode: 200...299).responseJSON(completionHandler: { response in
            if (response.result.isSuccess) {
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    highScores = ""
                    var i = 0
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
            }
            completion(highScores)
        })
    }
    
    func buttonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true);
    }
}
