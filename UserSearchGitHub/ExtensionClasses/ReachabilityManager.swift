//
//  ReachabilityManager.swift
//  GitHubUserSearch
//
//  Created by Vinit Ingale on 01/06/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager {
    
    private init() {}
    static let shared = ReachabilityManager()
    
    let reachability = Reachability()!
    
    func isReachable() -> Bool{
        return reachability.connection != .none ? true : false
    }
}
