//
//  GameViewController.swift
//  PushTheButton
//
//  Created by Nychka, Tyler on 1/21/17.
//  Copyright © 2017 Nychka, Tyler. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Alamofire

class GameViewController: UIViewController, GameSceneDelegate, GameOverViewControllerDelegate, MainMenuGameViewControllerDelegate {
    
    var button: PushButtonSprite?
    var gameScene: GameScene?
    var tick: Timer?
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeGame()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showMainMenu() {
        let mainMenu = MainMenuGameViewController()
        mainMenu.delegate = self
        self.present(mainMenu, animated: false, completion: nil)
    }
    
    func valueRelativeToHappy() -> Int {
        if (getHappy() <= 10) {
            return 1
        } else if (getHappy() <= 20) {
            return 1
        } else if (getHappy() <= 30) {
            return 1
        } else if (getHappy() <= 50) {
            return 2
        } else {
            return 3
        }
    }
   
    func updateButton() {
        if let button = button {
            button.happy -= 1
        }
        if (getHappy() <= 0){
            button?.faceLabel.text = "X("
            didEnd()
        } else if (getHappy() <= 10) {
            button?.faceLabel.text = ":'("
            score += valueRelativeToHappy()
        } else if (getHappy() <= 20) {
            button?.faceLabel.text = ":("
            score += valueRelativeToHappy()
        } else if (getHappy() <= 30) {
            button?.faceLabel.text = ":|"
            score += valueRelativeToHappy()
        } else if (getHappy() <= 50) {
            button?.faceLabel.text = ":)"
            score += valueRelativeToHappy()
        } else {
            button?.faceLabel.text = ":D"
            score += valueRelativeToHappy()
        }
    }
    
    func didEnd() {
        tick?.invalidate()
        tick = nil
        let gameOver = GameOverViewController()
        gameOver.delegate = self
        self.present(gameOver, animated: true, completion: {
            self.gameScene?.removeAllChildren()
            self.gameScene = nil
            self.score = 0
            self.button = nil
        })
    }
    
    var firstStart: Bool = true
    func initializeGame() {
        if (firstStart) {
            firstStart = false
            showMainMenu()
        }
    }
    
    func didRestart() {
        self.gameScene = nil
        score = 0
        let width = view.bounds.width/2
        let height = view.bounds.height/4
        let center = view.center
        button = PushButtonSprite(rectOf: CGSize(width: width, height: height), location: CGPoint(x: center.x - width/2,y: center.y - height/2), cornerRadius: 10, fillColor: UIColor.red)
        if let scene = GKScene(fileNamed: "GameScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                gameScene = sceneNode
                sceneNode.size = view.bounds.size
                sceneNode.scaleMode = .aspectFill
                sceneNode.gameSceneDelegate = self
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                }
            }
        }
        tick = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateButton), userInfo: nil, repeats: true)
    }
    
    func didTap() -> Int {
        button!.happy += valueRelativeToHappy()
        score += valueRelativeToHappy()
        return valueRelativeToHappy()
    }
    
    func getHappy() -> Int {
        if let button = button {
            return button.happy
        } else {
            return 0
        }
    }
    
    func getButton() -> PushButtonSprite {
        return button!
    }
    
    func getScore() -> Int {
        return score
    }
}
