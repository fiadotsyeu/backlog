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
    @FocusState private var titleFieldIsFocused: Bool

    @State private var newTitle: String = ""
    @State private var newSubTitle: String = ""
    @State private var newBody: String = ""
    @State private var newTag: [Tag] = [Tag(systemImage: "bookmark.circle", titleKey: "Framevorks", items: nil)]
    @State private var selectedTag = false
    @State private var selectedCreationMode = CreationMode.item
    
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
                            .focused($titleFieldIsFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    titleFieldIsFocused = true
                                }
                            }
                        TextField("Enter suubtitle", text: $newSubTitle)
                            .textContentType(.none)
                        Picker("Select a tag", selection: $selectedTag) {
                            ForEach(tags) { tag in
                                Text(tag.titleKey)
                            }
                        }
                    case .tag:
                        TextField("Enter title Key", text: $newTitle)
                            .textContentType(.none)
                            .focused($titleFieldIsFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    titleFieldIsFocused = true
                                }
                            }
                        Picker("Select a image", selection: $selectedTag) {
                            ForEach(tags) { tag in
                                Text(tag.titleKey)
                            }
                        }
                    }
                }
                
                HStack {
                    Button(action: { dismiss() }, label: {
                        Text("Dismiss")
                            .font(.title3)
                            .foregroundColor(.red)
                            .bold()
                        
                    })
                    .padding(.horizontal, 10)
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Save")
                            .font(.title3)
                            .foregroundColor(.green)
                            .bold()
                    })
                    .padding(.horizontal, 10)
                }
            }
//            .navigationTitle("Add new item")
//            .navigationBarTitleDisplayMode(.large)
        }

    }
}


#Preview {
    SheetView()
}