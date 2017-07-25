//
//  EventViewModel.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 23/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation
import UIKit

class EventViewModel {
    private var event: Event
    var eventName: String {
        return event.name
    }
    var cityText: String {
        return event.city
    }
    var countryText: String {
        return event.country
    }
    var remainingDaysText: String {
        return "\(event.date.getRemainingDays())"
    }
    var degreesText: String? {
        return event.cityTemperture
    }
    var weatherCode: String? {
        return event.weatherCode
    }
    var backgroundImage: UIImage {
        return event.backgroundImage
    }
    var tempFormat: String {
        return event.tempFormat
    }
    var shouldUpdateWeather: Bool {
        if event.lastWeatherUpdate == nil {
            return true
        }else {
            let lastWeatherUpdate = event.lastWeatherUpdate!
            let now = Date()
            let hoursSinceLastUpdate = now.timeIntervalSince(lastWeatherUpdate).hoursPasted()
            return hoursSinceLastUpdate >= 3
        }
    }
    var isExpire: Bool {
        return remainingDaysText == "0"
    }
    
    func colourFor(row: Int) -> UIColor {
        if isExpire { return .lightGray }
        if row % 3 == 0 { return UIColor.CustomColors.blueCell }
        if row % 2 == 0 { return UIColor.CustomColors.greenCell }
        return UIColor.CustomColors.brownCell
    }
    
    func getProgress(_ completion: @escaping (_ percent: Float) -> () ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let startDate = dateFormatter.date(from: "Jan 01, 2017")!
        let percent = ((Date().timeIntervalSince1970 - startDate.timeIntervalSince1970) * 100) / (event.date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
        UIView.animate(withDuration: 1.0) {
            completion(Float(percent))
        }
    }
    
    func updateWeather(completion: @escaping () -> () ) {
        WeatherManager.instance().getWeather(forCity: event.city, country: event.country, tempFormat: event.tempFormat ?? "Celsius") { (results) in
            if let results = results {
                self.event.cityTemperture = results["temperture"]
                self.event.weatherCode = results["code"]
                self.event.lastWeatherUpdate = Date()
                EventResourceManager.instance().setupValues(with: self.event)
                EventResourceManager.instance().updateEvent()
                completion()
            }
        }
    }
    init(event: Event){
        self.event = event
    }
    
    
}
