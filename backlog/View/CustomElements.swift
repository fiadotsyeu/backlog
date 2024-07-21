//
//  CustomElements.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 25.05.2024.
//

import SwiftUI
import SwiftData


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
    @Binding var appColor: Color

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(appColor)
            TextField("Search", text: $searchText)
                .textFieldStyle(CustomTextFieldStyle(borderColor: appColor))
                .foregroundColor(appColor)
            Button(action: { hideKeyboard() }, label: {
                Text("Cancel")
                    .foregroundColor(appColor)
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
    
    @Binding var appColor: Color
    
    typealias ItemFilter = (Item) -> Bool
    private var filter: ItemFilter
    
    init(items: [Item], appColor: Binding<Color>, filter: @escaping ItemFilter = { _ in true }) {
        self._items = State(initialValue: items)
        self._appColor = appColor
        self.filter = filter
    }
    
    private var searchResults : [Item] {
        searchText.isEmpty ? items : items.filter { $0.title.localizedStandardContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(searchText: $searchText, appColor: $appColor)
                    .padding(.vertical, 15)
                List {
                    Section(header: Text("Favorite items")) {
                        ForEach(searchResults.filter(filter), id: \.self) { item in
                            NavigationLink(destination: DetailView(item: item, appColor: $appColor)) {
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


let customDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
    return formatter
}()


struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var showingTimer: Bool
    @State var selectedDate: Date = Date()
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("Dismiss", systemImage: "xmark.circle")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Label("Save", systemImage: "plus.circle")
                    .font(.title3)
                    .foregroundColor(.green)
            }
        }
        .padding()
        
        DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(.wheel)
            .presentationDetents([.height(270)])
            .labelsHidden()
    }
}


extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            let startIndex = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[startIndex...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    let r = Double((hexNumber & 0xff0000) >> 16) / 255
                    let g = Double((hexNumber & 0x00ff00) >> 8) / 255
                    let b = Double(hexNumber & 0x0000ff) / 255
                    self.init(red: r, green: g, blue: b)
                    return
                }
            }
        }
        self.init(red: 1, green: 1, blue: 1) // Default to white color
    }
    
    var toHex: String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let hexString = String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        return hexString
    }
}


struct CustomTextFieldStyle: TextFieldStyle {
    var borderColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12))
            .background(RoundedRectangle(cornerRadius: 4).stroke(borderColor, lineWidth: 1))
    }
}


struct CustomColorPicker: View {
    @Binding var appColor: Color
    @AppStorage("appColorHex") private var appColorHex: String = "#FFFFFF"
    
    let colors: [Color] = [.purple, .red, .orange, .yellow, .green, .blue]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        appColor = color
                        if let hex = color.toHex {
                            appColorHex = hex
                            print("ok")
                            print("appColor \(appColor)")
                            print("appColorHex \(appColorHex)")
                        } else {
                            print("not ok")
                            print("appColor \(appColor)")
                            print("appColorHex \(appColorHex)")
                        }
                    }) {
                        Image(systemName: appColor == color ? "dot.circle.fill" : "circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(color)
                    }
                }
            }
            .padding()
        }
    }
}
