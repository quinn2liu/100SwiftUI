//
//  Color-Theme.swift
//  Moonshot
//
//  Created by Quinn Liu on 7/27/24.
//

import SwiftUI

// this extension should only apply when the ShapeStyle is of a color type
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
    
}
