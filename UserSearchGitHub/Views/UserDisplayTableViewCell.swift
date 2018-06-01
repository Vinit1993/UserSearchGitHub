//
//  UserDisplayTableViewCell.swift
//  GitHubSearch
//
//  Created by Vinit Ingale on 31/05/18.
//  Copyright © 2018 Vinit Ingale. All rights reserved.
//

import UIKit

protocol UserDisplayTableViewCellProtocol {
    func shareUserDetails(_ message: String)
    func navigateIndication(view : ButtonTags)
}

enum ButtonTags: Int {
    case followers = 0
    case following = 1
}

class UserDisplayTableViewCell: UITableViewCell {

    @IBOutlet var allInfoLabel: UILabel?
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var organizationNameLabel: UILabel?
    @IBOutlet weak var gitNameLabel: UILabel?
    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var emailLabel: UILabel?
    @IBOutlet weak var reposCountLabel: AnimatedLabel?
    @IBOutlet weak var followingCountLabel: AnimatedLabel?
    @IBOutlet weak var gistsCountLabel: AnimatedLabel?
    @IBOutlet weak var followersLabel: AnimatedLabel?
    @IBOutlet weak var lastUpdated: UILabel?
    @IBOutlet weak var followingButton: UIButton?
    @IBOutlet weak var followersButton: UIButton?
    @IBOutlet weak var shareButton: UIButton?
    
    var cellUser: User?
    var delegate: UserDisplayTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.size.height)! / 2
        followingButton?.layer.cornerRadius = (followingButton?.frame.size.height)! / 2
        followersButton?.layer.cornerRadius = (followersButton?.frame.size.height)! / 2
    }
    
    func setUpUserCell(user : User) {
        cellUser = user
        
        if let avatarURL = user.avatar_url  {
            avatarImageView?.imageFromServerURL(urlString: avatarURL)
        } else {
            avatarImageView?.setImage(string: user.name, color: UIColor.darkGray, circular: false, textAttributes: [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        }
        
        nameLabel?.text = user.userName
        organizationNameLabel?.text = user.userCompany
        gitNameLabel?.text = user.userLogin
        cityLabel?.text = user.userLocation
        emailLabel?.text = user.userEmail
        allInfoLabel?.text = user.userAllInfo
        reposCountLabel?.count(from: 0.0, to: Float(user.public_repos), duration: 1.0)
        followingCountLabel?.count(from: 0.0, to: Float(user.following), duration: 1.0)
        followersLabel?.count(from: 0.0, to: Float(user.followers), duration: 1.0)
        gistsCountLabel?.count(from: 0.0, to: Float(user.public_gists), duration: 1.0)
        lastUpdated?.text = Helper.getLastUpdatedDateString(dateString: user.updated_at)
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        let message = "Hey! Check out \(cellUser?.login ?? "Unknown") on GitHub.\n\(cellUser?.html_url ?? "")"
        delegate?.shareUserDetails(message)
    }
    @IBAction func followButtonClicked(_ sender: UIButton) {
        if sender.tag == ButtonTags.followers.rawValue {
            delegate?.navigateIndication(view: .followers)
        } else {
            delegate?.navigateIndication(view: .following)
        }
    }
}
