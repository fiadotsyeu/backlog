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
    
    var body: some View {
        HomeView()
            .onAppear {
                ItemManager(items: items).startTimers()
            }
    }
}

#Preview {
    HomeView()
}
