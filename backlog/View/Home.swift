//
//  Home.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 04.05.2024.
//

import SwiftUI

struct Home: View {
    @State private var selectedTab: Tab?
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bell.badge")
                })
            }
            .font(.title2)
            .overlay {
                Text("BackLog")
                    .font(.title.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            TabBar()
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    //updating tab
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
}

#Preview {
    ContentView()
}
