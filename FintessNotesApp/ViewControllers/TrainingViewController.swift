//
//  TrainingViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 27.03.2021.
//
import CoreData
import UIKit

class TrainingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - UI
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func onSaveClick(_ sender: Any) {
        training!.name = nameTextField.text
        var trainingExercises = [ExerciseTemplate]()
        
        for exercise in exercises {
            if (exercises.firstIndex(of: exercise) != nil) {
                if checkedExercises[exercises.firstIndex(of: exercise)!] {
                    trainingExercises.append(exercise)
                }
            }
        }
        
        training?.allExercisesTemplates = trainingExercises
        CoreDataManager.shared.saveContext()
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Variables
    
    var training: TrainingTemplate? = nil
    var exercises = [ExerciseTemplate]()
    var checkedExercises = [Bool]()
    
    // MARK: - LifeSycle
    override func viewWillDisappear(_ animated: Bool) {
        if training?.name == nil {
            training?.name = "Тренировка"
        }
        CoreDataManager.shared.saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercises = CoreDataManager.shared.getAllExerciseTemplates()
        CoreDataManager.shared.saveContext()
        exercisesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteTraining))
        //self.exercisesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        nameTextField.text = training?.name ?? ""
        exercises = CoreDataManager.shared.getAllExerciseTemplates()
        if training != nil {
            for exercise in exercises {
                checkedExercises.append(training!.exercisesTemplates.contains(exercise))
            }
        }
        nameTextField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //print("\(training!.allExercisesTemplates.count)")
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        nameTextField.backgroundColor = UIColor(rgb: 0xAE2834)
    }
    
    
    @IBAction func onAddExerciseClick(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
        let newExercise = CoreDataManager.shared.initNewExerciseTemplate()
        //newExercise.trainingTemplate = training
        //training!.exercisesTemplates.adding(newExercise)
        //exercises.append(newExercise)
        checkedExercises.append(true)
        //print("Got \(training!.allExercisesTemplates.count) exercises")
        //CoreDataManager.shared.saveContext()
        controller.exercise = newExercise
        
        //self.present(controller, animated: true, completion: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    // MARK: - CoreData
    
    @objc func deleteTraining() {
        //MARK: FIX THIS
        CoreDataManager.shared.deleteTrainingTemplate(training: training!)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return training!.allExercisesTemplates.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        cell.accessoryType = .checkmark
        //cell.tintColor = UIColor.red
        let checkImage: UIImage
        if checkedExercises[indexPath.section] {
            checkImage = UIImage(named: "ok-2")!
        } else {
            checkImage = UIImage(named: "empty-round-2")!
        }
        //let checkImage = UIImage(named: "ok-2")
        let checkMark = UIImageView(image: checkImage)
        checkMark.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        cell.accessoryView = checkMark
        cell.backgroundColor = .clear
        //cell.layer.cornerRadius = 2
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = addExerciseButton.backgroundColor?.cgColor
        cell.textLabel?.textColor = .white
        let exercise = exercises[indexPath.section]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath) {
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
//        print("Got \(training!.allExercisesTemplates.count) exercises")
//        print(indexPath.row)
//        controller.exercise = exercises[indexPath.row]
//        navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
        
        checkedExercises[indexPath.section] = !checkedExercises[indexPath.section]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Изменить") { _, _, completionHandler in
            //        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercisesTemplates.remove(at: indexPath.row))
            //        tableView.deleteRows(at: [indexPath], with: .fade)
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
            //print("Got \(self.training!.allExercisesTemplates.count) exercises")
            //print(indexPath.row)
            controller.exercise = self.exercises[indexPath.section]
            self.navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true, completion: nil)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .orange
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
