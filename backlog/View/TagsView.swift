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
    
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false

    @Query private var items: [Item]
    
    @State private var searchText = ""
    
    let tagColor: ColorModel
    let systemImage: String
    let titleKey: String
    
    @Binding var isSelected: Bool
    
    var body: some View {
        
        HStack(spacing: 4) {
            Image(systemName: systemImage).font(.body)
            Text(titleKey).font(.body).lineLimit(1)
        }
        .padding(.vertical, 4)
        .padding(.leading, 4)
        .padding(.trailing, 10)
        .foregroundColor(isSelected ? .white : tagColor.swiftUIColor)
        .background(isSelected ? tagColor.swiftUIColor : activateDarkMode ? .black : .white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(tagColor.swiftUIColor, lineWidth: 1.5)
        )
        .onTapGesture {
            withAnimation {
                isSelected.toggle()
            }
        }
    }
}

struct TagContainerView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    @Query private var tags: [Tag]
    
    @State private var selectedTags: Set<Tag> = []
    
    @Binding var appColor: Color

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    var width = CGFloat.zero
                    var height = CGFloat.zero
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            ForEach(tags) { tag in
                                TagsView(
                                    tagColor: tag.color,
                                    systemImage: tag.systemImage,
                                    titleKey: tag.titleKey,
                                    isSelected: Binding(
                                        get: { selectedTags.contains(tag) },
                                        set: { newValue in
                                            withAnimation {
                                                if newValue {
                                                    selectedTags.insert(tag)
                                                } else {
                                                    selectedTags.remove(tag)
                                                }
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
                }
                .frame(height: 200)
                
                if !selectedTags.isEmpty {
                    List {
                        Section(header: Text(selectedTags.map { $0.titleKey }.joined(separator: ", ") )) {
                            ForEach(items.filter { item in
                                selectedTags.contains(item.tag)
                            }, id: \.id) { item in
                                NavigationLink(destination: DetailView(item: item, appColor: $appColor)) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("No items selected.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .transition(.opacity)
                    Spacer()
                }
            }
            .animation(.default, value: selectedTags)
        }
        .scrollIndicators(.hidden)
        .navigationViewStyle(.stack)
    }
}

