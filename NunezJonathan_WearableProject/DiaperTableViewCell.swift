//
//  DiaperTableViewCell.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/26/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit

class DiaperTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaperTypeLabel: UILabel!
    @IBOutlet weak var diaperColorLabel: UILabel!
    @IBOutlet weak var diaperTextureLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
