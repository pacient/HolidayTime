//
//  WeatherManager.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 17/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherManager: NSObject {
    private let apiURLString = "https://api.apixu.com/v1/current.json?key=11754a90f82f41be8db142311171706"
    
    open class func instance() -> WeatherManager {
        struct Struc {
            static let instance = WeatherManager()
        }
        return Struc.instance
    }
    
    func getWeather(forCity city: String, country: String, completionHandler: @escaping (_ results: [String : String]?) -> () ) {
        let urlString = "\(apiURLString)&q=\(city),\(country)".replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: urlString)!
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            if let value = response.result.value, let json = JSON(value).dictionaryObject, let current = json["current"] as? [String : Any] {
                var results = [String : String]()
                if let temperture = current["temp_c"] as? Float, let condition = current["condition"] as? [String : Any] {
                    results["temperture"] = "\(Int(temperture))°"
                    let code = condition["code"] as! Int
                    results["code"] = "\(code)"
                    completionHandler(results)
                }else {
                    completionHandler(nil)
                }
            }else{
                completionHandler(nil)
            }
        })
    }
}
