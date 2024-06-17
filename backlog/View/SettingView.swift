//
//  SettingView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 05.05.2024.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers


struct SettingView: View {
    @Environment(\.modelContext) private var modelContext

    @AppStorage("isNotification") private var isNotification: Bool = true
    @AppStorage("isMemoMinder") private var isMemoMinder: Bool = true
    @AppStorage("MemoMindreInterval") private var memoMinderInterval: TimeInterval = Intervals.week.rawValue
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    @State private var exportJson: Bool = false
    @State private var importJson: Bool = false

    @Query private var items: [Item]
    @Query private var tags: [Tag]

    private enum Intervals: TimeInterval, CaseIterable {
        case day = 6400  // 1 day in seconds
        case twoDays = 172800  // 2 days in seconds
        case threeDays = 259200  // 3 days in seconds
        case fourDays = 345600  // 4 days in seconds
        case fiveDays = 432000  // 5 days in seconds
        case week = 604800  // 1 week in seconds
        case month = 2592000  // 30 days (approximately 1 month) in seconds
    }
    
    var body: some View {
        Form {
            Section(header: Text("Notification")) {
                Toggle(isOn: $isNotification, label: {
                    Text("Notification")
                })
            }
            Section(header: Text("MemoMinder")) {
                Toggle(isOn: $isMemoMinder, label: {
                    Text("MemoMinder")
                })
                .onChange(of: isMemoMinder) {
                    if isMemoMinder {
                        ItemManager(items: items).startTimers()
                    } else {
                        NotificationManager.shared.cancelAllTimers()
                    }
                }
                Picker(selection: $memoMinderInterval, label: Text("Select frequency")) {
                    Text("1 time per day").tag(Intervals.day.rawValue)
                    Text("1 time every two days").tag(Intervals.twoDays.rawValue)
                    Text("1 time every three days").tag(Intervals.threeDays.rawValue)
                    Text("1 time every four days").tag(Intervals.fourDays.rawValue)
                    Text("1 time every five days").tag(Intervals.fiveDays.rawValue)
                    Text("1 time per week").tag(Intervals.week.rawValue)
                    Text("1 time per month").tag(Intervals.month.rawValue)
                }
                .onChange(of: memoMinderInterval) {
                    NotificationManager.shared.cancelAllTimers()
                    ItemManager(items: items).startTimers()
                }
            }
            Section(header: Text("Language")) {
                Picker(selection: $selectedLanguage, label: Text("Select a language")) {
                    Text("EN").tag("en")
                    Text("CZ").tag("cs")
                    Text("UK").tag("uk")
                    Text("RU").tag("ru")
                }
            }
            Section(header: Text("Export")) {
                Picker(selection: $selectedLanguage, label: Text("Select a format")) {
                    Text("Json").tag("json")
                    Text("CSV").tag("csv")
                    Text("TXT").tag("txt")
                }
                Picker(selection: $selectOptionExport, label: Text("Choose a folder")) {
                    Text("Choose a folder")
                }
                .pickerStyle(.segmented)
            }
            Section(header: Text("Import")) {
                Picker(selection: $selectOptionExport, label: Text("Choose a file")) {
                    Text("Choose a file")
                }
                .pickerStyle(.segmented)
            }
        }
        .scrollContentBackground(.hidden)
        .padding()
    }
}

#Preview {
    SettingView()
}
