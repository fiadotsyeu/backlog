//
//  Home.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 04.05.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    
    @State private var showingSheet = false
    @State private var showingArchive = false
    @State private var showingFavorite = false
    @State private var showingTutorials: Bool = false
    @State private var showingTips: Bool = false
    @State private var showingNews: Bool = false

    @State private var buttonRect: CGRect = .zero
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    @State private var maskAnimation: Bool = false
    
    @Binding var appColor: Color

    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Menu {
                    Button("Tutorial", systemImage: "book", action: { showingTutorials.toggle() })
                    Button("Tips", systemImage: "lightbulb.max", action: { showingTips.toggle() })
                    Button("What's new?", systemImage: "newspaper", action: { showingNews.toggle() })
                    Button("Feedback", systemImage: "text.bubble", action: { })
                } label: {
                    Button(action: {  }, label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(appColor)
                            .frame(width: 40, height: 40)
                            .font(.title2)
                    })
                }
                .menuStyle(.borderlessButton)
                
                Spacer()
                
                Image("app_logo_dark")
                    .resizable()
                    .frame(width: 130, height: 30)
                    .colorMultiply(appColor)
                
                Spacer()
                
                Button(action: { toggleDarkMode.toggle() }, label: {
                    Image(systemName: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                        .foregroundStyle(appColor)
                        .symbolEffect(.bounce, value: toggleDarkMode)
                        .frame(width: 40, height: 40)
                        .font(.title2)
                })
                .rect { value in
                    buttonRect = value
                }
                .disabled(currentImage != nil || previousImage != nil || maskAnimation)
            }
            .padding(15)
                        
            TabView {
                NavigationView {
                    AllView(appColor: $appColor)
                }
                .accentColor(appColor)
                .tabItem {
                    Label(
                        title: { Text("All") },
                        icon: { Image(systemName: "list.bullet.rectangle.portrait") }
                    )
                }
                .navigationViewStyle(.stack)
                
                NavigationView {
                    TagContainerView(appColor: $appColor)
                }
                .tabItem {
                    Label(
                        title: { Text("Tags") },
                        icon: { Image(systemName: "folder") }
                    )
                }
                .navigationViewStyle(.stack)
                
                NavigationView {
                    SettingView(appColor: $appColor)
                }
                .tabItem {
                    Label(
                        title: { Text("Setting") },
                        icon: { Image(systemName: "gear") }
                    )
                }
                .navigationViewStyle(.stack)
            }
            .ignoresSafeArea()
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .background(appColor)
        }
        .createImages(toggleDarkMode: toggleDarkMode, currentImage: $currentImage, previousImage: $previousImage, activateDarkMode: $activateDarkMode)
        .overlay(content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                if let previousImage, let currentImage {
                    ZStack {
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading) {
                                Circle()
                                    .frame(width: buttonRect.width * (maskAnimation ? 80 : 1), height: buttonRect.height * (maskAnimation ? 80 : 1), alignment: .bottomLeading)
                                    .frame(width: buttonRect.width, height: buttonRect.height)
                                    .offset(x: buttonRect.minX, y: buttonRect.minY)
                                    .ignoresSafeArea()
                            }
                    }
                    .task {
                        guard !maskAnimation else { return }
                        try? await Task.sleep(for: .seconds(0))
                        
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete) {
                            maskAnimation = true
                        } completion: {
                            /// Removing all snapshots
                            self.currentImage = nil
                            self.previousImage = nil
                            maskAnimation = false
                        }
                    }
                }
            })
            // Reverse Masking
            .mask({
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .frame(width: buttonRect.width, height: buttonRect.height)
                            .offset(x: buttonRect.minX, y: buttonRect.minY)
                            .blendMode(.destinationOut)
                    }
            })
            .ignoresSafeArea()
        })
        .preferredColorScheme(activateDarkMode ? .dark : .light)
        .overlay(alignment: .bottomTrailing) {
            FButton()
                .padding(.bottom, 25)
                .padding(.trailing, 20)
        }
        .animation(.easeInOut, value: 0.35)
        .sheet(isPresented: $showingSheet) {
            SheetView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingArchive) {
            ArchivView(appColor: $appColor)
                .presentationDetents([.medium])
        }
        
        .sheet(isPresented: $showingFavorite) {
            FavoriteView(appColor: $appColor)
                .presentationDetents([.medium])
        }
    }
    
    private func FButton() -> some View {
        FloatingButton {
            FloatingAction(appColor: $appColor, symbol: "archivebox") {
                showingArchive.toggle()
            }
            FloatingAction(appColor: $appColor, symbol: "bookmark") {
                showingFavorite.toggle()
            }
            FloatingAction(appColor: $appColor, symbol: "square.badge.plus") {
                showingSheet.toggle()
            }
        } label: { isExpanded in
            Image(systemName: "plus")
                .font(.title3)
                .fontWidth(.standard)
                .foregroundStyle(.primary)
                .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                .scaleEffect(1.02)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(appColor, in: .circle)
            // Scaling effect when expanded
                .scaleEffect(isExpanded ? 0.9 : 1)
        }
        .padding()
    }
}



//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
