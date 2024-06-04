//
//  FavoriteView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 04.06.2024.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @Query private var items: [Item]
    
    var body: some View {
        ItemList(items: items) { item in
            item.isFavorite && !item.isArchive
        }
    }
}

#Preview {
    FavoriteView()
        .modelContainer(for: Item.self, inMemory: true)
}
