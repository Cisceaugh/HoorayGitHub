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
    
    var githubClientId = "78037d39e69c701846d5"
    var githubClientSecret = "f334e8f2cd8634eb7423619af6007a2746a6900b"
    
    static let shared = GithubOAuth()
    
    func oAuthRequestWith(parameters: [String:String]) {
        
        var parametersString = String()
        for parameter in parameters.values {
            parametersString = parametersString.stringByAppendingString(parameter)
        }
        
        print("\(kOAuthBaseURLString)authorize?client_id=\(self.githubClientId)&scope=\(parametersString)")
        
        if let requestUrl = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(self.githubClientId)&scope=\(parametersString)") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GithubOAuthCompletion) {
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(self.githubClientId)&client_secret=\(self.githubClientSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString) {
                
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
                    
                    if let _ = error {
                        completion(success: false); return
                    }
                    if let data = data {
                        if let tokenString = self.stringWith(data) {
                            
                            do {
                                let token = try self.accessTokenFromString(tokenString)!
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: self.saveAccessTokenToUserDefaults(token))
                                })
                            } catch _ {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: false)
                                })
                            }
                            
                        }
                    }
                }).resume()
            }
        } catch _ {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(success: false)
            })
        }
    }
    
    func accessToken()throws -> String {
        
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
            throw GithubOAuthError.MissingAccessToken("No token saved")
            
        }
        
        return accessToken
    }
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw GithubOAuthError.ExtractingTemporaryCode("Error extracting temporary code")
        }
        
        return temporaryCode
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, string.characters.count))
            if matches.count > 0 {
                for (_, value) in matches.enumerate() {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
        } catch _ {
            throw GithubOAuthError.ExtractingTokenFromString("Could not get token")
        }
        
        return nil
    }
    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func stringWith(data: NSData) -> String? {
        let byteBuffer: UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        return String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
    }
 }
