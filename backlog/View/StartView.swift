//
//  StartView.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 22.06.2024.
//

import SwiftUI

struct StartView: View {
    
    @State private var scale = 0.7
    @Binding var isActive: Bool
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    
    var body: some View {
        VStack {
            Image(activateDarkMode ? "app_logo_dark" : "app_logo_light")
                .resizable()
                .frame(width: 160, height: 40)
            Text("Effortless Content Management for Your Busy Life\n\n")
                .foregroundColor(Color(activateDarkMode ? .white : .black))
                .font(.system(.footnote))
                .bold()
            Image(systemName: "ellipsis")
                .foregroundColor(activateDarkMode ? .white : .black)
                .symbolEffect(.variableColor.reversing.cumulative, options: .repeat(3).speed(3), value: scale)
                .font(.system(size: 70))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(activateDarkMode ? .black : .white))
        .ignoresSafeArea(.all)
        .onAppear{
            withAnimation(.default) {
                self.scale = 0.9
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
