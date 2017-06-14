//
//  EventChecklistViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 14/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventChecklistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
