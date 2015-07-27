//
//  Json.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 12/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//

import Foundation

class Json
{
    class func readEvents(data: NSData) -> [String : [Event]]
    {
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        
        var dataArray: [String: [Event]] = [:]
        
        let  jsonEvents = jsonData["GentseFeestenEvents"]! as NSArray
        var events: [Event] = []
        var eventsTitle: [String] = []
        for jsonEvent in jsonEvents {
            let jsonEvent = jsonEvent as NSDictionary
            let title = jsonEvent["titel"] as String
            let description = jsonEvent["omschrijving"] as? String
            let date2 = jsonEvent["datum"] as NSString
            let date = NSDate(timeIntervalSince1970:date2.doubleValue)
            let startHour = jsonEvent["startuur"] as? String
            let endHour = jsonEvent["einduur"] as? String
            let categorieId = jsonEvent["categorie_id"] as NSString
            let categorieNaam = jsonEvent["categorie_naam"] as String
            let url = jsonEvent["url"] as? String
            let image = jsonEvent["afbeelding"] as? String
            let locationName = jsonEvent["locatie"] as String
            let sublocation = jsonEvent["sublocatie"] as? String
            let nr = jsonEvent["huisnummer"] as? String
            let postalcode = jsonEvent["postcode"] as? NSString
            let city = jsonEvent["gemeente"] as? String
            let latitude = jsonEvent["latitude"] as NSString
            let longitude = jsonEvent["longitude"] as NSString
            let street = jsonEvent["straat"] as? String
            
            let event = Event(title: title, description: description, date: date, startHour: startHour, endHour: endHour, categorieId: categorieId.integerValue, categorieNaam: categorieNaam, url: url, image: image, locationName: locationName, sublocation: sublocation, nr: nr, postalcode: postalcode?.integerValue, city: city, location:Location(latitude: latitude.doubleValue, longitude: longitude.doubleValue), street: street)
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            var dateKey = dateFormatter.stringFromDate(date)
            
            if dataArray[dateKey] != nil {
                var array = dataArray[dateKey]!
                array.append(event)
                dataArray[dateKey] = array
            } else {
                dataArray[dateKey] = [event]
            }
            
            events.append(event)
        }
        return dataArray;
    }
}
