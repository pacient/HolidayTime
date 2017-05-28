//
//  BackgroundSelectorViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 28/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class BackgroundSelectorViewController: UIViewController {
    private var gradientLayer = RadialGradientLayer()
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var sixthImageView: UIImageView!
    
    @IBOutlet weak var imageSelectorBtn: UIButton!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if gradientLayer.superlayer == nil {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = self.view.bounds
        
        imageSelectorBtn.layer.borderColor = UIColor.white.cgColor
        imageSelectorBtn.layer.borderWidth = 1
        imageSelectorBtn.layer.cornerRadius = 5
        imageSelectorBtn.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
        firstImageView.addGestureRecognizer(tapGesture)
        secondImageView.addGestureRecognizer(tapGesture)
        thirdImageView.addGestureRecognizer(tapGesture)
        fourthImageView.addGestureRecognizer(tapGesture)
        fifthImageView.addGestureRecognizer(tapGesture)
        sixthImageView.addGestureRecognizer(tapGesture)
    }
    

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let tappedImageView = tapGestureRecognizer.view as? UIImageView {
            EventResourceManager.instance().eventImage = tappedImageView.image
            EventResourceManager.instance().createEvent()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
    }

}
