//
//  ItemRow.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 25.05.2024.
//

import SwiftUI

struct ItemRow: View {
    @Environment(\.modelContext) private var modelContext
    @State var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.title)
                Spacer()
                HStack(spacing: 4) {
                    Image.init(systemName: item.tag.systemImage).font(.system(size: 11))
                    Text(item.tag.titleKey).font(.system(size: 11)).lineLimit(1)
                }
                .padding(.vertical, 2)
                .padding(.leading, 2)
                .padding(.trailing, 8)
                .foregroundColor(item.tag.color.swiftUIColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(item.tag.color.swiftUIColor, lineWidth: 1)
                )
            }
            
            HStack {
                Image(systemName: item.isFavorit ? "bookmark.fill" : "bookmark")
                Image(systemName: item.isPinned ? "pin.fill" : "pin")
                
                Spacer()
                
                Text("Created in \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))") //or Updated in
            }
            .font(.system(size: 9))

            
            .contextMenu {
                Button {
                    item.isFavorit.toggle()
                } label: {
                    if item.isFavorit {
                        Label("Unfavorite", systemImage: "bookmark.fill")
                    } else {
                        Label("Favorite", systemImage: "bookmark")
                    }
                }
                
                Button {
                    item.isPinned.toggle()
                } label: {
                    if item.isPinned {
                        Label("Unpin", systemImage: "pin.fill")
                    } else {
                        Label("Pin", systemImage: "pin")
                    }
                }
                
                Button {
                    
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                
                Button(role: .destructive) {
                    modelContext.delete(item)
                } label: {
                    HStack {
                        Label("Delete", systemImage: "trash")
                            .tint(.red)
                    }
                }
            }
        }
    }
}

//#Preview {
//    ItemRow()
//}
