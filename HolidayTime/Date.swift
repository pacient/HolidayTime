//
//  Date.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 16/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

extension Date {
    func getRemainingDays() -> Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: Date(), to: self)
        if let daysRemaining = components.day {
            if calendar.isDateInToday(self) {
                return 0
            }
            return daysRemaining < 0 ? 0 : daysRemaining + 1
        }
        return 0
    }
}
