//
//  AllView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 05.05.2024.
//

import SwiftUI
import SwiftData

struct AllView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var tags: [Tag]
    @State private var searchText = ""
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }

    var pinnedItems: [Item] {
        searchResults.filter { $0.isPinned }
    }
        
    var unpinnedItems: [Item] {
        searchResults.filter { !$0.isPinned }
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 8)
                List {
                    if !pinnedItems.isEmpty {
                        Section(header: Text("Pinned items")) {
                            ForEach(pinnedItems, id: \.self) { item in
                                NavigationLink(destination: DetailView(item: item)) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }
                    
                    if !unpinnedItems.isEmpty {
                        Section(header: Text("All items")) {
                            ForEach(unpinnedItems, id: \.self) { item in
                                NavigationLink(destination: DetailView(item: item)) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.default, value: pinnedItems.count)
            }
            .scrollIndicators(.hidden)
        } detail: {
        }
        .navigationViewStyle(.stack)
    }
    
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}



#Preview {
    AllView()
        .modelContainer(for: Item.self, inMemory: true)
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
