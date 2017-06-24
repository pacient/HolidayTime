//
//  MenuViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 24/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.setBackgroundImage(#imageLiteral(resourceName: "transparent"), for: .default)
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let backBarButton = UIBarButtonItem(customView: button)
        navBar.topItem?.setLeftBarButton(backBarButton, animated: true)
    }
    
    func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
