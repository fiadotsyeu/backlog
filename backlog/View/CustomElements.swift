//
//  CustomElements.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 25.05.2024.
//

import SwiftUI


struct СustomPicker: View {
    @Binding var selectedItem: String
    let items: [String]
    let rows = [GridItem(.fixed(11), spacing: 24), GridItem(.fixed(11), spacing: 24), GridItem(.fixed(11))]

    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows) {
                    ForEach(items, id: \.self) { item in
                        Image(systemName: item)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .background(selectedItem == item ? .blue.opacity(0.5) : .white) // barva stejna jako ve SheetView
                            .cornerRadius(25)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}


struct CustomSearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: { hideKeyboard() }, label: {
                Text("Cancel")
            })

        }
        .padding(.horizontal)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        searchText = ""
    }
}


struct ItemList: View {
    @Environment(\.modelContext) private var modelContext
    @State private var items: [Item]
    @State private var searchText = ""
    typealias ItemFilter = (Item) -> Bool
    private var filter: ItemFilter
    
    init(items: [Item], filter: @escaping ItemFilter = { _ in true }) {
        self._items = State(initialValue: items)
        self.filter = filter
    }
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 15)
                List {
                    Section(header: Text("Favorite items")) {
                        ForEach(searchResults.filter(filter), id: \.self) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                ItemRow(item: item)
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.default, value: items.count)
            }
            .listStyle(.plain)
            .animation(.default, value: searchResults)
        }
        .scrollIndicators(.hidden)
    }
}


extension View {
    @ViewBuilder
    func rect(value: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    let rect = geometry.frame(in: .global)
                    
                    Color.clear
                        .preference(key: Rect.self, value: rect)
                        .onPreferenceChange(Rect.self, perform: { rect in
                            value(rect)
                        })
                })
            }
    }
    
    @MainActor
    @ViewBuilder
    func createImages(toggleDarkMode: Bool, currentImage: Binding<UIImage?>, previousImage: Binding<UIImage?>, activateDarkMode: Binding<Bool>) -> some View {
        self
            .onChange(of: toggleDarkMode) { oldValue, newValue in
                Task {
                    if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) {
                        let imageView = UIImageView()
                        imageView.frame = window.frame
                        imageView.image = window.rootViewController?.view.image(window.frame.size)
                        imageView.contentMode = .scaleAspectFit
                        window.addSubview(imageView)
                        
                        if let rootView = window.rootViewController?.view {
                            let frameSize = rootView.frame.size
                            // Creating Snapshots
                            // Old One
                            activateDarkMode.wrappedValue = !newValue
                            previousImage.wrappedValue = rootView.image(frameSize)
                            // New One with Updated Trait State
                            activateDarkMode.wrappedValue = newValue
                            // Giving some time to complete the transition
                            try await Task.sleep(for: .seconds(0.01))
                            currentImage.wrappedValue = rootView.image(frameSize)
                            // Removing once all the snapshots has taken
                            try await Task.sleep(for: .seconds(0.01))
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
    }
}

// Converting UIView to UIImage
extension UIView {
    func image(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            drawHierarchy(in: .init(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}
