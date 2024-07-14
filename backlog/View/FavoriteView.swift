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
    @Binding var appColor: Color

    
    var body: some View {
        ItemList(items: items, appColor: $appColor) { item in
            item.isFavorite && !item.isArchive
        }
    }
}

#Preview {
    FavoriteView()
        .modelContainer(for: Item.self, inMemory: true)
}
