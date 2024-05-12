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
                TextField("Title", text: $item.subTitle)
                    .focused($isInputActive)
                    .padding([.leading, .trailing], 15)
                    .padding(.vertical, 5)
                Divider()
                ScrollView {
                    TextField("Body", text: $item.body, axis: .vertical)
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing], 15)
                        .padding(.vertical, 5)
                        .lineLimit(20, reservesSpace: true)
                    Spacer()
                }
                
            }
            .toolbar {
                ToolbarItemGroup {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        if item.isFavorit {
                            Image(systemName: "bookmark.fill")
                        } else {
                            Image(systemName: "bookmark")
                        }
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        if item.isPined {
                            Image(systemName: "pin.fill")
                        } else {
                            Image(systemName: "pin")
                        }
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "trash")
                            .accentColor(.red)
                    })
                    .padding(.horizontal, 15)
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "checkmark") // done
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
