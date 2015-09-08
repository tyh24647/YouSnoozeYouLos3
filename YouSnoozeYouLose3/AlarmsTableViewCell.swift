//
//  AlarmsTableViewCell.swift
//  YouSnoozeYouLose3
//
//  Created by Tyler hostager on 8/3/15.
//  Copyright © 2015 Tyler hostager. All rights reserved.
//

import UIKit

class AlarmsTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var alarmTitleLabel: UILabel?
    @IBOutlet weak var alarmDaysLabel: UILabel?
    @IBOutlet weak var alarmHoursLabel: UILabel?
    @IBOutlet weak var alarmMinutesLabel: UILabel?
    @IBOutlet weak var alarmIsEnabledSwitch: UISwitch?
    
    var alarmDoesRepeat: Bool?
    

    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
