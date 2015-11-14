//
//  API.swift
//  HoorayGitHub
//
//  Created by Francisco Ragland Jr on 11/13/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GithubOAuthCompletion = (success:Bool) -> ()

enum GithubOAuthError: ErrorType {
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporaryCode(String)
    case ResponseFromGithub(String)
}

enum SaveOptions: Int{
    case UserDefaults
}

class GithubOAuth {
    
    var githubClientId = "9b6bfd768b1b45b675fa"
    var githubClientSecret = "a525edcfb8ee9e5c07d3e2e9b4657c3592488442"
    
    static let shared = GithubOAuth()
    
    func oAuthRequestWith(parameters: [String:String]) {
        var parametersString = String()
        for parameter in parameters.values {
            parametersString = parametersString.stringByAppendingString(parameter)
        }
        
        if let requestUrl = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(self.githubClientId)&scope=\(parametersString)")
    }
}
