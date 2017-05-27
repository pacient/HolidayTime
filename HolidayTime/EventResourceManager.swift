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
    
    class func allEvents() -> [Event] {
        if let eventsData: Data = UserDefaults.standard.object(forKey: Const.allEvents) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: eventsData) as! [Event]
        }
        return [Event]()
    }
    
    class func add(event: Event) {
        let allEvents = self.allEvents()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: allEvents), forKey: Const.allEvents)
        UserDefaults.standard.synchronize()
    }
    
    class func remove(event: Event) {
        var allEvents = self.allEvents()
        for each in allEvents {
            if each == event {
                allEvents.removeObject(each)
            }
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: allEvents), forKey: Const.allEvents)
        UserDefaults.standard.synchronize()
    }
}
