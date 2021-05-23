//
//  TrainingTableViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 22.05.2021.
//

import UIKit

class TrainingTableViewController: UITableViewController {

    var training: Training? = nil
    var exercises = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = training!.allExercises
        let customCellNib = UINib.init(nibName: "CalendarTableViewCell", bundle: Bundle.main)
        //let customSwimCellNib = UINib.init(nibName: "SwimCalendarTableViewCell", bundle: Bundle.main)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")
        //self.tableView.register(customSwimCellNib, forCellReuseIdentifier: "SwimCell")
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTraining))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    @objc func saveTraining() {
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return exercises.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return training!.allExercisesTemplates.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CalendarTableViewCell
        cell.backgroundColor = .clear
        //cell.layer.cornerRadius = 2
        let exercise = exercises[indexPath.section]
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cell.nameLabel?.textColor = .white
        cell.countLabel.textColor = .white
        cell.timeLabel.textColor = .white
        switch exercise.isSwimming {
        case false:
            cell.timeLabel.isHidden = true
            switch exercise.type {
            case 0:
                cell.countLabel.text = String(exercise.numberOfReps)
            case 1:
                cell.countLabel.text = String(exercise.numberOfReps)
                //cell.countLabel.text = String(exercise.numberOfReps) + "x" + String(exercise.weight)
            default:
                cell.countLabel.text = timeStringFor(seconds: Int(exercise.time))
            }
        default:
            cell.timeLabel.text = timeStringFor(seconds: Int(exercise.time))
            switch exercise.type {
            case 0:
                cell.countLabel.text = String(exercise.numberOfReps)
            default:
                cell.timeLabel.isHidden = false
                cell.countLabel.text = String(exercise.numberOfReps)
            }
        }
        cell.nameLabel.text = exercise.name
        //cell.countLabel.text = String(exercises[indexPath.section].numberOfReps)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "DoneExerciseViewController") as DoneExerciseViewController
        //print("Got \(training!.allExercisesTemplates.count) exercises")
        //print(indexPath.row)
        controller.forEditing = true
        controller.exercise = exercises[indexPath.section]
        navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func timeStringFor(seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(seconds))!
        return seconds < 3600 ? output.substring(from: output.range(of: ":")!.upperBound) : output
    }
    
    
    
}
