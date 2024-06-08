//
//  DetailView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 07.05.2024.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @FocusState var isInputActive: Bool
    @State var item: Item
    @Query private var tags: [Tag]
    @State var lineLImit = 25
    @State private var keyboardHeight: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isExpanded: Bool = false
    @State private var isPresented: Bool = false
    @State private var selectedTag: Tag
    
    init(item: Item) {
        self.item = item
        _selectedTag = State(initialValue: item.tag)
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("\(item.createDate >= item.updateDate ? "Created" : "Updated") at \(item.createDate >= item.updateDate ? item.createDate : item.updateDate, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    .font(.caption)
            }

            Divider()
            
            HStack {
                Text("Title:")
                    .foregroundColor(.gray)
                TextField("", text: $item.title)
                    .focused($isInputActive)
                    .padding(.vertical, 5)
            }
            .padding([.leading, .trailing], 15)
            
            Divider()
            
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    HStack {
                        Text("Subtitle:")
                            .foregroundColor(.gray)
                        TextField("", text: $item.subTitle)
                            .focused($isInputActive)
                            .padding(.vertical, 5)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("URL:")
                            .foregroundColor(.gray)
                        TextField("", text: $item.url)
                            .focused($isInputActive)
                            .padding(.vertical, 5)
                        Link(destination: URL(string: item.url) ?? URL(string: "blank")!) {
                            Image(systemName: "link.circle")
                                .font(.system(size: 23))
                        }
                    }
                    
                }, label: {
                    HStack {
                        withAnimation(.easeOut){
                            Text(isExpanded ? "Hide additional fields." : "Show additional fields.")
                                .font(.footnote)
                        }
                    }
                }
            )
            .padding([.leading, .trailing], 15)
            
            Divider()
            ScrollView {
                TextField("Body", text: $item.body, axis: .vertical)
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing], 15)
                    .padding(.vertical, 5)
                    .lineLimit(lineLImit, reservesSpace: true)
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            self.keyboardHeight = keyboardFrame.height
                            print(keyboardFrame.height)
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        self.keyboardHeight = 0
                    }
                Spacer()
            }
            
        }
        .onChange(of: item.hasChanges) {  [weak item] oldValue, newValue in
            guard let item = item else { return }
            if newValue {
                item.updateDate = Date()
            }
        }

        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Image(systemName: "checkmark")
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "checklist")
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "list.bullet")
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "tablecells")
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "arrow.uturn.backward")
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "arrow.uturn.right")
                })
            }
        }
        
        .toolbar(id: "secondaryAction") {
            ToolbarItem(id: "Archive", placement: .navigationBarTrailing) {
                Button {
                    item.isArchive.toggle()
                } label: {
                    if item.isArchive {
                        Label("Unarchive", systemImage: "archivebox.fill")
                    } else {
                        Label("Archive", systemImage: "archivebox")
                    }
                }
            }
            
            ToolbarItem(id: "secondaryAction", placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        item.isFavorite.toggle()
                    } label: {
                        if item.isFavorite {
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
                        isPresented.toggle()
                    } label: {
                        Label("Change tag", systemImage: "tag")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                                        
                    Button(role: .destructive) {
                        modelContext.delete(item)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Label("secondaryAction", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            HStack {
                Button(role: .destructive) {
                    isPresented.toggle()
                } label: {
                    Label("Dismiss", systemImage: "")
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    item.tag = selectedTag
                    isPresented.toggle()
                } label: {
                    Label("Save", systemImage: "")
                        .font(.title3)
                }
            }
            .padding()
            
            Picker("Select a tag", selection: $selectedTag) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag.titleKey).tag(tag)
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.height(250)])
        }
    }
}





#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        let color = ColorModel(color: .black)
        let newsTag = Tag(systemImage: "bookmark.circle", titleKey: "framevorks", color: color)
        let newItem = Item(title: "swiftUI", subTitle: "subTitle", body: "body", tag: newsTag, url: "")
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


        return DetailView(item: newItem)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
