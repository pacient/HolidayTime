//
//  EventModel.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class Event: NSObject, NSCoding {
    
    var name: String
    var date: Date
    var city: String
    var country: String
    var backgroundImage: UIImage
    
    init(data: [String : Any]) {
        self.name = data["name"] as! String
        self.date = data["date"] as! Date
        self.city = data["city"] as! String
        self.country = data["country"] as! String
        self.backgroundImage = data["bgimage"] as! UIImage
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let country = aDecoder.decodeObject(forKey: "country") as! String
        let bgimage = aDecoder.decodeObject(forKey: "bgimage") as! UIImage
        let data: [String : Any] = ["name" : name,
                                          "date" : date,
                                          "city" : city,
                                          "country" : country,
                                          "bgimage" : bgimage]
        self.init(data: data)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.backgroundImage, forKey: "bgimage")
    }
    
    public static func ==(lhs: Event, rhs: Event) -> Bool {
        return  lhs.name == rhs.name &&
                lhs.city == rhs.city &&
                lhs.country == rhs.country &&
                lhs.date == rhs.date
    }
    
}
