//
//  NotificationScheduler.swift
//  uStream
//
//  Created by stanley phillips on 3/5/21.
//

import UserNotifications

class NotificationScheduler {
    static let shared = NotificationScheduler()
    
    func scheduleNotifications(media: ListMedia) {
        guard let date = media.releaseDate,
              let title = media.title else {return}
        let id = media.id
        
        let content = UNMutableNotificationContent()
        content.title = "New Release!"
        content.body = "\(title) is now available to stream!"
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(media: ListMedia) {
        let id = String(media.id)
        print(id)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
