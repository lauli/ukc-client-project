//
//  NewsFeedTableViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 17/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController
{
    private var rssItems: [RSSItem]?
    private var cellStates: [CellState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchData()
    }
    
    private func fetchData()
    {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://developer.apple.com/news/rss/news.rss") { (rssItems) in
            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
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
                cell.issueDesc.numberOfLines = (cellStates[indexPath.row] == .expanded) ? 0 : 4
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NewsFeedTableViewCell
        
        tableView.beginUpdates()
        cell.issueDesc.numberOfLines = (cell.issueDesc.numberOfLines == 0) ? 3 : 0
        
        cellStates?[indexPath.row] = (cell.issueDesc.numberOfLines == 0) ? .expanded : .collapsed
        
        tableView.endUpdates()
    }
    
}
