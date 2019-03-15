//
//  NewsFeedViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class NewsFeedViewController: UITableViewController {

    private let reuseIdentifier = "issueCell"
    
    //var viewModel: NewsFeedViewModel!
    
    private(set) var sharedIssue: Shared?
    var allIssues = [""]
    
    
    func loadIssues(){
        DataHandler.shared.fetchReportedIssues() { success, issues in
            if success {
                self.allIssues = issues
                for issue in self.allIssues {
                    DataHandler.shared.fetchReportedIssue(issueId: issue){ success, sharedIssues in
                        if success {
                            self.sharedIssue = sharedIssues
                            print("ahred", sharedIssues)
                        }
                        else{
                        }
                    }
                }
            }
        }
    }
    
    
    func issueForIndex(_ index: Int) -> Report? {
        return sharedIssue?.reports?[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIssues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set navigationbar layout, because otherwise childVC would override it
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shouldRemoveShadow(false)
        self.navigationController?.navigationBar.tintColor = .princetonOrange
        
    }
    
    private func setupIssues() {
        loadIssues()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedIssue?.reports?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? IssueTableViewCell else {
            print("IssueTableViewController > CellType doesn't match.")
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        }
        
        if let report = issueForIndex(indexPath.row) {
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
