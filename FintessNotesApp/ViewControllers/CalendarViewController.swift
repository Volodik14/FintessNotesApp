//
//  ViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 25.03.2021.
//

import UIKit
import FSCalendar

import Foundation

extension Date {

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    

    @IBAction func onEditButtonClicked(_ sender: Any) {
        if calendar.selectedDate != nil {
            let stringDate = self.formatter.string(from: calendar.selectedDate!)
            if myDict.keys.contains(stringDate) {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let controller = story.instantiateViewController(identifier: "TrainingsTableViewController") as TrainingsTableViewController
                controller.trainings = myDict[stringDate]!
                navigationController?.pushViewController(controller, animated: true)
            }
        }
        
    }
    
    @IBAction func onAddButtonClicked(_ sender: Any) {
        if calendar.selectedDate != nil {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "AddTrainingTableViewController") as AddTrainingTableViewController
            controller.date = calendar.selectedDate!
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @IBOutlet weak var calendar: FSCalendar!
    
    private var trainings = [Training]()
    private var myDict = [String: [Training]]()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        calendar.reloadData()
        trainings = CoreDataManager.shared.getAllTrainings()
        myDict = setDictionary(trainings: trainings)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        trainings = CoreDataManager.shared.getAllTrainings()
        myDict = setDictionary(trainings: trainings)
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        //self.calendar.select(self.formatter.date(from: "2017/08/10")!)
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        self.calendar.delegate = self
        self.calendar.dataSource = self
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        //self.tabBar.barTintColor = .black
        // Do any additional setup after loading the view.
    }
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = self.formatter.string(from: date)
        //print("calendar did select date \(stringDate)")
        if myDict.keys.contains(stringDate) {
            let trainings = myDict[stringDate]
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "OldTrainingTableViewController") as OldTrainingTableViewController
            controller.trainings = trainings!
            navigationController?.pushViewController(controller, animated: true)
        }
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    // Выставление выполненных на основе цвета.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if myDict.keys.contains(self.formatter.string(from: date)) {
            return UIColor.red
        }
        return nil
    }
    
    // Выставление выполненных на основе ивентов.
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if myDict.keys.contains(date) {
//            return 1
//        }
//        return 0
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if myDict.keys.contains(self.formatter.string(from: date)) {
            return 1
        }
        return 0
    }
    
    func setDictionary(trainings: [Training]) -> [String: [Training]] {
        var myDict = [String: [Training]]()
        for training in trainings {
            let stringDate =  self.formatter.string(from: training.date!)
            if myDict[stringDate] == nil {
                myDict[stringDate] = []
            }
            
            myDict[stringDate]?.append(training)
        }
        return myDict
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
}

