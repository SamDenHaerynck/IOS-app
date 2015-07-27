//
//  OverzichtViewController.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 19/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class OverzichtViewController : UIViewController, MKMapViewDelegate {
    
    var events: [Event] = []
    var event: Event!
    
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        
        for event in events {
            let location = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = event.title
            annotation.subtitle = event.locationName
            map.addAnnotation(annotation)
            
            
        }
        let location = CLLocationCoordinate2D(latitude: events[0].location.latitude, longitude: events[0].location.longitude)
        let region = MKCoordinateRegionMakeWithDistance(location, 1000, 600)
        map.region = region
        map.delegate = self
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let ann = mapView.selectedAnnotations[0] as? MKAnnotation {
            for event1 in events {
                if event1.title == ann.title {
                    event = event1
                }
            }
        }
        performSegueWithIdentifier("details", sender: events[0])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as EventViewController
        eventViewController.event = event
        
    }
    
    
}

