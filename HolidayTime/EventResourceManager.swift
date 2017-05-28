//
//  EventResourceManager.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventResourceManager: NSObject {
    
    var eventName: String?
    var eventCity: String?
    var eventCountry: String?
    var eventImage: UIImage?
    var eventDate: Date?
    
    open class func instance() -> EventResourceManager {
        struct Struc {
            static let instance = EventResourceManager()
        }
        return Struc.instance
    }
    
    func allEvents() -> [Event] {
        if let eventsData: Data = UserDefaults.standard.object(forKey: Const.allEvents) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: eventsData) as! [Event]
        }
        return [Event]()
    }
    
    func add(event: Event) {
        var allEvents = self.allEvents()
        allEvents.append(event)
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: allEvents)
        UserDefaults.standard.set(data, forKey: Const.allEvents)
        UserDefaults.standard.synchronize()
    }
    
    func remove(event: Event) {
        var allEvents = self.allEvents()
        for each in allEvents {
            if each == event {
                allEvents.removeObject(each)
            }
        }
        UserDefaults.standard.set(allEvents, forKey: Const.allEvents)
        UserDefaults.standard.synchronize()
    }
    
    func createEvent() {
        let eventDict = ["name" : self.eventName!,
                         "city" : self.eventCity!,
                         "country" : self.eventCountry!,
                         "date" : self.eventDate!,
                         "bgimage" : self.eventImage!] as [String : Any]
        let event = Event(data: eventDict)
        self.add(event: event)
    }
    
    func setupValues(data: [String : Any]) {
        if let name = data["name"] as? String{
            self.eventName = name
        }
        
        if let city = data["city"] as? String {
            self.eventCity = city
        } else {
            self.eventCity = ""
        }
        
        if let country = data["country"] as? String {
            self.eventCountry = country
        }
        
        if let image = data["bgimage"] as? UIImage {
            self.eventImage = image
        }
        
        if let date = data["date"] as? Date {
            self.eventDate = date
        }
    }
}
