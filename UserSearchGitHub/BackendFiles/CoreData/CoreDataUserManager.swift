//
//  CoreDataManager.swift
//  GitHubSearch
//
//  Created by Vinit Ingale on 31/05/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataUserManager {
    
    private init() {}
    static let shared = CoreDataUserManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func saveUserToLocalDB(userDict: [String: Any], isFollower: Bool, completion:(_ user: User?) -> Void) {
        
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            do {
                user.fillObject(userDict: userDict)
                user.isFollower = isFollower
                if isFollower == false {
                    try context.save()
                }
                completion(user)
            }
            catch {
                completion(nil)
            }
        }
    }
    
    func getAllUsersFromDB() -> [User] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "fecthed_at", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "isFollower == %@", NSNumber(value: false))
        do{
            if let users = try context.fetch(fetchRequest) as? [User] {
                return users
            }
        }
        catch  {
            print("Error")
        }
        return []
    }
}

