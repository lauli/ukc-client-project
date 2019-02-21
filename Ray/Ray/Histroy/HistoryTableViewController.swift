//
//  HistoryTableViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 21.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    private let reuseIdentifier = "historyCell"
    private var datahandler: DataHandler!
    private var viewModel: ReportingViewModel! // TODO: make own VM

    override func viewDidLoad() {
        super.viewDidLoad()
        datahandler = DataHandler.shared
        viewModel = ReportingViewModel()
        setupPage()
        setupIssues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set navigationbar layout, because otherwise reportVC would override it
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shouldRemoveShadow(false)
        self.navigationController?.navigationBar.tintColor = .princetonOrange

    }

    private func setupPage() {
        navigationItem.title = "History"
        tabBarItem = UITabBarItem(title: "Report",
                                  image: UIImage.init(named: "icon-report-outline"),
                                  selectedImage: UIImage.init(named: "icon-report"))
    }
    
    private func setupIssues() {
        if viewModel.user == nil {
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if self.viewModel.user != nil {
                    self.tableView.reloadData()
                    timer.invalidate()
                }
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.user?.reports?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? HistoryTableViewCell else {
            print("HistoryTableViewController > CellType doesn't match HistoryTableViewCell.")
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        }
        
        if let user = viewModel.user, let reports = user.reports, reports.count > indexPath.row {
             cell.report = reports[indexPath.row]
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set back button to "Cancel" for ReportVC
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
    }
    
}
