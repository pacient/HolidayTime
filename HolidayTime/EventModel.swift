//
//  EventModel.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class Event: NSObject, NSCoding {
    
    var name: String!
    var date: Date!
    var city: String!
    var country: String!
    var backgroundImage: UIImage!
    var eventID: String!
    var tasks: [ChecklistTask]!
    var cityTemperture: String?
    var weatherCode: String?
    var lastWeatherUpdate: Date?
    var tempFormat: String!
    
    override init() {}
    
    convenience init(data: [String : Any]) {
        self.init()
        self.name = data["name"] as! String
        self.date = data["date"] as! Date
        self.city = data["city"] as! String
        self.country = data["country"] as! String
        self.backgroundImage = data["bgimage"] as! UIImage
        self.eventID = data["eventID"] as! String
        self.tempFormat = data["tempFormat"] as? String
        if let tasks = data["tasks"] as? [ChecklistTask]{
            self.tasks = tasks
        }else {
            self.tasks = [ChecklistTask]()
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.date = aDecoder.decodeObject(forKey: "date") as? Date
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.country = aDecoder.decodeObject(forKey: "country") as? String
        self.backgroundImage = aDecoder.decodeObject(forKey: "bgimage") as? UIImage
        self.eventID = aDecoder.decodeObject(forKey: "eventID") as? String
        self.tasks = aDecoder.decodeObject(forKey: "tasks") as? [ChecklistTask]
        self.cityTemperture = aDecoder.decodeObject(forKey: "cityTemperture") as? String
        self.weatherCode = aDecoder.decodeObject(forKey: "weatherCode") as? String
        self.lastWeatherUpdate = aDecoder.decodeObject(forKey: "lastWeatherUpdate") as? Date
        self.tempFormat = aDecoder.decodeObject(forKey: "tempFormat") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.backgroundImage, forKey: "bgimage")
        aCoder.encode(self.eventID, forKey: "eventID")
        aCoder.encode(self.tasks, forKey: "tasks")
        aCoder.encode(self.cityTemperture, forKey: "cityTemperture")
        aCoder.encode(self.weatherCode, forKey: "weatherCode")
        aCoder.encode(self.lastWeatherUpdate, forKey: "lastWeatherUpdate")
        aCoder.encode(self.tempFormat, forKey: "tempFormat")
    }
    
    public static func ==(lhs: Event, rhs: Event) -> Bool {
        return  lhs.eventID == rhs.eventID
    }
}
