//
//  ExerciseTableViewCell.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//

import UIKit

protocol CustomCellDelegate: class {
    func doExercise(button: UIButton, section: Int)
}

class ExerciseTableViewCell: UITableViewCell {

    @IBAction func tapDone(_ sender: UIButton) {
        delegate?.doExercise(button: sender, section: section)
    }
    weak var delegate: CustomCellDelegate?
    var section: Int = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countDone: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var countOfReps: UILabel!
    @IBOutlet weak var titleExercise: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
