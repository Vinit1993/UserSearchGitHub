//
//  UserSearchViewController.swift
//  GitHubSearch
//
//  Created by Vinit Ingale on 31/05/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserSearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultsTableView: UITableView!
    @IBOutlet var showHistoryButton: UIBarButtonItem!
    
    var activeUser: User?
    var cachedUsers: [User] = []
    var filteredUsers: [User] = []
    var showHistoryData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCachedUsersFromDB()
        showHistoryButton.title = "Show History"
    }
    
    @IBAction func showHistoryButtonClicked(_ sender: UIBarButtonItem) {
        searchBar.text = nil
        activeUser = nil
        
        if showHistoryData == false {
            showHistoryData = true
            getCachedUsersFromDB()
            searchResultsTableView.separatorStyle = .singleLine
            showHistoryButton.title = "Hide History"
        } else {
            searchResultsTableView.separatorStyle = .none
            showHistoryData = false
            showHistoryButton.title = "Show History"
        }
        searchResultsTableView.reloadData()
    }
    
    func getCachedUsersFromDB() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.cachedUsers = CoreDataUserManager.shared.getAllUsersFromDB()
            strongSelf.filteredUsers = strongSelf.cachedUsers
            if strongSelf.showHistoryData == true {
                DispatchQueue.main.async {
                    strongSelf.searchResultsTableView.reloadData()
                }
            }
        }
    }
    
    func fectchUserDetailsFromGitHub(text: String) {
        if ReachabilityManager.shared.isReachable() == true {
            view.isUserInteractionEnabled = false
            SVProgressHUD.show(withStatus: "Fetching \(text)...")
            UserManagerAPI.shared.getUserDetails(name: text) { [weak self] (error, user) in
                guard let strongSelf = self else {
                    return
                }
                if error == nil {
                    strongSelf.activeUser = user
                    DispatchQueue.main.async {
                        strongSelf.view.isUserInteractionEnabled = true
                        SVProgressHUD.dismiss()
                        strongSelf.searchResultsTableView.reloadData()
                    }
                } else {
                    strongSelf.showAlert(message: error.debugDescription)
                }
            }
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
extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = showHistoryData == true ? filteredUsers.count : activeUser != nil ? 1 : 0
        if num == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Enter user name!!"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.font          = UIFont.systemFont(ofSize: 20)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        
        tableView.backgroundView  = nil
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchResultsUserCell", for: indexPath) as? UserDisplayTableViewCell else {
            fatalError("AddAttendeeTableViewCell not found.")
        }
        
        if showHistoryData == true {
            cell.setUpUserCell(user: filteredUsers[indexPath.row])
        } else {
            cell.setUpUserCell(user: activeUser!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showHistoryData == true {
             activeUser = filteredUsers[indexPath.row]
        }
        performSegue(withIdentifier: "toUserDetailsScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetailsScreen" {
            let destinationVC = segue.destination as! UserDetailsViewController
            destinationVC.activeUser = activeUser
        }
    }
}

// MARK:- UISearchBarDelegate
extension UserSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let trimmedText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), trimmedText.count > 0, showHistoryData == false {
            fectchUserDetailsFromGitHub(text: trimmedText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let trimmedText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased(), trimmedText.count > 0, showHistoryData == true {
            filteredUsers = cachedUsers.filter({ $0.userName.lowercased().contains(trimmedText) || $0.userLogin.lowercased().contains(trimmedText)})
            searchResultsTableView.reloadData()
        } else {
            filteredUsers = cachedUsers
            searchResultsTableView.reloadData()
        }
    }
}
