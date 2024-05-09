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
    @State var isEditing = false
    @State var symbol: String = "minus"
    @State  var count = 0

    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 8)
                List {
                    ForEach(searchResults, id: \.self) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            Text("Item at \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .scrollIndicators(.hidden)
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
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
            FloatingAction(symbol: symbol) {
                count += 1
                self.isEditing.toggle()
                symbol = count % 2 == 0 ? "minus" : "plus"
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
