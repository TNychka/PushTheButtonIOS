//
//  GameViewController.swift
//  PushTheButton
//
//  Created by Nychka, Tyler on 1/21/17.
//  Copyright © 2017 Nychka, Tyler. All rights reserved.
//

import UIKit
import Alamofire
import GameplayKit
import Stormpath
import KeychainSwift



class MainMenuGameViewController: UIViewController {
    var keychain: KeychainSwift?
    var loginButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            keychain = KeychainSwift()
            let mainMenuLabel = UILabel()
            let startButton = UIButton()
            loginButton = UIButton()
            
            mainMenuLabel.text = "Push the Button!"
            mainMenuLabel.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            mainMenuLabel.textColor = UIColor.white
            mainMenuLabel.textAlignment = .center
            mainMenuLabel.frame = CGRect(x: weakSelf.view.bounds.width/2 - 150 ,y: weakSelf.view.bounds.height/2,width: 300,height: 100)
            
            startButton.frame = CGRect(x: weakSelf.view.bounds.width/2 - 50 ,y: weakSelf.view.bounds.height - 200, width: 100, height: 50)
            startButton.setTitle("Start Game", for: .normal)
            startButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
            startButton.backgroundColor = .red
            startButton.layer.cornerRadius = 5
            startButton.addTarget(weakSelf, action: #selector(MainMenuGameViewController.startGame(_:)), for: UIControlEvents.touchUpInside)
            
            loginButton!.frame = CGRect(x: weakSelf.view.bounds.width/2 - 50 ,y: startButton.frame.maxY + 20, width: 100, height: 50)
            loginButton!.setTitle("Login", for: .normal)
            loginButton!.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
            loginButton!.backgroundColor = .red
            loginButton!.layer.cornerRadius = 5
            loginButton!.addTarget(weakSelf, action: #selector(MainMenuGameViewController.login(_:)), for: UIControlEvents.touchUpInside)
            if(keychain!.getBool("isLoggedIn") == nil || !keychain!.getBool("isLoggedIn")!){
                weakSelf.view.addSubview(loginButton!)
            }
            weakSelf.view.addSubview(startButton)
            weakSelf.view.addSubview(mainMenuLabel)
            
            weakSelf.view.tintColor = UIColor.black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let loginButton = loginButton {
            if (keychain!.getBool("isLoggedIn") != nil && keychain!.getBool("isLoggedIn")!) {
                loginButton.removeFromSuperview()
            } else {
                self.view.addSubview(loginButton)
            }
        }
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
    
    func login(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: false)
    }
    
    func startGame(_ sender: UIButton) {
        let readyLabel = UILabel()
        readyLabel.text = "Get ready to push!"
        readyLabel.font = UIFont(name: "AvenirNext-Heavy", size: 30)
        readyLabel.textColor = UIColor.black
        readyLabel.textAlignment = .center
        readyLabel.frame = CGRect(x: self.view.bounds.width/2 - 150 ,y: self.view.bounds.height/2,width: 300,height: 100)
        
        let getReadyView = UIView()
        getReadyView.frame = CGRect(x: 0,y: 0,width: self.view.bounds.width, height: self.view.bounds.height)
        getReadyView.backgroundColor = UIColor.white
        getReadyView.addSubview(readyLabel)
        getReadyView.alpha = 0
        self.view.addSubview(getReadyView)
        
        UIView.animate(withDuration: 1, animations: {
            getReadyView.alpha = 1
        }, completion: { _ in
            let delay = Int(1 * Double(1000))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
                getReadyView.removeFromSuperview()
                self.navigationController?.pushViewController(GameViewController(), animated: false)
            }
        })
    }
}
