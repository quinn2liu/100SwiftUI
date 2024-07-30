//
//  SwiftDataAppApp.swift
//  SwiftDataApp
//
//  Created by Quinn Liu on 7/28/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
