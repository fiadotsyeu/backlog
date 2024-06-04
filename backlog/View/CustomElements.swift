//
//  CustomElements.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 25.05.2024.
//

import SwiftUI


struct СustomPicker: View {
    @Binding var selectedItem: String
    let items: [String]
    let rows = [GridItem(.fixed(11), spacing: 24), GridItem(.fixed(11), spacing: 24), GridItem(.fixed(11))]

    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows) {
                    ForEach(items, id: \.self) { item in
                        Image(systemName: item)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .background(selectedItem == item ? .blue.opacity(0.5) : .white) // barva stejna jako ve SheetView
                            .cornerRadius(25)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
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


struct ItemList: View {
    @Environment(\.modelContext) private var modelContext
    @State private var items: [Item]
    @State private var searchText = ""
    typealias ItemFilter = (Item) -> Bool
    private var filter: ItemFilter
    
    init(items: [Item], filter: @escaping ItemFilter = { _ in true }) {
        self._items = State(initialValue: items)
        self.filter = filter
    }
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 15)
                List {
                    Section(header: Text("Favorite items")) {
                        ForEach(searchResults.filter(filter), id: \.self) { item in
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
