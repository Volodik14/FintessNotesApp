//
//  SettingsViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 23.05.2021.
//

import UIKit

class Reminder {
    var title: String
    var body: String
    var date: Date
    var dayOfWeek: Int
    var id: String
    init() {
        title = "Напоминание";
        dayOfWeek = 0;
        date = Date();
        body = ""
        id = UUID().uuidString
    }
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CalendarTableViewCell
        cell.backgroundColor = .clear
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cell.nameLabel?.textColor = .white
        cell.nameLabel.text = reminders[indexPath.section].title
        cell.timeLabel?.textColor = .white
        cell.countLabel?.textColor = .white
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.timeLabel.text = weekdays[reminders[indexPath.section].dayOfWeek - 1]
        cell.countLabel.text = formatter.string(from: reminders[indexPath.section].date)
        return cell
    }
    
    let weekdays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресение"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addReminder(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "EditReminderViewController") as EditReminderViewController
        //print("Got \(self.training!.allExercisesTemplates.count) exercises")
        //print(indexPath.row)
        let reminder = Reminder()
        reminders.append(reminder)
        controller.reminder = reminder
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return training!.allExercisesTemplates.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            //        CoreDataManager.shared.deleteExerciseTemplate(exercise: exercisesTemplates.remove(at: indexPath.row))
            //        tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.reminders.remove(at: indexPath.section)
            self.tableView.reloadData()
            // Удаление из LocalNotifications
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "EditReminderViewController") as EditReminderViewController
        //print("Got \(self.training!.allExercisesTemplates.count) exercises")
        //print(indexPath.row)
        let reminder = reminders[indexPath.section]
        controller.reminder = reminder
        controller.forEditing = true
        self.navigationController?.pushViewController(controller, animated: true)
        
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
    
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customCellNib = UINib.init(nibName: "CalendarTableViewCell", bundle: Bundle.main)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
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
