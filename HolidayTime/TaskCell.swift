//
//  TaskCell.swift
//  HolidayTime
//
//  Created by Vasil Nunev on 15/06/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var selectedCellImageView: UIImageView!
    
    var task: ChecklistTask! {
        didSet{
            taskTitle.text = task.title
            switch task.status {
            case .done:
                selectedCellImageView.image = #imageLiteral(resourceName: "Path 2")
            case .todo:
                selectedCellImageView.image = #imageLiteral(resourceName: "unselectedTask")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
