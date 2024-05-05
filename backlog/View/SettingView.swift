//
//  SettingView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 05.05.2024.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("isNotification") private var notification: Bool = true
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    
    var body: some View {
        Form {
            Section(header: Text("Notification")) {
                Toggle(isOn: $notification, label: {
                    Text("Label")
                })
            }
            Section(header: Text("Language")) {
                Picker(selection: $selectedLanguage, label: Text("Select a language")) {
                    Text("EN").tag("en")
                    Text("CZ").tag("cs")
                    Text("UK").tag("uk")
                    Text("RU").tag("ru")
                }
            }
        }
        .padding()
    }
}

#Preview {
    SettingView()
}
