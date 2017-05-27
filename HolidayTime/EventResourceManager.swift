//
//  EventResourceManager.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class EventResourceManager: NSObject {
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
}
