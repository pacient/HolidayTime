//
//  EventModel.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    var name: String
    var date: Date
    var city: String
    var country: String
    
    init(name: String, date: Date, city: String, country: String) {
        self.name = name
        self.date = date
        self.city = city
        self.country = country
    }
}
