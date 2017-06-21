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
    var eventID: String?
    var eventTasks = [ChecklistTask]()
    var eventTemperture: String?
    var eventWeatherCode: String?
    var eventLastUpdatedWeather: Date?
    
    open class func instance() -> EventResourceManager {
        struct Struc {
            static let instance = EventResourceManager()
        }
        return Struc.instance
    }
    
    func allEvents() -> [Event] {
        if let eventsData: Data = UserDefaults.standard.object(forKey: Const.allEvents) as? Data {
            let events = (NSKeyedUnarchiver.unarchiveObject(with: eventsData) as! [Event])
            var before: [Event] = []
            var after: [Event] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let nowStr = dateFormatter.string(from: Date())
            let now = dateFormatter.date(from: nowStr)!
            var shouldUpdateEvents = false
            events.forEach({ (event) in
                if now.timeIntervalSince(event.date).hoursPasted() >= 168 {
                    shouldUpdateEvents = true
                }else {
                    if event.date < now {
                        before.append(event)
                    }else {
                        after.append(event)
                    }
                }
            })
            before.sort(by: { (one, two) in one.date < two.date })
            after.sort(by: { (one, two) in one.date < two.date })
            if shouldUpdateEvents {
                saveEvents(events: after+before)
            }
            return after + before
        }
        return [Event]()
    }
    
    func add(event: Event) {
        var allEvents = self.allEvents()
        allEvents.append(event)
        saveEvents(events: allEvents)
    }
    
    func remove(event: Event) {
        var allEvents = self.allEvents()
        for each in allEvents {
            if each == event {
                allEvents.removeObject(each)
            }
        }
        saveEvents(events: allEvents)
    }
    
    func saveEvents(events: [Event]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: events)
        UserDefaults.standard.set(data, forKey: Const.allEvents)
        UserDefaults.standard.synchronize()
    }
    
    func updateEvent() {
        let allEvents = self.allEvents()
        allEvents.forEach { (ev) in
            if self.eventID == ev.eventID {
                ev.name = self.eventName!
                ev.city = self.eventCity!
                ev.country = self.eventCountry!
                ev.date = self.eventDate!
                ev.backgroundImage = self.eventImage!
                ev.tasks = self.eventTasks
                ev.cityTemperture = self.eventTemperture
                ev.lastWeatherUpdate = self.eventLastUpdatedWeather
                ev.weatherCode = self.eventWeatherCode
            }
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: allEvents)
        UserDefaults.standard.set(data, forKey: Const.allEvents)
    }
    
    func createEvent() {
        let eventDict = ["name" : self.eventName!,
                         "city" : self.eventCity!,
                         "country" : self.eventCountry!,
                         "date" : self.eventDate!,
                         "bgimage" : self.eventImage!,
                         "eventID" : String.getRandomID()] as [String : Any]
        let event = Event(data: eventDict)
        self.add(event: event)
    }
    
    func setupValues(with event: Event) {
        self.eventName = event.name
        self.eventCity = event.city
        self.eventCountry = event.country
        self.eventImage = event.backgroundImage
        self.eventDate = event.date
        self.eventID = event.eventID
        self.eventTasks = event.tasks
        self.eventTemperture = event.cityTemperture
        self.eventWeatherCode = event.weatherCode
        self.eventLastUpdatedWeather = event.lastWeatherUpdate
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
        
        if let id = data["eventID"] as? String {
            self.eventID = id
        }
        
        if let tasks = data["tasks"] as? [ChecklistTask] {
            self.eventTasks = tasks
        }
    }
}
