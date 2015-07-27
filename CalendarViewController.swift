//
//  CalendarViewController.swift
//  GentseFeestenApp
//
//  Created by Sam Den Haerynck on 16/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class CalendarViewController: UITableViewController {
    
    var calendarArray : [EKCalendar]!
    var event: Event!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Hoeveel cellen per onderverdeling?
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarArray.count
    }
    //vraagt een cel voor een plaats
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("calendarCell") as UITableViewCell
        var calendar: EKCalendar
        calendar = calendarArray[indexPath.row]
        cell.textLabel.text = calendar.title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as EventViewController
        var calendar : EKCalendar
        calendar = calendarArray[tableView.indexPathForSelectedRow()!.row]
        eventViewController.selectedCalendar = calendar
        eventViewController.event = event
    }
    
    
    
}