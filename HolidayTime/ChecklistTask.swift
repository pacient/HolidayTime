//
//  ChecklistTask.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 15/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

struct ChecklistTask: Codable, Equatable {
    enum TaskStatus: Int, Codable {
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
    
    public static func ==(lhs: ChecklistTask, rhs: ChecklistTask) -> Bool {
        return lhs.id == rhs.id
    }
}
