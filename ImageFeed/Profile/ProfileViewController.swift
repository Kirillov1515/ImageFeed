//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Macbook on 11.02.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: - IBActions
    @IBAction func didTapLogoutButton(_ sender: Any) {}
}
