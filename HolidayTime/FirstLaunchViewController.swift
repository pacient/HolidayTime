//
//  FirstLaunchViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 23/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class FirstLaunchViewController: UIViewController {
    var gradientLayer = RadialGradientLayer()
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if gradientLayer.superlayer == nil {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = self.view.bounds
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateInitialViewController()!
        let currentStack = Array(self.navigationController!.viewControllers.dropLast())
        self.navigationController?.setViewControllers(currentStack + [vc], animated: true)
    }
}
