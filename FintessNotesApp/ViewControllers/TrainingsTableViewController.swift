//
//  TrainingsTableViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 22.05.2021.
//

import UIKit



class TrainingsTableViewController: UITableViewController {

    var trainings = [Training]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        let customCellNib = UINib.init(nibName: "TrainingTableViewCell", bundle: Bundle.main)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")

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
        //return 1
        return trainings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return training!.allExercisesTemplates.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        //cell.layer.cornerRadius = 2
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cell.textLabel?.textColor = .white
        
        cell.textLabel?.text = trainings[indexPath.section].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TrainingTableViewController") as TrainingTableViewController
        //print("Got \(training!.allExercisesTemplates.count) exercises")
        //print(indexPath.row)
        let training = trainings[indexPath.section]
        controller.training = training
        navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            //        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercisesTemplates.remove(at: indexPath.row))
            //        tableView.deleteRows(at: [indexPath], with: .fade)
            
            CoreDataManager.shared.deleteTraining(training: self.trainings[indexPath.section])
            tableView.reloadData()
            //self.present(controller, animated: true, completion: nil)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
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
}
