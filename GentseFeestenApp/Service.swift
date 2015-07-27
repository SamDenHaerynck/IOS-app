//
//  Service.swift
//  GentseFeestenApp
//
//  Created by Matthias De Groote on 12/11/14.
//  Copyright (c) 2014 Matthias De Groote. All rights reserved.
//

import Foundation

class Service
{
    private let baseUrl = NSURL(string: "http://pr.datatank.gent.be/Toerisme")
    
    private let session: NSURLSession
    
    init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createFetchTask(#completionHandler: [String : [Event]] -> Void) -> NSURLSessionTask {
        let request = NSMutableURLRequest(URL: baseUrl!.URLByAppendingPathComponent("GentseFeestenEvents.json"))
        return session.dataTaskWithRequest(request) {
            data, response, error in
            let response = response as NSHTTPURLResponse
            if response.statusCode == 200 {
                let events = Json.readEvents(data)
                
                //disptach_get_main_queue() is om de gui-thread op te vragen
                dispatch_async(dispatch_get_main_queue()){
                    completionHandler(events)
                }
            }
        }
    }
}

let service = Service()
