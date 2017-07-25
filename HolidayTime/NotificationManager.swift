//
//  NotificationManager.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 08/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    private static let instance = NotificationManager()
    
    enum Period {
        case month
        case week
        case nextDay
    }
    
    class func scheduleNotifications(for event: Event) {
        //Remove all notifications for that event first
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.eventID])
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: event.date)
        if let daysLeft = components.day {
            let components = Calendar.current.dateComponents([.day,.month,.year], from: event.date)
            if daysLeft >= 30 {
                instance.createNotification(event.name, id: event.eventID, components: components, period: .month)
                instance.createNotification(event.name, id: event.eventID, components: components, period: .week)
                instance.createNotification(event.name, id: event.eventID, components: components, period: .nextDay)
            }else if daysLeft >= 7 {
                instance.createNotification(event.name, id: event.eventID, components: components, period: .week)
                instance.createNotification(event.name, id: event.eventID, components: components, period: .nextDay)
            }else if daysLeft < 7 && daysLeft > 0 || calendar.isDateInTomorrow(event.date){
                instance.createNotification(event.name, id: event.eventID, components: components, period: .nextDay)
            }
        }
    }
    
    class func removeNotifications(for eventID: String) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [eventID])
    }
    
    fileprivate func createNotification(_ title: String, id: String, components: DateComponents, period: Period) {
        var components = components
        components.hour = 10
        components.minute = 00
        var daysLeft: String!
        if period == .month {
            components.month = components.month! - 1
            daysLeft = "One month"
        }else if period == .week {
            components.day = components.day! - 7
            daysLeft = "One week"
        }else if period == .nextDay {
            components.day = components.day! - 1
            daysLeft = "One day"
        }
        
        let content = UNMutableNotificationContent()
        content.body = "\(daysLeft!) till \(title) 🎉"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let requst = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(requst, withCompletionHandler: nil)
    }
}
