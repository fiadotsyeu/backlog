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
    let systemImage: String
    let titleKey: String
    @State var isSelected: Bool
    
    var body: some View {
        
        HStack(spacing: 4) {
            Image.init(systemName: systemImage).font(.body)
            Text(titleKey).font(.body).lineLimit(1)
        }
        .padding(.vertical, 4)
        .padding(.leading, 4)
        .padding(.trailing, 10)
        .foregroundColor(isSelected ? .white : .blue)
        .background(isSelected ? Color.blue : Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 1.5)
                
        ).onTapGesture {
            isSelected.toggle()
        }
        
        
    } 
}

struct TagContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var tags: [Tag]
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geo in
            ZStack(alignment: .topLeading, content: {
                ForEach(tags) { tag in
                    TagsView(systemImage: tag.systemImage ?? "bookmark.circle",
                             titleKey: tag.titleKey,
                             isSelected: tag.isSelected)
                    .padding(.all, 5)
                    .alignmentGuide(.leading) { dimension in
                        if (abs(width - dimension.width) > geo.size.width) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if tag.id == tags.last!.id {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        if tag.id == tags.last!.id {
                            height = 0
                        }
                        return result
                    }
                }
            })
        }
    }
}


#Preview {
    TagsView(systemImage: "heart.circle", titleKey: "Title", isSelected: false)
        .modelContainer(for: Item.self, inMemory: true)
        .previewLayout(.sizeThatFits)
        .padding()
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: false)
}
