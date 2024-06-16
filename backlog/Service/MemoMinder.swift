//
//  MemoMinder.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 16.06.2024.
//

import SwiftUI
import SwiftData
import Foundation

class MemoMinder {
    var creationDate: Date
    var modificationDate: Date
    var period: TimeInterval
    var notificationId: String
    var useModificationDate: Bool
    
    init(creationDate: Date, modificationDate: Date, period: TimeInterval, useModificationDate: Bool = false) {
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.period = period
        self.notificationId = UUID().uuidString
        self.useModificationDate = useModificationDate
        NotificationManager.shared.registerFileTimer(self)
    }
    
    func scheduleNotification() {
        let notificationDate = getRandomDateWithinPeriod()
        print("notificationDate: \(customDateFormatter.string(from: notificationDate)) notificationId: \(notificationId)")
        NotificationManager.shared.scheduleNotification(at: notificationDate, with: notificationId)
    }
    
    private func getRandomDateWithinPeriod() -> Date {
        let startDate = useModificationDate ? modificationDate : creationDate
        var randomDate: Date
        
        repeat {
            let randomTimeInterval = TimeInterval.random(in: 0..<period)
            randomDate = startDate.addingTimeInterval(randomTimeInterval)
        } while randomDate <= Date() || !isWithinAllowedHours(randomDate)
        
        return randomDate
    }
    
    private func isWithinAllowedHours(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour >= 7 && hour < 21
    }
    
    func updateForReschedule() {
        useModificationDate = true
    }
}

struct ItemManager {
    @State private var items: [Item]
    @State private var memoMinderInterval: TimeInterval
    @AppStorage("isMemoMinder") private var isMemoMinder: Bool = true
    
    init(items: [Item], memoMinderInterval: TimeInterval) {
        self.items = items
        self.memoMinderInterval = memoMinderInterval
    }
    
    func startTimers() {
        if isMemoMinder {
            for item in items {
                let fileTimer = MemoMinder(creationDate: item.createDate, modificationDate: item.updateDate, period: memoMinderInterval)
                fileTimer.scheduleNotification()
            }
        }
    }
}
