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
}
