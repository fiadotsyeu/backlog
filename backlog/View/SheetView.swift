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

    @State private var newTitle: String = ""
    @State private var newSubTitle: String = ""
    @State private var newBody: String = ""
    @State private var selectedTag: Tag = Tag(systemImage: "bookmark.circle", titleKey: "Work")
    
    @State private var imageList = ["folder.circle", "paperplane.circle", "paperplane.circle", "doc.circle", "apple.terminal.circle", "book.circle", "books.vertical.circle", "book.closed.circle", "newspaper.circle", "bookmark.circle", "graduationcap.circle", "backpack.circle", "paperclip.circle", "link.circle", "personalhotspot.circle", "person.circle", "shared.with.you.circle", "person.2.circle", "figure.fall.circle", "figure.run.circle", "trophy.circle", "command.circle", "restart.circle", "sleep.circle", "power.circle", "peacesign", "globe", "sun.min", "moon.circle", "cloud.circle", "tornado.circle", "flame.circle", "play.circle", "repeat.circle", "infinity.circle", "speaker.circle", "magnifyingglass.circle", "swirl.circle.righthalf.filled", "play.rectangle.on.rectangle.circle", "heart.circle", "star.circle", ]
    
    private enum CreationMode { case item, tag }
    
    
    var body: some View {
        
        var newItem = Item(title: newTitle, subTitle: newSubTitle, body: newBody, tags: newTag)
        
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
                                Text(tag.titleKey)
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
                        Picker("Select a image", selection: $selectedTag) {
                            ForEach(tags) { tag in
                                Text(tag.titleKey)
                            }
                        }
                    }
                }
                Section {
                    Button(action: {
                        if selectedCreationMode == .tag {
                            addTag(image: selectedTagImage, titleKey: newTitleKey)
                        } else if selectedCreationMode == .item {
                            addItem(title: newTitle, subTitle: newSubTitle, body: newBody, tag: selectedTag)
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
//            .navigationTitle("Add new item")
//            .navigationBarTitleDisplayMode(.large)
        }

    }
    
    private func addTag(image: String, titleKey: String) {
        var tagExists = false
        for tag in tags {
            if tag.titleKey.localizedStandardContains(titleKey) {
                print("This tag already exists.")
                tagExists = true
                break
            }
        }
        if !tagExists {
            do {
                let newTag = Tag(systemImage: image, titleKey: titleKey)
                modelContext.insert(newTag)
                try modelContext.save()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func addItem(title: String, subTitle: String, body: String, tag: Tag) {
        for tag in tags {
            if tag.titleKey.localizedStandardContains(tag.titleKey) {
                do {
                    let newItem = Item(title: title, subTitle: subTitle, body: body, tag: tag.self)
                    modelContext.insert(newItem)
                    try modelContext.save()
                } catch {
                    print("Error: \(error)")
                }
            } else {
                do {
                    let newItem = Item(title: title, subTitle: subTitle, body: body, tag: tag)
                    modelContext.insert(newItem)
                    try modelContext.save()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}


#Preview {
    SheetView()
}
