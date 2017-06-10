//
//  EventDetailViewController.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 28/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTempertureLabel: UILabel!
    @IBOutlet weak var eventDaysLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventProgressView: UIProgressView!
    @IBOutlet weak var eventCardView: UIView!
    
    var event: Event!
    var cardColour: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notf.updateView, object: nil)
        setupViews()
    }
    
    //TODO: Move this to a model view to clear things up
    func setupViews() {
        eventCardView.backgroundColor = cardColour
        eventNameLabel.text = event.name
        eventDaysLabel.text = getRemainingDays(forDate: event.date)
        UIView.transition(with: self.eventImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.eventImageView.image = self.event.backgroundImage
        }, completion: nil)
        self.eventProgressView.progress = 0
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
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

    func getRemainingDays(forDate: Date) -> String {
        let calendar = Calendar.current
        
        let today = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
        
        let components = calendar.dateComponents([.day], from: today, to: forDate)
        return "\(components.day ?? 0)"
    }
    
    //MARK: Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "EventCreator", bundle: nil).instantiateInitialViewController() as! EventCreatorViewController
        vc.isEventEditing = true
        vc.event = self.event
        vc.viewTitle = "Edit Event"
        navigationController?.pushViewController(vc, animated: true)
    }
}
