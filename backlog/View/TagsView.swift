//
//  CategoryView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 05.05.2024.
//

import SwiftUI
import SwiftData

struct TagsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var searchText = ""

    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...20, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.gray).gradient).opacity(0.6)
                        .frame(height: 100)
                        .overlay {
                            VStack(alignment: .leading, spacing: 6) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.5))
                                    .frame(width: 150, height: 40)
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
    } 
}

#Preview {
    TagsView()
        .modelContainer(for: Item.self, inMemory: true)
}
