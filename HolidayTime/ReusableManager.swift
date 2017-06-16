//
//  ReusableManager.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 16/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation
import GoogleMobileAds

class ReusableManager: NSObject {
    open class func instance() -> ReusableManager {
        struct Struc {
            static let instance = ReusableManager()
        }
        return Struc.instance
    }
    
    func loadAd(bannerView: GADBannerView, viewController: UIViewController) {
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = Const.banner_adunit
        bannerView.rootViewController = viewController
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
}
