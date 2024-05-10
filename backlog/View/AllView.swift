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
            .onChange(of: isAddItem) {
                addItem()
            }
        }
        .navigationViewStyle(.stack)
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
}


struct CustomSearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: { hideKeyboard() }, label: {
                Text("Cancel")
            })

        }
        .padding(.horizontal)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        searchText = ""
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
