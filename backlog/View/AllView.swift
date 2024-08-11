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
    
    @Binding var appColor: Color
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }

    var pinnedItems: [Item] {
        searchResults.filter { $0.isPinned && !$0.isArchive}
    }
        
    var unpinnedItems: [Item] {
        searchResults.filter { !$0.isPinned && !$0.isArchive}
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchText: $searchText, appColor: $appColor)
                    .padding(.vertical, 8)
                List {
                    if !pinnedItems.isEmpty {
                        Section(header: Text("Pinned items")) {
                            ForEach(pinnedItems, id: \.self) { item in
                                NavigationLink(destination: DetailView(item: item, appColor: $appColor)) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }
                    
                    if !unpinnedItems.isEmpty {
                        Section(header: Text("All items")) {
                            ForEach(unpinnedItems, id: \.self) { item in
                                NavigationLink(destination: DetailView(item: item, appColor: $appColor)) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.default, value: pinnedItems.count)
            }
            .listStyle(.plain)
            .animation(.default, value: searchResults)
        }
        .scrollIndicators(.hidden)
    }
    
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}
