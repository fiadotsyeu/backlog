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
