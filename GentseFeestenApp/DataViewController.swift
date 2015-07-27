//
//  DataViewController.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 18/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//

import UIKit

class DataViewController : UITableViewController {
    
    var events: [String : [Event]] = [:]
    var keys : [String] = []
    
    override func viewDidLoad() {
        let task = service.createFetchTask {
            self.events = $0
            self.tableView.reloadData()
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventsViewController = segue.destinationViewController as EventsViewController
        var s = sender as UITableViewCell
        eventsViewController.events = events[s.textLabel.text!]!
    }

    //Hoeveel onderverdelingen?
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Hoeveel cellen per onderverdeling?
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    //vraagt een cel voor een plaats
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("dateCell") as UITableViewCell
        cell.textLabel.text = self.events.keys.array[indexPath.row]
        return cell
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        let task = service.createFetchTask(){
            self.events = $0
            self.tableView.reloadData()
            sender.endRefreshing()
        }
        task.resume()
    }

    
}
