//
//  EventCreatorViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventCreatorViewController: UIViewController {
    private let gradientLayer = RadialGradientLayer()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let textFields = [nameTextField,cityTextField,countryTextField,dateTextField]
        textFields.forEach { (field) in
            field?.layer.borderColor = UIColor.white.cgColor
            field?.layer.borderWidth = 1.0
            field?.layer.cornerRadius = 5
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if gradientLayer.superlayer == nil {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = self.view.bounds
        
        
    }

}
