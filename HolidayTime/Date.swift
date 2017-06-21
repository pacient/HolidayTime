//
//  Date.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 16/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

extension Date {
    func getRemainingDays() -> String {
        let calendar = Calendar.current
        
        let today = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
        
        let components = calendar.dateComponents([.day], from: today, to: self)
        if let daysRemaining = components.day {
            if daysRemaining + 1 <= 0 {
                return "0"
            }
            return "\(daysRemaining + 1)"
        }
        return "0"
    }
}
