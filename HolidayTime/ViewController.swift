//
//  ViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 16/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension UIViewController {
    func loadBannerAd(to bannerView: GADBannerView) {
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = Const.banner_adunit
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
}
