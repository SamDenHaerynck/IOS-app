
//
//  EventViewController.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 14/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class EventViewController: UITableViewController {
    
    var event: Event!
    
    var selectedCalendar: EKCalendar!

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var vanLabel: UILabel!
    
    @IBOutlet weak var totLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        navigationItem.title = event.title
        categoryLabel.text = "Categorie: \(event.categorieName)"
        descriptionField.text = (event.description != nil) ? event.description : ""
        descriptionField.editable = false
        
        dateLabel.text = "Wanneer? \(event.formattedDate())"
        vanLabel.text = (event.startHour != nil) ? "Vanaf? \(event.startHour!) uur" : ""
        
        totLabel.text = (event.endHour != nil) ? "Tot? \(event.endHour!) uur" : ""
        websiteLabel.text = (event.url != nil) ? "Website? \(event.url!)" : ""
        locationName.text = event.locationName
        if (event.street != nil && event.nr != nil) {
            streetLabel.text = "\(event.street!) \(event.nr!)"
        }
        else if (event.street != nil) {
            streetLabel.text = "\(event.street!)"
        }
        else {
            streetLabel.text = ""
        }
        
        if(event.postalcode != nil && event.city != nil) {
            cityLabel.text = "\(event.postalcode!) - \(event.city!)"
        } else if (event.postalcode != nil) {
            cityLabel.text = "\(event.postalcode!)"
        } else if (event.city != nil) {
            cityLabel.text = "\(event.city!)"
        }
        
        
        let center = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
        let region = MKCoordinateRegionMakeWithDistance(center, 1000, 600)
        map.region = region
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        map.addAnnotation(annotation)
        
        
        
        
        if (event.image != nil){
            let imageUrl = NSURL(string: event.image!)
            let img: UIImage = UIImage(data: NSData(contentsOfURL: imageUrl!)!)!
            image.image = img
        }
        
        if selectedCalendar != nil {
            let eventStore = EKEventStore()
            self.insertEventIntoStore(eventStore, calendar: selectedCalendar)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let calendarViewController = segue.destinationViewController as CalendarViewController
        let eventStore = EKEventStore()
        var calendars : [EKCalendar]!
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent){
            
        case .Authorized:
            calendars = findICloudCalendars(eventStore)
        case .Denied:
            displayAccessDenied()
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in
                    if granted{
                        calendars = self!.findICloudCalendars(eventStore)
                    } else {
                        self!.displayAccessDenied()
                    }
            })
        case .Restricted:
            displayAccessRestricted()
        }

        calendarViewController.calendarArray = calendars
        calendarViewController.event = event
    }

    
    func displayAccessDenied(){
        println("Access to the event store is denied.")
    }
    
    func displayAccessRestricted(){
        println("Access to the event store is restricted.")
    }
    
    func findICloudCalendars (store: EKEventStore) -> [EKCalendar] {
        var calendarArray : [EKCalendar] = []
        let icloudSource = sourceInEventStore(store,
            type: EKSourceTypeCalDAV,
            title: "iCloud")
        
        if icloudSource == nil{
            println("You have not configured iCloud for your device.")
        }
        
        let calendars = icloudSource?.calendarsForEntityType(EKEntityTypeEvent)
        
        for calendar in calendars!.allObjects as [EKCalendar] {
            calendarArray.append(calendar)
        }
        
        return calendarArray
        
    }
    
    func sourceInEventStore(
        eventStore: EKEventStore,
        type: EKSourceType,
        title: String) -> EKSource?{
            
            for source in eventStore.sources() as [EKSource]{
                if source.sourceType.value == type.value &&
                    source.title.caseInsensitiveCompare(title) ==
                    NSComparisonResult.OrderedSame{
                        return source
                }
            }
            
            return nil
    }
    
    func calendarWithTitle(
        title: String,
        type: EKCalendarType,
        source: EKSource,
        eventType: EKEntityType) -> EKCalendar?{
            
            for calendar in source.calendarsForEntityType(eventType).allObjects
                as [EKCalendar]{
                    if calendar.title.caseInsensitiveCompare(title) ==
                        NSComparisonResult.OrderedSame &&
                        calendar.type.value == type.value{
                            return calendar
                    }
            }
            
            return nil
    }
    
        
    func insertEventIntoStore(store: EKEventStore, calendar: EKCalendar){
        
        let icloudSource = sourceInEventStore(store,
            type: EKSourceTypeCalDAV,
            title: "iCloud")
        
        if icloudSource == nil{
            println("You have not configured iCloud for your device.")
            return
        }
        
        let calendar = calendarWithTitle(calendar.title,
            type: EKCalendarTypeCalDAV,
            source: icloudSource!,
            eventType: EKEntityTypeEvent)
        
        if calendar == nil{
            println("Could not find the calendar we were looking for.")
            return
        }
        
        let calendar2 = NSCalendar(identifier: NSGregorianCalendar)
        
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let startdate = event.date
        let componentsStart = NSCalendar.currentCalendar().components(flags, fromDate: startdate)
        let componentsEnd = NSCalendar.currentCalendar().components(flags, fromDate: startdate)
        
        let startH = event.startHour != nil ? event.startHour! : "00:01"
        let endH = event.endHour != nil ? event.endHour! : "23:59"
        var starthour = startH.substringWithRange(Range<String.Index>(start: startH.startIndex, end: advance(startH.endIndex, -3)))
        var endhour = endH.substringWithRange(Range<String.Index>(start: startH.startIndex, end: advance(startH.endIndex, -3)))
        var startMin = startH.substringWithRange(Range<String.Index>(start: advance(startH.startIndex, 3), end: startH.endIndex))
        var endMin = endH.substringWithRange(Range<String.Index>(start: advance(startH.startIndex, 3), end: startH.endIndex))
        
        //Aangezien de gegevens die momenteel uit de json-file opgehaald worden, datums in het verleden hebben kunnen er geen blijvende calendar-items worden aangemaakt. Deze error hebben we opgelost door momenteel het jaar steeds op 2015 in te stellen. Indien de gegevens op de webservice aangepast zijn voor het komende jaar mogen de 2 volgende regels code verwijdert worden.
        componentsStart.year = 2015
        componentsEnd.year = 2015
        
        componentsStart.hour = starthour.toInt()!
        componentsStart.minute = startMin.toInt()!
        componentsEnd.hour = endhour.toInt()!
        componentsEnd.minute = endMin.toInt()!
        
        let startDate = calendar2!.dateFromComponents(componentsStart)! as NSDate
        let endDate = calendar2!.dateFromComponents(componentsEnd)! as NSDate
        
        if createEventWithTitle("Gentse feesten",
            startDate: startDate,
            endDate: endDate,
            inCalendar: calendar!,
            inEventStore: store,
            notes: event.title){
                var alert = UIAlertController(title: "Info", message: "Evenement toegevoegd", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        } else {
            println("Failed to create the event.")
        }
        
    }
    
    func createEventWithTitle(
        title: String,
        startDate: NSDate,
        endDate: NSDate,
        inCalendar: EKCalendar,
        inEventStore: EKEventStore,
        notes: String) -> Bool{
            
            /* If a calendar does not allow modification of its contents
            then we cannot insert an event into it */
            if inCalendar.allowsContentModifications == false{
                println("The selected calendar does not allow modifications.")
                return false
            }
            
            /* Create an event */
            var e = EKEvent(eventStore: inEventStore)
            e.calendar = inCalendar
            
            /* Set the properties of the event such as its title,
            start date/time, end date/time, etc. */
            e.title = title
            e.notes = notes
            e.startDate = startDate
            e.endDate = endDate
            
            /* Finally, save the event into the calendar */
            var error:NSError?
            
            let result = inEventStore.saveEvent(e, span: EKSpanThisEvent, error: &error)
            
            if result == false{
                if let theError = error{
                    println("An error occurred \(theError)")
                }
            }
            
            return result
    }

}