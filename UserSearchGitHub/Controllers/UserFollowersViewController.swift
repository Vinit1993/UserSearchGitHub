//
//  UserFollowersViewController.swift
//  GitHubUserSearch
//
//  Created by Vinit Ingale on 01/06/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserFollowersViewController: UIViewController {

    @IBOutlet weak var followersTableView: UITableView!
    
    var isFollowersShown: Bool?
    var activeUser: User?

    var usersArray: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = isFollowersShown == true ? "Followers" : "Following"
        fectchUserFollowersDetailsFromGitHub()
    }
    
    func fectchUserFollowersDetailsFromGitHub() {
        
        if ReachabilityManager.shared.isReachable() == true {
            
            view.isUserInteractionEnabled = false
            SVProgressHUD.show(withStatus: "Fetching \(activeUser?.userName ?? "") details...")
            let url = isFollowersShown == true ? activeUser?.followers_url : activeUser?.followers_url?.replacingOccurrences(of: "followers", with: "following")
            
            UserManagerAPI.shared.getUserFollowersDetails(url: url!, completion: { [weak self] (error, users) in
                guard let strongSelf = self else {
                    return
                }
                if error == nil {
                    strongSelf.usersArray = users
                    DispatchQueue.main.async {
                        strongSelf.view.isUserInteractionEnabled = true
                        SVProgressHUD.dismiss()
                        strongSelf.followersTableView.reloadData()
                    }
                } else {
                    strongSelf.showAlert(message: error.debugDescription)
                }
            })
        } else {
            showAlert(message: "No internet connection.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "GitHub", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension UserFollowersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if usersArray.count == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = isFollowersShown == true ? "No followers" : "No Following"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.font          = UIFont.systemFont(ofSize: 20)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        
        tableView.backgroundView  = nil
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = followersTableView.dequeueReusableCell(withIdentifier: "searchResultsUserCell", for: indexPath) as? UserDisplayTableViewCell else {
            fatalError("AddAttendeeTableViewCell not found.")
        }
        cell.setUpUserCell(user: usersArray[indexPath.row])
        return cell
    }
}

