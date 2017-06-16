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
    @IBOutlet weak var navBar: UINavigationBar!
    
    var isEventEditing = false
    
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
        
        navBar.setBackgroundImage(#imageLiteral(resourceName: "transparent"), for: .default)
        navBar.shadowImage = #imageLiteral(resourceName: "transparent")
        
        let imgViewArray = [firstImageView,secondImageView,thirdImageView,fourthImageView,fifthImageView,sixthImageView]
        imgViewArray.forEach{$0?.addGestureRecognizer(setTapGestureRecognizer())}
    
    }
    
    func setTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let tappedImageView = tapGestureRecognizer.view as? UIImageView {
            EventResourceManager.instance().eventImage = tappedImageView.image
            if isEventEditing {
                EventResourceManager.instance().updateEvent()
                NotificationCenter.default.post(name: Notf.updateView, object: nil)
            }else {
                EventResourceManager.instance().createEvent()
            }
            NotificationCenter.default.post(name: Notf.updateEvents, object: nil)
            var controllers = self.navigationController?.viewControllers
            for controller in controllers! {
                if controller.isKind(of: EventCreatorViewController.self) || controller.isKind(of: BackgroundSelectorViewController.self) {
                    controllers?.removeObject(controller)
                }
            }
            self.navigationController?.setViewControllers(controllers!, animated: true)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
    }

}
