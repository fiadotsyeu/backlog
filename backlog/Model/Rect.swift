//
//  Rect.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 08.06.2024.
//

import SwiftUI

struct Rect: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

