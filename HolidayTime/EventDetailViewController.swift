//
//  EventDetailViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 28/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EventDetailViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTempertureLabel: UILabel!
    @IBOutlet weak var eventDaysLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventProgressView: UIProgressView!
    @IBOutlet weak var eventCardView: UIView!
    @IBOutlet weak var eventCityLabel: UILabel!
    @IBOutlet weak var eventWeatherImgView: UIImageView!
    @IBOutlet weak var daysWordLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var event: Event!
    var cardColour: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notf.updateView, object: nil)
        setupViews()
        setupBarButtons()
        
        navBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
        self.loadBannerAd(to: bannerView)
    }
    
    //TODO: Move this to a model view to clear things up
    fileprivate func setupViews() {
        eventCardView.backgroundColor = cardColour
        eventNameLabel.text = event.name
        eventCityLabel.text = event.city
        eventDaysLabel.text = event.date.getRemainingDays()
        daysWordLabel.text = eventDaysLabel.text == "1" ? "day" : "days"
        if let temp = event.cityTemperture {
            eventTempertureLabel.isHidden = false
            eventTempertureLabel.text = temp
            eventWeatherImgView.image = WeatherManager.instance().image(forCode: event.weatherCode!)
        }
        UIView.transition(with: self.eventImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.eventImageView.image = self.event.backgroundImage
        }, completion: nil)
        self.eventProgressView.progress = 0
    }
    
    fileprivate func setupBarButtons() {
        navBar.setBackgroundImage(#imageLiteral(resourceName: "transparent"), for: .default)
        navBar.shadowImage = #imageLiteral(resourceName: "transparent")
        let backItem = getBarButton(image: #imageLiteral(resourceName: "backButton"), action: #selector(backButtonPressed(_:)))
        //let menuItem = getBarButton(image: #imageLiteral(resourceName: "menuButton"), action: #selector(menuButtonPressed(_:)))
        navBar.topItem?.setLeftBarButtonItems([backItem,/*menuItem*/], animated: true)
        
        let editButton = getBarButton(image: #imageLiteral(resourceName: "pencilButton"), action: #selector(settingButtonPressed(_:)))
        let taskButton = getBarButton(image: #imageLiteral(resourceName: "checklistButton"), action: #selector(checkButtonPressed(_:)))
        navBar.topItem?.setRightBarButtonItems([editButton,taskButton], animated: true)
    }
    
    @objc fileprivate func updateView() {
        let allEvents = EventResourceManager.instance().allEvents()
        allEvents.forEach { (event) in
            if self.event.eventID == event.eventID {
                self.event = event
            }
        }
        setupViews()
        getProgress()
    }
    
    fileprivate func getBarButton(image: UIImage, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        return UIBarButtonItem(customView: button)
    }
    
    
    func getProgress() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let startDate = dateFormatter.date(from: "Jan 01, 2017")!
        let percent = ((Date().timeIntervalSince1970 - startDate.timeIntervalSince1970) * 100) / (event.date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
        UIView.animate(withDuration: 1.0) {
            self.eventProgressView.setProgress(Float(percent/100), animated: true)
            print(self.eventProgressView.progress)
        }
    }
    
    @IBAction func unwindFromChecklist(_ sender: UIStoryboardSegue) {
        let destination = sender.source as! EventChecklistViewController
        self.event = destination.event
    }
    
    //MARK: Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        EventResourceManager.instance().setupValues(with: event)
        EventResourceManager.instance().updateEvent()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "EventChecklist", bundle: nil).instantiateInitialViewController() as! EventChecklistViewController
        vc.event = event
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateInitialViewController() as! EventCreatorViewController
        vc.isEventEditing = true
        vc.event = self.event
        vc.viewTitle = "Edit Event"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
