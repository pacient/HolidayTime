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
    enum WeatherStatus {
        case sunny
        case partlyCloudy
        case cloudy
        case rainySunny
        case thunderSunny
        case foggy
        case rainy
        case thunderstorm
        case snowing
        case unknown
        
        init(rawValue: String) {
            switch rawValue {
            case "1000":
                self = .sunny
            case "1003", "1210":
                self = .partlyCloudy
            case "1006", "1009", "1030":
                self = .cloudy
            case "1063", "1069", "1072", "1180", "1183", "1186", "1189", "1192", "1240", "1243", "1249", "1252":
                self = .rainySunny
            case "1087", "1246":
                self = .thunderSunny
            case "1114", "1117", "1213", "1216", "1219", "1222", "1225", "1237", "1255", "1258", "1261", "1264":
                self = .snowing
            case "1135", "1147":
                self = .foggy
            case "1150", "1153", "1168", "1171", "1195", "1198", "1201", "1204", "1207":
                self = .rainy
            case "1273", "1276", "1279", "1282":
                self = .thunderstorm
            default:
                self = .unknown
            }
        }
    }
    
    open class func instance() -> WeatherManager {
        struct Struc {
            static let instance = WeatherManager()
        }
        return Struc.instance
    }
    
    func image(forCode code: String) -> UIImage? {
        let status = WeatherStatus(rawValue: code)
        switch status {
        case .sunny:
            return #imageLiteral(resourceName: "sunny")
        case .cloudy:
            return #imageLiteral(resourceName: "cloudy")
        case .foggy:
            return #imageLiteral(resourceName: "foggy")
        case .partlyCloudy:
            return #imageLiteral(resourceName: "partlyCloudy")
        case .rainy:
            return #imageLiteral(resourceName: "rainy")
        case .rainySunny:
            return #imageLiteral(resourceName: "rainySunny")
        case .snowing:
            return #imageLiteral(resourceName: "snowing")
        case .thunderstorm:
            return #imageLiteral(resourceName: "thunderstorm")
        case .thunderSunny:
            return #imageLiteral(resourceName: "stormySunny")
        case .unknown:
            return nil
        }
    }
    
    func getWeather(forCity city: String, country: String, tempFormat: String, completionHandler: @escaping (_ results: [String : String]?) -> () ) {
        let urlString = "\(apiURLString)&q=\(city),\(country)".replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: urlString)!
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            if let value = response.result.value, let json = JSON(value).dictionaryObject, let current = json["current"] as? [String : Any] {
                var results = [String : String]()
                let tempStr = tempFormat == "Celsius" ? "temp_c" : "temp_f"
                if let temperture = current[tempStr] as? Double, let condition = current["condition"] as? [String : Any] {
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
