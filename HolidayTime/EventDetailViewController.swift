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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //TODO: Move this to a model view to clear things up
    func setupViews() {
        eventNameLabel.text = event.name
        eventDaysLabel.text = getRemainingDays(forDate: event.date)
        eventImageView.image = event.backgroundImage
    }

    func getRemainingDays(forDate: Date) -> String {
        let calendar = Calendar.current
        
        let today = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
        
        let components = calendar.dateComponents([.day], from: today, to: forDate)
        return "\(components.day ?? 0)"
    }
}
