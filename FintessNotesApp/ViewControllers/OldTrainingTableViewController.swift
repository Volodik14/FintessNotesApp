//
//  OldTrainingTableViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 21.05.2021.
//

import UIKit

class OldTrainingTableViewController: UITableViewController, HeaderViewDelegate{
    
    
    func expandedSection(button: UIButton) {
        // Можно сделать переменнной класса.
        let refreshAlert = UIAlertController(title: "Удаление тренировки", message: "Удалить тренировку?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
            CoreDataManager.shared.deleteTraining(training: self.trainings[button.tag])
            self.trainings.remove(at: button.tag)
            self.tableView.reloadData()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    

    // MARK: - Variables
    
    var trainings = [Training]()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.navigationController?.isNavigationBarHidden = false
        let headerNib = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        let customCellNib = UINib.init(nibName: "CalendarTableViewCell2", bundle: Bundle.main)
        let customSwimCellNib = UINib.init(nibName: "SwimCalendarableViewCell", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")
        self.tableView.register(customSwimCellNib, forCellReuseIdentifier: "SwimCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return trainings.count
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let exercises = trainings[section].valueForKey("exercises")
        return trainings[section].allExercises.count
        //return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CalendarTableViewCell2
        //cellView.frame = cellView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
//        let viewSeparatorLine = UIView(frame:CGRect(x: 0, y: cellView.contentView.frame.size.height - 8.0, width: cellView.contentView.frame.size.width, height: 8))
//        viewSeparatorLine.backgroundColor = .blue
//        cellView.contentView.addSubview(viewSeparatorLine)
//
        var subview = cellView.contentView.subviews[0]
        subview.layer.borderWidth = 2
        subview.backgroundColor = .clear
        subview.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cellView.frame = cellView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        //subview.backgroundColor = .red
        //cellView.layer.borderWidth = 2
        cellView.backgroundColor = .clear
        //cellView.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cellView.nameLabel?.textColor = .white
        cellView.countLabel.textColor = .white
        cellView.timeLabel.textColor = .white
        
        let exercise = trainings[indexPath.section].allExercises[indexPath.row]
        switch exercise.isSwimming {
        case false:
            cellView.timeLabel.isHidden = true
            switch exercise.type {
            case 0:
                cellView.countLabel.text = String(exercise.numberOfReps)
            case 1:
                cellView.countLabel.text = String(exercise.numberOfReps)
                //cellView.countLabel.text = String(exercise.numberOfReps) + "x" + String(exercise.weight)
            default:
                cellView.countLabel.text = timeStringFor(seconds: Int(exercise.time))
            }
        default:
            cellView.timeLabel.text = timeStringFor(seconds: Int(exercise.time))
            switch exercise.type {
            case 0:
                cellView.countLabel.text = String(exercise.numberOfReps)
            default:
                cellView.timeLabel.isHidden = false
                cellView.countLabel.text = String(exercise.numberOfReps)
            }
        }
        
        cellView.nameLabel.text = exercise.name;
        //cellView.countLabel.text = String(exercise.numberOfReps);
        
        //print(exercisesTemplates.count)
        //print(trainingTemplates.count)
        
        return cellView
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Изменить") { _, _, completionHandler in
            //        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercisesTemplates.remove(at: indexPath.row))
            //        tableView.deleteRows(at: [indexPath], with: .fade)
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "DoneExerciseViewController") as DoneExerciseViewController
            //print("Got \(training!.allExercisesTemplates.count) exercises")
            //print(indexPath.row)
            let training = self.trainings[indexPath.section]
            let exercise = training.allExercises[indexPath.row]
            controller.exercise = exercise
            controller.forEditing = true
            self.navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true, completion: nil)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .orange
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! CustomHeaderView
        headerView.titleLabel.text = trainings[section].name
        headerView.editButton.setImage(UIImage(systemName: "trash"), for: .normal)
        headerView.delegate = self
        headerView.editButton.tag = section
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    

    func timeStringFor(seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(seconds))!
        return seconds < 3600 ? output.substring(from: output.range(of: ":")!.upperBound) : output
    }

}
