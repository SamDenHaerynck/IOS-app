//
//  EventsViewController.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 12/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//


import UIKit

class EventsViewController: UITableViewController {
    
    var events: [Event] = []
    var filteredEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchDisplayController!.searchResultsTableView.rowHeight = self.tableView.rowHeight
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "kaartOverzicht" {
            let eventViewController = segue.destinationViewController as EventViewController
            
            //TOEVOEGING searchbar
            var selectedEvent: Event
            if  self.searchDisplayController?.active == true {
                let table = self.searchDisplayController?.searchResultsTableView
                selectedEvent = filteredEvents[table!.indexPathForSelectedRow()!.row]
            } else {
                selectedEvent = events[tableView.indexPathForSelectedRow()!.row]
            }
            
            eventViewController.event = selectedEvent
            
        }else{
            let overzichtViewController = segue.destinationViewController as OverzichtViewController
            overzichtViewController.events = events
            
        }
        
        
    }
    
    //Hoeveel onderverdelingen?
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Hoeveel cellen per onderverdeling?
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredEvents.count
        } else {
            return self.events.count
        }
    }
    
    //vraagt een cel voor een plaats
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
        var event: Event
        if tableView == self.searchDisplayController!.searchResultsTableView {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        
        var image: UIImage
        
        if (event.image != nil) {
            let imageUrl = NSURL(string: event.image!)
            image = UIImage(data: NSData(contentsOfURL: imageUrl!)!)!
        } else {
            image = UIImage(named: "icon")!
        }
        
        var icon = cell.viewWithTag(100) as UIImageView
        icon.image = image
        var title = cell.viewWithTag(101) as UILabel
        title.text = event.title
        var loc = cell.viewWithTag(102) as UILabel
        loc.text = event.locationName
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        self.filteredEvents = self.events.filter({( event: Event) -> Bool in
            let categoryMatch = (scope == "All") || (event.categorieName == scope)
            let stringMatch = event.title.lowercaseString.rangeOfString(searchText.lowercaseString)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        return true
    }
    
}
