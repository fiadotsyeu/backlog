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
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 6)
                
                ForEach(searchResults, id: \.self) { item in
                    NavigationLink(destination: DetailView(item: item), label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.white))
                            .frame(height: 50)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text(item.date, format: Date.FormatStyle(date:
                                            .numeric, time: .standard))
                                }
                            }
                    })
                }
                .padding(.horizontal, 20)
            }
            
            .scrollClipDisabled()
            .background(.gray.opacity(0.1))
            .scrollIndicators(.hidden)
            .mask {
                Rectangle()
                    .padding(.bottom, -100)
                    .background(.black)
            }
            .overlay(alignment: .bottomTrailing) {
                FButton()
            }
        }
    }
    
    
    private func addItem() {
        withAnimation {
            for _ in 0..<15 {
                let newItem = Item(title: "swiftUI", subTitle: "subTitle", body: "body", category: "framevorks")
                modelContext.insert(newItem)
                try? modelContext.save()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func FButton() -> some View {
        FloatingButton {
            FloatingAction(symbol: "plus") {
                addItem()
                print("add item")
            }
            FloatingAction(symbol: "plus") {
                print("edit")
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


struct CustomSearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
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
