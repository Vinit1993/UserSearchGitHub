//
//  User.swift
//  GitHubSearch
//
//  Created by Vinit Ingale on 31/05/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import Foundation
import CoreData

class User : NSManagedObject {
    @NSManaged public var avatar_url: String?
    @NSManaged public var bio: String?
    @NSManaged public var email: String?
    @NSManaged public var followers: Int32
    @NSManaged public var company: String?
    @NSManaged public var followers_url: String?
    @NSManaged public var following: Int32
    @NSManaged public var following_url: String?
    @NSManaged public var html_url: String?
    @NSManaged public var location: String?
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var public_gists: Int32
    @NSManaged public var public_repos: Int32
    @NSManaged public var updated_at: String?
    @NSManaged public var fecthed_at: Date?
    @NSManaged public var isFollower: Bool
    
    
    func fillObject(userDict: [String: Any]) {
        avatar_url = userDict["avatar_url"] as? String
        bio = userDict["bio"] as? String
        email = userDict["email"] as? String
        company = userDict["company"] as? String
        followers = (userDict["followers"] as? Int32) ?? 0
        following = (userDict["following"] as? Int32) ?? 0
        location = userDict["location"] as? String
        login = userDict["login"] as? String
        name = userDict["name"] as? String
        public_gists = (userDict["public_gists"] as? Int32) ?? 0
        public_repos =  (userDict["public_repos"] as? Int32) ?? 0
        updated_at = userDict["updated_at"] as? String
        followers_url = userDict["followers_url"] as? String
        following_url = userDict["following_url"] as? String
        html_url = userDict["html_url"] as? String
        fecthed_at = Date()
    }
    
    var userName: String {
        return name ?? "Unknown"
    }
    
    var userBio: String {
        return bio ?? "No bio"
    }
    
    var userEmail: String {
        return email ?? "No email"
    }
    
    var userCompany: String {
        return company ?? "No company"
    }
    
    var userLocation: String {
        return location ?? "No location"
    }
    
    var userLogin: String {
        return login ?? "No login"
    }
    
    var userAllInfo: String {
        return userLogin + ", " + userBio + ", " + userCompany + ", " + userLocation + ", " + userEmail
    }
}
