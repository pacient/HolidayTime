//
//  ChecklistTask.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 15/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class ChecklistTask: NSObject, NSCoding {
    enum TaskStatus: Int {
        case done
        case todo
    }
    var title: String
    var status: TaskStatus
    var id: String
    
    init(title: String, status: TaskStatus, id: String = .getRandomID()) {
        self.title = title
        self.status = status
        self.id = id
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "taskTitle") as! String
        let id = aDecoder.decodeObject(forKey: "taskID") as! String
        let statusRawValue = aDecoder.decodeInteger(forKey: "taskStatus")
        let status = TaskStatus(rawValue: statusRawValue)!
        self.init(title: title, status: status, id: id)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "taskTitle")
        let statusRawValue = self.status.rawValue
        aCoder.encode(statusRawValue, forKey: "taskStatus")
        aCoder.encode(self.id, forKey: "taskID")
    }
    
    public static func ==(lhs: ChecklistTask, rhs: ChecklistTask) -> Bool {
        return lhs.id == rhs.id
    }
}
