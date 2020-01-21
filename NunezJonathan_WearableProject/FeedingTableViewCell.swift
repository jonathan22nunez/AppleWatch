//
//  FeedingTableViewCell.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/26/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit

class FeedingTableViewCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leftDurationLabel: UILabel!
    @IBOutlet weak var rightDurationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
