//
//  NewsFeedTableViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 17/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class NewsFeedTableViewController: UITableViewController {
    private var rssItems: [RSSItem]?
    private var cellStates: [CellState]?
    var titleText: String?
    var dateText: String?
    var descText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchData()
    }
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://thegulbenkian.co.uk/feed") { rssItems in
            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let rssItems = rssItems else {
            return 0
        }
        
        // rssItems
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsFeedTableViewCell
        if let item = rssItems?[indexPath.item] {
            cell.item = item
            cell.selectionStyle = .none
            
            if let cellStates = cellStates {
                cell.descriptionLabel.numberOfLines = (cellStates[indexPath.row] == .expanded) ? 0 : 4
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! NewsFeedTableViewCell
        
        titleText = currentCell.titleLabel.text
        dateText = currentCell.dateLabel.text
        descText = currentCell.fullDescriptionText
        
        performSegue(withIdentifier: "newsSegue", sender: self)
    }

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "newsSegue") {
        
        let vc = segue.destination as? NewsFeedDetailsViewController
        vc?.dateText = dateText
        vc?.titleText = titleText
        vc?.descText = descText
        
    }
}
}
