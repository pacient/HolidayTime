//
//  ChecklistTask.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 15/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

struct ChecklistTask: Codable {
    enum TaskStatus: Int, Codable {
        case done
        case todo
    }
    var title: String
    var status: TaskStatus
}
