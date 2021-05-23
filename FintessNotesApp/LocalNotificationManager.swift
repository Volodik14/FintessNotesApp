//
//  LocalNotificationManager.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 23.05.2021.
//

import Foundation

import UserNotifications


class LocalNotificationManager {
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {
        
    }
    public static var shared = LocalNotificationManager()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationTitle: String, notificationBody: String, dayOfWeek: Int, date: Date, id: String) {
        
        let content = UNMutableNotificationContent()
        let calendar = Calendar.current
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        content.badge = 1
        var components = calendar.dateComponents([.hour, .minute,], from: date)
        components.weekday = dayOfWeek
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let identifire = id
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }
    
    func deleteNotification(id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
