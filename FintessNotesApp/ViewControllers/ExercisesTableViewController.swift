//
//  ExercisesTableViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 25.03.2021.
//

import UIKit
import CoreData





class ExercisesTableViewController: UITableViewController, HeaderViewDelegate, CustomCellDelegate {
    
    
    // MARK: - Variables
    var trainingTemplates = [TrainingTemplate]()
    var exercisesTemplates = [ExerciseTemplate]()
    var lastTrainings = [Training?]()
    //var exercises = [Exercise]()
    
    var roundButton = UIButton()
    
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Использовал, когда засорилось.
//        CoreDataManager.shared.DeleteAllData(entity: "TrainingTemplate")
//        CoreDataManager.shared.DeleteAllData(entity: "ExerciseTemplate")
//        CoreDataManager.shared.DeleteAllData(entity: "Exercise")
//        CoreDataManager.shared.DeleteAllData(entity: "Training")
        
        loadSavedTemplates()
        //loadSavedData()
        getLastTrainings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //loadSavedData()
        loadSavedTemplates()
        //getLastTrainings()
        //print(exercisesTemplates.count)
        //print(trainingTemplates.count)
        tableView.reloadData()
    }
    
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        //roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"plus"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
                                        roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                        roundButton.widthAnchor.constraint(equalToConstant: 50),
                                        roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    // MARK: LoadData
    
    func loadSavedTemplates() {
        trainingTemplates = CoreDataManager.shared.getSavedTemplates()
        tableView.reloadData()
        for template in trainingTemplates {
            exercisesTemplates.append(contentsOf: template.allExercisesTemplates)
        }
    }
    
    func getLastTrainings() {
        if trainingTemplates.count > 0 {
            lastTrainings = CoreDataManager.shared.getAllLastTrainings(trainingTemplates: trainingTemplates)
            tableView.reloadData()
        }
        
    }
    
    
    // MARK: UIActions
    
    func expandedSection(button: UIButton) {
        let section = button.tag
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TrainingViewController") as TrainingViewController
        controller.training = trainingTemplates[section]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func doExercise(button: UIButton, section: Int) {
        var exercises : [Exercise]
        if lastTrainings[section] == nil {
            lastTrainings[section] = CoreDataManager.shared.initNewTrainingByTemplate(template: trainingTemplates[section])
            exercises = lastTrainings[section]!.allExercises
            exercises.reverse()
        } else {
            exercises = lastTrainings[section]!.allExercises
        }
        
        let row = button.tag
        //print(row)
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "DoneExerciseViewController") as DoneExerciseViewController
        exercises[row].date = Date()
        lastTrainings[section]?.date = Date()
        controller.exercise = exercises[row]
        controller.exerciseTemplate = trainingTemplates[section].allExercisesTemplates[row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    // Действие при добавлении.
    @IBAction func ButtonClick(_ sender: UIButton){
        let newTrainingTemplate = CoreDataManager.shared.initNewTrainingTemplate()
        trainingTemplates.append(newTrainingTemplate)
        lastTrainings.append(nil)
        newTrainingTemplate.exercisesTemplates = NSSet()
        
        //newTraining.exercises = [NSSet]()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TrainingViewController") as TrainingViewController
        controller.training = newTrainingTemplate
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return trainingTemplates.count
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let exercises = trainings[section].valueForKey("exercises")
        return trainingTemplates[section].exercisesTemplates.count
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ExerciseTableViewCell
        var subview = cellView.contentView.subviews[0]
        subview.layer.borderWidth = 2
        subview.backgroundColor = .clear
        subview.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cellView.frame = cellView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        //subview.backgroundColor = .red
        cellView.editButton.tag = indexPath.row
        cellView.section = indexPath.section
        //cellView.layer.borderWidth = 2
        cellView.backgroundColor = .clear
        //cellView.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cellView.countOfReps?.textColor = .white
        cellView.countDone.textColor = .white
        cellView.dateLabel.textColor = .white
        cellView.titleExercise.textColor = .white
        if  indexPath.section > lastTrainings.count - 1 || lastTrainings[indexPath.section] == nil  {
            let training = trainingTemplates[indexPath.section]
            let exercise = training.allExercisesTemplates[indexPath.row]
            cellView.delegate = self
            cellView.dateLabel.text = "Никогда"
            cellView.titleExercise.text = exercise.name
            cellView.countDone.text = ""
            cellView.countOfReps.text = "0"
        } else {
            let training = lastTrainings[indexPath.section]
            // MARK: Если просто вернуться назад из окна добавления, то тут эксепшн!!!
            let exercise = training?.allExercises[indexPath.row]
            cellView.delegate = self
            let date = exercise?.date
            if date == nil {
                cellView.dateLabel.text = "Никогда"
            } else {
                cellView.dateLabel.text = parseDateToString(date!)
            }
            switch exercise?.isSwimming {
            case false:
                switch exercise?.type {
                case 0:
                    cellView.countOfReps.text = String(exercise!.numberOfReps)
                case 1:
                    cellView.countOfReps.text = String(exercise!.numberOfReps) + "x" + String(exercise!.weight)
                default:
                    cellView.countOfReps.text = timeStringFor(seconds: Int(exercise!.time))
                }
            default:
                cellView.countOfReps.text = String(exercise!.numberOfReps)
            }
            
            cellView.titleExercise.text = exercise!.name
            cellView.countDone.text = "0"
            //cellView.countOfReps.text = String(exercise!.numberOfReps)
        }
        //print(exercisesTemplates.count)
        //print(trainingTemplates.count)
        
        return cellView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! CustomHeaderView
        
        print(lastTrainings.count)
        headerView.titleLabel.text = trainingTemplates[section].name
        headerView.delegate = self
        headerView.editButton.tag = section
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        //        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercisesTemplates.remove(at: indexPath.row))
    //        //        tableView.deleteRows(at: [indexPath], with: .fade)
    //
    //        let story = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
    //        //print("Got \(training!.allExercisesTemplates.count) exercises")
    //        //print(indexPath.row)
    //        let training = trainingTemplates[indexPath.section]
    //        let exercise = training.allExercisesTemplates[indexPath.row]
    //        controller.exercise = exercise
    //        navigationController?.pushViewController(controller, animated: true)
    //        //self.present(controller, animated: true, completion: nil)
    //    }
    
    // Editing via swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Изменить") { _, _, completionHandler in
            //        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercisesTemplates.remove(at: indexPath.row))
            //        tableView.deleteRows(at: [indexPath], with: .fade)
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
            //print("Got \(training!.allExercisesTemplates.count) exercises")
            //print(indexPath.row)
            let training = self.trainingTemplates[indexPath.section]
            let exercise = training.allExercisesTemplates[indexPath.row]
            controller.exercise = exercise
            self.navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true, completion: nil)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .orange
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        initTableView()
        initButton()
    }
    
    func initTableView() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let headerNib = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        let customCellNib = UINib.init(nibName: "ExerciseTableViewCell", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")
    }
    
    func initButton() {
        //create a button or any UIView and add to subview
        roundButton = UIButton(type: .custom)
        roundButton.setTitle("+", for: .normal)
        roundButton.setTitleColor(UIColor.orange, for: .normal)
        roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)
        
        //set constrains
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            roundButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            roundButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
            roundButton.rightAnchor.constraint(equalTo: tableView.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            roundButton.bottomAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    // MARK: - Utils
    
    private func parseStringToDate(_ str : String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: str)!
    }
    
    private func parseDateToString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        //df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: date)
        return now
    }
    
    func timeStringFor(seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(seconds))!
        return seconds < 3600 ? output.substring(from: output.range(of: ":")!.upperBound) : output
    }
    
}

