//
//  NotificationsUtil.swift
//  Notes
//
//  Created by Андрей Олесов on 9/17/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsUtil{
    static func createNotification(inSeconds seconds: TimeInterval, withIdentificator identificator:String, withText text: String) {
        let date = Date(timeIntervalSinceNow: seconds)
        let content = UNMutableNotificationContent()
        content.title = "One of your notes is wating for you"
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.count > 10{
            let range = trimmedText.startIndex..<trimmedText.index(trimmedText.startIndex, offsetBy: 10)
            content.body = trimmedText[range] + "..."
        } else {
            content.body = trimmedText
        }
        
        
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents( [.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identificator, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    static func removeNotification(withIdentificator identificators: [String]){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identificators)
    }
}

