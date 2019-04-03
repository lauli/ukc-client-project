//
//  ProfileViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 13.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//
import UIKit
import Firebase

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var pathLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var contributorsLabel: UILabel!
    
    @IBOutlet private weak var contributorContainer: UIView!
    
    @IBAction func LogoutButton(_ sender: Any) {
        do {
            print ("Signed Out")
            UserDefaults.standard.removeObject(forKey: "userID")
            try Auth.auth().signOut()
            performSegue(withIdentifier: "LogoutSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if viewModel == nil {
            viewModel = ProfileViewModel()
        }
        
        if let tableViewController = segue.destination as? IssueTableViewController {
            tableViewController.viewModel = viewModel
            
        } else if let userViewController = segue.destination as? UserViewController {
            userViewController.viewModel = viewModel
        }
    }
    
    // MARK: - Private Custom
    // MARK: Layout
    
    private func setupLayout() {
        updateLabels()
        showLabels(true)
    }
    
    private func showLabels(_ visible: Bool) {
        nameLabel.isHidden = !visible
        pathLabel.isHidden = !visible
        descriptionLabel.isHidden = !visible
        contributorsLabel.isHidden = !visible
    }
    
    // MARK: Information
    
    private func updateLabels() {
        guard let viewModel = viewModel else {
            print("RepoDetailViewController > ViewModel is nil.")
            return
        }
        
        nameLabel.text = viewModel.nameText()
        nameLabel.adjustsFontSizeToFitWidth = true
        
        pathLabel.text = viewModel.contactDetailsText()
        pathLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.text = viewModel.savedLocationsText()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
}
