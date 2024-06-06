//
//  ArchivView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 01.06.2024.
//

import SwiftUI
import SwiftData

struct ArchivView: View {
    @Query private var items: [Item]
    
    var body: some View {
        ItemList(items: items) { item in
            item.isArchive
        }
    }
}

#Preview {
    ArchivView()
        .modelContainer(for: Item.self, inMemory: true)
}
