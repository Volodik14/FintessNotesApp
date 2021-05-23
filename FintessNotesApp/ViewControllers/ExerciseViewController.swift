//
//  ExerciseViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
import CoreData
import UIKit

class ExerciseViewController: UIViewController {
    // MARK: - UI
    @IBAction func segment1Changed(_ sender: Any) {
        switch segment1.selectedSegmentIndex {
        case 0:
            if segment2.numberOfSegments == 2 {
                segment2.insertSegment(withTitle: "Время", at: 2, animated: true)
                segment2.setTitle("Подходы", forSegmentAt: 0)
                segment2.setTitle("Подходы + Вес", forSegmentAt: 1)
            }
        default:
            if segment2.numberOfSegments == 3 {
                segment2.removeSegment(at: 2, animated: true)
                segment2.setTitle("Расстояние", forSegmentAt: 0)
                segment2.setTitle("Расстояние + Время", forSegmentAt: 1)
            }
        }
    }
    @IBAction func segment2Changed(_ sender: Any) {
    }
    @IBOutlet weak var segment1: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func onSaveExerciseClick(_ sender: Any) {
        exercise!.name = nameTextField.text
        exercise!.type = Int16(segment2.selectedSegmentIndex)
        if segment1.selectedSegmentIndex == 1 {
            exercise!.isSwimming = true
            if exercise?.type == 1 {
                if exercise?.lastTime == nil {
                    exercise?.lastTime = 0
                }
            }
            if exercise?.lastRep == nil {
                exercise?.lastRep = 0
            }
        } else {
            exercise?.isSwimming = false
            switch exercise?.type {
            case 2:
                if exercise?.lastTime == nil {
                    exercise?.lastTime = 0
                }
            case 1:
                if exercise?.lastWeight == nil {
                    exercise?.lastWeight = 0
                }
                if exercise?.lastRep == nil {
                    exercise?.lastRep = 0
                }
            default:
                if exercise?.lastRep == nil {
                    exercise?.lastRep = 0
                }
            }
        }
        
        //exercise?.isWeight = switchValue.isOn
        //print("Got \(exercise?.name) exercise")
        CoreDataManager.shared.saveContext()
        
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Variables
    var exercise: ExerciseTemplate? = nil
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteExercise))
        segment1.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segment2.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segment1.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment2.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        nameTextField.text = exercise?.name
        if exercise!.isSwimming {
            segment1.selectedSegmentIndex = 1
        }
        segment2.selectedSegmentIndex = Int(exercise!.type)
        switch segment1.selectedSegmentIndex {
        case 0:
            if segment2.numberOfSegments == 2 {
                segment2.insertSegment(withTitle: "Время", at: 2, animated: true)
                segment2.setTitle("Подходы", forSegmentAt: 0)
                segment2.setTitle("Подходы + Вес", forSegmentAt: 1)
            }
        default:
            if segment2.numberOfSegments == 3 {
                segment2.removeSegment(at: 2, animated: true)
                segment2.setTitle("Расстояние", forSegmentAt: 0)
                segment2.setTitle("Расстояние + Время", forSegmentAt: 1)
            }
        }
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        nameTextField.backgroundColor = UIColor(rgb: 0xAE2834)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if exercise?.name == nil {
            exercise?.name = "Упражнение"
        }
        //exercise?.isWeight = switchValue.isOn
        CoreDataManager.shared.saveContext()
    }
    
    @objc func deleteExercise() {
        CoreDataManager.shared.saveContext()
        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercise!)
        navigationController?.popViewController(animated: true)
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
