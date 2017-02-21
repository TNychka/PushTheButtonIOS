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
import KeychainSwift

class LoginViewController: UIViewController {
    
    var titleLabel: UILabel?
    var loginButton: UIButton?
    var signUpButton: UIButton?
    var userNameTextBox: UITextField?
    var passwordTextBox: UITextField?
    var keychain: KeychainSwift?
    
    var mgr: Alamofire.SessionManager!
    let cookies = HTTPCookieStorage.shared
    
    func configureManager() -> Alamofire.SessionManager {
        let cfg = URLSessionConfiguration.default
        cfg.httpCookieStorage = cookies
        return Alamofire.SessionManager(configuration: cfg)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain = KeychainSwift()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            titleLabel = UILabel()
            loginButton = UIButton()
            signUpButton = UIButton()
            userNameTextBox = UITextField()
            passwordTextBox = UITextField()
            
            titleLabel!.text = "Login or Sign up"
            titleLabel!.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            titleLabel!.textColor = UIColor.white
            titleLabel!.textAlignment = .center
            titleLabel!.lineBreakMode = .byWordWrapping
            titleLabel!.numberOfLines = 0
            titleLabel!.frame = CGRect(x: weakSelf.view.bounds.width/2 - 150 , y: weakSelf.view.bounds.height/2, width: 300, height: 50)
            
            loginButton!.frame = CGRect(x: weakSelf.view.bounds.width/2 - 50 ,y: weakSelf.view.bounds.height - 170, width: 100, height: 50)
            loginButton!.setTitle("Login", for: .normal)
            loginButton!.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
            loginButton!.backgroundColor = .red
            loginButton!.layer.cornerRadius = 5
            loginButton!.addTarget(weakSelf, action: #selector(LoginViewController.login(_:)), for: UIControlEvents.touchUpInside)
            
            signUpButton!.frame = CGRect(x: weakSelf.view.bounds.width/2 - 50 ,y: loginButton!.frame.maxY + 20, width: 100, height: 50)
            signUpButton!.setTitle("Sign Up", for: .normal)
            signUpButton!.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 15)
            signUpButton!.backgroundColor = .red
            signUpButton!.layer.cornerRadius = 5
            signUpButton!.addTarget(weakSelf, action: #selector(LoginViewController.signUp(_:)), for: UIControlEvents.touchUpInside)
            
            userNameTextBox!.frame = CGRect(x: 10, y: titleLabel!.frame.maxY +  20, width: weakSelf.view.bounds.width - 20, height: 50)
            userNameTextBox!.backgroundColor = UIColor.white
            userNameTextBox!.placeholder = "Username"
            
            passwordTextBox!.frame = CGRect(x: 10, y: userNameTextBox!.frame.maxY +  20, width: weakSelf.view.bounds.width - 20, height: 50)
            passwordTextBox!.backgroundColor = UIColor.white
            passwordTextBox!.isSecureTextEntry = true
            passwordTextBox!.placeholder = "Password"
            
            weakSelf.view.addSubview(titleLabel!)
            weakSelf.view.addSubview(loginButton!)
            weakSelf.view.addSubview(signUpButton!)
            weakSelf.view.tintColor = UIColor.black
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
        titleLabel!.text = "Login"
        loginButton!.frame = CGRect(x: loginButton!.frame.minX, y: passwordTextBox!.frame.maxY + 20, width: loginButton!.frame.width, height: loginButton!.frame.height)
        loginButton!.addTarget(self, action: #selector(LoginViewController.validate(_:)), for: UIControlEvents.touchUpInside)
        signUpButton!.removeFromSuperview()
        self.view.addSubview(userNameTextBox!)
        self.view.addSubview(passwordTextBox!)
    }
    
    func signUp(_ sender: UIButton) {
        titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 12)
        titleLabel!.text = "Sign up, only requires\nusername and password! You can also login"
        loginButton!.frame = CGRect(x: loginButton!.frame.minX, y: passwordTextBox!.frame.maxY + 20, width: loginButton!.frame.width, height: loginButton!.frame.height)
        loginButton!.addTarget(self, action: #selector(LoginViewController.validate(_:)), for: UIControlEvents.touchUpInside)
        signUpButton!.removeFromSuperview()
        self.view.addSubview(userNameTextBox!)
        self.view.addSubview(passwordTextBox!)
    }
    
    func validate(_ sender: UIButton) {
        if(userNameTextBox!.text != "" && passwordTextBox!.text != "") {
            let user = userNameTextBox!.text
            let pass = passwordTextBox!.text
            titleLabel!.font = UIFont(name: "AvenirNext-Heavy", size: 30)
            titleLabel!.text = "please wait"
            
            weak var weakSelf = self
            if let weakSelf = weakSelf {
                Stormpath.sharedSession.logout()
                Stormpath.sharedSession.login(user!+"@pushTheButton.com", password: pass!) { success, error in
                    guard error == nil else {
                        let newUser = RegistrationModel(email: user!+"@pushTheButton.com", password: pass!)
                        Stormpath.sharedSession.register(newUser)
                        Stormpath.sharedSession.login(user!+"@pushTheButton.com", password: pass!)
                        weakSelf.keychain?.set(true, forKey: "isLoggedIn")
                        Stormpath.sharedSession.refreshAccessToken()
                        weakSelf.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                    weakSelf.keychain?.set(true, forKey: "isLoggedIn")
                    Stormpath.sharedSession.refreshAccessToken()
                    weakSelf.navigationController?.popToRootViewController(animated: true)
                }
                
                //                Alamofire.request("https://fierce-savannah-51444.herokuapp.com/logout", method: .post, parameters: parameters).validate(statusCode: 200...299).responseJSON(completionHandler: { response in
                //                    Alamofire.request("https://fierce-savannah-51444.herokuapp.com/login", method: .post, parameters: parameters).validate(statusCode: 200...299).responseJSON(completionHandler: { response in
                //                        if (response.result.isSuccess) {
                //                            let JSON = response.result.value as! NSDictionary
                //                            weakSelf.keychain?.set(user!, forKey: "username")
                //                            weakSelf.keychain?.set(pass!, forKey: "password")
                //                            weakSelf.keychain?.set(true, forKey: "isLoggedIn")
                //                            let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.request!.allHTTPHeaderFields!, for: (response.request?.url!)!)
                //                            Alamofire.SessionManager.shared.session.configuration.HTTPCookieStorage?.setCookies(cookies, forURL: (response.request?.url!)!, mainDocumentURL: nil)
                //                            Alamofire.request("https://fierce-savannah-51444.herokuapp.com/oauth/token", method: .get).validate(statusCode: 200...299).responseJSON(completionHandler: { response in
                //                                print(response.data)
                //                            })
                //                            weakSelf.navigationController?.popToRootViewController(animated: true)
                //                        } else {
                //                            parameters = ["givenName": user!, "surname": user!, "email":user!+"@pushTheButton.com", "password":pass!]
                //                            Alamofire.request("https://fierce-savannah-51444.herokuapp.com/register", method: .post, parameters: parameters).validate(statusCode: 200...299).responseJSON(completionHandler: { response in
                //                                if(response.result.isSuccess){
                //                                    weakSelf.keychain?.set(user!, forKey: "username")
                //                                    weakSelf.keychain?.set(pass!, forKey: "password")
                //                                    weakSelf.keychain?.set(true, forKey: "isLoggedIn")
                //                                    Alamofire.request("https://fierce-savannah-51444.herokuapp.com/oauth/token", method: .get).validate(statusCode: 200...299).responseJSON(completionHandler: { response in
                //                                        print(response.data)
                //                                    })
                //                                    weakSelf.navigationController?.popToRootViewController(animated: true)
                //                                } else {
                //                                    weakSelf.titleLabel?.text = "No account found and error registering, please ensure password is 8 chars, contains a capital and a number"
                //
                //                                    weakSelf.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 12)
                //
                //                                }
                //                            })
                //                        }
                //                    })
                //                })
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
