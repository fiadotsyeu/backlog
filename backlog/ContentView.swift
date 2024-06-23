//
//  ContentView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 03.05.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            HomeView()
                .onAppear {
                    ItemManager(items: items).startTimers()
                }
        } else {
            StartView(isActive: $isActive)
        }
    }
}

#Preview {
    HomeView()
}
