//
//  EditReminderViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 23.05.2021.
//

import UIKit
import DateTimePicker

class EditReminderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBAction func saveReminder(_ sender: Any) {
        reminder?.body = textView.text
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm"
        let date = inFormatter.date(from: (self.dateButton.titleLabel?.text)!)!
        reminder?.date = date
        reminder?.title = nameTextField.text!
        reminder?.dayOfWeek = pickerView.selectedRow(inComponent: 0) + 1
        if forEditing {
            LocalNotificationManager.shared.deleteNotification(id: reminder!.id)
        }
        LocalNotificationManager.shared.scheduleNotification(notificationTitle: reminder!.title, notificationBody: reminder!.body, dayOfWeek: reminder!.dayOfWeek, date: reminder!.date, id: reminder!.id)
        navigationController?.popViewController(animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        7
    }
    

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: weekdays[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    
    let weekdays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресение"]
    var reminder: Reminder?
    var selectedDay = 0
    var forEditing = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func dateButtonClicked(_ sender: Any) {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm"
        let date = inFormatter.date(from: ("00:00"))!
        let picker = DateTimePicker.create(minimumDate: date, maximumDate: Calendar.current.date(byAdding: .day, value: 1, to: date)!)
        picker.isTimePickerOnly = true
        picker.includesSecond = false
        picker.doneButtonTitle = "Выбрать"
        picker.dateFormat = "HH:mm"
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: .boldSystemFont(ofSize: 20))
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.todayButtonTitle = ""
        picker.cancelButtonTitle = "Отмена"
        picker.is12HourFormat = false
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.dateButton.setTitle(formatter.string(from: date), for: .normal)
        }
        picker.selectedDate = date
        picker.show()
    }
    @IBOutlet weak var dateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = reminder?.title
        textView.text = reminder?.body
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        dateButton.setTitle(formatter.string(from: reminder!.date), for: .normal)
        pickerView.selectRow(reminder!.dayOfWeek, inComponent: 0, animated: true)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        nameTextField.backgroundColor = UIColor(rgb: 0xAE2834)
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
