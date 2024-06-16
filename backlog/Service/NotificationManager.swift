//
//  Notification.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 16.06.2024.
//

import SwiftUI
import Foundation
import UserNotifications

class NotificationCenter: NSObject, UNUserNotificationCenterDelegate {
    static let shared = Notification()
    private var fileTimers = [String: MemoMinder]()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func registerFileTimer(_ fileTimer: MemoMinder) {
        fileTimers[fileTimer.notificationId] = fileTimer
    }
    
    func scheduleNotification(at date: Date, with identifier: String) {
        print("shedule ok")
        let content = UNMutableNotificationContent()
        content.title = "File Timer Alert"
        content.body = "Your file timer has ended."
        content.sound = .default
        content.userInfo = ["notificationId": identifier]
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let receivedNotificationId = userInfo["notificationId"] as? String {
            rescheduleNotification(with: receivedNotificationId)
        }
        completionHandler()
    }
    
    func rescheduleNotification(with identifier: String) {
        if let fileTimer = fileTimers[identifier] {
            fileTimer.updateForReschedule()
            fileTimer.scheduleNotification()
        } else {
            print("No FileTimer found with identifier: \(identifier)")
        }
    }
    
    func cancelAllTimers() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        fileTimers.removeAll()
    }
}

