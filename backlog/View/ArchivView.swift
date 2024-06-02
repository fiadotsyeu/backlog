//
//  ArchivView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 01.06.2024.
//

import SwiftUI
import SwiftData

struct ArchivView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var searchText = ""
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 15)
                List {
                    Section(header: Text("Archived items")) {
                        ForEach(searchResults.filter { $0.isArchive }, id: \.self) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                ItemRow(item: item)
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.default, value: items.count)
            }
            .listStyle(.plain)
            .animation(.default, value: searchResults)
        } detail: {
            
        }
        .scrollIndicators(.hidden)
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ArchivView()
        .modelContainer(for: Item.self, inMemory: true)
}
