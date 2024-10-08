//
//  DetailView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 07.05.2024.
//

import SwiftUI
import SwiftData
import Combine

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Query private var tags: [Tag]

    @FocusState var isInputActive: Bool
    
    @Binding var appColor: Color
    
    @State var item: Item
    @State var lineLImit = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var isExpanded: Bool = false
    @State private var isPresented: Bool = false
    @State private var selectedTag: Tag
    @State var showingTimer: Bool = false
    
    init(item: Item, appColor: Binding<Color>) {
        self.item = item
        self._appColor = appColor
        _selectedTag = State(initialValue: item.tag)
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("\(item.createDate >= item.updateDate ? "Created" : "Updated") at \(item.createDate >= item.updateDate ? item.createDate : item.updateDate, formatter: customDateFormatter)")
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
                                .foregroundColor(appColor)
                        }
                    }
                    
                }, label: {
                    Text("Additional fields:")
                        .font(.footnote)
                        .foregroundColor(appColor)
                }
            )
            .padding([.leading, .trailing], 15)
            
            Divider()
            GeometryReader { geometry in
                TextField("Body", text: $item.body, axis: .vertical)
                    .focused($isInputActive)
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing], 15)
                    .padding(.vertical, 5)
                    .lineLimit(lineLImit, reservesSpace: false)
                    .onAppear {
                        updateLineLimit(for: geometry.size.height)
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                self.keyboardHeight = keyboardFrame.height + 13
                                updateLineLimit(for: geometry.size.height)
                            }
                        }
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                            self.keyboardHeight = -5
                            updateLineLimit(for: geometry.size.height)
                        }
                    }
                    .onDisappear {
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        .onReceive(Publishers.keyboardHeight) { height in
            self.keyboardHeight = height
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: {
                    isInputActive.toggle()
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
        .accentColor(appColor)

        
        .toolbar(id: "navBar") {
            ToolbarItem(id: "Archive", placement: .navigationBarTrailing) {
                Button {
                    item.isArchive.toggle()
                } label: {
                    if item.isArchive {
                        Label("Unarchive", systemImage: "archivebox.fill")
                            .foregroundColor(appColor)
                    } else {
                        Label("Archive", systemImage: "archivebox")
                            .foregroundColor(appColor)
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
                    
                    ShareLink(item: "Title: \(item.title)\nSubtitle: \(item.subTitle)\nURL: \(item.url)\n\n\(item.body)") {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        item.isMemoMinder.toggle()
                    } label: {
                        if item.isMemoMinder {
                            Label("MemoMinder", systemImage: "bell.badge.fill")
                        } else {
                            Label("MemoMinder", systemImage: "bell.badge")
                        }
                    }
                    
                    Button {
                        showingTimer.toggle()
                        item.isTimer.toggle()
                    } label: {
                        if item.isTimer {
                            Label("Stop timer", systemImage: "fitness.timer.fill")
                        } else {
                            Label("Set timer", systemImage: "fitness.timer")
                        }
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
                Button {
                    isPresented.toggle()
                } label: {
                    Label("Dismiss", systemImage: "xmark.circle")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                    item.tag = selectedTag
                    isPresented.toggle()
                } label: {
                    Label("Save", systemImage: "plus.circle")
                        .font(.title3)
                        .foregroundColor(.green)
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
        
        .sheet(isPresented: $showingTimer) {
            TimerView(showingTimer: showingTimer)
        }
    }
    
    private func updateLineLimit(for availableHeight: CGFloat) {
        let lineHeight: CGFloat = 22 // Estimated height of a single line
        let availableSpace = availableHeight - keyboardHeight
        self.lineLImit = max(Int(availableSpace / lineHeight), 1)
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
            .map { $0.height }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

