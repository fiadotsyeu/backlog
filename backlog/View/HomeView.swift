//
//  Home.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 04.05.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var scheme
    @Query private var items: [Item]
    @State private var selectedTab = 0
    @State private var showingSheet = false
    @State private var showingArchive = false

    
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
                
                NavigationView {
                    TagContainerView()
                }
                .tag(1)
                .tabItem {
                    Label(
                        title: { Text("Tags") },
                        icon: { Image(systemName: "folder") }
                    )
                }
                .navigationViewStyle(.stack)
                .padding(10)
                
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
        .overlay(alignment: .bottomTrailing) {
            if selectedTab != 2 {
                FButton()
                    .padding(.bottom, 25)
                    .padding(.trailing, 20)
            }
        }
        .animation(.easeInOut, value: 0.35)
        .sheet(isPresented: $showingSheet) {
            SheetView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingArchive) {
            ArchivView()
        }
    }
    
    private func FButton() -> some View {
        FloatingButton {
            FloatingAction(symbol: "trash") {
                
            }
            FloatingAction(symbol: "archivebox") {
                showingArchive.toggle()
            }
            FloatingAction(symbol: "bookmark") {
                
            }
            FloatingAction(symbol: "square.badge.plus") {
                showingSheet.toggle()
            }
        } label: { isExpanded in
            Image(systemName: "plus")
                .font(.title3)
                .fontWidth(.standard)
                .foregroundStyle(.white)
                .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                .scaleEffect(1.02)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black, in: .circle)
            // Scaling effect when expanded
                .scaleEffect(isExpanded ? 0.9 : 1)
        }
        .padding()
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
