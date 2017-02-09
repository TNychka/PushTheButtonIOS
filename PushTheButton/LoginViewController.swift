//
//  GameViewController.swift
//  PushTheButton
//
//  Created by Nychka, Tyler on 1/21/17.
//  Copyright © 2017 Nychka, Tyler. All rights reserved.
//

import UIKit
import Alamofire
import Stormpath

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            let titleLabel = UILabel()
            let loginButton = UIButton()
            
            titleLabel.text = "Login or Sign up"
            titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            titleLabel.textColor = UIColor.white
            titleLabel.textAlignment = .center
            titleLabel.frame = CGRect(x: weakSelf.view.bounds.width/2 - 150 ,y: weakSelf.view.bounds.height/2,width: 300,height: 100)
            
            loginButton.frame = CGRect(x: weakSelf.view.bounds.width/2 - 50 ,y: weakSelf.view.bounds.height - 100, width: 100, height: 50)
            loginButton.setTitle("Login", for: .normal)
            loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
            loginButton.backgroundColor = .red
            loginButton.layer.cornerRadius = 5
            loginButton.addTarget(weakSelf, action: #selector(LoginViewController.login(_:)), for: UIControlEvents.touchUpInside)
            
            weakSelf.view.addSubview(titleLabel)
            weakSelf.view.addSubview(loginButton)
            weakSelf.view.tintColor = UIColor.black
        }
    }
    
    func login(_ sender: UIButton) {

    
    }
}
