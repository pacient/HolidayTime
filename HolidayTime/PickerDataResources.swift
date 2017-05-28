//
//  PickerDataResources.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class PickerDataResources: NSObject {
    
    open class func instance() -> PickerDataResources {
        struct Struc {
            static let instance = PickerDataResources()
        }
        return Struc.instance
    }
    
    func allCountries() -> [String] {
        return NSLocale.isoCountryCodes.map {
            return NSLocale(localeIdentifier: "en").localizedString(forCountryCode: $0) ?? $0
            }.sorted{$0 < $1}
    }
    
    func allDates() -> [[String]] {
        var dates = [["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                     [String](),
                     [String](),
                     ]
        for i in 1...31 {
            let extra = i < 10 ? "0" : ""
            dates[1].append("\(extra)\(i)")
        }
        
        let date = Date()
        let year = Calendar.current.component(.year, from: date)
        for i in 0...10 {
            dates[2].append("\(year+i)")
        }
        return dates
    }
}
