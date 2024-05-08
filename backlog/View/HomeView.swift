//
//  Home.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 04.05.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedTab: Tab?
    @Environment(\.colorScheme) private var scheme
    @State private var tabProgress: CGFloat = 0
    @State private var searchText = ""
    @Query private var items: [Item]

    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.contains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "microbe")
                })
            }
            .font(.title2)
            .overlay {
                Text("BackLog")
                    .font(.title.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
                        
            TabView(selection: $selectedTab) {
                NavigationView {
                    AllView()
                }
                .tag(0)
                .tabItem {
                    Label(
                        title: { Text("All") },
                        icon: { Image(systemName: "list.bullet.rectangle.portrait") }
                    )
                }
                .navigationViewStyle(.stack)
                
                CategoryView()
                    .tag(1)
                    .tabItem {
                        Label(
                            title: { Text("Category") },
                            icon: { Image(systemName: "folder") }
                        )
                    }
                SettingView()
                    .tag(2)
                    .tabItem {
                        Label(
                            title: { Text("Setting") },
                            icon: { Image(systemName: "gear") }
                        )
                    }
                
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
    
    
}

#Preview {
    ContentView()
}
