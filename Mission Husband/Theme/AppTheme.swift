//
//  AppTheme.swift
//  Mission Husband
//
//  Color palette for the Mission Husband app
//

import SwiftUI

struct AppTheme {
    static let black = Color(red: 0, green: 0, blue: 0)
    static let white = Color(red: 1, green: 1, blue: 1)
    static let charcoal = Color(red: 0x42/255, green: 0x41/255, blue: 0x3d/255)
    static let tan = Color(red: 0x85/255, green: 0x73/255, blue: 0x4d/255)

    // Semantic colors
    static let background = black
    static let surface = charcoal
    static let text = white
    static let accent = tan
    static let secondary = Color(white: 0.6)
}
