//
//  UserDetailsViewController.swift
//  GitHubUserSearch
//
//  Created by Vinit Ingale on 31/05/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet var userDetailsTableView: UITableView!
    
    var activeUser: User?
    var isFollowersShown: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUser != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = userDetailsTableView.dequeueReusableCell(withIdentifier: "UserDisplayTableViewCell", for: indexPath) as? UserDisplayTableViewCell else {
            fatalError("AddAttendeeTableViewCell not found.")
        }
        cell.setUpUserCell(user: activeUser!)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK:- UserDisplayTableViewCellProtocol
extension UserDetailsViewController: UserDisplayTableViewCellProtocol {
    func shareUserDetails(_ message: String) {
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func navigateIndication(view: ButtonTags) {
        if view.rawValue == 0 {
            isFollowersShown = true
        } else {
            isFollowersShown = false
        }
        performSegue(withIdentifier: "toFollowersScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFollowersScreen" {
            let destinationVC = segue.destination as! UserFollowersViewController
            destinationVC.activeUser = activeUser
            destinationVC.isFollowersShown = isFollowersShown
        }
    }
}



