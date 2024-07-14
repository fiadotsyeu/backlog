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
    @Binding var appColor: Color

    var body: some View {
        ItemList(items: items, appColor: $appColor) { item in
            item.isArchive
        }
    }
}

#Preview {
    ArchivView()
        .modelContainer(for: Item.self, inMemory: true)
}
