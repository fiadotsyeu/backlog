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
    @State private var searchText = ""
    @AppStorage("isEditing") var isEditing = false
    @AppStorage("isAddItem") var isAddItem = false

    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }

    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 8)
                List {
                    ForEach(searchResults, id: \.self) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(item.title)
//                                    Text("Created in \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))") //or Updated in
                                }
                                ForEach(item.tags) { tag in
                                    HStack(spacing: 4) {
                                        Image.init(systemName: tag.systemImage).font(.system(size: 11))
                                        Text(tag.titleKey).font(.system(size: 11)).lineLimit(1)
                                    }
                                    .bold()
                                    .padding(.vertical, 2)
                                    .padding(.leading, 2)
                                    .padding(.trailing, 8)
                                    .foregroundColor(tag.isSelected ? .white : .blue)
                                    .background(tag.isSelected ? Color.blue : Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.blue, lineWidth: 1)
                                    ).onTapGesture {
                                        isSelected.toggle()
                                    }
                                }
                            }
                            .contextMenu {
                                Button {
                                    item.isFavorit.toggle()
                                } label: {
                                    if item.isFavorit {
                                        Label("Unfavorite", systemImage: "bookmark.fill")
                                    } else {
                                        Label("Favorite", systemImage: "bookmark")
                                    }
                                }
                                
                                Button {
                                    item.isPinned.toggle()
                                } label: {
                                    if item.isPinned {
                                        Label("Unpin", systemImage: "pin.fill")
                                    } else {
                                        Label("Pin", systemImage: "pin")
                                    }
                                }
                                
                                Button {
                                    
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                                                
                                Button(role: .destructive) {
                                    modelContext.delete(item)
                                } label: {
                                    HStack {
                                        Label("Delete", systemImage: "trash")
                                            .tint(.red)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(.plain)
                .animation(.default, value: searchResults)
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
