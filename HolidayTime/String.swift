//
//  String.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 15/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

extension String {
    static func getRandomID(length: Int = 8) -> String {
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var s = ""
        for _ in 0..<length {
            let r = Int(arc4random_uniform(UInt32(a.characters.count)))
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        return s
    }
}
