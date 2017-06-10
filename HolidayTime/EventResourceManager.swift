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
    
    open class func instance() -> EventResourceManager {
        struct Struc {
            static let instance = EventResourceManager()
        }
        return Struc.instance
    }
    
    func allEvents() -> [Event] {
        if let eventsData: Data = UserDefaults.standard.object(forKey: Const.allEvents) as? Data {
            return (NSKeyedUnarchiver.unarchiveObject(with: eventsData) as! [Event]).sorted{ $0.date < $1.date }
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
        let data = NSKeyedArchiver.archivedData(withRootObject: allEvents)
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
            }
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: allEvents)
        UserDefaults.standard.set(data, forKey: Const.allEvents)
        UserDefaults.standard.synchronize()
    }
    
    func createEvent() {
        let eventDict = ["name" : self.eventName!,
                         "city" : self.eventCity!,
                         "country" : self.eventCountry!,
                         "date" : self.eventDate!,
                         "bgimage" : self.eventImage!,
                         "eventID" : setEventID()] as [String : Any]
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
        
        if let id = data["eventID"] as? String {
            self.eventID = id
        }
    }
    
    //This sets a random string with lowercase, uppercase and numbers with 8 charactes
    private func setEventID() -> String {
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var s = ""
        for _ in 0..<8 {
            let r = Int(arc4random_uniform(UInt32(a.characters.count)))
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        return s
    }
}
