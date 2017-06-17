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
    
    override init() {
    }
    
    convenience init(data: [String : Any]) {
        self.init()
        self.name = data["name"] as! String
        self.date = data["date"] as! Date
        self.city = data["city"] as! String
        self.country = data["country"] as! String
        let imageData = data["bgimage"] as! Data
        self.backgroundImage = UIImage(data: imageData)
        self.eventID = data["eventID"] as! String
        if let tasks = data["tasks"] as? [ChecklistTask]{
            self.tasks = tasks
        }else {
            self.tasks = [ChecklistTask]()
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.country = aDecoder.decodeObject(forKey: "country") as! String
        let bgimageData = aDecoder.decodeObject(forKey: "bgimage") as! Data
        self.backgroundImage = UIImage(data: bgimageData)!
        self.eventID = aDecoder.decodeObject(forKey: "eventID") as!  String
        self.tasks = aDecoder.decodeObject(forKey: "tasks") as! [ChecklistTask]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.country, forKey: "country")
        let imageData = UIImagePNGRepresentation(self.backgroundImage)
        aCoder.encode(imageData, forKey: "bgimage")
        aCoder.encode(self.eventID, forKey: "eventID")
        aCoder.encode(self.tasks, forKey: "tasks")
    }
    
    public static func ==(lhs: Event, rhs: Event) -> Bool {
        return  lhs.eventID == rhs.eventID
    }
}
