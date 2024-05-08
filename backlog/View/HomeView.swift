//
//  Home.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 04.05.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) private var scheme
    @Query private var items: [Item]

    
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
                
                TagsView()
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
            .ignoresSafeArea()
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
