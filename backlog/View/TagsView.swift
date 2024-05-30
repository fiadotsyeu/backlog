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
    let tagColor: ColorModel
    let systemImage: String
    let titleKey: String
    @Binding var isSelected: Bool
    
    var body: some View {
        
        HStack(spacing: 4) {
            Image.init(systemName: systemImage).font(.body)
            Text(titleKey).font(.body).lineLimit(1)
        }
        .padding(.vertical, 4)
        .padding(.leading, 4)
        .padding(.trailing, 10)
        .foregroundColor(isSelected ? .white : tagColor.swiftUIColor)
        .background(isSelected ? tagColor.swiftUIColor : Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(tagColor.swiftUIColor, lineWidth: 1.5)
                
        ).onTapGesture {
            isSelected.toggle()
        }
        
        
    } 
}

struct TagContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var tags: [Tag]
    @State private var selectedTag: Tag?
    
    var body: some View {
        VStack {
        var width = CGFloat.zero
        var height = CGFloat.zero
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    ForEach(tags) { tag in
                        TagsView(tagColor: tag.color,
                                 systemImage: tag.systemImage,
                                 titleKey: tag.titleKey,
                                 isSelected: Binding(
                                    get: { tag.isSelected },
                                    set: { newValue in
                                        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
                                            tags[index].isSelected = newValue
                                            selectedTag = newValue ? tag : nil
                                        }
                                    }
                                 )
                        )
                        .padding(5)
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
                }
            }
            
            
                        
            if let selectedTag = selectedTag {
                NavigationView {
                    List {
                        Section(header: Text(selectedTag.titleKey)) {
                            ForEach(items.filter { $0.tag == selectedTag }) { it in
                                NavigationLink(destination: DetailView(item: it)) {
                                    ItemRow(item: it)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .scrollIndicators(.hidden)
                .navigationViewStyle(.stack)
            }
        }
    }
}


#Preview {
    TagsView(tagColor: ColorModel.from(color: .red), systemImage: "heart.circle", titleKey: "Title", isSelected: false)
        .modelContainer(for: Item.self, inMemory: true)
        .previewLayout(.sizeThatFits)
        .padding()
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: false)
}
