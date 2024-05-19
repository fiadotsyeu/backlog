//
//  SheetView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 10.05.2024.
//

import SwiftUI
import SwiftData

struct SheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var items: [Item]
    @Query private var tags: [Tag]
    @FocusState private var isFocused: Bool
    @State private var selectedCreationMode = CreationMode.item

    @State private var newTitleKey: String = ""
    @State private var selectedTagImage = "folder.circle"

    @State private var newTitle: String = ""
    @State private var newSubTitle: String = ""
    @State private var newBody: String = ""
    @State private var selectedTag: Tag = Tag(systemImage: "bookmark.circle", titleKey: "Work")
    
    @State private var imageList = ["folder.circle", "paperplane.circle", "paperplane.circle", "doc.circle", "apple.terminal.circle", "book.circle", "books.vertical.circle", "book.closed.circle", "newspaper.circle", "bookmark.circle", "graduationcap.circle", "backpack.circle", "paperclip.circle", "link.circle", "personalhotspot.circle", "person.circle", "shared.with.you.circle", "person.2.circle", "figure.fall.circle", "figure.run.circle", "trophy.circle", "command.circle", "restart.circle", "sleep.circle", "power.circle", "peacesign", "globe", "sun.min", "moon.circle", "cloud.circle", "tornado.circle", "flame.circle", "play.circle", "repeat.circle", "infinity.circle", "speaker.circle", "magnifyingglass.circle", "swirl.circle.righthalf.filled", "play.rectangle.on.rectangle.circle", "heart.circle", "star.circle", ]
    
    private enum CreationMode { case item, tag }
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("I want to create...")) {
                    Picker("CreationMode", selection: $selectedCreationMode) {
                        Text("Item").tag(CreationMode.item)
                        Text("Tag").tag(CreationMode.tag)
                    }
                    .pickerStyle(.segmented)
                    switch selectedCreationMode {
                    case .item:
                        TextField("Enter title", text: $newTitle)
                            .textContentType(.none)
                            .focused($isFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isFocused = true
                                }
                            }
                        TextField("Enter suubtitle", text: $newSubTitle)
                            .textContentType(.none)
                        Picker("Select a tag", selection: $selectedTag) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag.titleKey).tag(tag)
                            }
                        }
                    case .tag:
                        TextField("Enter title Key", text: $newTitleKey)
                            .textContentType(.none)
                            .focused($isFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isFocused = true
                                }
                            }
                        Picker("Select a image", selection: $selectedTagImage) {
                            ForEach(imageList, id: \.self) { image in
                                Image(systemName: image)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 130)
                    }
                }
                Section {
                    Button(action: {
                        if selectedCreationMode == .tag {
                            addOrUpdateTag(image: selectedTagImage, titleKey: newTitleKey)
                        } else if selectedCreationMode == .item {
                            addOrUpdateItem(title: newTitle, subTitle: newSubTitle, body: newBody, tag: selectedTag)
                        }
                        dismiss()
                    }, label: {
                        Text("Save")
                            .font(.title3)
                            .foregroundColor(.green)
                    })
                    .frame(maxWidth: .infinity)
                }
                Section {
                    Button(action: { dismiss() }, label: {
                        Text("Dismiss")
                            .font(.title3)
                            .foregroundColor(.red)
                    })
                }
                .frame(maxWidth: .infinity)
            }
        }

    }
    
    private func addOrUpdateTag(image: String, titleKey: String) {
        if let existingTag = tags.first(where: { $0.titleKey == titleKey }) {
            existingTag.systemImage = image
            print("This tag already exists.")
        }
        do {
            let newTag = Tag(systemImage: image, titleKey: titleKey)
            modelContext.insert(newTag)
            try modelContext.save()
        } catch {
            print("Error: \(error)")
        }
    }

    
    private func addOrUpdateItem(title: String, subTitle: String, body: String, tag: Tag) {
        if let existingItem = items.first(where: { $0.title == title }) {
            if !subTitle.isEmpty { existingItem.subTitle += " + " + subTitle }
            print("This item already exists.")
        } else {
            let newItem = Item(title: title, subTitle: subTitle, body: body, tag: tag.self)
            modelContext.insert(newItem)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error: \(error)")
        }
    }
}


#Preview {
    SheetView()
}
