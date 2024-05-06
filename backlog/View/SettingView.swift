//
//  SettingView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 05.05.2024.
//

import SwiftUI


struct SettingView: View {
    @AppStorage("isNotification") private var notification: Bool = true
    @AppStorage("isMemoMinder") private var isMemoMinder: Bool = true
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @AppStorage("selectOptionExport") private var selectOptionExport: Bool = false
    @AppStorage("selectOptionImport") private var selectOptionImport: Bool = false

    
    var body: some View {
        Form {
            Section(header: Text("Notification")) {
                Toggle(isOn: $notification, label: {
                    Text("Notification")
                })
            }
            Section(header: Text("MemoMinder")) {
                Toggle(isOn: $notification, label: {
                    Text("MemoMinder")
                })
                Picker(selection: $notification, label: Text("Select frequency")) {
                    Text("1 time per day")
                    Text("1 time every two days")
                    Text("1 time every three days")
                    Text("1 time every four days")
                    Text("1 time every five days")
                    Text("1 time during weekends")
                    Text("1 time per week")
                    Text("1 time per month")
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
