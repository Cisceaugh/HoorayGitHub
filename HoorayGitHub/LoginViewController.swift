//
//  LoginViewController.swift
//  HoorayGitHub
//
//  Created by Francisco Ragland Jr on 11/13/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

typealias LoginViewControllerCompletionHandler = () -> ()

class LoginViewController: UIViewController {
    
    var loginViewControllerCompletionHandler: LoginViewControllerCompletionHandler?

    @IBOutlet weak var loginButton: UIButton!
    
    class func identifier() -> String{
        return "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.cornerRadius = 4.0
    }
    
    func processOauthRequest() {
        if let loginViewControllerCompletionHandler = self.loginViewControllerCompletionHandler {
            loginViewControllerCompletionHandler()
        }
    }
    
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        NSOperationQueue().addOperationWithBlock { () -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                GithubOAuth.shared.oAuthRequestWith(["scope":"email,user,repo"])
            })
        }
    }
    
}