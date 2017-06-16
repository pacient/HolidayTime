//
//  EventCell.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 27/05/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDays: UILabel!
    @IBOutlet weak var eventTemperture: UILabel!
    @IBOutlet weak var eventCard: UIView!
    @IBOutlet weak var eventCity: UILabel!
    @IBOutlet weak var eventWeatherImage: UIImageView!
    @IBOutlet weak var daysWordLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
