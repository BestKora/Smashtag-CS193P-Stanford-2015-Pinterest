//
//  RecentsTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/9/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {
    let recents = RecentSearches()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    private struct Constants {
        static let cellReuseIdentifier = "Recents"
        static let segueIdentifier = "Show Recent Search"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.searches.count }
    
    override func tableView(tableView: UITableView,
                      cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellReuseIdentifier,
                                            forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = recents.searches[indexPath.row]
        return cell
    }
    
    // Переопределяем поддержку редактирования table view.
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // уничтожаем строку из data source
            recents.searches.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            if identifier == Constants.segueIdentifier {
                if let cell = sender as? UITableViewCell {
                    if let ttvc = segue.destinationViewController as? TweetTableViewController {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            }
        }
        
    }


}
