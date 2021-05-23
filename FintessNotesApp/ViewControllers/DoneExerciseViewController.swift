//
//  DoneExerciseViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
import CoreData
import UIKit
import ValueStepper
import DateTimePicker

class DoneExerciseViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var valueStepper2: ValueStepper!
    
    
    @IBAction func timeEditPressed(_ sender: Any) {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm:ss"
        let date = inFormatter.date(from: (self.timeButton.titleLabel?.text)!)!
        let picker = DateTimePicker.create(minimumDate: date, maximumDate: Calendar.current.date(byAdding: .day, value: 1, to: date)!)
        picker.isTimePickerOnly = true
        picker.includesSecond = true
        picker.doneButtonTitle = "Выбрать"
        picker.dateFormat = "HH:mm:ss"
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: .boldSystemFont(ofSize: 20))
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.todayButtonTitle = ""
        picker.cancelButtonTitle = "Отмена"
        picker.is12HourFormat = false
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            self.timeButton.setTitle(formatter.string(from: date), for: .normal)
        }
        picker.selectedDate = date
        picker.show()
    }
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var valueStepper: ValueStepper!
    @IBAction func onSaveClicked(_ sender: Any) {
        let chosenValue = Int16(valueStepper.value)
        let chosenValue2 = Int16(valueStepper2.value)
        switch exercise?.isSwimming {
        case false:
            switch exercise?.type {
            case 0:
                if forEditing {
                    exercise?.numberOfReps = chosenValue
                } else {
                    exercise?.numberOfReps += chosenValue
                    exerciseTemplate?.lastRep = chosenValue
                }
                //exercise?.numberOfReps = chosenValue
                
            case 1:
                if forEditing {
                    exercise?.numberOfReps = chosenValue * chosenValue2
                } else {
                    exercise?.numberOfReps += chosenValue * chosenValue2
                    exerciseTemplate?.lastWeight = chosenValue2
                    exerciseTemplate?.lastRep = chosenValue
                }
                //exercise?.numberOfReps = chosenValue
                
                //exercise?.weight = chosenValue2
                
            default:
                let inFormatter = DateFormatter()
                inFormatter.dateFormat = "HH:mm:ss"
                let date = inFormatter.date(from: (self.timeButton.titleLabel?.text)!)!
                let secs = timeToSeconds(date: date)
                exercise?.time += secs
                if !forEditing {
                    exerciseTemplate?.lastTime = secs
                }
                
            }
        default:
            switch exercise?.type {
            case 0:
                if !forEditing {
                    exerciseTemplate?.lastRep = chosenValue2
                }
                exercise?.numberOfReps = chosenValue2
                
            default:
                
                exercise?.numberOfReps = chosenValue2
                let inFormatter = DateFormatter()
                inFormatter.dateFormat = "HH:mm:ss"
                let date = inFormatter.date(from: (self.timeButton.titleLabel?.text)!)!
                let secs = timeToSeconds(date: date)
                exercise?.time = secs
                if !forEditing {
                    exerciseTemplate?.lastRep = chosenValue2
                    exerciseTemplate?.lastTime = secs
                }
                
        }
        }
        
        exercise?.weight = chosenValue2
        CoreDataManager.shared.saveContext()
        navigationController?.popViewController(animated: true)
        labelCount.isHidden = false
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Variables
    var forEditing = false
    var exercise: Exercise?
    var exerciseTemplate: ExerciseTemplate?
    
    func timeStringFor(seconds : Int) -> String {
      let formatter = DateComponentsFormatter()
      formatter.allowedUnits = [.second, .minute, .hour]
      formatter.zeroFormattingBehavior = .pad
      let output = formatter.string(from: TimeInterval(seconds))!
      return seconds < 3600 ? output.substring(from: output.range(of: ":")!.upperBound) : output
    }
    
    
    func timeToSeconds(date: Date) -> Int32 {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return Int32(hours * 3600 + minutes * 60 + seconds)
    }
    // MARK: - LifeSycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let numberOfElements: Int? = self.navigationController?.viewControllers.count
        switch exercise?.isSwimming {
        case false:
            switch exercise?.type {
            case 0:
                valueStepper2.isHidden = true
                timeButton.isHidden = true
                labelTime.isHidden = true
                labelWeight.isHidden = true
                if forEditing {
                    valueStepper.value = Double(exercise!.numberOfReps)
                } else {
                    valueStepper.value = Double(exerciseTemplate!.lastRep)
                }
            case 1:
                timeButton.isHidden = true
                labelTime.isHidden = true
                if forEditing {
                    valueStepper.value = Double(exercise!.numberOfReps)
                    valueStepper2.value = Double(exercise!.weight)
                } else {
                    valueStepper.value = Double(exerciseTemplate!.lastRep)
                    valueStepper2.value = Double(exerciseTemplate!.lastWeight)
                }
            default:
                valueStepper.isHidden = true
                valueStepper2.isHidden = true
                labelCount.isHidden = true
                labelWeight.isHidden = true
                if forEditing {
                    timeButton.titleLabel?.text = timeStringFor(seconds: Int(exercise!.time))
                } else {
                    timeButton.titleLabel?.text = timeStringFor(seconds: Int(exerciseTemplate!.lastTime))
                }
            }
        default:
            switch exercise?.type {
            case 0:
                valueStepper.isHidden = true
                labelCount.isHidden = true
                timeButton.isHidden = true
                labelTime.isHidden = true
                labelWeight.text = "Расстояние"
                if forEditing {
                    valueStepper2.value = Double(exercise!.numberOfReps)
                } else {
                    valueStepper2.value = Double(exerciseTemplate!.lastRep)
                }
                
            default:
                valueStepper.isHidden = true
                labelCount.isHidden = true
                labelWeight.text = "Расстояние"
                if forEditing {
                    valueStepper2.value = Double(exercise!.numberOfReps)
                    timeButton.titleLabel?.text = timeStringFor(seconds: Int(exercise!.time))
                } else {
                    valueStepper2.value = Double(exerciseTemplate!.lastRep)
                    timeButton.titleLabel?.text = timeStringFor(seconds: Int(exerciseTemplate!.lastTime))
                }
        }
        }
        //dateTimePicker.isTimePickerOnly = true
        //container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        //valuePicker.selectRow(Int(exercise!.numberOfReps), inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
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
