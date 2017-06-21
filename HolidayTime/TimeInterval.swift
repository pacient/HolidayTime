//
//  TimeInterval.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 21/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation
extension TimeInterval {
    func hoursPasted() -> Int {
        let ti = Int(self)
        return (ti / 3600)
    }
}
