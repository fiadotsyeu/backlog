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
    
    
    var body: some View {
        VStack {
            TextField("Title", text: $item.title)
                .focused($isInputActive)
                .padding([.leading, .trailing], 15)
                .padding(.vertical, 5)
            Divider()
            TextField("Subtitle", text: $item.subTitle)
                .focused($isInputActive)
                .padding([.leading, .trailing], 15)
                .padding(.vertical, 5)
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
            //                                    Text("Created in \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))") //or Updated in
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
            ToolbarItem(id: "secondaryAction", placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        
                    } label: {
                        if item.isFavorit {
                            Label("Unfavorite", systemImage: "bookmark.fill")
                        } else {
                            Label("Favorite", systemImage: "bookmark")
                        }
                    }
                    Button {
                        
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        
                    } label: {
                        if item.isPinned {
                            Label("Unpin", systemImage: "pin.fill")
                        } else {
                            Label("Pin", systemImage: "pin")
                        }
                    }
                    
                    Button {
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
}





#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        let newsTags = [Tag(systemImage: "bookmark.circle", titleKey: "framevorks", items: nil)]
        let newItem = Item(title: "swiftUI", subTitle: "subTitle", body: "body", tags: newsTags)

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
