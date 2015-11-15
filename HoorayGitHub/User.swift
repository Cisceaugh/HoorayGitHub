//
//  User.swift
//  HoorayGitHub
//
//  Created by Francisco Ragland Jr on 11/13/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var profileImageUrl: String
    
    init(name: String, profileImageUrl: String){
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
}