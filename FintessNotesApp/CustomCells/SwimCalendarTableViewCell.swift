//
//  SwimCalendarableViewCell.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 21.05.2021.
//

import UIKit

class SwimCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
