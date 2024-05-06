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
    

    var body: some View {
        NavigationSplitView {
            ScrollView(.vertical) {
                CustomSearchBar(searchText: $searchText)
                LazyVGrid(columns: Array(repeating: GridItem(), count: 1), content: {
                    ForEach(1...20, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.gray).gradient).opacity(0.6)
                            .frame(height: 100)
                            .overlay {
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.5))
                                        .frame(width: 320, height: 30)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.5))
                                        .frame(width: 150, height: 17)
                                }
                            }
                    }
                })
                .padding(15)
            }
                        
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .mask {
                Rectangle()
                    .padding(.bottom, -100)
            }
            .background(.gray.opacity(0.1))
        } detail: {
            Text("sad")
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
        }
        .padding(.horizontal)
    }
}


#Preview {
    AllView()
}
