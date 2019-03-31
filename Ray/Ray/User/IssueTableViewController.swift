//
//  IssueTableViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 13.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//
import UIKit

final class IssueTableViewController: UITableViewController {
    
    private let reuseIdentifier = "issueCell"
    
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // set navigationbar layout, because otherwise childVC would override it
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shouldRemoveShadow(false)
        self.navigationController?.navigationBar.tintColor = .princetonOrange
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.user?.reports?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? IssueTableViewCell else {
            print("IssueTableViewController > CellType doesn't match.")
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        }
        
        if let report = viewModel.issueForIndex(indexPath.row) {
            cell.report = report
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set back button to "Cancel" for Edit VC
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
    }
    
}
