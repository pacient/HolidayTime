//
//  BackgroundSelectorViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 28/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class BackgroundSelectorViewController: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var sixthImageView: UIImageView!
    
    @IBOutlet weak var imageSelectorBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func selectImagePressed(_ sender: Any) {
    }

}
