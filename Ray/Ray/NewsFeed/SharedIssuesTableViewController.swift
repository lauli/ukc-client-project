//
//  SharedIssuesTableViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 15/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SharedIssuesTableViewController: UITableViewController {

    private let reuseIdentifier = "issueCell"
    

    @IBOutlet var tableview: UITableView!
    //var viewModel: NewsFeedViewModel!
    
    var i: Int = 0
    
//    private(set) var sharedIssue: Shared? {
//        didSet {
//            tableview.reloadData()
//        }
//    }
    
    var Issue = Shared()
    
    var allIssues = [""]
    var sharedIssue : [Shared] = []
    func issueForIndex(_ index: Int) -> Shared? {
        return sharedIssue[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataHandler.shared.fetchReportedIssues() { success, issues in
            if success {
                self.allIssues = issues
                for issue in self.allIssues {
                    DataHandler.shared.fetchReportedIssue(issueId: issue){ success, sharedIssues in
                        if success {
                            if sharedIssues != nil{
                                self.Issue = sharedIssues!
                                self.sharedIssue.append(self.Issue)
                                self.tableview.reloadData()
                            }
                        }
                        else{
                        }
                    }
                }
            }
        }
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
        return sharedIssue.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SharedIssueTableViewCell else {
            print("SharedIssueTableViewController > CellType doesn't match.")
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        }
        
        if let report = issueForIndex(indexPath.row) {
            cell.sharedIssue = report
        }
        
        return cell
    }

}
