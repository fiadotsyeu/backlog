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
    @State private var isCreate = false

    @State private var newTitleKey: String = ""
    @State private var selectedTagImage = "folder.circle"
    @State private var newTagColor = Color(.sRGB, red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1))

    @State private var newTitle: String = ""
    @State private var newSubTitle: String = ""
    @State private var newBody: String = ""
    @State private var selectedTag: Tag = Tag(systemImage: "bookmark.circle", titleKey: "Work", color: ColorModel(color: .black))
    
    @State private var imageList = ["folder.circle", "paperplane.circle", "doc.circle", "apple.terminal.circle", "book.circle", "books.vertical.circle", "book.closed.circle", "newspaper.circle", "bookmark.circle", "graduationcap.circle", "backpack.circle", "paperclip.circle", "link.circle", "personalhotspot.circle", "person.circle", "shared.with.you.circle", "person.2.circle", "figure.fall.circle", "figure.run.circle", "trophy.circle", "command.circle", "restart.circle", "sleep.circle", "power.circle", "peacesign", "globe", "sun.min", "moon.circle", "cloud.circle", "tornado.circle", "flame.circle", "play.circle", "repeat.circle", "infinity.circle", "speaker.circle", "magnifyingglass.circle", "swirl.circle.righthalf.filled", "play.rectangle.on.rectangle.circle", "heart.circle", "star.circle", "airplane.circle", "car.circle"]
    
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
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    isFocused = true
                                }
                            }
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
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    isFocused = true
                                }
                            }
                        
                        ColorPicker("Shoosen color", selection: $newTagColor)
                        
                        СustomPicker(selectedItem: $selectedTagImage, items: imageList)
                    }
                }
                Section {
                    Button(action: {
                        if selectedCreationMode == .tag {
                            addOrUpdateTag(image: selectedTagImage, titleKey: newTitleKey, color: ColorModel.from(color: newTagColor))
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
        .onAppear {
            if !tags.isEmpty {
                selectedTag = tags[0]
            }
        }
    }
    
    private func addOrUpdateTag(image: String, titleKey: String, color: ColorModel) {
        if let existingTag = tags.first(where: { $0.titleKey == titleKey }) {
            existingTag.systemImage = image
            print("This tag already exists.")
        } else {
            var titleKey = titleKey
            if titleKey.isEmpty { titleKey = "New Tag" }
            let newTag = Tag(systemImage: image, titleKey: titleKey, color: color)
            modelContext.insert(newTag)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error: \(error)")
        }
    }

    
    private func addOrUpdateItem(title: String, subTitle: String, body: String, tag: Tag) {
        var title = title
        if (items.first(where: { $0.title == title }) != nil) {
            title = "\(title) \(count)"
            print("This item already exists.")
        } else {
            if title.isEmpty {
                title = "New Item \(count)"
            }
            let newItem = Item(title: title, subTitle: subTitle, body: body, tag: tag, url: "")
            modelContext.insert(newItem)
        }
        do {
            try modelContext.save()
            count += 1
        } catch {
            print("Error: \(error)")
        }
    }
}


#Preview {
    SheetView()
}
