//
//  Event.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 12/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//
import Foundation

class Event{
    let title: String
    let description: String?
    let date: NSDate
    let startHour: String?
    let endHour: String?
    let categorieId: Int
    let categorieName: String
    let url: String?
    let image: String?
    let locationName: String
    let sublocation: String?
    let nr: String?
    let postalcode: Int?
    let city: String?
    let street: String?
    let location: Location
    
    init(title: String, description: String?, date: NSDate, startHour: String?, endHour: String?, categorieId: Int, categorieNaam: String, url: String?, image: String?, locationName: String, sublocation: String?, nr: String?, postalcode: Int?, city: String?, location: Location, street: String?){
        self.title = title
        self.description = description
        self.date = date
        self.startHour = startHour
        self.endHour = endHour
        self.categorieId = categorieId
        self.categorieName = categorieNaam
        self.url = url
        self.image = image
        self.locationName = locationName
        self.sublocation = sublocation
        self.nr = nr
        self.postalcode = postalcode
        self.city = city
        self.location = location
        self.street = street
    }
    
    func formattedDate() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.stringFromDate(date)
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
}

