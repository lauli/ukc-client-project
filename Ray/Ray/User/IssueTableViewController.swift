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
    var titleText: String?
    var locationText: String?
    var dateText: String?
    var monthText: String?
    var viewedText: String?
    var descriptionText: String?
    var attachment1Url: String?
    var attachment2Url: String?
    var attachment3Url: String?
    var attachment4Url: String?
    var viewed: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero) // set footer so that empty cells aren't shown
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! IssueTableViewCell
        
        titleText = currentCell.titleLabel.text
        locationText = currentCell.locationText
        dateText = currentCell.dayLabel.text
        monthText = currentCell.monthLabel.text
        viewedText = currentCell.viewedText
        descriptionText = currentCell.descriptionText
        attachment1Url = currentCell.attachment1Url
        attachment2Url = currentCell.attachment2Url
        attachment3Url = currentCell.attachment3Url
        attachment4Url = currentCell.attachment4Url
        
        performSegue(withIdentifier: "issueDetail", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set back button to "Cancel" for Edit VC
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
        
        if (segue.identifier == "issueDetail") {
            
            let vc = segue.destination as? SharedIssueDetailViewController
            vc?.date = dateText
            vc?.month = monthText
            vc?.viewed = viewedText
            vc?.titleText = titleText
            vc?.descriptionText = descriptionText
            vc?.location = locationText
            vc?.attachment1Text = attachment1Url
            vc?.attachment2Text = attachment2Url
            vc?.attachment3Text = attachment3Url
            vc?.attachment4Text = attachment4Url
        }
    }
    
}
